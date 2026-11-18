Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046634;
	b=LJGx2zO8+JK7jKusYOsEq1wgt8DMMILNR6Ybf7VHw1rVb3qf7cxxaDQMdVpNTgNT4OLg
	 xcpzvvOXcodTOwY1oj6d0aqPlKpwyS2A2ITs94iQxa3fK+KIcmqNkDYCn4wXnxePoziJ9
	 aZbn87DPIIa2m6f2h16rMeOzFJPkPIojWdUlZKJBhs+qkzh2J1L4ghrgjY9QBapY2tl9j
	 SbPD3OUQw6MdktBQzDYf17FLVVulZvzRtTwEYYddNQChHUoJ8S6nb8tdjiGjZvNrO6CJL
	 7ROiKfmwAqYbm5c39/4BMONKf5yRtEKxB3Xq7Ae6Dtvk21azWNLy4G3inAkLqet3/RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sKblxi+Og98OMKviW8s6NJAs0KCYQJuG4N5W7qJoNKg=;
	b=w/XUJnMnTqXTpmu7IIlR5+nQ1m/4JMkBPV1xM66N//M/Zm81tdcdANulfyQ2HzIsgVis
	 d1eX4br1o998EoXqH3jQPbXamvlGg3BG1OPiwwwQAo8FfKNLsMeV81/uhK2xP7wfuPhp7
	 omnCAkFw3hExD5vsYPJ/uoiAKN0g80OrRz9ROej2DKaDPTf2JhUgmQmGl+2D4m+LxIrl6
	 RshMJXzGDzOq+WHz6OK6Pf4c/xD8CsFTr0qOJhyoB1/YPIOuQPeMZv93EFC2nfuwZdNaq
	 svQOudoM3k9OhOqTJ2t2Uo/xf8ckniRDptH4SKdU2BgPtD2z3wIJcTavgC3mhU2z8Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eOx9pwDt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2316606A31C;
	Thu, 19 Nov 2026 00:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eOx9pwDt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AD71F000C4;
	Thu, 19 Nov 2026 00:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046633;
	bh=sKblxi+Og98OMKviW8s6NJAs0KCYQJuG4N5W7qJoNKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOx9pwDt9VR3k+xMwWP4NHmFfQTsVIg2cccqPfkemYXEQSsGuveJhWHdq4fx+KLKr
	 QOlCrPofKX8YfZqzz+FHuBHzO9mhuhzlDMpq9Xr43ZpbIXTlcW9gRFy/j+L+FgkcBF
	 zFQouJCjkhxHx0VQeih399JdKPkYItQ0iwK00upQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1352/2857] ALSA: usx2y: Refuse a retried DSP load after a failure
Date: Wed, 18 Nov 2026 15:39:46 +0100
Message-ID: <20261118150250.095248079@linuxfoundation.org>
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
index c0293af448fe7..89c7ff597a442 100644
--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -185,6 +185,9 @@ static int snd_usx2y_hwdep_dsp_load(struct snd_hwdep *hw,
 	int lret, err;
 	char *buf;
 
+	if (priv->chip_status & USX2Y_STAT_CHIP_HUP)
+		return -ENODEV;
+
 	snd_printdd("dsp_load %s\n", dsp->name);
 
 	buf = memdup_user(dsp->image, dsp->length);
@@ -209,11 +212,13 @@ static int snd_usx2y_hwdep_dsp_load(struct snd_hwdep *hw,
 		err = usx2y_in04_init(priv);
 		if (err) {
 			snd_printk(KERN_ERR "usx2y_in04_init error\n");
+			priv->chip_status |= USX2Y_STAT_CHIP_HUP;
 			return err;
 		}
 		err = usx2y_create_alsa_devices(hw->card);
 		if (err) {
 			snd_printk(KERN_ERR "usx2y_create_alsa_devices error %i\n", err);
+			priv->chip_status |= USX2Y_STAT_CHIP_HUP;
 			return err;
 		}
 		priv->chip_status |= USX2Y_STAT_CHIP_INIT;
-- 
2.53.0



