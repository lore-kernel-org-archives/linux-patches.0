Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829385;
	b=1GtrkivHzAJu0NFy1bmFNFemPHzfLWJ9qYH+5rznYDXO2y5RQRBtlUOjeInnit9ORkGa
	 JNRfIbmnkDQxH6AO2bO7m1as/eHtullNAhY+V61JuQZLsKYOqo++HHzqbpYuB1iIwZ0e8
	 hR5TPQwjElu/HR/mncLDNnyCNfKJcb/vOeSGcr9cCQVE8jcQqHnizTH2LMwJGz58u6SYy
	 SvRpqFJTlesc3EvjgaJjO/Gph0ah9S++PCS8NpcPjYmk/oRC+U7GMSwnydpoCMttHVuki
	 ohgoWFaQZB77XfznAzJ4YAM5syJlkjJbjbdcQmG6uj1BCD03yLrMONeEnQ8p3qUvKYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0w1PyD7jTPQUAfyfUWJwL+1+c+koxkgLUY7eYz55QOA=;
	b=seaM03dsYUf6RW+IMBt14U+u9xS46HyUt0Y+m9SYhMKA2NObw/lzM3ezpGDB6QUNsder
	 9023AHIeN2+LU9Kc+hF40sY+XqPiLP37eddIjSzXx3agCi4mlHHVJOMhD8zehQ12k5AEm
	 AMHOq70IbXso4hPDFgH7MBOwPcgI0t7b0ZhSHsE+g74FM6lWtdNIG1drQ/+DdWRuBpudK
	 uTzL1LlRcxhnPpqWd78S3E9jZY+5JflPjTvyrXbrhXRZW7Zz56mQ1bqmItq8jyyasqqpY
	 zsuqtZiHHzdNYOfhFgM21Sg3e49zK0X7zTZiYH/hKwSbwZA/yirFGeyI+Dmz5G+r7lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eufV30cE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68ED86086E66;
	Wed,  4 Nov 2026 21:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eufV30cE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CE81F0093A;
	Wed,  4 Nov 2026 21:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829385;
	bh=0w1PyD7jTPQUAfyfUWJwL+1+c+koxkgLUY7eYz55QOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eufV30cECVacYa0MfFQFgAxWuQ7DAPrl7bbR742JYX2eNQ+4eQPRDGQJekptMOPq6
	 KejJxShzJJKkAVG1LT7Zw7Y0cJrWu6wMNzk2OPJ9z4KHNLLFkBj+Yjgrl6gAWOiI9N
	 hi7+pw/GoMDqb6sIUotXPvT26pj2qE/SC05JBA6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0054/1005] spi: nxp-fspi: disable runtime PM on probe failures
Date: Wed,  4 Nov 2026 15:56:27 -0500
Message-ID: <20261104211045.108008999@linuxfoundation.org>
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
index b504a5c86692a..0300f4ae1455d 100644
--- a/drivers/spi/spi-nxp-fspi.c
+++ b/drivers/spi/spi-nxp-fspi.c
@@ -1426,9 +1426,11 @@ static int nxp_fspi_probe(struct platform_device *pdev)
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
@@ -1438,18 +1440,24 @@ static int nxp_fspi_probe(struct platform_device *pdev)
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
@@ -1467,6 +1475,11 @@ static int nxp_fspi_probe(struct platform_device *pdev)
 		return ret;
 
 	return devm_spi_register_controller(&pdev->dev, ctlr);
+
+err_disable_pm:
+	pm_runtime_dont_use_autosuspend(dev);
+	pm_runtime_disable(dev);
+	return ret;
 }
 
 static int nxp_fspi_runtime_suspend(struct device *dev)
-- 
2.53.0



