Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064186;
	b=wB/HJkswVtMZfL7XDaVuQgho37r+UNm8Q1kiD8YH/zbZ0VTfGtbmCXUlpvTV3G3c5MDe
	 jZBjE+yWMBtV5VGy1wCgw9ETD+hXOPk8nRuSaLcrL5uB5RK7o7r8/CvVXUhReP0M7oyna
	 SdO+TDELUNyf0jSHN5Ffkaj2PgXt6HTYHAuEfCIKXsNN18zFopji7sMSsGN/v9ocjXk7Z
	 KMXlpdW3LYQuWL5x/weJyu+8VhwrJerG1kOniwZEipSE46XjE3mEtD8aDOAhlNo7vqvRO
	 U9Olpv5ni2v/tnR6Ji4BlIU/sOoBXAzmn1ChyiIMtJhfx50KWWrd+1FDLD3tU7pE9ZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fFSbQH/AoezS60PxgEiB3x43RI9lxMKowtYLmJPT9pg=;
	b=0gXyxwKCM0otyqZlwtvgdD5ikjPlM5LKkkMl6BtBS7D7T1gt3qp3rf9r35gp8rU9YGGA
	 3d6YgABmT9a4tc5Vq8Ha8JX+0rCtk/6zeNzzRa2yAHg1VMdRjHpV8QzcuTIwJVpmCDqbt
	 l6FafY+VlfEJinqBMIIRd4oaejtOIv2wMNQG2A4mXAtLrTu9brGrnQrKk8zoYE3taSi4d
	 7IveFF3GZ69snMTAJRQi9PumE4NmTEBt3B3GHlNgALjzNBZrjrDx0XQZpHdkZ9NR6/adZ
	 Hwryi35Gv0tUiYHWISUsPYsWQa7TSXdIfVYxEaTZPON6DLGFiRvXnpBWeFUpPI3V5gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fBMB2zZS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB37606E8EF;
	Sat,  7 Nov 2026 15:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fBMB2zZS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287701F0089F;
	Sat,  7 Nov 2026 15:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064186;
	bh=fFSbQH/AoezS60PxgEiB3x43RI9lxMKowtYLmJPT9pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fBMB2zZSCDcF13qPWGtp1R6lNmgj2WsEGQunj1A//gKa3midPRjrFOYt2YY9Nv2IN
	 /GSTvOH9gvS0y4RkQt2Fv0VKy68wD44lgjDiVlDo1m1iROJGB1PxyVImmkqWJj6gtJ
	 Fjff7xYSZTaFxAiskjhzbBTZBn10aHedEZ3cmECI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0328/1257] ASoC: codecs: wcd9335: Fix SLIM interface device leak in wcd9335_slim_status()
Date: Sat,  7 Nov 2026 08:43:44 -0500
Message-ID: <20261107134948.481771692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9332082092c79..a98d1fd789251 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5135,25 +5135,32 @@ static int wcd9335_slim_status(struct slim_device *sdev,
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



