Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829699;
	b=cnH3Z6QJ7A+1Re60jYnnyxWPEibH7cFbMjGLT4f2OIMm4qd+G8TeQsQQ+4UUBu+kuMNT
	 y6Bbg9Al7zJNVMyTfRqv++qPCxm7y8ZXGesbhID5wB9wNZKuRYILaEbf66/eAjrvajyrY
	 2Hv+PRAkjfonZSZo4brTU/loq+D08tzCtWXXg0eCihVWeTLIkh0WRIO/Pmt+Qf6SgI8rF
	 hTRgvTccOjEGiKMuwgynznHYk0VGbZbX+gclRYafkfpCnVKS4Yz+atE/y9WW3OCwsjJnc
	 OXy+QkCuy9r5piTOEwolsX66ELpaz/vyAjmVInD1Di7dIAvIkTbU21OOHzIfxEc9i+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829699;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7VySvBCPPdYtMKFHBKJcey+IJl+rILCqNV4Scv8FXJQ=;
	b=nZEqBzeRCsyDuYT67VFvsgOx9edNT1fjbNacfdzSna3Go8UYRifroHLJBfP36lrQpd8v
	 hYDG6uC/tjcYtKsGsy/nMnEIb6QGVGiJ23PjGCfG1F5Gg7cGASRX+2O3RVilq6J+V0Rf8
	 Y8fz59SrRLMvsQeBYVQYAcA6PYZEv1NHV31TJ8/diXp4woRJr+6Z9l3rekAG2C49HXAMC
	 N/TPJKYGwRvksnMcIwtbKqUqmA9/J7fHwbQ7gSNH3O5TAPUODSeLhOA58WA7gUmGpmr9Z
	 aa9N1LlEvhylMcNyjPI6aX6EMsGljPqCwqtVSEyZtg8KTM4TU3fMXRrAWmJeoWsEXcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XnuT91T4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2749606BA30;
	Wed,  4 Nov 2026 22:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XnuT91T4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237681F00A18;
	Wed,  4 Nov 2026 22:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829698;
	bh=7VySvBCPPdYtMKFHBKJcey+IJl+rILCqNV4Scv8FXJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XnuT91T4nsSbTr71+gYpjWPGH5MgDqUQStCF7OdexzoAr/JhXo8iLbsLMiPkuhHdv
	 dPmGttF+eRzmR2+V1weR+tkN/EUnF+dTNxF4mP8QonwYjHrsHyBnnLYLM1WYCze31R
	 uR/6qw70UsjwHZFwc9p5eRqX/I5lXRc2O7Lo78hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0287/1005] ALSA: hda/realtek: add missing error checks for COEF index reads in alc269
Date: Wed,  4 Nov 2026 16:00:20 -0500
Message-ID: <20261104211051.939358411@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/codecs/realtek/alc269.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index d88627558150f..3364f6ad91fcb 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -296,7 +296,8 @@ static void alc282_init(struct hda_codec *codec)
 		msleep(100);
 
 	/* Headphone capless set to normal mode */
-	alc_write_coef_idx(codec, 0x78, coef78);
+	if (coef78 != -1)
+		alc_write_coef_idx(codec, 0x78, coef78);
 }
 
 static void alc282_shutup(struct hda_codec *codec)
@@ -333,7 +334,8 @@ static void alc282_shutup(struct hda_codec *codec)
 
 	alc_auto_setup_eapd(codec, false);
 	alc_shutup_pins(codec);
-	alc_write_coef_idx(codec, 0x78, coef78);
+	if (coef78 != -1)
+		alc_write_coef_idx(codec, 0x78, coef78);
 }
 
 static const struct coef_fw alc283_coefs[] = {
@@ -585,15 +587,19 @@ static void alc285_hp_init(struct hda_codec *codec)
 
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
@@ -858,7 +864,7 @@ static void alc294_hp_init(struct hda_codec *codec)
 
 	/* Wait for depop procedure finish  */
 	val = alc_read_coefex_idx(codec, 0x58, 0x01);
-	for (i = 0; i < 20 && val & 0x0080; i++) {
+	for (i = 0; i < 20 && val != -1 && val & 0x0080; i++) {
 		msleep(50);
 		val = alc_read_coefex_idx(codec, 0x58, 0x01);
 	}
-- 
2.53.0



