Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D026350297;
	Wed,  3 Dec 2025 16:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780615; cv=none; b=gKN37LQCrIeM5zhF5feYcgZqOQH6uSOW/Hg4hxC4HY446rpmSdI1Qaz5/yoZD+AIIRo/1oVK6V/qi4IiFrEZc8RfwB19wE89nc78X/HQP9E6CZllMHf3a+1D9DqGEu9rXp30EQbFZZWTOM7IX5LwDZcGe1Wf2SPb0c/i6eksWg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780615; c=relaxed/simple;
	bh=RAKOeo5GjLM1BcLY+a+z6PPcN5dR7MrkG3sKwc8yCDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuVJhW5SZNEnETzmF2EJp+mmpb/bKsIdqBQXRz7PQSbsp2wqG7gUfOy8/R1nKuTIKYxPjDb/SjI0qsn/pGakYzXe1Fp7rTGKlNJcubWwMZjc88rpwOumlXBtX/UUP08KJpkI1IOBHFWTfjbu8fml7ZGqIFaIQSP6q8lWUOC92/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2aRn97v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2aRn97v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9232C4CEF5;
	Wed,  3 Dec 2025 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780615;
	bh=RAKOeo5GjLM1BcLY+a+z6PPcN5dR7MrkG3sKwc8yCDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2aRn97vYGodZRw+ZP/0AXhRw1DstvEZHz5z59kY1bgXVfKW1CXdnlXB3n8wvU5jf
	 l7llwPjx6ux+PfcPR716wCSJpSfcCnj7e7gjcKTNhTZdE/0rCq/LTlHVPnIeORobcW
	 OiQatO6Dj0C8DaY5zkzoGPCHCnAG/8OeJeHjrGpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/132] spi: tegra114: remove Kconfig dependency on TEGRA20_APB_DMA
Date: Wed,  3 Dec 2025 16:28:38 +0100
Message-ID: <20251203152344.743880551@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit 3dcf44ab56e1d3ca3532083c0d5390b758e45b45 ]

This driver runs also on Tegra SoCs without a Tegra20 APB DMA controller
(e.g. Tegra234).
Remove the Kconfig dependency on TEGRA20_APB_DMA; in addition, amend the
help text to reflect the fact that this driver works on SoCs different from
Tegra114.

Fixes: bb9667d8187b ("arm64: tegra: Add SPI device tree nodes for Tegra234")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Link: https://patch.msgid.link/20251126095027.4102004-1-flavra@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 8237972174048..06c740442fa73 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -1087,10 +1087,10 @@ config SPI_TEGRA210_QUAD
 
 config SPI_TEGRA114
 	tristate "NVIDIA Tegra114 SPI Controller"
-	depends on (ARCH_TEGRA && TEGRA20_APB_DMA) || COMPILE_TEST
+	depends on ARCH_TEGRA || COMPILE_TEST
 	depends on RESET_CONTROLLER
 	help
-	  SPI driver for NVIDIA Tegra114 SPI Controller interface. This controller
+	  SPI controller driver for NVIDIA Tegra114 and later SoCs. This controller
 	  is different than the older SoCs SPI controller and also register interface
 	  get changed with this controller.
 
-- 
2.51.0



