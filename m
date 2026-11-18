Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059450;
	b=4NF6GaXRKMhdQx8wsSHNhmDB/yy+GQrvwEdaRVmJx5mR+yvSalt72BaDG2e/9Ssf2X0e
	 wsgqhp27axB6rvSue/3SvkI7AQBzUz+HCc9B/033ql0MoZ6VAPjGLHvIFBfWAnjxvAbv9
	 9fLt81SIOWaMLvWBexFrQfcTZLmM6f1Fx/3VS46DjWwUt+BHrXdmuvBPdHRT7uvOgDEo6
	 CTzONMr6YtRMVg726X3UdY4idWi2mfZaNpl+X82o35+4dFlRMJvFJ8Ia3hLIhRDP6LGCF
	 UK4w7vXXEtMmxK0O86ylrsPEUTCyWKVQ4i8rRbXZxjzCOd0GFUd63//Bb20OGDKC3UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f4/7IBKr6tDJmh1i9JtZ+zddyw15ZKBaJExMSa0TL9w=;
	b=CUQ6B5LqK4UoOjTOvhNkau74b1a1Tztfva7wlFSq6ScUrLCwxlug4hn4GJuFqCUIJU3R
	 c5d8HxaN2YDwGxG90bAQIHpQN1Pn6p6C5F/ofrrYY/nnyqyIM9k+IXK0dJ67roOxKr41C
	 4Cl0XTo+9rH831TAx7ndPFm/KUCJ501kr0ho8BSEy5FJQdl2EgwUOeUaGeRV9xgi+4OC4
	 ehgGk2jKz9Yz6T3Ro2mYoMxZT5kfZbYbxUB5c0x1yskmF7muxVaWp/lUY9XxtK53VcLgY
	 5LnyltgJpi3En9M9c2MsJXq3N7HUnJStj6srbdSB/+kU55k0WTdw20QkVY+Mp2fbYyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qur7OVWE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D11606A325;
	Thu, 19 Nov 2026 03:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qur7OVWE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0061F000C4;
	Thu, 19 Nov 2026 03:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059450;
	bh=f4/7IBKr6tDJmh1i9JtZ+zddyw15ZKBaJExMSa0TL9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qur7OVWEJM0lCHWMEAjHMQP59nbgHWg67ms3uc6apj0hQ77HLbDNxtNngXFt5/S+p
	 mwfUii24Gfm2kaZus+W1cEejDc3+5oMdr47wnJJDOPfQYYARMjzrqSS7Rn1IBfcV4Q
	 pEv5Rsts2OqlNmmrLJ8QJTummbfgpzTTnW2dRhy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0804/1848] ALSA: usx2y: Refuse a retried DSP load after a failure
Date: Wed, 18 Nov 2026 15:47:22 +0100
Message-ID: <20261118145950.004579091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

[ Upstream commit 1f8101b6adc87a3ddbd51fcb6609251591758026 ]

snd_usx2y_hwdep_dsp_load() sets up the asynchronous sequence URBs and
the interrupt URB when the FPGA firmware image with index 1 is loaded,
and then creates the ALSA devices.  If usx2y_in04_init() or
usx2y_create_alsa_devices() fails, the URBs that were already set up
are left in place.

The core keeps the index unloaded when the callback fails, so user
space may issue the same request again.  The second attempt then enters
usx2y_async_seq04_init() or usx2y_in04_init() with the URBs still
allocated and trips WARN_ON(usx2y->as04.buffer) or
WARN_ON(usx2y->in04_urb).

The URBs cannot be released at this point: the card may already have
registered PCM devices that user space can still open, and the
disconnect handler accesses the URBs without holding the DSP lock.
Mark the chip as hung instead, so that a retried request is refused
with -ENODEV and the assertions keep their meaning.  The URBs are
released by snd_usx2y_card_private_free() when the card is freed.

A failing usx2y_async_seq04_init() still releases its own URBs, so that
path remains retryable.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20261031191557.8460-1-25031212351@stu.xidian.edu.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>

In 5.10 a failure of usx2y_create_alsa_devices() frees the card, so
there is no retry to refuse on that path and only usx2y_in04_init() is
marked as hung here.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usX2Yhwdep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/usx2y/usX2Yhwdep.c b/sound/usb/usx2y/usX2Yhwdep.c
index eeafe580d0382..50c03e6cd5d5c 100644
--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -193,6 +193,9 @@ static int snd_usx2y_hwdep_dsp_load(struct snd_hwdep *hw,
 	int lret, err;
 	char *buf;
 
+	if (priv->chip_status & USX2Y_STAT_CHIP_HUP)
+		return -ENODEV;
+
 	snd_printdd("dsp_load %s\n", dsp->name);
 
 	buf = memdup_user(dsp->image, dsp->length);
@@ -217,6 +220,7 @@ static int snd_usx2y_hwdep_dsp_load(struct snd_hwdep *hw,
 		err = usx2y_in04_init(priv);
 		if (err) {
 			snd_printk(KERN_ERR "usx2y_in04_init error\n");
+			priv->chip_status |= USX2Y_STAT_CHIP_HUP;
 			return err;
 		}
 		err = usx2y_create_alsa_devices(hw->card);
-- 
2.53.0



