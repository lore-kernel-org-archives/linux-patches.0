Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214173;
	b=CShqTa+QjXOH31DvJtHgBAMCMepbmg36EeDjLI6HFahOch4P0dH+HKM7EP3mevm3Z5LS
	 t90zgHzeCKwhVBxtNDE8itEJh9SnVwgiFxocJCdNbFYToo7maBchjaosQIX/ffXeYg0O+
	 xPcCxEB4q7bFtJVLuzULT4EoRRfIJZHjKIHNKFY6s73Pmk9dy8U17P9hn+KNtnO2tAxyq
	 v9s3GEfWTMGTwXlZmSx5oEypwQzqg8Yzu1fBhwIcqylTycTFvpvP4AYNvv3k4V2vAsIdq
	 DEJ5sVT5pjftHAvNJm8jis97HBJ104FMi76x3GEM4zDSHFoPHXO5S5xSZ8wszNdMQHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FQYA6OPZl6/BZ5KFEmCGHY8D7fFDz4OYSaHs6qmi9v4=;
	b=vaXJlIMRCC+brqsk0dRUCML378SEkxJc5xex4r0fzBu3BTydk6Ihxhvujcqfz90J21Hw
	 pPBYin9ETzszpklTlM9UUQyQTb2+pVSzZOT6lqbV6caJVI6J/eiCuo9V4zj1ZC0g0SgWZ
	 XBUbp5sa3mw1ZMCPxmI623953mtlg6mOkvZmSqbmsEhhOsoV5EQ9c0Q1BbCflIGzJD4D3
	 pJHG1xbIb+AV8X0QmPbZGDwxu+0h1CblNR0S4X3AbHDqt28NoXKN7lHms+Do43SM/HcoC
	 qAfaWt/diEcXKIrQkI2CLbT5O0nMvErkr52V/sqCWOdpGorkUeGEmniHBnq8NOiVSVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Sc/PbPOT";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C51606A31A;
	Wed, 28 Oct 2026 19:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sc/PbPOT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAED1F01825;
	Wed, 28 Oct 2026 19:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214172;
	bh=FQYA6OPZl6/BZ5KFEmCGHY8D7fFDz4OYSaHs6qmi9v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sc/PbPOTAbcDPH0kGYXPSHWyw+BxdVl3UubfTINwe1loA9aIiVj4Jzd1kztQ3uk7u
	 HtIdpJKdNZnhqJRL/KYYy07RQUC2a4E2FALL/Y3yL/OBw7+HwsMInA7dyk5381ZA39
	 qcjGWlVFTL8aPsq+bDKgn8gN7CocAOYaDd2zFx6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prayas Patel <prayas.patel@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0722/1887] scsi: mpi3mr: Fix corrupt config pages PHY state is switched in sysfs
Date: Wed, 28 Oct 2026 17:46:58 +0100
Message-ID: <20261028170515.871923016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 711201a8b8334a397440ac0b859df0054e174bc9 ]

The driver, through the SAS transport, exposes a sysfs interface to
enable/disable PHYs in a controller/expander setup.  When multiple PHYs
are disabled and enabled in rapid succession, the persistent and current
config pages related to SAS IO unit/SAS Expander pages could get
corrupted.

Use separate memory for each config request.

Signed-off-by: Prayas Patel <prayas.patel@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110194405.10108-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  9 ----
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 81 ++++++---------------------------
 2 files changed, 13 insertions(+), 77 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index ffeadd1e3543b..982629a0ec803 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -130,8 +130,6 @@ extern atomic64_t event_counter;
 
 #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
 
-#define MPI3MR_DEFAULT_CFG_PAGE_SZ		1024 /* in bytes */
-
 #define MPI3MR_RESET_TOPOLOGY_SETTLE_TIME	10
 
 #define MPI3MR_SCMD_TIMEOUT    (60 * HZ)
@@ -1013,9 +1011,6 @@ struct scmd_priv {
  * @io_throttle_low: I/O size to stop throttle in 512b blocks
  * @num_io_throttle_group: Maximum number of throttle groups
  * @throttle_groups: Pointer to throttle group info structures
- * @cfg_page: Default memory for configuration pages
- * @cfg_page_dma: Configuration page DMA address
- * @cfg_page_sz: Default configuration page memory size
  * @sas_transport_enabled: SAS transport enabled or not
  * @scsi_device_channel: Channel ID for SCSI devices
  * @transport_cmds: Command tracker for SAS transport commands
@@ -1198,10 +1193,6 @@ struct mpi3mr_ioc {
 	u16 num_io_throttle_group;
 	struct mpi3mr_throttle_group_info *throttle_groups;
 
-	void *cfg_page;
-	dma_addr_t cfg_page_dma;
-	u16 cfg_page_sz;
-
 	u8 sas_transport_enabled;
 	u8 scsi_device_channel;
 	struct mpi3mr_drv_cmd transport_cmds;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index d4747ff4d800a..c14bee07f8c10 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3864,17 +3864,6 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 
 	mpi3mr_print_ioc_info(mrioc);
 
-	if (!mrioc->cfg_page) {
-		dprint_init(mrioc, "allocating config page buffers\n");
-		mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
-		mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
-		    mrioc->cfg_page_sz, &mrioc->cfg_page_dma, GFP_KERNEL);
-		if (!mrioc->cfg_page) {
-			retval = -1;
-			goto out_failed_noretry;
-		}
-	}
-
 	if (!mrioc->init_cmds.reply) {
 		retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
 		if (retval) {
@@ -4418,11 +4407,7 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		    mrioc->admin_req_base, mrioc->admin_req_dma);
 		mrioc->admin_req_base = NULL;
 	}
-	if (mrioc->cfg_page) {
-		dma_free_coherent(&mrioc->pdev->dev, mrioc->cfg_page_sz,
-		    mrioc->cfg_page, mrioc->cfg_page_dma);
-		mrioc->cfg_page = NULL;
-	}
+
 	if (mrioc->pel_seqnum_virt) {
 		dma_free_coherent(&mrioc->pdev->dev, mrioc->pel_seqnum_sz,
 		    mrioc->pel_seqnum_virt, mrioc->pel_seqnum_dma);
@@ -5007,55 +4992,6 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	return retval;
 }
 
-
-/**
- * mpi3mr_free_config_dma_memory - free memory for config page
- * @mrioc: Adapter instance reference
- * @mem_desc: memory descriptor structure
- *
- * Check whether the size of the buffer specified by the memory
- * descriptor is greater than the default page size if so then
- * free the memory pointed by the descriptor.
- *
- * Return: Nothing.
- */
-static void mpi3mr_free_config_dma_memory(struct mpi3mr_ioc *mrioc,
-	struct dma_memory_desc *mem_desc)
-{
-	if ((mem_desc->size > mrioc->cfg_page_sz) && mem_desc->addr) {
-		dma_free_coherent(&mrioc->pdev->dev, mem_desc->size,
-		    mem_desc->addr, mem_desc->dma_addr);
-		mem_desc->addr = NULL;
-	}
-}
-
-/**
- * mpi3mr_alloc_config_dma_memory - Alloc memory for config page
- * @mrioc: Adapter instance reference
- * @mem_desc: Memory descriptor to hold dma memory info
- *
- * This function allocates new dmaable memory or provides the
- * default config page dmaable memory based on the memory size
- * described by the descriptor.
- *
- * Return: 0 on success, non-zero on failure.
- */
-static int mpi3mr_alloc_config_dma_memory(struct mpi3mr_ioc *mrioc,
-	struct dma_memory_desc *mem_desc)
-{
-	if (mem_desc->size > mrioc->cfg_page_sz) {
-		mem_desc->addr = dma_alloc_coherent(&mrioc->pdev->dev,
-		    mem_desc->size, &mem_desc->dma_addr, GFP_KERNEL);
-		if (!mem_desc->addr)
-			return -ENOMEM;
-	} else {
-		mem_desc->addr = mrioc->cfg_page;
-		mem_desc->dma_addr = mrioc->cfg_page_dma;
-		memset(mem_desc->addr, 0, mrioc->cfg_page_sz);
-	}
-	return 0;
-}
-
 /**
  * mpi3mr_post_cfg_req - Issue config requests and wait
  * @mrioc: Adapter instance reference
@@ -5211,8 +5147,12 @@ static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
 		cfg_req->page_length = cfg_hdr->page_length;
 		cfg_req->page_version = cfg_hdr->page_version;
 	}
-	if (mpi3mr_alloc_config_dma_memory(mrioc, &mem_desc))
-		goto out;
+
+	mem_desc.addr = dma_alloc_coherent(&mrioc->pdev->dev,
+		mem_desc.size, &mem_desc.dma_addr, GFP_KERNEL);
+
+	if (!mem_desc.addr)
+		return retval;
 
 	mpi3mr_add_sg_single(&cfg_req->sgl, sgl_flags, mem_desc.size,
 	    mem_desc.dma_addr);
@@ -5241,7 +5181,12 @@ static int mpi3mr_process_cfg_req(struct mpi3mr_ioc *mrioc,
 	}
 
 out:
-	mpi3mr_free_config_dma_memory(mrioc, &mem_desc);
+	if (mem_desc.addr) {
+		dma_free_coherent(&mrioc->pdev->dev, mem_desc.size,
+			mem_desc.addr, mem_desc.dma_addr);
+		mem_desc.addr = NULL;
+	}
+
 	return retval;
 }
 
-- 
2.53.0



