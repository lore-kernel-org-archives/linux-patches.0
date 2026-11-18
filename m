Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015339;
	b=PjABV9szB+1IX4qIjsLWDPAC/n7Pn6UXp/MQPzahnsoX6x8R83994ZXQoOPCeacwtMQ6
	 wAgyHdiU9xfMzLBQy/qzBIy25xpBB1qnuH+d2325Rqf+93b4eIDBXypZxOXmJo1R8W9P3
	 pgfMMRBZUMnhV4cqSmqsEtS3CdjxkE3HciT794oqM1So7xDSuAgUzg56rA8FslIQESq0C
	 0k9NjK5Z5w/yMwgFJBqjCph57vR28Y2jrcYaHZ7JQaarZr457qKHWO8vnSWAXxNzRTB6U
	 JwWH0859eGm7IlOdDW5QAjSLXqo3oXztHKbqDtsLc+7Bem68ifyZ0XqasGKuMa02kpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7NTEn5yyFy2BP4P5UF03hLwOtVdnZppMc4TtPYSS1yM=;
	b=dAVDjKvaqqm6CChBGaXUSQ1ZdSUIKg4L7CWBALx3q+E+iGO+mTnZA+HAlVWjXAKLwq3Z
	 wH34FG2VHtJ9JF1FOIuHVFcXazWewEIJJcBCQ5TUB2qrEEfeWLK0TaidhxbOWtuGVDXKg
	 hTOwiAIhHIIYc36ybLhx3trbxopzg9f67oB9MVWR5eMGQ2A6Ji2v0tFH4wwpXOHsFMtHn
	 0oGlkzesAf6zPN9KJOa5uo+TeLaW3Yrx2MjNzk8DstwWUN7RmIkicTqW6GW3aiwdzLCxM
	 VngUH7jLouJgQoRMeLvKtkhnDhwXxsD5C3pu453Rj/R9Hdc6eEG2F8wYWRv+KYAzJKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Nl736Lt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7F960A2621;
	Wed, 18 Nov 2026 15:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Nl736Lt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8611F00925;
	Wed, 18 Nov 2026 15:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015339;
	bh=7NTEn5yyFy2BP4P5UF03hLwOtVdnZppMc4TtPYSS1yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Nl736LtwU0C5Ar/cBFydL5fMGZTeJolo5S3M3MYmNn00DSVObz5NTyuNGLbi4mEt
	 up/vAQAz5Ao6INovqnFGtKOcCRJBUQuew4Uvuh1jYJTYu5wg845ScVfpXAYPRVt3GL
	 VhO+glhkAcPIKYMmPzg/rcQkGIuDNmTUOPCeTSpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0138/2651] spi: omap2-mcspi: Remove unbalanced pm_runtime_put_sync() calls
Date: Wed, 18 Nov 2026 15:22:58 +0100
Message-ID: <20261118150252.818895722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 5f01cb141169fe422c42279f7d502479b1ff9fd2 ]

pm_runtime_put_sync() is called in the probe error path and in remove
when nothing holds a runtime PM reference anymore, so it underflows
the usage count.

Fixes: 0e6f357a5deb ("spi: omap2-mcspi: Fix PM regression with deferred probe for pm_runtime_reinit")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260826-mcspi-v1-1-0a8dd7f6dd56@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index a3355147f5de5..82c8b91e504e7 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -1595,7 +1595,6 @@ static int omap2_mcspi_probe(struct platform_device *pdev)
 
 err_disable_rpm:
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 err_release_dma:
 	omap2_mcspi_release_dma(ctlr);
@@ -1613,7 +1612,6 @@ static void omap2_mcspi_remove(struct platform_device *pdev)
 	omap2_mcspi_release_dma(ctlr);
 
 	pm_runtime_dont_use_autosuspend(mcspi->dev);
-	pm_runtime_put_sync(mcspi->dev);
 	pm_runtime_disable(&pdev->dev);
 }
 
-- 
2.53.0



