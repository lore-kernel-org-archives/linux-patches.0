Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B6F56B68;
	Tue, 23 Jan 2024 00:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970031; cv=none; b=BEtpu697Sp0Ea233mNUpE/qKdl6G0sCoHrSQYg3FNm0EiA1VAUNDEguYqgYtHAdgoixSuv75m72RxPsxOQq16rAEm/aj9Sj9oallhCNGftniwOFmrOVqeGK0onW+JNYv44z/JJH1ZoH8llNshxHsHeJ9ZAcwKr21kBov7rF4bp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970031; c=relaxed/simple;
	bh=/xxEQmI2fBMe2vOyx6q3OiE8cm5A9QSBT+Pif5RZjD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmOj8XNXvqlowfIbCH9yBEkpsYUBXrkUUcUmbCYdMztsAfiMs/OwJcwK5MrPlp2DsMsL4L410+rfGQdRmv/U0RYgsoYhq4yrYdC/z3DZJH+02DmTlZm8pp8ixY1baBYjilOLY4zLPmYZhDOooWv24brm4+5DLcqDpkkKtMtEkj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUgId/8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUgId/8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A47C433F1;
	Tue, 23 Jan 2024 00:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970031;
	bh=/xxEQmI2fBMe2vOyx6q3OiE8cm5A9QSBT+Pif5RZjD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jUgId/8J55GbjdTsjNxkkgtmfhkRHEz6054bTPUMmH++JKcAkNX1RFX+d1U3bdbpN
	 QZD3BuukIqDJpNuMxPXEtVYYQrI7TNZFcJ6SdkmbsrU72s62oWKgg7SzW7tRO+mL79
	 SG30pZZudDkF0RLmSZyR6jM9IM7y1+VyC84igF8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 569/641] spi: coldfire-qspi: Remove an erroneous clk_disable_unprepare() from the remove function
Date: Mon, 22 Jan 2024 15:57:53 -0800
Message-ID: <20240122235835.966208125@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 17dc11a02d8dacc7e78968daa2a8c16281eb7d1e ]

The commit in Fixes has changed a devm_clk_get()/clk_prepare_enable() into
a devm_clk_get_enabled().
It has updated the error handling path of the probe accordingly, but the
remove has been left unchanged.

Remove now the redundant clk_disable_unprepare() call from the remove
function.

Fixes: a90a987ebe00 ("spi: use devm_clk_get_enabled() in mcfqspi_probe()")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://msgid.link/r/6670aed303e1f7680e0911387606a8ae069e2cef.1704464447.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-coldfire-qspi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-coldfire-qspi.c b/drivers/spi/spi-coldfire-qspi.c
index f0b630fe16c3..b341b6908df0 100644
--- a/drivers/spi/spi-coldfire-qspi.c
+++ b/drivers/spi/spi-coldfire-qspi.c
@@ -441,7 +441,6 @@ static void mcfqspi_remove(struct platform_device *pdev)
 	mcfqspi_wr_qmr(mcfqspi, MCFQSPI_QMR_MSTR);
 
 	mcfqspi_cs_teardown(mcfqspi);
-	clk_disable_unprepare(mcfqspi->clk);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.43.0



