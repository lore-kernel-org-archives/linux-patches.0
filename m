Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23203471411;
	Tue, 21 Jul 2026 19:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662913; cv=none; b=sSAUm+4POFk6ozD5zXXXrKy6E5kPKz5rEXJCvMiXRgb5wmniM7cCb6NL4qtIw5O/xEp/i0qFBPrWPuxInqiW2pQ1dNDstJoYVPjkcW5xHLUlaCBpnuzm14S7Ep5Cx1YGgkqB0wSNV6bxEWKoGTkf1NSaF10YvDUUK0Bma5wWyUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662913; c=relaxed/simple;
	bh=/4+a4wKV7Q5WAA7xdGxCzB3yU34RLaBZFvB0t+wffO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buh+zK2rCGTZeUChoLXbL7basA99fpYreMa2LnWtH/0/3CVz3itqNY79zhriPYYiKkl6kZm1gVGzq7r84t1jXOH6jLeGMKjAiVB8WpHgp2SzMCR7oxgqqJQ7Z5/DLVnbQrQejXe6eWvtDvq5kkLVoU897yfHVa+173u30JUpdvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/S8WdxV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/S8WdxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CDD61F000E9;
	Tue, 21 Jul 2026 19:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662912;
	bh=95RyCBpUpbkN3VlKGEGuYue0nAf2hvsooozEn3deEXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/S8WdxV9AC8lSuqulYPITqKyheepBdpAzg6W1x2CPyc3M0LarLq3nU/qBbEvr8us
	 7QH+5vWrItajCQp4mr9TygTnT0rHyT1uUuXlOJBLUMBwzM2cnh8qD/oBxkTwgMcJdX
	 F2b4U3qLWMG9czzm6eNXrGkOeXAelRawM9ZdsuIs=
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
Subject: [PATCH 6.12 0624/1276] PCI: endpoint: pci-epf-vntb: Add check to detect db_count value of 0
Date: Tue, 21 Jul 2026 17:17:47 +0200
Message-ID: <20260721152500.070936693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6875af691b2de6..f9786637d21c49 100644
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



