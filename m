Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060592;
	b=z/qPNqaao03Id/Z/oJfvP0EL2oVBgkoAzp46E7GLtlrLHLiZGg6eW39aCzimWqj9HKMR
	 oJKGA756eMwfx/xZAfYYqKT7vS3ooWgvTw7V+mIXsbEf6Pj0gwN7qeu789udCAOU6WxZ0
	 qnyFePt9DaUqAO9YsfOxNLlNCZJ4wC1WjPj9fANyBj+DduoNLuiT2M4gWbMnfVMrb7mVe
	 5eStF8GxI04690F8Wssr0WWLE1WxW3ZfkMDjiqdtnYt7DxOof4WOdtvS3FgNj4r4DGyOr
	 IcA3beM/pWDCb9gLHDm0p9zA1t1ja5UXs3U52OBTEgmw5blKP8FwKfHSWnv0gGyx5hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q74UDETH+3V6ptMbJ3GBmaeyktkxzK9HVEfVrz0N9pY=;
	b=uFIwecuk13AA7OZPWjaD7G0VvEm82SS3T1P4wnF/3qhdGvDA++OwHDLTt+Q/pjhpgx0a
	 5FFpF/ebR8bUz8ZpV/4zBanEiaqmj+amQ3Zyb3Ue2eYPNCKM8VQCsVoE/sgGa7QtRdVBY
	 ReeWTbcSRRLTiI3zQMn1MhSPncNXjRqRXNj06XYZngJaDIZSZIEpDmblR0hQz/eE4Cwy3
	 pRb10Z0QZxcal+Og3GBWQYCZDLJMyW8VrgBx+n7HmGV06vEWyxUf2/hWrLYYxWFvEXpO0
	 +YfU1ZKWKIs7y9g+v7gMxw2O296qsHR1x54mP9/y9fxZn7ZVSIkT9pBKOx5Dzv7Hptg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7vwkLoG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865B3606A330;
	Sat,  7 Nov 2026 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7vwkLoG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3771F0089F;
	Sat,  7 Nov 2026 14:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060592;
	bh=q74UDETH+3V6ptMbJ3GBmaeyktkxzK9HVEfVrz0N9pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7vwkLoGQ7+uhjcwSUgLNu7oqj/vHYEBoFWVAtbCzslX934lsbv77xnVeoyOwsT8O
	 CRnD7dt1o0JctrmmEX8ALD0fCtZcqo0Es0PAmGP4y0SYpq5lBVn7rIqY8UtuuB93lN
	 8X90XBimgbzgUiSxeUa75ekhO7ZKFmmQCunPNJ8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0049/1536] spi: nxp-fspi: disable runtime PM on probe failures
Date: Sat,  7 Nov 2026 08:34:25 -0500
Message-ID: <20261107134959.036584513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit 5d14285d60ba95561609a293064654a0c7d7d928 ]

nxp_fspi_probe() enables runtime PM and autosuspend before
several operations that can fail.

Some failure paths returned directly before the devm cleanup
action was installed, leaving runtime PM enabled.

Route those failures through a common runtime PM cleanup path.
Use pm_runtime_resume_and_get() for the initial clock enable.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_8FC0B8DFAF4AE67AEBA20548045D53A77707@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-nxp-fspi.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/spi/spi-nxp-fspi.c b/drivers/spi/spi-nxp-fspi.c
index b7dbc015d88fa..be60d41520ce1 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -1252,9 +1252,11 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	pm_runtime_use_autosuspend(dev);
 
 	/* enable clock */
-	ret = pm_runtime_get_sync(f->dev);
-	if (ret < 0)
-		return dev_err_probe(dev, ret, "Failed to enable clock");
+	ret = pm_runtime_resume_and_get(f->dev);
+	if (ret < 0) {
+		ret = dev_err_probe(dev, ret, "Failed to enable clock");
+		goto err_disable_pm;
+	}
 
 	/* Clear potential interrupts */
 	reg = fspi_readl(f, f->iobase + FSPI_INTR);
@@ -1264,18 +1266,24 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	nxp_fspi_default_setup(f);
 
 	ret = pm_runtime_put_sync(dev);
-	if (ret < 0)
-		return dev_err_probe(dev, ret, "Failed to disable clock");
+	if (ret < 0) {
+		ret = dev_err_probe(dev, ret, "Failed to disable clock");
+		goto err_disable_pm;
+	}
 
 	init_completion(&f->c);
 	ret = devm_request_irq(dev, irq,
 			nxp_fspi_irq_handler, 0, pdev->name, f);
-	if (ret)
-		return dev_err_probe(dev, ret, "Failed to request irq\n");
+	if (ret) {
+		ret = dev_err_probe(dev, ret, "Failed to request irq\n");
+		goto err_disable_pm;
+	}
 
 	ret = devm_mutex_init(dev, &f->lock);
-	if (ret)
-		return dev_err_probe(dev, ret, "Failed to initialize lock\n");
+	if (ret) {
+		ret = dev_err_probe(dev, ret, "Failed to initialize lock\n");
+		goto err_disable_pm;
+	}
 
 	ctlr->bus_num = -1;
 	ctlr->num_chipselect = NXP_FSPI_MAX_CHIPSELECT;
@@ -1289,6 +1297,11 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 	device_set_node(&ctlr->dev, fwnode);
 
 	return devm_spi_register_controller(&pdev->dev, ctlr);
+
+err_disable_pm:
+	pm_runtime_dont_use_autosuspend(dev);
+	pm_runtime_disable(dev);
+	return ret;
 }
 
 static void nxp_fspi_remove(struct platform_device *pdev)
-- 
2.53.0



