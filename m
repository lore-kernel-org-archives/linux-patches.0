Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051284;
	b=YR9JWZOOkHSOkJN3UHRH+FxgAFYEcfAG19jOO/Ul4P1YfFR/JhrAGoanz8ZT9qyQiuzn
	 Y8DlXDCm7hOr/fEzamY4V5srB2kJilmV4poYek0lYBo2HrijaX8O4XNhN+DJhi863fRfi
	 nTZNqwtVxhV2FUoX3RjHhlovZKldW1/y523mo3qcPlJTHO4uYgG2/rxJ5/1I3fjg7sxn/
	 M3NGQvO/0yqZzACDeUYtfeOEgcAmbwWvFB0iE2qWYV7hIZ/9rkM8KyKcoTb2HwgG7lVJm
	 m84tqCBsY6zuCeuS/iGpRWNnt419ylfYymAgQYyrr7bUf6KwXLULbwFrfrvObmkyY6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=djq1BrlhB0SvLY+/6h1k8pVNDZwY5KLtdWyB+rptsk0=;
	b=png/X5VB3kxO8LWUDCL7cbBcCj8C4bdMniubY3OkAX23NqWshfIKX9ZwxwXsXLErdhO0
	 dVkvh9Q6Ow2aPQSADBW8je8B2jRmE7SXnQshPwQyR5vTY0Ocu4xv6Q1/B8VZ7VQkDWGrw
	 POSq5KF2b6m9jnj/+l9jixwQ7K8NDm8tyEkw2V4ZbWMV2vEAVGeK3IIA9J9XLyH7PnjoQ
	 Zn9r2qKaL06hly+X4KbglJ4zUEgtyfsHeRJVr3tTCJF/lWzKX9qTxKwpB/wsJwfqMXxZh
	 uNNiW20F42dgxqSgAgZvAcdwzrAkOCixmdcahjFjCs1MFL1w+8XH6fGhHP608HDByWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p0ercVxX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C207606A325;
	Thu, 19 Nov 2026 01:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p0ercVxX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34C81F000C4;
	Thu, 19 Nov 2026 01:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051284;
	bh=djq1BrlhB0SvLY+/6h1k8pVNDZwY5KLtdWyB+rptsk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p0ercVxXBrAzzotYNhoz9aHCbxMq0EZohxWNBabukSPp8+KcwiZ9s9j4iNSPN5BUD
	 1x9J1Jzec/bF5cOxcEdBKkhrjm4xYbDfUvr2NDdnvhoC3KHLRJVPYlSecFmHi6k3Qp
	 XMWZGiPCwyLbd5eAxl6I+T1p2d0ssBFthzeES3rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0154/2214] ALSA: hda/realtek: add missing error checks for COEF index reads in alc269
Date: Wed, 18 Nov 2026 15:30:30 +0100
Message-ID: <20261118150016.306380902@linuxfoundation.org>
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
index c2aa68164e812..207aad871e320 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3420,7 +3420,8 @@ static void alc282_init(struct hda_codec *codec)
 		msleep(100);
 
 	/* Headphone capless set to normal mode */
-	alc_write_coef_idx(codec, 0x78, coef78);
+	if (coef78 != -1)
+		alc_write_coef_idx(codec, 0x78, coef78);
 }
 
 static void alc282_shutup(struct hda_codec *codec)
@@ -3457,7 +3458,8 @@ static void alc282_shutup(struct hda_codec *codec)
 
 	alc_auto_setup_eapd(codec, false);
 	alc_shutup_pins(codec);
-	alc_write_coef_idx(codec, 0x78, coef78);
+	if (coef78 != -1)
+		alc_write_coef_idx(codec, 0x78, coef78);
 }
 
 static const struct coef_fw alc283_coefs[] = {
@@ -3709,15 +3711,19 @@ static void alc285_hp_init(struct hda_codec *codec)
 
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
@@ -3982,7 +3988,7 @@ static void alc294_hp_init(struct hda_codec *codec)
 
 	/* Wait for depop procedure finish  */
 	val = alc_read_coefex_idx(codec, 0x58, 0x01);
-	for (i = 0; i < 20 && val & 0x0080; i++) {
+	for (i = 0; i < 20 && val != -1 && val & 0x0080; i++) {
 		msleep(50);
 		val = alc_read_coefex_idx(codec, 0x58, 0x01);
 	}
-- 
2.53.0



