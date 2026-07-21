Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF613B1ECC;
	Tue, 21 Jul 2026 20:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666657; cv=none; b=qM4XfC5/m/Il9F7OIovjVpqdWEJgLZ/8nGR6lUr8VoDY1/Kfn7tM8eU+RD4O/TNmyVkMNzwQZ20S52l5GADFuFFY1UjTLQIwVOkX0L2he2D919EYJPj+dKPHSCSaTap/xdq/HWOIlIvbfEbhU1LwV/xGw+dYzx3tXtotglDRLWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666657; c=relaxed/simple;
	bh=UBFgLdw+fCORuHEBoK11krRpMGy+rqiB8V9X8Q1Kh3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loYqqpnuGhEMaRDIXJcpuZE3ygMS9Ih/N/aE9ecCKe1l5gGspacTjmkRrFcyrboGSFZbcZ7tGRNoWmTl0KL4G8EFtaxIHv54IaGhIOitcR3+OWb5hEd/XrAkKR5ET6khfOOds8QHVq6RKXNooil2L2jC6z74oHEuX7Zrdp2TANU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KukmEnNf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KukmEnNf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED411F000E9;
	Tue, 21 Jul 2026 20:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666654;
	bh=mKW+iRlf8j7yg5ZU1EL2EnS1N1pC1dfGOnYsgHwM+Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KukmEnNf87D+rNNtrUvRU5qUry4rmuUucvFHdGdP7O5/VK4KGXFVjwg/Pch3wMbjg
	 SiJter+D8orpajfo8cjXJbKSxOTIr75A5pS+P9KY3nixECw6Y/8Mb91Gq/r1+cNq5l
	 c6rQLnZKwR0Nk7+tffJjelqRk7FXOnYOloWys61k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0764/1266] PCI: endpoint: pci-epf-ntb: Add check to detect db_count value of 0
Date: Tue, 21 Jul 2026 17:20:01 +0200
Message-ID: <20260721152458.959878233@linuxfoundation.org>
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
index b759b4e0bfb598..cba6bab067b61d 100644
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



