Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026902;
	b=ktXAoMDYiQFSJjF07kqnOE+f/3x5PFMoK7M/mnjlPEmtyMN6uXxarBj5vXMenuvCxK3l
	 pfilidNyPsZ6Vl/n3IsFwM5siV0zZJV18CYTU3qJggSh0mKfmVP75MgJFqfQdRW3byvgi
	 5R6r6hj2oGJj1W/11exouKu2akWi5ST/kF5vTgBcgdyDpYBylbI4RtG6JApWjDDlh7MZh
	 T80OtPCfCOK0sGjnsV81SxUhiQQI3FiCouX3SDlsuXmHRvh2DBQ5o3Epo53Ka03Uf/vIp
	 XXHyP7X5pWNcFr8X2U00XBIR61Z+gohljt+ZWGgWn9grkdMboMLAb1L/vJ/+2PBd2Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FH7mIomDv+Vj6KqKGL0GwWGNkaEZ3jMAv2rlQU6kSo4=;
	b=OD2bWwPog6Hpb0LIs1QwDXCiRzkjKoVeu3FdOp48DzoTlsDlgBdYU5J7PS649kEucSmN
	 PwMQogcsshJpmcXjlmolIwqT3DZoZy3eRfQ/eB9fwKHcqtcebBP1ZZ6Qy5FAKCdg2mFtD
	 oCz1/Und8jmoFXMuizOfx24b2Wyz0G3RXhVykXQl2niS0VNye7qjMwg4IwME1Dsqz9rxF
	 1aSpO3cZSvxZ1QjTRUmPCitsMuy46e194/seicoo9HVjaBCtS67BmnbLZAn/D0DKQqsov
	 fR9pjTdPUZ/UM+O35hHuwgzpYZI3/vjV7jCTU7fCAugamMmm0IV0wxQ0649o3gI+d7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AKjn1L6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AED606A31C;
	Wed, 18 Nov 2026 18:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AKjn1L6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18291F000C4;
	Wed, 18 Nov 2026 18:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026902;
	bh=FH7mIomDv+Vj6KqKGL0GwWGNkaEZ3jMAv2rlQU6kSo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKjn1L6WtQuB7iWQDXMx8nOxPNM1xtatMPsDzsZyjMBvVAXoQYHA8tBbUhKGUlVGj
	 hCjlv1GWOF82TFmgItKnwtfYx4qgwvrfjXr9nS78ePMcVS7bO22M+zLgMKerg2Wsgz
	 mHFXrz09DX+Nzq93dnEpqmSFoaTOgTpE2VBpJnCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1559/2151] scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
Date: Wed, 18 Nov 2026 15:54:54 +0100
Message-ID: <20261118150218.682766727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 16256a0529253..fbd476a3f1318 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -547,6 +547,9 @@ struct hisi_sas_err_record_v3 {
 #define IRQ_AXI_INDEX 11
 
 #define DELAY_FOR_RESET_HW 100
+#define STOP_PHY_DELAY_US 50
+#define DISABLE_PHY_DELAY_MS 50
+#define DISABLE_HOST_PHY_DELAY_MS 10
 #define HDR_SG_MOD 0x2
 #define LUN_SIZE 8
 #define ATTR_PRIO_REGION 9
@@ -983,7 +986,7 @@ static int reset_hw_v3_hw(struct hisi_hba *hisi_hba)
 
 	/* Disable all of the PHYs */
 	hisi_sas_stop_phys(hisi_hba);
-	udelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
+	udelay(STOP_PHY_DELAY_US);
 
 	/* Ensure axi bus idle */
 	ret = hisi_sas_read32_poll_timeout(AXI_CFG, val, !val,
@@ -1072,7 +1075,7 @@ static void disable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	cfg &= ~PHY_CFG_ENA_MSK;
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 
-	mdelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
+	mdelay(DISABLE_PHY_DELAY_MS);
 
 	state = hisi_sas_read32(hisi_hba, PHY_STATE);
 	if (state & BIT(phy_no)) {
@@ -2755,7 +2758,7 @@ static int disable_host_v3_hw(struct hisi_hba *hisi_hba)
 
 	hisi_sas_stop_phys(hisi_hba);
 
-	mdelay(HISI_SAS_DELAY_FOR_PHY_DISABLE);
+	mdelay(DISABLE_HOST_PHY_DELAY_MS);
 
 	reg_val = hisi_sas_read32(hisi_hba, AXI_MASTER_CFG_BASE +
 				  AM_CTRL_GLOBAL);
-- 
2.53.0



