Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033948;
	b=0yqVO2uGeZe6PhoLsbbU3BKlS7LtGjZIWoz4AvhVEsz/l2m3bKCdrOR7m6yF3wwF4aLb
	 PkuFxTWzCbui9swQ46xKIjP4QJLBqB40BReCy0qx2xOSQhjHAx+sskydRzeYrvhgTxsYc
	 /TNVrQfT892uLU7NXiN/Wd7cFBlA3tXuQvg9R2xhEff7/EPanSU7jh8cNneHTZL3wOUu4
	 M73QqFuXuiEsHIjZ0i1gfumafJKp1msYyVRAPsz9ohlwJRzs7YU0oEE8O8AKMgkxBwf+q
	 wBZud+dtGdwuyJsMj0EwK/pxwU7iKU93v1a4PiuZbZ7LZKWKBumfAYIzRXGiRsFPfYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WHpYmDzQIf2Xa1d4V9f4ZL+o5+MXMqsAl6kB2Surj5s=;
	b=D12hlUrB83yJ81q/rHZDcpEjtmkNzqF6GoqjpGVOlBxFh/UaG3vp3FSjPiXiYlGsLLbS
	 bjScHjVI+ip2Ha+5MArDRodS7GoQq5U5/dPlwwrDLc/5eoMwEw3LjbSPtFM3Rd7Lpremg
	 5Sepj1P8PJlEyL1RO26AAXQyGO7ZvgBnYMDcVyu40Wvr0Am1wy0aJMpvLV8pFV1gymTs6
	 DuiErvZI3hh1dB5PWnRPiA7ShinQdJvpEFo9I9HQ4G5YL1+IE38NKg7UQngTGgb7FoKnp
	 zMi5XKpIZLl8OgGc6Kl4dF+PWEXV4izb/VgyTggTABLG8f1P4Z5N98n8at485GnRlEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvjGeNl9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFC3606A33F;
	Wed, 18 Nov 2026 20:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvjGeNl9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21E61F000C4;
	Wed, 18 Nov 2026 20:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033948;
	bh=WHpYmDzQIf2Xa1d4V9f4ZL+o5+MXMqsAl6kB2Surj5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvjGeNl9pPlIxE8DTd7FMDJrmr4kod2SbfQmiRvlXQMrL6jzbqwuZW50WDAPUoQYH
	 57aBX6I7GRBf5oVg18HqPRRTGvSAFLW+/ajzOgXUa+Gw10QFtcdk4217D7rvzP1wgg
	 No6hsUy5uNfTBLpsBTr7r/onLBKhzHhWrFR5wV74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0195/3318] ALSA: hda/realtek: add missing error checks for COEF index reads in alc269
Date: Wed, 18 Nov 2026 15:13:37 +0100
Message-ID: <20261118150320.673182966@linuxfoundation.org>
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
index 6141b813b21ab..16ad87a2c6f07 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3430,7 +3430,8 @@ static void alc282_init(struct hda_codec *codec)
 		msleep(100);
 
 	/* Headphone capless set to normal mode */
-	alc_write_coef_idx(codec, 0x78, coef78);
+	if (coef78 != -1)
+		alc_write_coef_idx(codec, 0x78, coef78);
 }
 
 static void alc282_shutup(struct hda_codec *codec)
@@ -3467,7 +3468,8 @@ static void alc282_shutup(struct hda_codec *codec)
 
 	alc_auto_setup_eapd(codec, false);
 	alc_shutup_pins(codec);
-	alc_write_coef_idx(codec, 0x78, coef78);
+	if (coef78 != -1)
+		alc_write_coef_idx(codec, 0x78, coef78);
 }
 
 static const struct coef_fw alc283_coefs[] = {
@@ -3719,15 +3721,19 @@ static void alc285_hp_init(struct hda_codec *codec)
 
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
@@ -3992,7 +3998,7 @@ static void alc294_hp_init(struct hda_codec *codec)
 
 	/* Wait for depop procedure finish  */
 	val = alc_read_coefex_idx(codec, 0x58, 0x01);
-	for (i = 0; i < 20 && val & 0x0080; i++) {
+	for (i = 0; i < 20 && val != -1 && val & 0x0080; i++) {
 		msleep(50);
 		val = alc_read_coefex_idx(codec, 0x58, 0x01);
 	}
-- 
2.53.0



