Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043106;
	b=av9iOA0aL4auKVdL1SbY4cyjcodrx0MMaJwOKKX3mzu/aQt5HejIJDkF6urGXUjeBEQ/
	 AY1i/oFyTCs3LaJlKAw7tMvGYtvIe2OTd1cJLgA17mg/vOg2eGqhjvDsb8fRR49Ukc2JF
	 VnJboBzLENsDDqqZF+KmUoxvawoH+6eqeHKNyzxHmgJY8LzlTjBSQxNyMZeW6+q85v0BO
	 fSxe7g8E0WF6tAg2ctKeSwmMHppwPp/jxX4y3uoLK9arufXF+7BDpRKrRj/sIkrcxc5YQ
	 fl7cBrpRbtffdQvK8hy0QsiTmwLttJGv/Lyh+DVgK2SR0e11lmBOpjYK6YofwJAHUlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I7nTp5nkZKxWkj7Lf0TNdyX9/oVa9WCUjSO9Bb4Ryzs=;
	b=g9hcgX+IYdooTRePpLs90RuAZ2BLrvIWsGSbzisSqlbcF+1Z7culv3Rdcklgo4zss59V
	 UIEkKQ8rc0PcAkXNwQiA1FWKpR8AFlzaF9P2GYaJYLgZynOY0qhfxED/OeaWYmQgzN/A+
	 o0Jyc0+fOLL4Xcfj4byGUGk+ln5cdecplbjN2q5DJxvSNotnDh0EUfm8khICJQvt3TL6i
	 j4HpJPpXxP01px6usYsIv5URSs9siLLzYKV0ZnJngL4CuyTLLUf9s0wnd3ch+t+9tuzJf
	 8qAcbTngW/FscBtiwQy2iGxTT1Hmxg8EsZqDMoj+p98FoO4bpz9EcMT2IzLM9pbRk1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FcLILrUQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E693C606A325;
	Wed, 18 Nov 2026 23:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FcLILrUQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468E81F000C4;
	Wed, 18 Nov 2026 23:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043105;
	bh=I7nTp5nkZKxWkj7Lf0TNdyX9/oVa9WCUjSO9Bb4Ryzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcLILrUQBMHvQUoLGYaiYq48t9kE6C3rJy9MHYagUY8cqqeiQ/FgffcGvx3NSsiYh
	 yW3+1lwKawxMCOQqIKpw+cWQYfEQdgpeM484orga5h9NDCEEbS/Fl2DpqUxsZQUJ7g
	 cxTADzKyKwZ1XO0mT2HiQhi2IkzzTfmWW5xANBwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0091/2857] media: go7007: avoid undefined shifts in MPEG-4 headers
Date: Wed, 18 Nov 2026 15:18:45 +0100
Message-ID: <20261118150204.553555398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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



