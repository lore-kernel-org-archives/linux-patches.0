Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031967;
	b=XaeuFewBTEdHjbgeV3bD+CDxa2ZKuqQaMA1sYLNZFIAgjdW+68NEJIWFnxBuRCFopKqR
	 HiaIuc7s3E2ojBmMqMlGP56xdiPt7rPebYWp1Fj3IYtoCfyojok2HGoKOZgqZmJBHUb+M
	 J84o8ScL/3VUWNMD0z1l62J/0cP88b/ntRkCb48+xZ3OgT+O7mZeryql2xvD4plzkV+93
	 1NjL/sdKBnS3J5cXtIcWL1rjy1zu80pmgv+zav3Kin5HnF3BORxc89lWepOn7Rx/GlCMI
	 Qgx6eej2gCig71DEfVBYj76IUUtAmCSErkNtr+eu/IFYt0YUkpiN6mCcJB2p5+rppNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cc0d0iGsfH+4Md5o3GyKkU3GwZ/mVgfBPNJNywzIis4=;
	b=GC1elsCxF38l0A07jtH/EHSR78a8yOHFRYDCyQ4PEZbPMs9agPCLNTxOMaY3NyyI7Fxx
	 mbqwBOJldcACSj5hVLlOYky3J8Un97REtXNZHxyu/eAEd2bpaI1ekoFh8KvFbW8nbwiFp
	 5x20AUJeh7DMA8UZfoHTH+wFvqdE1XsH883XdQHDgEZVvlKZtHmprL4SXuGbZENxvLN9X
	 BHoI3OSpQaz0C7JOldZUEp02sQEZk7CZcF21VEMS4xcUVx+tbmQmb0Skbw7QIkQzmN5Xd
	 va5wNvfXEnlwOurU0HAqjXva1zTxY80dq/j9cAByHlIVCxXq4yhHDaZjHT9aZIn1Dkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWevmc8e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D70606A31C;
	Wed, 18 Nov 2026 19:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWevmc8e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD521F000C4;
	Wed, 18 Nov 2026 19:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031967;
	bh=cc0d0iGsfH+4Md5o3GyKkU3GwZ/mVgfBPNJNywzIis4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWevmc8eIriQRegLJrcZ1ag8ldW4odYExWnMq1JPvQdeXmGzJJ6W8sDqy1VMmX1dv
	 8mmswe4Z41IcGi2/V13iiTnTMT+pgOEKs8nGeMsaHja1bYUAeOaYwqO2GvJ/Y8zf0U
	 bZqWFTK99L043fXR+c8CLfcIt5cQhxXFnxkQZPkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1246/1756] scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
Date: Wed, 18 Nov 2026 15:56:13 +0100
Message-ID: <20261118150059.339541151@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 7307109c92f702434669bfcd29fb8058ccc07b45 ]

Commit 4ca7fe99fc84 ("scsi: hisi_sas: Use macro instead of magic
number") replaced several delay constants with a single macro of value
100. However, three sites originally used different values:

  - reset_hw_v3_hw:     udelay(50) -> udelay(100) [doubled]
  - disable_phy_v3_hw:  mdelay(50) -> mdelay(100) [doubled]
  - disable_host_v3_hw: mdelay(10) -> mdelay(100) [10x longer]

The overly long delays on the PHY disable and host shutdown paths
increase boot and shutdown time for all local PHYs.

Add separate macros for each delay to restore the original values while
still avoiding magic numbers.

Fixes: 4ca7fe99fc84 ("scsi: hisi_sas: Use macro instead of magic number")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://patch.msgid.link/20261009033238.1076098-3-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 64aad320a04a3..1b21cde7849fc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -546,6 +546,9 @@ struct hisi_sas_err_record_v3 {
 #define IRQ_AXI_INDEX 11
 
 #define DELAY_FOR_RESET_HW 100
+#define STOP_PHY_DELAY_US 50
+#define DISABLE_PHY_DELAY_MS 50
+#define DISABLE_HOST_PHY_DELAY_MS 10
 #define HDR_SG_MOD 0x2
 #define LUN_SIZE 8
 #define ATTR_PRIO_REGION 9
@@ -980,7 +983,7 @@ static int reset_hw_v3_hw(struct hisi_hba *hisi_hba)
 
 	/* Disable all of the PHYs */
 	hisi_sas_stop_phys(hisi_hba);
-	udelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
+	udelay(STOP_PHY_DELAY_US);
 
 	/* Ensure axi bus idle */
 	ret = hisi_sas_read32_poll_timeout(AXI_CFG, val, !val,
@@ -1069,7 +1072,7 @@ static void disable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	cfg &= ~PHY_CFG_ENA_MSK;
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 
-	mdelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
+	mdelay(DISABLE_PHY_DELAY_MS);
 
 	state = hisi_sas_read32(hisi_hba, PHY_STATE);
 	if (state & BIT(phy_no)) {
@@ -2757,7 +2760,7 @@ static int disable_host_v3_hw(struct hisi_hba *hisi_hba)
 
 	hisi_sas_stop_phys(hisi_hba);
 
-	mdelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
+	mdelay(DISABLE_HOST_PHY_DELAY_MS);
 
 	reg_val = hisi_sas_read32(hisi_hba, AXI_MASTER_CFG_BASE +
 				  AM_CTRL_GLOBAL);
-- 
2.53.0



