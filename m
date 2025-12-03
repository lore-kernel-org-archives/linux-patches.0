Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6FA328B67;
	Wed,  3 Dec 2025 15:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776977; cv=none; b=WM0DEtdUa283qer8LRJzsYyET8vlFkLFz74XVnavmgL8eJjEjUy76ec36UxSQ2HrBrRLXPNvbw67DzOutx9Hoz3wDWfZKNex7K/qaCUEgD+Rz6sEwgC2ihNhMsomE7EVmoY6HPMpKABsKfMWZnytiGRz7uNNtTxvtIEwjwisKjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776977; c=relaxed/simple;
	bh=H6L2pcrqxsIbuWrlLcaFT6LpWQmbPPiVDIzZbSMLAA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SN+jDrjm/Tzn4JVrMLAzyEBImMRq9jZ7NJHAqxSHVB0MyyO+QPokGNYv+3gFPdQUO3eoHo3Sqvo6ZZeslN+/zQYJ2D2XvdstX/GBeSeR0bm5m6TE8iiKmtYx+2wSOLTZaLem9QtOXg+xyWTR0Zlc0ZFiqERmYN6ddYJpPajRLQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+RfRLPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+RfRLPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546B3C116B1;
	Wed,  3 Dec 2025 15:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776976;
	bh=H6L2pcrqxsIbuWrlLcaFT6LpWQmbPPiVDIzZbSMLAA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+RfRLPvhL5ZBb/evdtgpdYBajNKfV50Zd09zvSkQEk4XGoCSM8hGRjDoE7ylU4rx
	 HT3johhSazQuPclNovzV99hcJWAad3EqxvHQsKC7Mv74DzR2LsrqoB65Obdabk/2tQ
	 xiJmtPNmO5tiqoqwR9C+fxbW8jBE02fOV1NVBOqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 045/146] spi: tegra114: remove Kconfig dependency on TEGRA20_APB_DMA
Date: Wed,  3 Dec 2025 16:27:03 +0100
Message-ID: <20251203152348.123933799@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 891729c9c5642..9f20cb75bb856 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -1170,10 +1170,10 @@ config SPI_TEGRA210_QUAD
 
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



