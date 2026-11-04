Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831117;
	b=slOInlEA9mFeZbiutGgkD/wiDYOJEutXb4iFbAR8TX05hmuFhF5fJNbSH7BGAH7LU5Sc
	 HLgwBK0wF9R3C+B/3CWgrplTdn9TZjRq4dxSWxc3Y1Orto1TFIWwZulBQT8wzmYIAidxQ
	 wlcLz0LZs14F4bIz9OtBO2N/nixP/PSjAN82Av77qLjezdz16FilE4pQNowcYGkntbi2Y
	 9y1i9S/7x7xNiJeT+pdTr9J6WhvCpjbI+3PCKL0D4ywhOLP8fxRWY/KyBTvGb/WUru0TG
	 GieIPco0OAX5jFqYlXkEakX0GtLTDRVCNRB+SVowhUD9oh9dl3QEyQPl3dP5nsznpFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wkp7nCrWZfiirWUVqdAvfqQs7VDHC8AY9yT2k2ZTIoM=;
	b=vyhhruew4Bwteg67S4zaHWSzEhGna25/gcoI/fgj/sOZGilJJJdmVtGqP5Kwvh8d/8GA
	 pkxPWEPsHqC9xs5OYTlym7QE02jJ4fdoxPEYRowK2U6ZSC+O7veVu0KYZoXNRfFY8Vr5y
	 Xre1qyBG1QO26AHNm9W2uGoPZM0Jge4/EauoDM+j2N+c/GpgfxqQLx4S3P9XO3uCrFe2I
	 UK5j8BcITDic2kpiEIdKk8qTClwqt7KcW1odzRaKvQDOYl7birZcO9upfYkz/CbBa5zfn
	 E5BnBIag8DcMfiev2zpzjARntq5ZAppLemkDyLRQqWwiJsw/wkx+ZIiwPiCKNUi2mLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W1kU/fNx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25933606B3A3;
	Wed,  4 Nov 2026 22:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1kU/fNx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71491F000C1;
	Wed,  4 Nov 2026 22:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831117;
	bh=wkp7nCrWZfiirWUVqdAvfqQs7VDHC8AY9yT2k2ZTIoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1kU/fNxNl+HPcdZ1GZwO0eFuFVpU0GYj64iFfRBfJQQ0CQfr/JZkzCfoYnIS39kA
	 x/LPlY1etTbqv3sQhxIlu5KBO8zmCV1Bxu08Qfxb10Bx8xmcK0H2Kq6WlzxPHMZzw/
	 eAM6rTn2Wh/M1HbQEx7TWykkVTYcyal/A99CawBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeyu Li <13776528859@163.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0505/1005] ALSA: hda/realtek: Add ALC235 support for headset mode
Date: Wed,  4 Nov 2026 16:03:58 -0500
Message-ID: <20261104211058.084155607@linuxfoundation.org>
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

From: Zeyu Li <13776528859@163.com>

[ Upstream commit 9ee4266827cfb67b9fbb89136ea6a8f3d7809f5c ]

The ALC235 (0x10ec0235) is registered as the ALC255 codec variant in
patch_alc269(), but the headset mode functions were missing a case
for it, so the CTIA/OMTP jack type detection and routing never ran
on this codec. As a result, a plugged-in headset is detected (jack
presence works) but the microphone signal is never routed, leaving
the capture stream permanently silent.

Verified on an ASUS M5451GA laptop (HDA:10ec0235,10431814): with the
ALC255 coef sequence applied, the headset microphone works correctly.

Signed-off-by: Zeyu Li <13776528859@163.com>
Link: https://patch.msgid.link/20260926140336.27896-1-13776528859@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/realtek.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/hda/codecs/realtek/realtek.c b/sound/hda/codecs/realtek/realtek.c
index ca377a5adadb5..a1529650950d8 100644
--- a/sound/hda/codecs/realtek/realtek.c
+++ b/sound/hda/codecs/realtek/realtek.c
@@ -1305,6 +1305,7 @@ static void alc_headset_mode_unplugged(struct hda_codec *codec)
 	}
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
@@ -1420,6 +1421,7 @@ static void alc_headset_mode_mic_in(struct hda_codec *codec, hda_nid_t hp_pin,
 	};
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_write_coef_idx(codec, 0x45, 0xc489);
 		snd_hda_set_pin_ctl_cache(codec, hp_pin, 0);
@@ -1575,6 +1577,7 @@ static void alc_headset_mode_default(struct hda_codec *codec)
 		alc_process_coef_fw(codec, coef0225);
 		alc_hp_enable_unmute(codec, 75);
 		break;
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
@@ -1676,6 +1679,7 @@ static void alc_headset_mode_ctia(struct hda_codec *codec)
 	};
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
@@ -1793,6 +1797,7 @@ static void alc_headset_mode_omtp(struct hda_codec *codec)
 	};
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		break;
@@ -1894,6 +1899,7 @@ static void alc_determine_headset_type(struct hda_codec *codec)
 	}
 
 	switch (codec->core.vendor_id) {
+	case 0x10ec0235:
 	case 0x10ec0255:
 		alc_process_coef_fw(codec, coef0255);
 		msleep(300);
-- 
2.53.0



