Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC69168CB
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43237C433EF;
	Mon,  8 May 2023 10:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541160;
	bh=TP1zeGAjCvcaBJy6uJ8i0BW3NXHwa/T6C5q3+PAIKNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tesGCLijiqsnJ9YuF51bbyGEYW0ZMTsS3v0/kXSFTMarNVow5FtgnqD06zACKbqNj
	 BOKrKZ+W558pcaki5l3RplXMOv966YrU861NWtj6qXKvJALrH9wT2x6p+pU7+Ia0wo
	 BB8LxVgVOtYVlLdDcUwYa/fgw8ZeAiJzK+JAYRps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Triplett <josh@joshtriplett.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 6.2 025/663] PCI: kirin: Select REGMAP_MMIO
Date: Mon,  8 May 2023 11:37:31 +0200
Message-Id: <20230508094429.258647944@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Triplett <josh@joshtriplett.org>

commit 3a2776e8a0e156a61f5b59ae341d8fffc730b962 upstream.

pcie-kirin uses regmaps, and needs to pull them in; otherwise, with
CONFIG_PCIE_KIRIN=y and without CONFIG_REGMAP_MMIO pcie-kirin produces
a linker failure looking for __devm_regmap_init_mmio_clk().

Fixes: d19afe7be126 ("PCI: kirin: Use regmap for APB registers")
Link: https://lore.kernel.org/r/04636141da1d6d592174eefb56760511468d035d.1668410580.git.josh@joshtriplett.org
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
[lpieralisi@kernel.org: commit log and removed REGMAP select]
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: stable@vger.kernel.org # 5.16+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/controller/dwc/Kconfig
+++ b/drivers/pci/controller/dwc/Kconfig
@@ -286,6 +286,7 @@ config PCIE_KIRIN
 	tristate "HiSilicon Kirin series SoCs PCIe controllers"
 	depends on PCI_MSI
 	select PCIE_DW_HOST
+	select REGMAP_MMIO
 	help
 	  Say Y here if you want PCIe controller support
 	  on HiSilicon Kirin series SoCs.


