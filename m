Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19262AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EBBC433C9;
	Wed, 20 Sep 2023 12:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211320;
	bh=XUcMT0bDd+UoXkmF2GndNAzBNPVExvoM29bcpyxPnhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDuw/+TQ+p/Z2uvaD1ikG8qhtNE0GvBa7C5Z9Guq+M50mq53OkSa3S7b2MvUPSjwr
	 kNtiGAS10gn8b06sjxMX/fZQ+7tfnJ32VxW1O+vhxY5VHBibLZ0qJUMNyeux5VgsY9
	 4Tw6iqdKnbL1zxO8nFZmb2x72eHjL82jL4ZQqSvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Baoquan He <bhe@redhat.com>,
	Vinod Koul <vkoul@kernel.org>,
	dmaengine@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 023/186] idmaengine: make FSL_EDMA and INTEL_IDMA64 depends on HAS_IOMEM
Date: Wed, 20 Sep 2023 13:28:46 +0200
Message-ID: <20230920112837.734244634@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112836.799946261@linuxfoundation.org>
References: <20230920112836.799946261@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoquan He <bhe@redhat.com>

[ Upstream commit b1e213a9e31c20206f111ec664afcf31cbfe0dbb ]

On s390 systems (aka mainframes), it has classic channel devices for
networking and permanent storage that are currently even more common
than PCI devices. Hence it could have a fully functional s390 kernel
with CONFIG_PCI=n, then the relevant iomem mapping functions
[including ioremap(), devm_ioremap(), etc.] are not available.

Here let FSL_EDMA and INTEL_IDMA64 depend on HAS_IOMEM so that it
won't be built to cause below compiling error if PCI is unset.

--------
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/idma64.ko] undefined!
--------

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306211329.ticOJCSv-lkp@intel.com/
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Link: https://lore.kernel.org/r/20230707135852.24292-2-bhe@redhat.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 5ea37d133f241..6abb80b09db3b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -209,6 +209,7 @@ config FSL_DMA
 config FSL_EDMA
 	tristate "Freescale eDMA engine support"
 	depends on OF
+	depends on HAS_IOMEM
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
@@ -254,6 +255,7 @@ config IMX_SDMA
 
 config INTEL_IDMA64
 	tristate "Intel integrated DMA 64-bit support"
+	depends on HAS_IOMEM
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
 	help
-- 
2.40.1



