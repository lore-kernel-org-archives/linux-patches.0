Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E5C398FB8;
	Wed,  3 Dec 2025 16:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781133; cv=none; b=Dj7h/qkkXy/WW1wGKKHNKeyZsnFY1V4qPh78b4g2nLSvTWa/gdYShVtE4c50wZHk5xtLROi1xCrUlIDxHCEawvAkCR9BOTUKdsOLjhAPsnX8GvO7n2SLIRA8MbNVYwOftW9LcrfNDmehqrzKxJb/MI+611JkDRxnAm73WmsD5Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781133; c=relaxed/simple;
	bh=oBrSHqv7vD0nZyQCgu4wXaQGEAT0T/Gs8/wvbE1uk8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiEJ0w7Z40uZ+igNWNaD62HTzOgWR7KCB0EZai50vudFAz13tyFz300iyKoyQGVRpmuW7/V/bv1OFGryTUbbuCxinSK8LVFHXby8e6aGHhKf5yxWsXdMOoq1SzwZb04tfWfbuVeuXyZUDj6Hrh8uyWaJBPBsDTS/u+SLslevjn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tg4jWAip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tg4jWAip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F05BC4CEF5;
	Wed,  3 Dec 2025 16:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781131;
	bh=oBrSHqv7vD0nZyQCgu4wXaQGEAT0T/Gs8/wvbE1uk8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tg4jWAip2sTEZgPB6glguyPCe7zkLYu9C8OK+icLxsrKLqDnqmmfUYmk8qu7n01WS
	 m8RDGNX8Z4mwT/orC325TuIkJFov69FpJl9H/ZYp+fEZWKRXaTZjKTyni+JWxLikI7
	 yu0ZqNHPtIbVcnq8S5EjnNxwoxvYU6HxY0qHrXps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 26/93] spi: tegra114: remove Kconfig dependency on TEGRA20_APB_DMA
Date: Wed,  3 Dec 2025 16:29:19 +0100
Message-ID: <20251203152337.483247063@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3ce0fd5df8e9c..cda333f226b66 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -1059,10 +1059,10 @@ config SPI_TEGRA210_QUAD
 
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



