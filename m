Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A72A7DA9E;
	Thu, 15 Aug 2024 13:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729203; cv=none; b=n3CtP6TPBZsp4WGxIQRTMYan8OXv2ocbHrxonlevsEwzzIZWn/xDGJ6KJFu99Lt4OkvyXEVZwCNq+dlJd4C3I3FYeYdS91l+AUvV0P8W6evldqO4cAU9MZ5OZX11dmgTpIg55WN8T7WzP95t3RRnx5KTA/VLWNKlkLFfQVsCSTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729203; c=relaxed/simple;
	bh=VDCNKyNGO+sLMhJKRjXj3S4hx2LTvWV1+A1iZ0ZegI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvVmMjTBs1Xjbc3CczfM7tGRk7x2MxWR92jRlkMBC0yX3TyJakt9nl01egN5nNL/FB/VdVqsn9Ob1fQu3jL1kT3xjMeLv9ygbcXF0hviEX2qYYfBdizt6w+ulU/9P3h6HVgoFvPsW08E39fDnVg32pGLO9FmtRUQ7zph2VPqqpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HD2vakuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HD2vakuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B8EC32786;
	Thu, 15 Aug 2024 13:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729203;
	bh=VDCNKyNGO+sLMhJKRjXj3S4hx2LTvWV1+A1iZ0ZegI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HD2vakuhQkD0vVEUR5ZLV3uU/4RZD5Ob3GOL0e6rhzMcEspG2IooeLaWPx5DoZTSS
	 6zRKehmPZT+jSM58mODPgEkjQHT8PS/n4Vu+Yyu96JEQaOqG9diXE6NCB7PudbuUG8
	 4XkFCXrlF28KoiZDv9RAJ9FHYv3KfyPBblQOVLdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Esben Haabendal <esben@geanix.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/484] memory: fsl_ifc: Make FSL_IFC config visible and selectable
Date: Thu, 15 Aug 2024 15:18:01 +0200
Message-ID: <20240815131942.169401751@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 72c0df129d5c5..5a410a40f914a 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -168,7 +168,7 @@ config FSL_CORENET_CF
 	  represents a coherency violation.
 
 config FSL_IFC
-	bool "Freescale IFC driver" if COMPILE_TEST
+	bool "Freescale IFC driver"
 	depends on FSL_SOC || ARCH_LAYERSCAPE || SOC_LS1021A || COMPILE_TEST
 	depends on HAS_IOMEM
 
diff --git a/drivers/mtd/nand/raw/Kconfig b/drivers/mtd/nand/raw/Kconfig
index 67b7cb67c0307..aa584aaf8ae3f 100644
--- a/drivers/mtd/nand/raw/Kconfig
+++ b/drivers/mtd/nand/raw/Kconfig
@@ -254,8 +254,7 @@ config MTD_NAND_FSL_IFC
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



