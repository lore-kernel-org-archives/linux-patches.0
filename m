Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7C3187FEC;
	Tue, 30 Jul 2024 16:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355405; cv=none; b=i1Mu/V1JshWB6MZTZl1AsbF4CUpc6KDUvHchvw/y/TmsvcVGlIhOHj+aEGvwDJEY5iamrluOZovtAKMdR5ZH8fsmsVPdtH4RuMv6gGp0VC0yYnhPWIHu9QQwXScUFu3XhtUVVzLgM2sCT7enLh9STKUhxoQx3Pc0+RAYV7kuc/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355405; c=relaxed/simple;
	bh=R1UbsZEzHD/a99RTLrZUf7W/N2z0+3DZ8bbj1yuqSsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ko1zRglMYZgZLrVRmDJiKi0/38DsCwRzPQyrNIycRlsy8KgBBFM3z+Gy35rRX+DDgh1Vv9LrXFL/6Z1cEM8QO/wD5tfJFr17rIQkaK9LAbJTLrFOOMD0SdoNklr5iiDFsOaMAC9zhFginT8JZk6SBf3ygNVxFr1Mx5mCTZztM20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0CJi5Vk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0CJi5Vk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDC1C32782;
	Tue, 30 Jul 2024 16:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355405;
	bh=R1UbsZEzHD/a99RTLrZUf7W/N2z0+3DZ8bbj1yuqSsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0CJi5Vk5Z40K7VKCzxKKD9/wx2MHSFXrY8OLCgaTZAnXnFwqiBCTaHQ/WQst6+Kyo
	 oCy9PTZyQwwJwr7gC8H5qXXT4JJF3MkNrI0hU3oDBsnre2qIy9HKrPgv0DsFfb0011
	 2tyuiTuCxbbHTQWFmJrARocvHT6niKIu08flIxp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/568] memory: fsl_ifc: Make FSL_IFC config visible and selectable
Date: Tue, 30 Jul 2024 17:42:42 +0200
Message-ID: <20240730151641.999005798@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8efdd1f971395..c82d8d8a16eaf 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -167,7 +167,7 @@ config FSL_CORENET_CF
 	  represents a coherency violation.
 
 config FSL_IFC
-	bool "Freescale IFC driver" if COMPILE_TEST
+	bool "Freescale IFC driver"
 	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A || COMPILE_TEST
 	depends on HAS_IOMEM
 
diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index cbf8ae85e1ae0..6142573085169 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -234,8 +234,7 @@ config MTD_NAND_FSL_IFC
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



