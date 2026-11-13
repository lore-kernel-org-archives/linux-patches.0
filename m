Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591240;
	b=e1emBCQJUvX/KK7upo9NFgAcdf+IjGhsR3uOPlQ7nrlsBCDs9k60PoJS4CYkECYhOLb+
	 7T3hYXLKjKpLEx/YTq+9quIoV766Elf7zK1x3+VbDoyzfeUE//2OuE3I9KEM6H7UuXnv2
	 H1bGhqyIuSKG8cf8SmQ5s5LrGVB54GHydgj2vHFF/T2/hdK8L9HwR7JKFBZL/9a1HXu01
	 niE8pFnQsK77c1lCjZ3oBZvMZH0zW5GNh/qqQmf2sGbuEci4Tl3UDfXpQ5Hq004Ssg/NO
	 Qh4EV0tMf8IVyYCoRFnV2LKAcwWd7sJsrGjALfLo7UaJ6qD6GFlBVpG3oGTjG529B6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IhAeOOUuD5maeC6/oPlgs4wWFkWLkPeYbYrCCfbkLnw=;
	b=QTct99Hb4SGuruq49lEqZ4z+b/n+7+CaW21qzBXVsVKvMgXC42pzAdWHKxgL1QMZRJYv
	 08CfQzZhG171UH1mUm/SDdGP2bb29Kh90IdDtmdR3gqB6PfkGK2B01LkBUT0yFcIqYT8q
	 iCSg8fVWIxCp4xC4Gc3UK0T04tTVJnGGD+PXdMCw+Y1YFld0xIszFcd8FCIhBLI6ojCjN
	 edW4BcPxQra0XbIGao/o/FVt1pRzTSRg5F6sCgylVVk6eVJ38Di0EKAvFKorUWpDlRGxK
	 fy9H3fHfO0h5hQ454xjV0WwibMquqPDeN61k1IoWBgTfCdGqR81s2G1h+/BEClkhwPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V/XYyi7j";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B136075E2F;
	Fri, 13 Nov 2026 17:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V/XYyi7j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8C71F000C4;
	Fri, 13 Nov 2026 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591240;
	bh=IhAeOOUuD5maeC6/oPlgs4wWFkWLkPeYbYrCCfbkLnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/XYyi7jZDM/ZDlS6AcTYFvOAlOwEtRDquFUUsCumv4sD4re+JNZ+dm17slC68PvW
	 Cpj2nyVCHWMOBWKZL6ZfWZzE9+1pR9B4M/jY2UiwaB0B58KHiHdXcwIb3/LBRKkcB4
	 KqTRl9lQYMZjYoY/inIfikFr/+nuDQRpQlIceKAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 367/670] ALSA: usx2y: Refuse a retried DSP load after a failure
Date: Fri, 13 Nov 2026 10:48:51 -0500
Message-ID: <20261113153824.240509714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/usx2y/usX2Yhwdep.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/usb/usx2y/usX2Yhwdep.c b/sound/usb/usx2y/usX2Yhwdep.c
index 2cc0f90a23be3..be755a8afaf26 100644
--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -179,6 +179,9 @@ static int snd_usx2y_hwdep_dsp_load(struct snd_hwdep *hw,
 	int lret, err;
 	char *buf;
 
+	if (priv->chip_status & USX2Y_STAT_CHIP_HUP)
+		return -ENODEV;
+
 	buf = memdup_user(dsp->image, dsp->length);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
@@ -201,11 +204,13 @@ static int snd_usx2y_hwdep_dsp_load(struct snd_hwdep *hw,
 		err = usx2y_in04_init(priv);
 		if (err) {
 			dev_err(&dev->dev, "usx2y_in04_init error\n");
+			priv->chip_status |= USX2Y_STAT_CHIP_HUP;
 			return err;
 		}
 		err = usx2y_create_alsa_devices(hw->card);
 		if (err) {
 			dev_err(&dev->dev, "usx2y_create_alsa_devices error %i\n", err);
+			priv->chip_status |= USX2Y_STAT_CHIP_HUP;
 			return err;
 		}
 		priv->chip_status |= USX2Y_STAT_CHIP_INIT;
-- 
2.53.0



