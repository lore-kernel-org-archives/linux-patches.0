Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212272;
	b=oLHAPo1Vj+sYkghBP+hO55lRwI2LdiLU4zYnrqMzJzCZkYkdFhySOXFUUTe732x28jk1
	 A88+V6HG8joaHSD9MDPi8G0jZ6r16QczTAZFQ/m9Y2tRwsntoGvqDCSubBE5QzMxKZBO4
	 dTx7pKsL6HuFoSUA4k9OMHfIo775hYaSD1uRqsClbk28Lnb16rU5KfFaPFn6q3tEOEyyy
	 2Qc036utjyw8wBOCf6DzDRG5Q1Jku2sSYq32i9fIgjTIj7M4vUKL1THRG7KCCHb7rTC2l
	 NVxVncsDLimmDg1QcCpwVAXYBw7yaNMxZXCOmt5SqzKa2Nhe8B5Y7SStj9hUY52z+kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HKie8Ua1wNq0frcnq/KsMGE6nadRIcVi9i1lH86zlnI=;
	b=sCNPTbKRKF8JSriaTpxFVjtnlB8BBWkIpnZVR93YtI4S/Q/HdwxN53c6uPqbNkE4e3e3
	 Jbz+M2O3Pz6Giz0GzNpZ6QutkCQIrzlw8itwWpYAc7G7P2YOzDu0rXFWoVZ14hitpGm9j
	 1QAOhTt+j53VC9KlJOIf6uN793qlBy1e7Dz5jQEd0I2R6IghOSmBt2zz0Vri7LQQPip6E
	 SR0q4+62vZLm6gCwrE5DWYIw1a7jlnUoPuoUmF1Wwp0V+vVDuQOwZyLmFVeNtV8oivU4G
	 HHKtNTcRdpfwBJds0O9ZEwT71HrelQXNeINxbswVQ/dSHuNTxFPrkW4tFYok9nG7Xww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gY5DTsYV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309BE606A31C;
	Wed, 28 Oct 2026 18:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gY5DTsYV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4345E1F01825;
	Wed, 28 Oct 2026 18:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212271;
	bh=HKie8Ua1wNq0frcnq/KsMGE6nadRIcVi9i1lH86zlnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gY5DTsYVa0Q6MEXDa5yQTi4NXPgiMWsxfti6ojQTaBMR0riYoIeeM/N5+aCZggUye
	 QDH/QKPAjnQsENrVyh6kh8MRHhb25xb8c2C4PcYUNcOxCZoMOXDa9r3GWc648kNy6x
	 g/OgZKdmQxRrUMUxYPXgyZkuOYwdgRCD2OIPDQeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Muhammad Bilal <meatuni001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0097/1887] staging: sm750fb: fix mono image source stride mismatch in lynxfb_ops_imageblit()
Date: Wed, 28 Oct 2026 17:36:33 +0100
Message-ID: <20261028170501.441540229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit cc7cd2a9228175c975f62ad56ed7c767701cb4fa ]

sm750_hw_imageblit() advances its monochrome source pointer by
src_delta per scanline, and computes the correct rounded-up stride
internally as:

        bytes_per_scan = (width + start_bit + 7) / 8;

Its only caller, lynxfb_ops_imageblit(), instead passed src_delta as
image->width >> 3. For widths not a multiple of 8 this under-counted
the stride, so the source pointer fell further behind the real
per-scanline layout on every line, corrupting the rendered image.

Rather than just fixing the caller's calculation, remove src_delta
as a parameter entirely and have sm750_hw_imageblit() advance by the
bytes_per_scan it already computes for itself. There has only ever
been one caller, and that caller was passing an out-of-sync
derivative of the same width/start_bit values sm750_hw_imageblit()
already has, so keeping stride as a separate parameter served no
purpose beyond letting the two calculations drift apart, which is
exactly what happened here.

Rounding up, rather than down, is the direction consistent with the
rest of the fbdev core: struct fb_image mono bitmap data (the same
image->data this driver receives) is walked elsewhere with byte
strides derived from a ceiling division of width by 8. The generic
mono bit iterator in drivers/video/fbdev/core/fb_imageblit.h advances
scanlines with "iter->data += BITS_TO_BYTES(iter->width)", and
BITS_TO_BYTES() (include/linux/bitops.h) is a ceiling division.
sm750_hw_imageblit()'s own "(width + start_bit + 7) / 8" is that same
ceiling division with an added start_bit offset, so the caller's
">> 3" (floor) was the one calculation out of step with how this data
layout is handled everywhere else.

Found by code review of sm750_hw_imageblit()'s internal stride
calculation against what its only caller was passing in, and
confirmed with a clean -Werror build. I do not have this hardware,
so this has not been exercised at runtime on real sm750 silicon.

Fixes: 81dee67e215b2 ("staging: sm750fb: add sm750 to staging")
Cc: stable@vger.kernel.org
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Link: https://patch.msgid.link/20260901113031.161610-1-meatuni001@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/sm750fb/sm750.c       | 2 +-
 drivers/staging/sm750fb/sm750.h       | 2 +-
 drivers/staging/sm750fb/sm750_accel.c | 6 ++----
 drivers/staging/sm750fb/sm750_accel.h | 4 +---
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/sm750fb/sm750.c b/drivers/staging/sm750fb/sm750.c
index 758759b706d47..ad41ba284a3af 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -276,7 +276,7 @@ static void lynxfb_ops_imageblit(struct fb_info *info,
 	spin_lock(&sm750_dev->slock);
 
 	sm750_dev->accel.de_imageblit(&sm750_dev->accel,
-				      image->data, image->width >> 3, 0,
+				      image->data, 0,
 				      base, pitch, Bpp,
 				      image->dx, image->dy,
 				      image->width, image->height,
diff --git a/drivers/staging/sm750fb/sm750.h b/drivers/staging/sm750fb/sm750.h
index aff69661c8e62..a693d9f1d0d5e 100644
--- a/drivers/staging/sm750fb/sm750.h
+++ b/drivers/staging/sm750fb/sm750.h
@@ -73,7 +73,7 @@ struct lynx_accel {
 			   u32 rop2);
 
 	int (*de_imageblit)(struct lynx_accel *accel, const char *p_srcbuf,
-			    u32 src_delta, u32 start_bit, u32 d_base, u32 d_pitch,
+			    u32 start_bit, u32 d_base, u32 d_pitch,
 			    u32 byte_per_pixel, u32 dx, u32 dy, u32 width,
 			    u32 height, u32 f_color, u32 b_color, u32 rop2);
 
diff --git a/drivers/staging/sm750fb/sm750_accel.c b/drivers/staging/sm750fb/sm750_accel.c
index 24b9077a634a6..eb47c18a585d0 100644
--- a/drivers/staging/sm750fb/sm750_accel.c
+++ b/drivers/staging/sm750fb/sm750_accel.c
@@ -301,8 +301,6 @@ static unsigned int deGetTransparency(struct lynx_accel *accel)
  * sm750_hw_imageblit
  * @accel: Acceleration device data
  * @pSrcbuf: pointer to start of source buffer in system memory
- * @srcDelta: Pitch value (in bytes) of the source buffer, +ive means top down
- *	      and -ive mean button up
  * @startBit: Mono data can start at any bit in a byte, this value should be
  *	      0 to 7
  * @dBase: Address of destination: offset in frame buffer
@@ -317,7 +315,7 @@ static unsigned int deGetTransparency(struct lynx_accel *accel)
  * @rop2: ROP value
  */
 int sm750_hw_imageblit(struct lynx_accel *accel, const char *pSrcbuf,
-		       u32 srcDelta, u32 startBit, u32 dBase, u32 dPitch,
+		       u32 startBit, u32 dBase, u32 dPitch,
 		       u32 bytePerPixel, u32 dx, u32 dy, u32 width,
 		       u32 height, u32 fColor, u32 bColor, u32 rop2)
 {
@@ -406,7 +404,7 @@ int sm750_hw_imageblit(struct lynx_accel *accel, const char *pSrcbuf,
 			write_dpPort(accel, *(unsigned int *)ajRemain);
 		}
 
-		pSrcbuf += srcDelta;
+		pSrcbuf += ulBytesPerScan;
 	}
 
 	return 0;
diff --git a/drivers/staging/sm750fb/sm750_accel.h b/drivers/staging/sm750fb/sm750_accel.h
index 2c79cb730a0a6..df48ed57a054e 100644
--- a/drivers/staging/sm750fb/sm750_accel.h
+++ b/drivers/staging/sm750fb/sm750_accel.h
@@ -220,8 +220,6 @@ int sm750_hw_copyarea(struct lynx_accel *accel,
 /**
  * sm750_hw_imageblit
  * @pSrcbuf: pointer to start of source buffer in system memory
- * @srcDelta: Pitch value (in bytes) of the source buffer, +ive means top down
- *>-----      and -ive mean button up
  * @startBit: Mono data can start at any bit in a byte, this value should be
  *>-----      0 to 7
  * @dBase: Address of destination: offset in frame buffer
@@ -236,7 +234,7 @@ int sm750_hw_copyarea(struct lynx_accel *accel,
  * @rop2: ROP value
  */
 int sm750_hw_imageblit(struct lynx_accel *accel, const char *pSrcbuf,
-		       u32 srcDelta, u32 startBit, u32 dBase, u32 dPitch,
+		       u32 startBit, u32 dBase, u32 dPitch,
 		       u32 bytePerPixel, u32 dx, u32 dy, u32 width,
 		       u32 height, u32 fColor, u32 bColor, u32 rop2);
 
-- 
2.53.0



