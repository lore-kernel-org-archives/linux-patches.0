Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060848;
	b=w8hb6GxNVPoKmg0nj2t5MVwXFbjUpJNGt6dTpamP8pmH6KwljMtZm+8VCcOBhpkUTV7f
	 25TBezJHRwwNMnwPSCM8fT10adRMCaKIYMMVZkT3WMoPBr3LTZEy+5rlwIji9auG+/E4+
	 ml0D1tfON3JwIPwwIQQK9s71bixwz1THYOqwZ9I3B3TYNbBz5XPe+V5wzE0Ql67i7slBt
	 6uZpg6ftpIGV4gJy7MEqQhBiPmncvW3QH4LWlyEjc+xKEIDjgxxUvEFBb1Iqu8cosviSP
	 0UMgIlWH4Ioobj4vjfNa+L8BVdMj1/lmWpm1ROt8W7Q4nfcSs1fkAQuPytgeEKvceYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VvxZY8Bb5Ardqtlq4BajiCw+xcmm+8UwxEz7uqsaFVs=;
	b=RMjKE0D8aEv0px4HoNPuLXt2bNdD7xMvglYidk2guCzBRgdXKQLokWON8/YlMbA6J5lA
	 wpg4P5a7K6rWKpTY9kYkSa7ORAmB8ozlnuUqtajtX9zrXnq3clslebD1mzNY1/smyj7VA
	 iCjgzYQWowItlWpGH61AyNtmKqPa+KnIINNY4yobw8/SqXoSzElUH+bza6/dx2r43VTrD
	 NcPJzrYZ3Uxo17W0uoZ+aDM/O4gU2/afjpxy7CxjLOtKsdlcrfmze8EBI4R8ww4+yW6LJ
	 w6ZMD385H7ifFCM3w/K+Rad37N4sxwWBHVinZILLO8K6UCQs+UBna5nnBGBZmJTb/UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4njdHqz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681E1606A326;
	Sat,  7 Nov 2026 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X4njdHqz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AE11F0089F;
	Sat,  7 Nov 2026 14:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060848;
	bh=VvxZY8Bb5Ardqtlq4BajiCw+xcmm+8UwxEz7uqsaFVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4njdHqzScxiRDXDhudWpM552Z017qFsO0cUoB39DX21Lms4D7ihAymB8M8EDgpQx
	 jzrZZmo9obWwtESEhvIQgbJs4zUPK9aY8R3tVTSIJBEcqpIR7xx7RYns6gMTiVXIAG
	 E0ht3MukBsAwnBkePxddVDMKdXFUrTX6wqpkx+aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0235/1536] ALSA: hda/realtek: add missing error checks for COEF index reads in alc269
Date: Sat,  7 Nov 2026 08:37:31 -0500
Message-ID: <20261107135004.274489356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 5b106b40ed22098f2bc049efb645148d038444bd ]

alc_read_coef_idx() and alc_read_coefex_idx() can return -1 on error
via snd_hda_codec_read(). Several codec initialization and shutdown
functions save these return values and later write them back to
hardware registers without checking for errors, potentially corrupting
COEF register state on a read failure.

Add error checks in:
- alc282_init() and alc282_shutup(): check coef78 before write-back
- alc285_hp_init(): check coef38/coef0d/coef36 before update, check
  val before write-back, and break polling loop on error
- alc294_hp_init(): break polling loop on read error

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260730015302.253008-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 25b37626a705b..eff234786c162 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3442,7 +3442,8 @@ static void alc282_init(struct hda_codec *codec)
 		msleep(100);
 
 	/* Headphone capless set to normal mode */
-	alc_write_coef_idx(codec, 0x78, coef78);
+	if (coef78 != -1)
+		alc_write_coef_idx(codec, 0x78, coef78);
 }
 
 static void alc282_shutup(struct hda_codec *codec)
@@ -3479,7 +3480,8 @@ static void alc282_shutup(struct hda_codec *codec)
 
 	alc_auto_setup_eapd(codec, false);
 	alc_shutup_pins(codec);
-	alc_write_coef_idx(codec, 0x78, coef78);
+	if (coef78 != -1)
+		alc_write_coef_idx(codec, 0x78, coef78);
 }
 
 static const struct coef_fw alc283_coefs[] = {
@@ -3731,15 +3733,19 @@ static void alc285_hp_init(struct hda_codec *codec)
 
 	alc_write_coefex_idx(codec, 0x58, 0x00, 0xf888); /* HP depop procedure start */
 	val = alc_read_coefex_idx(codec, 0x58, 0x00);
-	for (i = 0; i < 20 && val & 0x8000; i++) {
+	for (i = 0; i < 20 && val != -1 && val & 0x8000; i++) {
 		msleep(50);
 		val = alc_read_coefex_idx(codec, 0x58, 0x00);
 	} /* Wait for depop procedure finish  */
 
-	alc_write_coefex_idx(codec, 0x58, 0x00, val); /* write back the result */
-	alc_update_coef_idx(codec, 0x38, 1<<4, coef38);
-	alc_update_coef_idx(codec, 0x0d, 0x110, coef0d);
-	alc_update_coef_idx(codec, 0x36, 3<<13, coef36);
+	if (val != -1)
+		alc_write_coefex_idx(codec, 0x58, 0x00, val); /* write back the result */
+	if (coef38 != -1)
+		alc_update_coef_idx(codec, 0x38, 1<<4, coef38);
+	if (coef0d != -1)
+		alc_update_coef_idx(codec, 0x0d, 0x110, coef0d);
+	if (coef36 != -1)
+		alc_update_coef_idx(codec, 0x36, 3<<13, coef36);
 
 	msleep(50);
 	alc_update_coef_idx(codec, 0x4a, 1<<15, 0);
@@ -4004,7 +4010,7 @@ static void alc294_hp_init(struct hda_codec *codec)
 
 	/* Wait for depop procedure finish  */
 	val = alc_read_coefex_idx(codec, 0x58, 0x01);
-	for (i = 0; i < 20 && val & 0x0080; i++) {
+	for (i = 0; i < 20 && val != -1 && val & 0x0080; i++) {
 		msleep(50);
 		val = alc_read_coefex_idx(codec, 0x58, 0x01);
 	}
-- 
2.53.0



