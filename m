Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50B543D4E9;
	Tue, 16 Jun 2026 17:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632235; cv=none; b=ps9KniXGQYd7bgXr2M8a/NSvz6UZ1K3r081rWORwMEQKay07o2YEhhLdKEX5y/6nnaxOaALihgh7ixrvi/YLUzPgPruF372Xx2FVG3GPl2442nrj6aWSop8PVlfM6wrbNU7xmf+bzRB1kboFwzw5M5YFfQOLB54UKi0Bj6bdM0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632235; c=relaxed/simple;
	bh=32YPO6dbHJP75eaPwD8BY68xgflZndgujHCsODejLdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lB6Eml5YrzY6pSPIFZAZXi2muyOWIzFYlQFm+1+u1SB0dCFacMc23/B0MFKTu4tBVll5c9StsOKqJ/TwFirfkAs4jaG4Z4wcu2ShqdF1nap54HzVY/HJOP75jdg8/UP/0YyW3Y+8Roih7i6YWgBa6PWAXqycq1ZvXV0e31z4o8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UN0s+KAQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UN0s+KAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F59A1F000E9;
	Tue, 16 Jun 2026 17:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632234;
	bh=mKcHnTCfdHNBAlF98Aw11QNCD9bFGs08sqKHrXGsz1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UN0s+KAQZo0IU64hVXa5YIisP/SD4t4Kdtrx5lf01lDXKmsjBuch+ucVV1S+fT1ax
	 o5ZCQZPQSBPDL/JXu6+28Nn2/kqP2Z3hYIBW1/+Ufi5FD3oCDwdCjwauMgHG1RCIwd
	 9Q+Kx5IXQgkBs6Juf4mTXSUU2qAEthg+L3GsxfR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 340/522] spi: imx: Convert to platform remove callback returning void
Date: Tue, 16 Jun 2026 20:28:07 +0530
Message-ID: <20260616145141.722768798@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 423e548127223d597bb65a149ebcb3c50ea08846 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230306065733.2170662-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1c78c2002380 ("spi: imx: fix use-after-free on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-imx.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1879,7 +1879,7 @@ out_controller_put:
 	return ret;
 }
 
-static int spi_imx_remove(struct platform_device *pdev)
+static void spi_imx_remove(struct platform_device *pdev)
 {
 	struct spi_controller *controller = platform_get_drvdata(pdev);
 	struct spi_imx_data *spi_imx = spi_controller_get_devdata(controller);
@@ -1898,8 +1898,6 @@ static int spi_imx_remove(struct platfor
 	pm_runtime_disable(spi_imx->dev);
 
 	spi_imx_sdma_exit(spi_imx);
-
-	return 0;
 }
 
 static int __maybe_unused spi_imx_runtime_resume(struct device *dev)
@@ -1961,7 +1959,7 @@ static struct platform_driver spi_imx_dr
 		   .pm = &imx_spi_pm,
 	},
 	.probe = spi_imx_probe,
-	.remove = spi_imx_remove,
+	.remove_new = spi_imx_remove,
 };
 module_platform_driver(spi_imx_driver);
 


