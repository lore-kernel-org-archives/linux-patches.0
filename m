Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479DA8F4B
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0A0C433C7;
	Thu, 31 Aug 2023 11:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480230;
	bh=cRuq4F/BwwutsMpRy7D3viz1/yWkQWjlRKwGHoICyNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z415ZdLXxs1sdTgPSidS7m2yfckgAsBLyAoFnFoyPOlc/qbMrUZqGVvO0eArLX0l2
	 dg+m+28ipRfJyWNv7MSu22GoN+iNDsenF5azBdo44vtHZtkutRfO1QK1IJc0JPOHGF
	 MgCaY5wHtsHJ2/NB37b0hprz7Vz7hPAkODE1qL8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@linaro.org>,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <natechancellor@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 05/11] mhi: pci_generic: Fix implicit conversion warning
Date: Thu, 31 Aug 2023 13:09:57 +0200
Message-ID: <20230831110830.674039666@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>
References: <20230831110830.455765526@linuxfoundation.org>
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

From: Loic Poulain <loic.poulain@linaro.org>

commit 4ea6fa2cb921cb17812501a27c3761037d64a217 upstream.

Fix the following warning with explicit cast:

warning: implicit conversion from 'unsigned long long' to
'dma_addr_t' (aka 'unsigned int')
mhi_cntrl->iova_stop = DMA_BIT_MASK(info->dma_data_width);

Fixes: 855a70c12021 ("bus: mhi: Add MHI PCI support for WWAN modems")
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/pci_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/mhi/host/pci_generic.c
+++ b/drivers/bus/mhi/host/pci_generic.c
@@ -273,7 +273,7 @@ static int mhi_pci_probe(struct pci_dev
 	mhi_cntrl_config = info->config;
 	mhi_cntrl->cntrl_dev = &pdev->dev;
 	mhi_cntrl->iova_start = 0;
-	mhi_cntrl->iova_stop = DMA_BIT_MASK(info->dma_data_width);
+	mhi_cntrl->iova_stop = (dma_addr_t)DMA_BIT_MASK(info->dma_data_width);
 	mhi_cntrl->fw_image = info->fw;
 	mhi_cntrl->edl_image = info->edl;
 


