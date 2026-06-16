Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9112A257827;
	Tue, 16 Jun 2026 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632509; cv=none; b=Bc0mPEzs0vUYhqZeXrpL8zLRrLlRtYu6bgLMq27sJrWuMZBjS/vdvzQCN+v8TpYF7pgulPpJqkJPMBjjjBBaDlsUpZABezyJt9x3PzKtVLmPPN+45C64P1BXjdgOgBUQaQNHcsYtej+8zd4gRNP07gfzURd77Csl3EjsCG68qvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632509; c=relaxed/simple;
	bh=iSXVd5PVm5Fp2NMk7/PEUXwgVwpDxPBOq1km6bJAWzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Of23d1vtvjxPDwBhDolmDM01XjsiWwH37kzoeSgRBj2vdibEIZMr5+bwox5BjIibDhJAU1iFiSFrBeuDT6f3hl5rki2RVautC7ignOBhup142SSm8E4C1nX8SMqAa9Aexr68+zwyVrqRio2znfasCowD5efZVon/ziyFD7DV8ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00clYwI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00clYwI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C7D1F00A3A;
	Tue, 16 Jun 2026 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632508;
	bh=EENmG28x4K8wMKPjbuu7NAHRDTM7mBGF+lI8xZnZ8Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00clYwI4jH2tC0hxyAOBTgclcod76P9pdUnnfK3SRk0UqUGXo6IIszBAwdNCyyhly
	 8E7yrirYaWj0S/K3ih15++WIG1YsRv36zqzaMIC9YxXm0DQ/F4xQ6iqRf/IqH8/WOS
	 SLUnKkvOk1ynloVWzhqSOz/TcJuySJEeIwNbnTew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 407/522] spi: microchip-core-qspi: Convert to platform remove callback returning void
Date: Tue, 16 Jun 2026 20:29:14 +0530
Message-ID: <20260616145145.103545195@linuxfoundation.org>
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

[ Upstream commit e4cf312d6db2941b8267de6e094312afc1b523ee ]

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
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230303172041.2103336-37-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e6464140d439 ("spi: microchip-core-qspi: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-microchip-core-qspi.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -567,7 +567,7 @@ out:
 	return ret;
 }
 
-static int mchp_coreqspi_remove(struct platform_device *pdev)
+static void mchp_coreqspi_remove(struct platform_device *pdev)
 {
 	struct mchp_coreqspi *qspi = platform_get_drvdata(pdev);
 	u32 control = readl_relaxed(qspi->regs + REG_CONTROL);
@@ -576,8 +576,6 @@ static int mchp_coreqspi_remove(struct p
 	control &= ~CONTROL_ENABLE;
 	writel_relaxed(control, qspi->regs + REG_CONTROL);
 	clk_disable_unprepare(qspi->clk);
-
-	return 0;
 }
 
 static const struct of_device_id mchp_coreqspi_of_match[] = {
@@ -592,7 +590,7 @@ static struct platform_driver mchp_coreq
 		.name = "microchip,coreqspi",
 		.of_match_table = mchp_coreqspi_of_match,
 	},
-	.remove = mchp_coreqspi_remove,
+	.remove_new = mchp_coreqspi_remove,
 };
 module_platform_driver(mchp_coreqspi_driver);
 


