Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174DF44AB99;
	Tue, 21 Jul 2026 22:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672009; cv=none; b=aOHgzCsNjKzj8N8ALoL597tfjv9odHqgZ+qbrzLokVpqixY3KvqMeKo3gDuFmokFu2EblXCt7tOJj91njCUGPapZd6wlJ0DVFDQ+VzhEVN61wgJnILOU6Ii4w2IMxCK8V72PwfKhvYX6WjGXzDQy7SK8xrFD8tGPW+v+xeausio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672009; c=relaxed/simple;
	bh=e2cSfXL94zEnhItH6rpg2PPz9riSgmO1YqaZNSXDVSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdzGAocinxkiTYq7zRfNTqM3uWZsg775uPPU4Y9dUO2r3CJlNQghPVibcViyZwm2tGr4imzDexxYpZZVOTtW/bY59WSL1DlxiZeQ/gTfUZO6uMyCNVjauySe1MjDFoyVA9yYfQ88qBHFifZM7RRNAkUgY/nGmqaktMKfFvT282s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6vg3UB4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6vg3UB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7706E1F00A3A;
	Tue, 21 Jul 2026 22:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672008;
	bh=jevdMnnipWLXzrO/waK7aCN7k8trmPTSJ+TdOQRxyCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6vg3UB40iTAHpoFfKhuugKUCWB+MhJTx+m0Z6Y1fbJLZKjETs9FvjMTcg1TbWhWm
	 ggse++aAW2MvnKhzlYCDdgSGYrQsZCrEnMYitZQPBDbnTdDqx0JKnzLNbhGd7uUUV0
	 925tpqrAVbnBf8HSmd13rVWNzosdaoQzZWGz+mHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 463/843] PCI: endpoint: pci-epf-ntb: Add check to detect db_count value of 0
Date: Tue, 21 Jul 2026 17:21:38 +0200
Message-ID: <20260721152416.450673782@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit d1db6d7c2485ee475a04d8354fbb5b26ea10d978 ]

epf_ntb->db_count value should be within 1 to MAX_DB_COUNT. Current code
only checks for the upper bound, while the lower bound is unchecked. This
can cause a lot of issues in the driver if the user passes 'db_count' as 0.

Add a check for 0 also. While at it, remove the redundant 'db_count'
variable from epf_ntb_configure_interrupt().

Fixes: 8b821cf76150 ("PCI: endpoint: Add EP function driver to provide NTB functionality")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260407124421.282766-3-mani@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-ntb.c | 21 ++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-ntb.c b/drivers/pci/endpoint/functions/pci-epf-ntb.c
index 8673c16ffb864b..e52109e97446e8 100644
--- a/drivers/pci/endpoint/functions/pci-epf-ntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-ntb.c
@@ -559,12 +559,15 @@ static int epf_ntb_configure_db(struct epf_ntb *ntb,
 	struct pci_epc *epc;
 	int ret;
 
-	if (db_count > MAX_DB_COUNT)
-		return -EINVAL;
-
 	ntb_epc = ntb->epc[type];
 	epc = ntb_epc->epc;
 
+	if (!db_count || db_count > MAX_DB_COUNT) {
+		dev_err(&epc->dev, "DB count %d out of range (1 - %d)\n",
+			db_count, MAX_DB_COUNT);
+		return -EINVAL;
+	}
+
 	if (msix)
 		ret = epf_ntb_configure_msix(ntb, type, db_count);
 	else
@@ -1278,7 +1281,6 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb,
 	u8 func_no, vfunc_no;
 	struct pci_epc *epc;
 	struct device *dev;
-	u32 db_count;
 	int ret;
 
 	ntb_epc = ntb->epc[type];
@@ -1296,17 +1298,16 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb,
 	func_no = ntb_epc->func_no;
 	vfunc_no = ntb_epc->vfunc_no;
 
-	db_count = ntb->db_count;
-	if (db_count > MAX_DB_COUNT) {
-		dev_err(dev, "DB count cannot be more than %d\n", MAX_DB_COUNT);
+	if (!ntb->db_count || ntb->db_count > MAX_DB_COUNT) {
+		dev_err(dev, "DB count %d out of range (1 - %d)\n",
+			ntb->db_count, MAX_DB_COUNT);
 		return -EINVAL;
 	}
 
-	ntb->db_count = db_count;
 	epc = ntb_epc->epc;
 
 	if (msi_capable) {
-		ret = pci_epc_set_msi(epc, func_no, vfunc_no, db_count);
+		ret = pci_epc_set_msi(epc, func_no, vfunc_no, ntb->db_count);
 		if (ret) {
 			dev_err(dev, "%s intf: MSI configuration failed\n",
 				pci_epc_interface_string(type));
@@ -1315,7 +1316,7 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb,
 	}
 
 	if (msix_capable) {
-		ret = pci_epc_set_msix(epc, func_no, vfunc_no, db_count,
+		ret = pci_epc_set_msix(epc, func_no, vfunc_no, ntb->db_count,
 				       ntb_epc->msix_bar,
 				       ntb_epc->msix_table_offset);
 		if (ret) {
-- 
2.53.0



