Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1B83AE19C;
	Mon, 20 Apr 2026 13:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691999; cv=none; b=UX6pvKpULNmXvUoF7QwDcWWXUUeDvAxScAmwCYKrlO4UZe9VluW/bFyA7yfoe1q1waMCzetdw/wWReDaFG3csit0j645r2xOI292BKnEenFlOm4qJNYsb25IoU66taMcNY4ZYllwMLCutKw0RcSLFZExsiNm2WcpMtTkZe4J+7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691999; c=relaxed/simple;
	bh=qDd3lAIGsFZszATwqBgq1hp6evRIXI1W3nzcXU7eI0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5pqlcRlKeNhuC6lB1XJKi6uMRrdT84g/ndABm5VeP8Rp+bWDhWsDhOfp4oeJOARISSJq9VP4SzesFvD92BI8w31gU197CM+Sf7akx70lLnAElb8NIFoOAjXvCCvlKoNxtbTgwYebDRA9eq1f9r6lGmRVGmZ13VMGEoduEV5ft8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P87elB+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P87elB+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0F9C19425;
	Mon, 20 Apr 2026 13:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691999;
	bh=qDd3lAIGsFZszATwqBgq1hp6evRIXI1W3nzcXU7eI0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P87elB+5nwaWzxQ2bEAlrUzMBY40RmvMiFFNkFLoJnxS0iTOycXUMBiorAY7ZoMdC
	 PEC60+3kZYN61id7e/kPH6rmGvkG0bRwPRJJiBDFVjVE2bYMe3KkDKW0RpvmWPqpcY
	 jE5gjVMs9+ndp1tezpUVJwSg4+VGdB25LAyW8tUjhVSURUPhiu8D+MNdXC9IzzJgtW
	 Sa9TMzwAZws6BcQRaoPW8Xu4uh7r8xiHNVLc4DJMA2vYfKwN6KIhi96gpwB3CYBykK
	 AGP1toCDkwIK8sNvDPrqcAaanGIJiJdRbTiyuEI8/F+XWuLAXaGIH/ZK0hT/9s3x3q
	 8Kdg61ekiv+Zw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wenyuan Li <2063309626@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	mailhol@kernel.org,
	linux-can@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] can: mcp251x: add error handling for power enable in open and resume
Date: Mon, 20 Apr 2026 09:21:48 -0400
Message-ID: <20260420132314.1023554-314-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Wenyuan Li <2063309626@qq.com>

[ Upstream commit 7a57354756c7df223abe2c33774235ad70cb4231 ]

Add missing error handling for mcp251x_power_enable() calls in both
mcp251x_open() and mcp251x_can_resume() functions.

In mcp251x_open(), if power enable fails, jump to error path to close
candev without attempting to disable power again.

In mcp251x_can_resume(), properly check return values of power enable calls
for both power and transceiver regulators. If any fails, return the error
code to the PM framework and log the failure.

This ensures the driver properly handles power control failures and
maintains correct device state.

Signed-off-by: Wenyuan Li <2063309626@qq.com>
Link: https://patch.msgid.link/tencent_F3EFC5D7738AC548857B91657715E2D3AA06@qq.com
[mkl: fix patch description]
[mkl: mcp251x_can_resume(): replace goto by return]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/net/can/spi/mcp251x.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index b46262e791301..5a7aa02092c7e 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1225,7 +1225,11 @@ static int mcp251x_open(struct net_device *net)
 	}
 
 	mutex_lock(&priv->mcp_lock);
-	mcp251x_power_enable(priv->transceiver, 1);
+	ret = mcp251x_power_enable(priv->transceiver, 1);
+	if (ret) {
+		dev_err(&spi->dev, "failed to enable transceiver power: %pe\n", ERR_PTR(ret));
+		goto out_close_candev;
+	}
 
 	priv->force_quit = 0;
 	priv->tx_skb = NULL;
@@ -1272,6 +1276,7 @@ static int mcp251x_open(struct net_device *net)
 	mcp251x_hw_sleep(spi);
 out_close:
 	mcp251x_power_enable(priv->transceiver, 0);
+out_close_candev:
 	close_candev(net);
 	mutex_unlock(&priv->mcp_lock);
 	if (release_irq)
@@ -1508,11 +1513,25 @@ static int __maybe_unused mcp251x_can_resume(struct device *dev)
 {
 	struct spi_device *spi = to_spi_device(dev);
 	struct mcp251x_priv *priv = spi_get_drvdata(spi);
+	int ret = 0;
 
-	if (priv->after_suspend & AFTER_SUSPEND_POWER)
-		mcp251x_power_enable(priv->power, 1);
-	if (priv->after_suspend & AFTER_SUSPEND_UP)
-		mcp251x_power_enable(priv->transceiver, 1);
+	if (priv->after_suspend & AFTER_SUSPEND_POWER) {
+		ret = mcp251x_power_enable(priv->power, 1);
+		if (ret) {
+			dev_err(dev, "failed to restore power: %pe\n", ERR_PTR(ret));
+			return ret;
+		}
+	}
+
+	if (priv->after_suspend & AFTER_SUSPEND_UP) {
+		ret = mcp251x_power_enable(priv->transceiver, 1);
+		if (ret) {
+			dev_err(dev, "failed to restore transceiver power: %pe\n", ERR_PTR(ret));
+			if (priv->after_suspend & AFTER_SUSPEND_POWER)
+				mcp251x_power_enable(priv->power, 0);
+			return ret;
+		}
+	}
 
 	if (priv->after_suspend & (AFTER_SUSPEND_POWER | AFTER_SUSPEND_UP))
 		queue_work(priv->wq, &priv->restart_work);
-- 
2.53.0

