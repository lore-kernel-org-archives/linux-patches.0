Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F9D1B583F;
	Tue, 30 Jul 2024 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355024; cv=none; b=G83j1qN7Sk7+O1pVVh0e3xGPPGGCd5d282h0r/mLhSMVRWiCCc8SEq+QiTFbflWHm8uIipyVVj3ijiIlShTNIgWivXPjF/XzlnyhS1KaVNmo5oVK252WgFHKckNpUREJmulvhgjB4vauzo7Fq8sqsw3TKbtbREyXQl8c2UsRHyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355024; c=relaxed/simple;
	bh=RiP7flSFiHOZoYTsJ8ldG5erSVo3335AUkAXOMpr++g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bvjdLajyKKSH7oILaCw9UxKE+E5OgwWlZWkpuFyAQd7Sv8Kg1b/O0qJJ6mGFshrqWLfRptqt0aR9DZqfj9nvG1qQGHIFjWC/WihsPa1KpsGQtd0wYDDNo44QXfhMAjqkAtnZcLXb0VRLCTFrkc9heJRRwv1Gw+aKAAZWjmsTx0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gi4ZMMJh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gi4ZMMJh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8546CC32782;
	Tue, 30 Jul 2024 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355023;
	bh=RiP7flSFiHOZoYTsJ8ldG5erSVo3335AUkAXOMpr++g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gi4ZMMJhj+hoctAez/zI5igR9yQsBB3d7jhepx0zpchv91HKEGNkIjnsJWffrRnqC
	 +SNcU5ml9DaT0E+SZeV6iw+jmrGe0OZABiUUxjr1ouYbWakfzMrW2x5CoFwHORkxZw
	 sCAluO3aXnbXf/TieldftoMywKlQ4zakvFNAlOk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/440] memory: fsl_ifc: Make FSL_IFC config visible and selectable
Date: Tue, 30 Jul 2024 17:44:40 +0200
Message-ID: <20240730151617.601582512@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fac290e48e0b8..15a9e66f031d1 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -178,7 +178,7 @@ config FSL_CORENET_CF
 	  represents a coherency violation.
 
 config FSL_IFC
-	bool "Freescale IFC driver" if COMPILE_TEST
+	bool "Freescale IFC driver"
 	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A || COMPILE_TEST
 	depends on HAS_IOMEM
 
diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 4cd40af362de2..900b121219394 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -248,8 +248,7 @@ config MTD_NAND_FSL_IFC
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



