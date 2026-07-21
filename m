Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B183B8412;
	Tue, 21 Jul 2026 21:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669710; cv=none; b=TagTUN6IgLAa6a8Ol2Ls56zLO1YAZXjKLv9YtJicoAu5dtrh+1agTvlGYevFsiT/cNyrukyzxYJ5XwCU/fhn9ojW+BGv0IiIrUrW3BitzRb8KT5UjFRJZGzErh9g7zx1h/eKTc0HrhqBkm/VPWNtUQLLADuCnk3LUvcmkbgNmwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669710; c=relaxed/simple;
	bh=B72K08AbYr0X9BNdRdZ6jHJnuYTX+jq6z2knqBCV8J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UvCOJ6JJGrSSd14iCZuihBfhzGX4/fD5pt58rL3v1q/hctM36lYW/Vqbz0li1p7G+lGMlAbEYY0+1ObN/MjfKuZUA+C+H/JPEv85mNlfDfg8hw2DhfeYwshIxStg6551m/8pUWlgxu2lt33gylywne3QNhoxm3f+AXSTDKc/mFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YP8l2cO7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YP8l2cO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D571F000E9;
	Tue, 21 Jul 2026 21:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669708;
	bh=KRTStHgJvsM3GBCGrZ/MpinuXf+ZXg++xVRxS2Y88Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YP8l2cO7/0tX/MiGRvD5B3LTwpqHTi4UZRn8Vbh1kXiIyS9DKIgGgoApbMSqMv+Lt
	 RnLW8sio+FVu7lClxNHewrvX2DLsLBHcIIjY4OL5ouaE3/deNCP+kZ1zDcWwi5T3kx
	 u5D/Hhyx5U5TiK1XrbPt4y3IpcyoJ6TOZhP275N8=
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
Subject: [PATCH 6.1 0614/1067] PCI: endpoint: pci-epf-vntb: Add check to detect db_count value of 0
Date: Tue, 21 Jul 2026 17:20:15 +0200
Message-ID: <20260721152438.335190388@linuxfoundation.org>
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
index 1e11ce88369701..88ff3065990914 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -487,7 +487,6 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb)
 {
 	const struct pci_epc_features *epc_features;
 	struct device *dev;
-	u32 db_count;
 	int ret;
 
 	dev = &ntb->epf->dev;
@@ -499,14 +498,12 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb)
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



