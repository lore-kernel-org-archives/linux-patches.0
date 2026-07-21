Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603CE356A12;
	Tue, 21 Jul 2026 20:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666650; cv=none; b=BkxFzlwlIYHjLcrZd4ozq47zyL/n/mppjoNdP3TIEv6ipehGFW4gccUbNjsM//HkM5f7NWZBYEWqtrYnf7Kz7ZUL16rO7iEVMI657Z3M1RHWv4GIhkf6WIaRrbQPqR5Ky3LsMFCqt7ss1rm3Xd7tDVdnhn88tqhXTfKscp+mVgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666650; c=relaxed/simple;
	bh=tMsk6JQTBIwzIK5/sg0VtPQ+ZlXARA87bLOUjSlnm30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXZmsrEUmQ1pXE++CJS2FtQ8MZf1gw66h4vUaH3PacjvhF229MHW+XIH1zRMOL3Veabox8XNuSMGOz9EackEoh1gvVeVRabqW4h0kSSCyUWhZZR5zgmtTESruRwMF35G2j7g3kUwZK3Ure4LdLJdHulcrbyOeTHgVqlR8hDySww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prGu4Nhb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prGu4Nhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8CD1F000E9;
	Tue, 21 Jul 2026 20:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666649;
	bh=J6M/EW3LlRXUpT1zU/U968DhSRNJt5PRdFN7G+psBvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prGu4NhbXqtSXDmL00TJeK0wqoseHm8u8EMnKdcLxyZ8LRiO2350ROakj4AXUS+IA
	 Efo6iNhrHtAGfBkb4tgdZ7TdB/1Yqi5dxFLMQtU028RwXuQ42Mdi719idiu5R4gafu
	 SUUo7pB+0U8qj2rpRG4c2Tsv8DFBOe8lPvExtXc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Koichiro Den <den@valinux.co.jp>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0763/1266] PCI: endpoint: pci-epf-vntb: Add check to detect db_count value of 0
Date: Tue, 21 Jul 2026 17:20:00 +0200
Message-ID: <20260721152458.938305795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 33bd1ea748bc897c4d13437284e08c658e8d1340 ]

epf_ntb->db_count value should be within 1 to MAX_DB_COUNT. Current code
only checks for the upper bound, while the lower bound is unchecked. This
can cause a lot of issues in the driver if the user passes 'db_count' as 0.

Add a check for 0 also. While at it, remove the redundant 'db_count'
assignment.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260407124421.282766-2-mani@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 6590f77c1a0dcc..0ebd37e7ecd0f4 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -484,7 +484,6 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb)
 {
 	const struct pci_epc_features *epc_features;
 	struct device *dev;
-	u32 db_count;
 	int ret;
 
 	dev = &ntb->epf->dev;
@@ -496,14 +495,12 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb)
 		return -EINVAL;
 	}
 
-	db_count = ntb->db_count;
-	if (db_count > MAX_DB_COUNT) {
-		dev_err(dev, "DB count cannot be more than %d\n", MAX_DB_COUNT);
+	if (!ntb->db_count || ntb->db_count > MAX_DB_COUNT) {
+		dev_err(dev, "DB count %d out of range (1 - %d)\n",
+			ntb->db_count, MAX_DB_COUNT);
 		return -EINVAL;
 	}
 
-	ntb->db_count = db_count;
-
 	if (epc_features->msi_capable) {
 		ret = pci_epc_set_msi(ntb->epf->epc,
 				      ntb->epf->func_no,
-- 
2.53.0



