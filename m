Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD0A882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5415C433D2;
	Fri, 10 Mar 2023 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461012;
	bh=e6C0tvxYVW2gYPTu3FFCcqhQ5IdV0NPlKQwsHdgXgIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u196FCAOwrZ4fpjz+4sRQp1AdE/kvtFf6zPdESKM3H5n2/TrJE7e7oyCJ6NAQ/X0x
	 9PK3a1dLFyC4jIlhDd2E1/kBoM2myrfTuGI3HhnI/fEPpcqgi6h/vFyJygcdHjjP5n
	 A/5wu2Ml34OZikEVHThxfJY/yET537HjCLRaF2aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.10 526/529] scsi: mpt3sas: Remove usage of dma_get_required_mask() API
Date: Fri, 10 Mar 2023 14:41:09 +0100
Message-Id: <20230310133829.188475150@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

commit 06e472acf964649a58b7de35fc9cdc3151acb970 upstream.

Remove the usage of dma_get_required_mask() API.  Directly set the DMA mask
to 63/64 if the system is a 64bit machine.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20221028091655.17741-2-sreekanth.reddy@broadcom.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2824,8 +2824,7 @@ _base_config_dma_addressing(struct MPT3S
 	struct sysinfo s;
 	u64 coherent_dma_mask, dma_mask;
 
-	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4 ||
-	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32)) {
+	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4) {
 		ioc->dma_mask = 32;
 		coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */


