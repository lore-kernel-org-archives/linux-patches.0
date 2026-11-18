Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033711;
	b=skABaJmc9a10m3bFCZGzJifosXnwp8kK1HnXIaoBvAqgzVu3U2m3uyCmJnxJaHkoy/xs
	 Dnt7jovd0NttaAr7GJh/Y6nSOyCf2KwISfthnSLyT5L6l2NMR2mBN8qIcM0NFvu72NRbK
	 Lb24mpTL+Uzpxtj6a42Z5l5ck4X+PlDLPSKgH7y7pY48PImILmheOTTh78xE0dsd6nSTr
	 3k0qn7+sYEaU8cbyCf+m9sjdCofy3ywe8hAjQIU4ow3kOPb5wDBtM09BkqCMHPA++ObWh
	 KdF3QnuT0C8LNDVOqpmzN1l9fLX9oy3kfrhUIoLBqK04RCS/74WR96nJfbbC3JAZgDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C9G+j25kGlE2//LLxMGqWwM6CM/wD3EJQVZoRbdMOVg=;
	b=mxT7+dLSI7JkafZa/G4kidgu9/40LHrWMgA26z4ThNFznnJMYHXTjtdNtcbJuALCa1Qs
	 DzlQ/gc4vwUAU1BAtJoF52X2pnosdbwxtYzDa6fjgoDu0XPelwTlPSzryufidykakYF5D
	 HahJjZw70zvIIQXQ20lC3YutARTQDe64S8gdH5qeXf2EJz9tedYHxH3JxlyqffekzEFL0
	 tzh7cVEiia09yCPYAiKMLMym13eT7jlLh9cFzSk1hBX5rMUOUgND7UUPacv6+Qz6QmmDv
	 gw09wD/B2avfxluUcAjB/8L3t0f+vlaxn1nps9moTvIOwZWddBfDpBbfaf7z7py/zOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sbtqmB9i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADEC606A32C;
	Wed, 18 Nov 2026 20:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sbtqmB9i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FBF1F000C4;
	Wed, 18 Nov 2026 20:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033710;
	bh=C9G+j25kGlE2//LLxMGqWwM6CM/wD3EJQVZoRbdMOVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sbtqmB9i7KbUsxFfW7cSRhVR0MkgZL9jcPy3zfPt4RX9aqb5v6MIK7vQ9M7md3z2v
	 pIXj4Eo9edFPpvDrQp0SzVEGCPquL+HSDR525wkAKJi4krF9BLGtkjxSKmENnPATTN
	 qz2p3+AwKUoOXVFmQ3keSmsevVBmNqXSbh/ZYu00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0109/3318] media: go7007: avoid undefined shifts in MPEG-4 headers
Date: Wed, 18 Nov 2026 15:12:11 +0100
Message-ID: <20261118150317.541100105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



