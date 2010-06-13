/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * Copyright (c) 2009 Leonardo Kasperavičius
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */


// opengl
#import <OpenGLES/ES1/gl.h>

// cocos2d
#import "CCQuadParticleSystem.h"
#import "CCTextureCache.h"
#import "ccMacros.h"

// support
#import "Support/OpenGL_Internal.h"
#import "Support/CGPointExtension.h"

@implementation CCQuadParticleSystem


// overriding the init method
-(id) initWithTotalParticles:(int) numberOfParticles
{
	// base initialization
	if( (self=[super initWithTotalParticles:numberOfParticles]) ) {
	
		// allocating data space
		quads = malloc( sizeof(quads[0]) * totalParticles );
		indices = malloc( sizeof(indices[0]) * totalParticles * 6 );
		
		if( !quads || !indices) {
			NSLog(@"cocos2d: Particle system: not enough memory");
			if( quads )
				free( quads );
			if(indices)
				free(indices);
			
			[self release];
			return nil;
		}
		
		// initialize only once the texCoords and the indices
		[self initTexCoords];
		[self initIndices];

		// create the VBO buffer
		glGenBuffers(1, &quadsID);
		
		// initial binding
		glBindBuffer(GL_ARRAY_BUFFER, quadsID);
		glBufferData(GL_ARRAY_BUFFER, sizeof(quads[0])*totalParticles, quads,GL_DYNAMIC_DRAW);	
		glBindBuffer(GL_ARRAY_BUFFER, 0);		
	}
		
	return self;
}

-(void) dealloc
{
	free(quads);
	free(indices);
	glDeleteBuffers(1, &quadsID);
	
	[super dealloc];
}

-(void) initTexCoords
{
	float maxS = [texture_ maxS];
	float maxT = [texture_ maxT];

	for(int i=0; i<totalParticles; i++) {
		// bottom-left vertex:
		quads[i].bl.texCoords.u = 0;
		quads[i].bl.texCoords.v = 0;
		// bottom-right vertex:
		quads[i].br.texCoords.u = maxS;
		quads[i].br.texCoords.v = 0;
		// top-left vertex:
		quads[i].tl.texCoords.u = 0;
		quads[i].tl.texCoords.v = maxT;
		// top-right vertex:
		quads[i].tr.texCoords.u = maxS;
		quads[i].tr.texCoords.v = maxT;
	}
}

-(void) setTexture:(CCTexture2D *)texture
{
	[super setTexture:texture];
	[self initTexCoords];
}

-(void) initIndices
{
	for( int i=0;i< totalParticles;i++) {
		indices[i*6+0] = i*4+0;
		indices[i*6+1] = i*4+1;
		indices[i*6+2] = i*4+2;
		
		indices[i*6+5] = i*4+1;
		indices[i*6+4] = i*4+2;
		indices[i*6+3] = i*4+3;
	}
}

-(void) updateQuadWithParticle:(tCCParticle*)p newPosition:(CGPoint)newPos
{
	// colors
	quads[particleIdx].bl.colors = p->color;
	quads[particleIdx].br.colors = p->color;
	quads[particleIdx].tl.colors = p->color;
	quads[particleIdx].tr.colors = p->color;
	
	// vertices
	float size_2 = p->size/2;
	if( p->rotation ) {
		float x1 = -size_2;
		float y1 = -size_2;
		
		float x2 = size_2;
		float y2 = size_2;
		float x = newPos.x;
		float y = newPos.y;
		
		float r = (float)-CC_DEGREES_TO_RADIANS(p->rotation);
		float cr = cosf(r);
		float sr = sinf(r);
		float ax = x1 * cr - y1 * sr + x;
		float ay = x1 * sr + y1 * cr + y;
		float bx = x2 * cr - y1 * sr + x;
		float by = x2 * sr + y1 * cr + y;
		float cx = x2 * cr - y2 * sr + x;
		float cy = x2 * sr + y2 * cr + y;
		float dx = x1 * cr - y2 * sr + x;
		float dy = x1 * sr + y2 * cr + y;
		
		// bottom-left
		quads[particleIdx].bl.vertices.x = ax;
		quads[particleIdx].bl.vertices.y = ay;
		
		// bottom-right vertex:
		quads[particleIdx].br.vertices.x = bx;
		quads[particleIdx].br.vertices.y = by;
		
		// top-left vertex:
		quads[particleIdx].tl.vertices.x = dx;
		quads[particleIdx].tl.vertices.y = dy;
		
		// top-right vertex:
		quads[particleIdx].tr.vertices.x = cx;
		quads[particleIdx].tr.vertices.y = cy;
	} else {
		// bottom-left vertex:
		quads[particleIdx].bl.vertices.x = newPos.x - size_2;
		quads[particleIdx].bl.vertices.y = newPos.y - size_2;
		
		// bottom-right vertex:
		quads[particleIdx].br.vertices.x = newPos.x + size_2;
		quads[particleIdx].br.vertices.y = newPos.y - size_2;
		
		// top-left vertex:
		quads[particleIdx].tl.vertices.x = newPos.x - size_2;
		quads[particleIdx].tl.vertices.y = newPos.y + size_2;
		
		// top-right vertex:
		quads[particleIdx].tr.vertices.x = newPos.x + size_2;
		quads[particleIdx].tr.vertices.y = newPos.y + size_2;				
	}
}

-(void) postStep
{
	glBindBuffer(GL_ARRAY_BUFFER, quadsID);
	glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(quads[0])*particleCount, quads);
	glBindBuffer(GL_ARRAY_BUFFER, 0);
}

// overriding draw method
-(void) draw
{	
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Unneeded states: -
	
	
	glBindTexture(GL_TEXTURE_2D, texture_.name);

	glBindBuffer(GL_ARRAY_BUFFER, quadsID);

#define kPointSize sizeof(quads[0].bl)
	glVertexPointer(2,GL_FLOAT, kPointSize, 0);

	glColorPointer(4, GL_FLOAT, kPointSize, (GLvoid*) offsetof(ccV2F_C4F_T2F,colors) );
	
	glTexCoordPointer(2, GL_FLOAT, kPointSize, (GLvoid*) offsetof(ccV2F_C4F_T2F,texCoords) );
	
	
	BOOL newBlend = NO;
	if( blendFunc_.src != CC_BLEND_SRC || blendFunc_.dst != CC_BLEND_DST ) {
		newBlend = YES;
		glBlendFunc( blendFunc_.src, blendFunc_.dst );
	}
	
	// save color mode
#if 0
	glGetTexEnviv(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, &colorMode);
	if( colorModulate )
		glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );
	else
		glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE );
#endif

	if( particleIdx != particleCount ) {
		NSLog(@"pd:%d, pc:%d", particleIdx, particleCount);
	}
	glDrawElements(GL_TRIANGLES, particleIdx*6, GL_UNSIGNED_SHORT, indices);	
	
	// restore blend state
	if( newBlend )
		glBlendFunc( CC_BLEND_SRC, CC_BLEND_DST );
	
#if 0
	// restore color mode
	glTexEnvi( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, colorMode);
#endif
	
	glBindBuffer(GL_ARRAY_BUFFER, 0);

	// restore GL default state
	// -
}

@end


