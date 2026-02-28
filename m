Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B671333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301825; cv=none; b=bdb/5CInH46c5doQuM+k8fBBICaqoaX/8HxXLORHqVARC/gtfRa0MjPemQY5XyjdWkq+PPdEJroMAB7r0g4EBSboyAXhFWTyfHAvLAhE43l+EN5ya0Yit/CzYnKSNZW0O5DpxfT6i8wi/zODIMPM72xeCU7PDXsam7QZpNbrE88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301825; c=relaxed/simple;
	bh=6H1SfylmXdEznzN0UoCmynIT9ZpO3UsgpMrSsyI8+VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N68R6JALkUYXum8nEQjl57BNdMI6mBTLp2OOIQ4mFhnEe4mipuotbt06mxSpKxG6/Ex+swqU0MBRw2AZ70XYVtOsr2xDogCJ5sx8XzgQstr+fWA86tS/Zb8MoOM2T4N2GbGRa4NzeTNKl1qc4EzyB6OnMA6Vsxgpy1HeCQeyLHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uiIQmj8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uiIQmj8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73427C116D0;
	Sat, 28 Feb 2026 18:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301825;
	bh=6H1SfylmXdEznzN0UoCmynIT9ZpO3UsgpMrSsyI8+VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiIQmj8ywta2onY0iuzOm5cLSvop9/WcQPC6BjztDXjVIuyGFhb1tlJd4/Vlt8ms9
	 PmPBba4aUtbNf7LmMu3R8ztewcutVLDJyY1wms4ufkDNDI9kfQRxhPHwmPWD3M5g9Q
	 HBhxpyQ29H/ppi02eY3N5rkV6zq9z/klBKV99EO3cOODL44SS5jeO5KlGdjmcPcnTs
	 6MVoUbcF7JBLoysLpxcb/GsdlskmdnGGcw+DlfBL4vHUKFBy7t+OCuWFbiQlDqNsMB
	 UM1UBmjgDe0e8vNISwR6053MPpNpeOhnzTMKAe4ruMheIdLGBCj+5tdb/m56WEqKka
	 G5pEzpokLwgDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vimlesh Kumar <vimleshk@marvell.com>,
	Sathesh Edara <sedara@marvell.com>,
	Shinas Rasheed <srasheed@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 240/385] octeon_ep: disable per ring interrupts
Date: Sat, 28 Feb 2026 12:57:42 -0500
Message-ID: <20260228180011.1568201-240-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vimlesh Kumar <vimleshk@marvell.com>

[ Upstream commit 73e6ffa37cebee152c07c5f2b8bc70fd2899ea6e ]

Disable the MSI-X per ring interrupt for every PF ring when PF
netdev goes down.

Fixes: 1f2c2d0cee023 ("octeon_ep: add hardware configuration APIs")
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Signed-off-by: Vimlesh Kumar <vimleshk@marvell.com>
Link: https://patch.msgid.link/20260206111510.1045092-2-vimleshk@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeon_ep/octep_cn9k_pf.c | 18 +++++++++++++++---
 .../ethernet/marvell/octeon_ep/octep_cnxk_pf.c | 18 +++++++++++++++---
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h     |  1 +
 .../marvell/octeon_ep/octep_regs_cnxk_pf.h     |  1 +
 4 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
index b5805969404fa..f0bcb5f3c1474 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c
@@ -696,14 +696,26 @@ static void octep_enable_interrupts_cn93_pf(struct octep_device *oct)
 /* Disable all interrupts */
 static void octep_disable_interrupts_cn93_pf(struct octep_device *oct)
 {
-	u64 intr_mask = 0ULL;
+	u64 reg_val, intr_mask = 0ULL;
 	int srn, num_rings, i;
 
 	srn = CFG_GET_PORTS_PF_SRN(oct->conf);
 	num_rings = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
 
-	for (i = 0; i < num_rings; i++)
-		intr_mask |= (0x1ULL << (srn + i));
+	for (i = 0; i < num_rings; i++) {
+		intr_mask |= BIT_ULL(srn + i);
+		reg_val = octep_read_csr64(oct,
+					   CN93_SDP_R_IN_INT_LEVELS(srn + i));
+		reg_val &= ~CN93_INT_ENA_BIT;
+		octep_write_csr64(oct,
+				  CN93_SDP_R_IN_INT_LEVELS(srn + i), reg_val);
+
+		reg_val = octep_read_csr64(oct,
+					   CN93_SDP_R_OUT_INT_LEVELS(srn + i));
+		reg_val &= ~CN93_INT_ENA_BIT;
+		octep_write_csr64(oct,
+				  CN93_SDP_R_OUT_INT_LEVELS(srn + i), reg_val);
+	}
 
 	octep_write_csr64(oct, CN93_SDP_EPF_IRERR_RINT_ENA_W1C, intr_mask);
 	octep_write_csr64(oct, CN93_SDP_EPF_ORERR_RINT_ENA_W1C, intr_mask);
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c b/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
index 5de0b5ecbc5fd..07e00887c6940 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_cnxk_pf.c
@@ -720,14 +720,26 @@ static void octep_enable_interrupts_cnxk_pf(struct octep_device *oct)
 /* Disable all interrupts */
 static void octep_disable_interrupts_cnxk_pf(struct octep_device *oct)
 {
-	u64 intr_mask = 0ULL;
+	u64 reg_val, intr_mask = 0ULL;
 	int srn, num_rings, i;
 
 	srn = CFG_GET_PORTS_PF_SRN(oct->conf);
 	num_rings = CFG_GET_PORTS_ACTIVE_IO_RINGS(oct->conf);
 
-	for (i = 0; i < num_rings; i++)
-		intr_mask |= (0x1ULL << (srn + i));
+	for (i = 0; i < num_rings; i++) {
+		intr_mask |= BIT_ULL(srn + i);
+		reg_val = octep_read_csr64(oct,
+					   CNXK_SDP_R_IN_INT_LEVELS(srn + i));
+		reg_val &= ~CNXK_INT_ENA_BIT;
+		octep_write_csr64(oct,
+				  CNXK_SDP_R_IN_INT_LEVELS(srn + i), reg_val);
+
+		reg_val = octep_read_csr64(oct,
+					   CNXK_SDP_R_OUT_INT_LEVELS(srn + i));
+		reg_val &= ~CNXK_INT_ENA_BIT;
+		octep_write_csr64(oct,
+				  CNXK_SDP_R_OUT_INT_LEVELS(srn + i), reg_val);
+	}
 
 	octep_write_csr64(oct, CNXK_SDP_EPF_IRERR_RINT_ENA_W1C, intr_mask);
 	octep_write_csr64(oct, CNXK_SDP_EPF_ORERR_RINT_ENA_W1C, intr_mask);
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
index ca473502d7a02..95f1dfff90cce 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cn9k_pf.h
@@ -386,5 +386,6 @@
 #define CN93_PEM_BAR4_INDEX            7
 #define CN93_PEM_BAR4_INDEX_SIZE       0x400000ULL
 #define CN93_PEM_BAR4_INDEX_OFFSET     (CN93_PEM_BAR4_INDEX * CN93_PEM_BAR4_INDEX_SIZE)
+#define CN93_INT_ENA_BIT	BIT_ULL(62)
 
 #endif /* _OCTEP_REGS_CN9K_PF_H_ */
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h
index e637d7c8224d4..4d172a552f80c 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_regs_cnxk_pf.h
@@ -412,5 +412,6 @@
 #define CNXK_PEM_BAR4_INDEX		7
 #define CNXK_PEM_BAR4_INDEX_SIZE	0x400000ULL
 #define CNXK_PEM_BAR4_INDEX_OFFSET	(CNXK_PEM_BAR4_INDEX * CNXK_PEM_BAR4_INDEX_SIZE)
+#define CNXK_INT_ENA_BIT	BIT_ULL(62)
 
 #endif /* _OCTEP_REGS_CNXK_PF_H_ */
-- 
2.51.0

