Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038182;
	b=XF4+1bMnqS3pc4AoR6Xz4LL3O/yr81XLsLfTs+PvvGkIb174iHQi74OTmJTk3QoaUkXf
	 m6C7rCG04ejN1S8azpO5etbli6tWW6nGSBNov3Ohk5paJUiDIKg02TQG2m4YW98/jTHoy
	 NTvDxMjiajJWiRH6T7IWIqPR7I3Ut77mYDWhoq/Jefp2zSGjCpYl+bEPVSZBM/cu12Hi8
	 LayLBrIln7F4WerS1PjeXWaUYcbjnbI4vVi65GZ8Ea1D7LTaLEBDvWdqMa8hFwX43auWC
	 /DLMGTW7M6DzKAHYA/qHQB1q81jX6MwDQhVYIF2HdNm90fYgnAPHIGUNHoidCP2y6pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gpcCZNxBMcO3/lFgLL204lKJB/14CYXLOepLMjhBKPo=;
	b=mbbh38RFVaTGVZ5AeMABJ1ZE7Inar5DE8iqc5VOWbvagUzn1jYYQhmCO5GEDneExcZrd
	 em1kYvSlkAEzNE8Vqt7HaSsM8MW1FWaD68qdA9T36raEEGPmheDhiBWQVdERrgFvx+fZE
	 fNHa49ofy8yl0EUDCQRLVGNfDWGZ6RjuTeW74zfwkH3r86y6XFi1R6TNiuqZduHeU9Zip
	 9rjSGl83Is0nXUnz7E7oSNP8tjEtGeHVj6R9XXiU84yobjw1OrhKUGwS4GJ2F2MlI1/Uj
	 FZlDu+j8bPUMH/J12jng8A8q72kJidDBxnIs4qYQ+XmR/8m4TPBhOwGx4nEI6kxuwJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Nlcmzy/y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09413606A31C;
	Wed, 18 Nov 2026 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nlcmzy/y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562C11F000C4;
	Wed, 18 Nov 2026 21:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038181;
	bh=gpcCZNxBMcO3/lFgLL204lKJB/14CYXLOepLMjhBKPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nlcmzy/y8HP/nZZVswR53h7CQu9v7IycNX9mHmpK15Y0bviQcXvdmDjyLxNaXvNxP
	 7Zrghn80n3F5fdPF1cjxplQPX2DQKHToIkodTVo2K4VdfeSIuEwe5kf8YJXuDDJ6qF
	 aGUOU6cNkAjbvQogXVJa1uiu+8pvz/Gyh1GRks6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1603/3318] media: meson-ir-tx: Simplify and improve using dev_err_probe()
Date: Wed, 18 Nov 2026 15:37:05 +0100
Message-ID: <20261118150409.265771398@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 9af7c980f3ea3e85418beb25dc4d34939183e436 ]

With dev_err_probe() the error paths can be implemented in a more
condensed way with the added benefit that the error code is added to the
error messages by name.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 32999b8a9d5c ("media: meson-ir-tx: Ensure rc_free_device() is called on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/meson-ir-tx.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/meson-ir-tx.c b/drivers/media/rc/meson-ir-tx.c
index be353d22bbd7f..94208f76bb33a 100644
--- a/drivers/media/rc/meson-ir-tx.c
+++ b/drivers/media/rc/meson-ir-tx.c
@@ -337,20 +337,17 @@ static int __init meson_irtx_probe(struct platform_device *pdev)
 	spin_lock_init(&ir->lock);
 
 	ret = meson_irtx_mod_clock_probe(ir, &clk_nr);
-	if (ret) {
-		dev_err(dev, "modulator clock setup failed\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "modulator clock setup failed\n");
+
 	meson_irtx_setup(ir, clk_nr);
 
 	ret = devm_request_irq(dev, irq,
 			       meson_irtx_irqhandler,
 			       IRQF_TRIGGER_RISING,
 			       DRIVER_NAME, ir);
-	if (ret) {
-		dev_err(dev, "irq request failed\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "irq request failed\n");
 
 	rc = rc_allocate_device(RC_DRIVER_IR_RAW_TX);
 	if (!rc)
@@ -366,9 +363,8 @@ static int __init meson_irtx_probe(struct platform_device *pdev)
 
 	ret = devm_rc_register_device(dev, rc);
 	if (ret < 0) {
-		dev_err(dev, "rc_dev registration failed\n");
 		rc_free_device(rc);
-		return ret;
+		return dev_err_probe(dev, ret, "rc_dev registration failed\n");
 	}
 
 	return 0;
-- 
2.53.0



