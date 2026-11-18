Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051224;
	b=sivvRNzPVT6ysR/Pnue4KADqegj3FqOYmIuOP2nUeSH4xp5EYqIAfHKLAuZxcTmFJI1Q
	 Duy6iJ30F0+c8K+mc2fWAm3Zy2YKLsJ/F2BTwG4kc0jieqFK2FjAF73TVGouzNYO8Ag3Z
	 GVt5513PdOy0YKcB8zGlpoEGpSaOklaiCYe6AaYbqUAXlNYPpDrOqkVxo2IAcOXa9o8NH
	 5ILAWWUCVseOfjTTPrhpmwqXSz09w36Lt4FxNH+J6ffaaMpLOCChKgrSHsGDTuEIHJl11
	 7R25lHzkTD/cql/vDxgFIDoqMLKyNKJp96Od+eJrH4Omv+MPeI8U2c8dZsT/RrHHQoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wrQ5KkbwwvhhMOYL/dgY7Ia/wG5xDLawjzVnXmwivdQ=;
	b=4QgPuxri8dQ5LyouQxMSBmJwJDOiJCzIyRoHMC5Ch5Bs61vvSzHOc3m8WfIt+GVyZX/1
	 b4lqtn4xmUL4hz7Nm8t6Gl1PbAOK202uAnmy36aj+pWfY2t9y8EEWV5P5/5aSjjs8Dhib
	 Loq0bdN0GXmJ2AlZb41Ot4qIRJ6Y36xOyoq5FfFRpQjekeniIGH1CDy7bgWVDepWOYWG0
	 f3QTrG1nnkNVCUDbR1Ok2ZtoTQnu7ijrRddEmbomZEv+yJp+3MJkKcAh+lF4YlpFbloyx
	 vg4nRkDJrion4S5Y9fcccuZc3aDIN+rHEgY3kkVwVyOQ3oCT5MrDXfW8JW8hW9HEDwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e08ZilXZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED68606A325;
	Thu, 19 Nov 2026 01:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e08ZilXZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8A81F000C4;
	Thu, 19 Nov 2026 01:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051224;
	bh=wrQ5KkbwwvhhMOYL/dgY7Ia/wG5xDLawjzVnXmwivdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e08ZilXZ94mmPuSYeSF1BfJWvIsTukJqICdxz7h/z+A20+hZ9/r33jLftVj31N2sj
	 PSMWS4iGh6Q2bhtFlZWFjv5piMWvdz55J2aeSjkx81n+5Z47O5aVEI5zw4biqtpC1F
	 2DAS9JxNa/aAARm+ieevXAwpygQAHEAip+v8J54I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0082/2214] media: go7007: avoid undefined shifts in MPEG-4 headers
Date: Wed, 18 Nov 2026 15:29:18 +0100
Message-ID: <20261118150013.282462965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

[ Upstream commit 41f82777e547732460290ceb28fcc7c1b95ef192 ]

The byte-alignment paths can call CODE_ADD() with a zero bit
length.  The macro then shifts an int by name.b, which can be 32
after the preceding bit was flushed.

vti_bitlen() can likewise shift a signed int into its sign bit while
searching for the bit length, and the package mask construction can
shift by the full type width.

Make zero-length additions a no-op, derive the bit length with fls(),
and build the mask with GENMASK().

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-fw.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/go7007/go7007-fw.c b/drivers/media/usb/go7007/go7007-fw.c
index 018019ba47d46..d50304301eeae 100644
--- a/drivers/media/usb/go7007/go7007-fw.c
+++ b/drivers/media/usb/go7007/go7007-fw.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/bitops.h>
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/device.h>
@@ -58,14 +59,16 @@ struct code_gen {
 #define CODE_GEN(name, dest) struct code_gen name = { dest, 0, 32, 0 }
 
 #define CODE_ADD(name, val, length) do { \
-	name.b -= (length); \
-	name.a |= (val) << name.b; \
-	while (name.b <= 24) { \
-		*name.p = name.a >> 24; \
-		++name.p; \
-		name.a <<= 8; \
-		name.b += 8; \
-		name.len += 8; \
+	if (length) { \
+		name.b -= (length); \
+		name.a |= (val) << name.b; \
+		while (name.b <= 24) { \
+			*name.p = name.a >> 24; \
+			++name.p; \
+			name.a <<= 8; \
+			name.b += 8; \
+			name.len += 8; \
+		} \
 	} \
 } while (0)
 
@@ -707,11 +710,10 @@ static int gen_mpeg1hdr_to_package(struct go7007 *go,
 
 static int vti_bitlen(struct go7007 *go)
 {
-	unsigned int i, max_time_incr = go->sensor_framerate / go->fps_scale;
+	unsigned int max_time_incr = go->sensor_framerate / go->fps_scale;
+	int bitlen = fls(max_time_incr);
 
-	for (i = 31; (max_time_incr & ((1 << i) - 1)) == max_time_incr; --i)
-		;
-	return i + 1;
+	return bitlen ?: 1;
 }
 
 static int mpeg4_frame_header(struct go7007 *go, unsigned char *buf,
@@ -1209,7 +1211,7 @@ static int seqhead_to_package(struct go7007 *go, __le16 *code, int space,
 		0xbf08,		fps,
 		0xbf09,		0,
 		0xbff2,		vop_time_increment_bitlength,
-		0xbff3,		(1 << vop_time_increment_bitlength) - 1,
+		0xbff3,		GENMASK(vop_time_increment_bitlength - 1, 0),
 		0xbfe6,		0,
 		0xbfe7,		(fps / 1000) << 8,
 		0,		0,
-- 
2.53.0



