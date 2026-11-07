Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063016;
	b=Ii3sF/iPvFm9vmISih1WVIcCy/fO0Gz9RewcELwFaeDZR21vFen8ETfezmgFI0goqBWN
	 1N5HdtX4+XJSgmbxMLgWnXT2UQZkWqM4p2AyVdZv7114u9SaU3t+qxV1rM9/V+H3t1y7G
	 P8UsTi6f3PXq4XTVZCGPPiXuQE/j/ic54c7TyqHVsvDQ4DwZIklmrqPWyNixJb8mwgHja
	 pvzXMOD1zeOqAxdXUDYdTZzk3EkosHE0gCsj7MXLVe4RDkvNUN5FJtHw1YixvdKS2mEhS
	 /OWUgPK5dbPaJQHO2fFgyOUSnCgTeyTcXE2/2u09nsh5g4NbYz0tcACMH7osrbPmS0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nulyqsUR3GqVoMvjxKLSokaJaHMObvJ+Wn2TylpvkQ8=;
	b=Qe0pSU4K0Co3RLqu4iGV18ki8j36uUndwGPDL1nU4gL28rvjY6RO2wUD9pSX6PHHV0v8
	 7qLA4dy82MQWVT0a6MNQdofzJAR6ZMyEBESvgjs3x03Oew5e/yPEUy8yRYNq1VrEA8mqj
	 coCpBDbvM7kxaByUIflHUhze78T4iZmcjcXhfoaRqhcg5WMVBsug+PdOF78oKkbKLtmpF
	 Dsvohz8opssMR5U3lbBhNcz4zLHgIsHZWpYH7o5Y9ihGBojrgLp0pKOtJI102m6UKmNbd
	 RykliK2I2UVxHbTNp2vPKHmtPApjv0demmEz+A2KJU4IBiS1FjGObeZjMrJoNP3V7MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n0I730h3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F36606D821;
	Sat,  7 Nov 2026 14:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n0I730h3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BC41F0089F;
	Sat,  7 Nov 2026 14:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063015;
	bh=nulyqsUR3GqVoMvjxKLSokaJaHMObvJ+Wn2TylpvkQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n0I730h3hyAagXsbPyOtM4kqZMpKDePrVUyeGVSjlx5PmF4WvGzyukig3KTBGLOUJ
	 B/67HQPiA0RB48Ep2G4uQJuCQG22jBLaqqh16LJBKmeLvCEYKwJGRNoAMLAgW7LwWg
	 /+qBz79xW/O5QykyXQQEGfcCSkmU9o1PMFCkMdR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 266/869] ASoC: codecs: wcd9335: Fix SLIM interface device leak in wcd9335_slim_status()
Date: Sat,  7 Nov 2026 08:49:08 -0500
Message-ID: <20261107134900.736540452@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 082723fee626532f176727b6438b666a96d5246c ]

of_slim_get_device() returns a device with an elevated reference count,
and wcd->slim_ifc_dev is intentionally kept for the codec lifetime on
success. However, all the failure paths of wcd9335_slim_status() return
without dropping that reference, leaking the SLIM interface device
whenever the register maps cannot be created or the codec fails to come
up.

Put the device on each of those error paths.

Fixes: 20aedafdf492 ("ASoC: wcd9335: add support to wcd9335 codec")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917164853.2163184-1-vulab@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 9887a10881b07..d607400b3976d 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5131,25 +5131,32 @@ static int wcd9335_slim_status(struct slim_device *sdev,
 	slim_get_logical_addr(wcd->slim_ifc_dev);
 
 	wcd->regmap = regmap_init_slimbus(sdev, &wcd9335_regmap_config);
-	if (IS_ERR(wcd->regmap))
+	if (IS_ERR(wcd->regmap)) {
+		put_device(&wcd->slim_ifc_dev->dev);
 		return dev_err_probe(dev, PTR_ERR(wcd->regmap),
 				     "Failed to allocate slim register map\n");
+	}
 
 	wcd->if_regmap = regmap_init_slimbus(wcd->slim_ifc_dev,
 						  &wcd9335_ifc_regmap_config);
-	if (IS_ERR(wcd->if_regmap))
+	if (IS_ERR(wcd->if_regmap)) {
+		put_device(&wcd->slim_ifc_dev->dev);
 		return dev_err_probe(dev, PTR_ERR(wcd->if_regmap),
 				     "Failed to allocate ifc register map\n");
+	}
 
 	ret = wcd9335_bring_up(wcd);
 	if (ret) {
 		dev_err(dev, "Failed to bringup WCD9335\n");
+		put_device(&wcd->slim_ifc_dev->dev);
 		return ret;
 	}
 
 	ret = wcd9335_irq_init(wcd);
-	if (ret)
+	if (ret) {
+		put_device(&wcd->slim_ifc_dev->dev);
 		return ret;
+	}
 
 	wcd9335_probe(wcd);
 
-- 
2.53.0



