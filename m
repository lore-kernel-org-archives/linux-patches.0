Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059C437757D;
	Tue, 21 Jul 2026 21:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669713; cv=none; b=R6fK/vgkJbhAPtrLuSTxPIishwsBoNcgVFK4HN+nuujFZEnPP62bTOcaD8B9yCWGS3YU+ke0Qi97uqVzYR/SeubS89v6fB47uXzaOOBkjaNJzDHVLBbKn2qZCvawz5o8PMDumrx3/s/ZXflSIIZ7zGD6l8iwOTv07FdgS+VERNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669713; c=relaxed/simple;
	bh=aTE9ijfdoWI43/v9I4HUo/RzZGUATqgPdeWPKZyJAK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHXxLBXxn9evZD5erEypsxNorXaB8WscGzqzuvZs4mCyOJ78xX7w96F7ZWq9yKX1Zb3fBLAa1c6BDyr7BZCS2lxI3TpSuYxV60c97/IZ24fq9GSHCWxKlX0Xh6rJxHEf6uFbZD7jaIM/TEnimMMZpuDm+SAB4qNk8TqcKR9Jzzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcikH2Gy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcikH2Gy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1F61F000E9;
	Tue, 21 Jul 2026 21:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669711;
	bh=xBuC+ZlqHAbdAakl5gOJIMKy146Gmf8UqLS065Igpqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gcikH2GyrCvFiUudfZZlBUbD95wx3LzOJ3N15xvvDjJtdzXXjFt+jwjsBtVMcJ8pg
	 Fi+L8f6/JuNqr810P6uraHUFPfJ6UD6k9iOBiyvk1E9uqAi6zq5ObL8l+e6O+4mT3o
	 3El2Rc4X5Bt3ztKa01/fqYeVXz24D8MO4/cySezA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0615/1067] PCI: endpoint: pci-epf-ntb: Add check to detect db_count value of 0
Date: Tue, 21 Jul 2026 17:20:16 +0200
Message-ID: <20260721152438.358058810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eb972f9b4bea70..e17dbcc9c8dbbb 100644
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



