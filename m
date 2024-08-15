Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B471A01D2;
	Thu, 15 Aug 2024 14:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732614; cv=none; b=YBaWnMAqRl4WeRoDCHomfhgOeCfX8cazoX6jFCUZIyiWZQ2uX8qkCW7MAJXyaxGPF5UlBT7uQu6h8F1doHb7ZgCKw9jQxgZBsl2rI65/nFUOJpyO2I3MVl5D4lPk2wXPPbS1M4MKmr0HitMOxYwPLOth2pikl3Bdvp+P5m3twS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732614; c=relaxed/simple;
	bh=/kYK6IZU6os24KGZoHjiLprMZUgdT9LWjXR0Y/yUrMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utaXhnunXxxp5Zy87mRiANxXbnioAXNnsAoDVKDgGwAei3PUCPJG3TS7oqUhcMKulsHZw5tEw2hwckezeNjdYSmM0BvqPlH2nUXnTKlSlXO9CJrMTxl36UBT99C1xcMQPQxZCy9GrVjzsywl1RriNYYedtbv67UACyttgWUsfRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UivNbO7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UivNbO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2400DC4AF0C;
	Thu, 15 Aug 2024 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732614;
	bh=/kYK6IZU6os24KGZoHjiLprMZUgdT9LWjXR0Y/yUrMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UivNbO7F5JilX+hxtxjpBALY9lqr9rdrS9Rr4H7SXJxqUB//u1hGNG0bfeHDKJ+y
	 HAg7jL3s3zJDHUqnpTI3BG3p3r9glP0pCc1RRcT32c+PYe1BdUlmjRKGot91XRGTCJ
	 tq6fCnrPegECX46i2CbfNAE+CfkBZZyCJ1kH2yco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 216/352] powerpc/configs: Update defconfig with now user-visible CONFIG_FSL_IFC
Date: Thu, 15 Aug 2024 15:24:42 +0200
Message-ID: <20240815131927.638563668@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

commit 45547a0a93d85f704b49788cde2e1d9ab9cd363b upstream.

With CONFIG_FSL_IFC now being user-visible, and thus changed from a select
to depends in CONFIG_MTD_NAND_FSL_IFC, the dependencies needs to be
selected in defconfigs.

Depends-on: 9ba0cae3cac0 ("memory: fsl_ifc: Make FSL_IFC config visible and selectable")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240530-fsl-ifc-config-v3-2-1fd2c3d233dd@geanix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/configs/85xx-hw.config |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/configs/85xx-hw.config
+++ b/arch/powerpc/configs/85xx-hw.config
@@ -24,6 +24,7 @@ CONFIG_FS_ENET=y
 CONFIG_FSL_CORENET_CF=y
 CONFIG_FSL_DMA=y
 CONFIG_FSL_HV_MANAGER=y
+CONFIG_FSL_IFC=y
 CONFIG_FSL_PQ_MDIO=y
 CONFIG_FSL_RIO=y
 CONFIG_FSL_XGMAC_MDIO=y
@@ -58,6 +59,7 @@ CONFIG_INPUT_FF_MEMLESS=m
 CONFIG_MARVELL_PHY=y
 CONFIG_MDIO_BUS_MUX_GPIO=y
 CONFIG_MDIO_BUS_MUX_MMIOREG=y
+CONFIG_MEMORY=y
 CONFIG_MMC_SDHCI_OF_ESDHC=y
 CONFIG_MMC_SDHCI_PLTFM=y
 CONFIG_MMC_SDHCI=y


