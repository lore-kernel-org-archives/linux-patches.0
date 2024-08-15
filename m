Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00FB1AC8BB;
	Thu, 15 Aug 2024 14:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732012; cv=none; b=Djr4xEE+9eV7HIrndaWGrPuPGMFfvFqreQTlvrj1GTrY/i544SKC5W71AUUvYME31GGdpUiAa5lG7AfbpbUDjNb4Vx4V+Kyik1Pv1ggbMIoOgqKBYa6+9JbmMwcjloYGpjoPon9ALNRYCHmmaEjOuO8uZYWxR2eVz8qkQebqfuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732012; c=relaxed/simple;
	bh=BRgVOm2tkJh8UZaKo6HDujGGOHl7GIxgG+s0re8Sphg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oyfrjq9NnWsYE6Qcm76lGgqZLX/DQTshTT0J79AmfJtoHU9OgS+wUNMkdyZXgHju2BnvsN9c0dvPBRIXipc5EquPQcMeWR7cm2pkjZUPgJksaqRojoy/RmILQNihFIZoAPNEgDuQCBJXyOxH/00kUeTvIptojOvhUKRWBweAD3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0MHTr/o0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0MHTr/o0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077DDC32786;
	Thu, 15 Aug 2024 14:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732012;
	bh=BRgVOm2tkJh8UZaKo6HDujGGOHl7GIxgG+s0re8Sphg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0MHTr/o0zUMEhG40NrIvr2dz0SwmadxoI1giXCIjOQiE6QmvOqM2j8s0El9jvTvPn
	 31yfFkRwcJ4zqw7gAaSilKIAIJI4ikHIgW0x6HnYkPqSIR7MDe+iueGyj0u1W1YOQJ
	 G2+11Qaqu8tpzR/3KBqSKaLCORLajKWBGMh5NNZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/352] memory: fsl_ifc: Make FSL_IFC config visible and selectable
Date: Thu, 15 Aug 2024 15:21:22 +0200
Message-ID: <20240815131919.840495317@linuxfoundation.org>
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

[ Upstream commit 9ba0cae3cac07c21c583f9ff194f74043f90d29c ]

While use of fsl_ifc driver with NAND flash is fine, as the fsl_ifc_nand
driver selects FSL_IFC automatically, we need the CONFIG_FSL_IFC option to
be selectable for platforms using fsl_ifc with NOR flash.

Fixes: ea0c0ad6b6eb ("memory: Enable compile testing for most of the drivers")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Link: https://lore.kernel.org/r/20240530-fsl-ifc-config-v3-1-1fd2c3d233dd@geanix.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/Kconfig       | 2 +-
 drivers/mtd/nand/raw/Kconfig | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index cc2c83e1accfb..244dc48d1b715 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -159,7 +159,7 @@ config FSL_CORENET_CF
 	  represents a coherency violation.
 
 config FSL_IFC
-	bool "Freescale IFC driver" if COMPILE_TEST
+	bool "Freescale IFC driver"
 	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A || COMPILE_TEST
 	depends on HAS_IOMEM
 
diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 6c46f25b57e2a..205663298734a 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -282,8 +282,7 @@ config MTD_NAND_FSL_IFC
 	tristate "Freescale IFC NAND controller"
 	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A || COMPILE_TEST
 	depends on HAS_IOMEM
-	select FSL_IFC
-	select MEMORY
+	depends on FSL_IFC
 	help
 	  Various Freescale chips e.g P1010, include a NAND Flash machine
 	  with built-in hardware ECC capabilities.
-- 
2.43.0



