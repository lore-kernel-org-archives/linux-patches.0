Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05972269B07;
	Wed, 23 Apr 2025 15:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421953; cv=none; b=hEw6UHH5RycV9lby5r1UR+WMkAEqlCS4GGBfBwdPtAREF69kAj52F2dZsM3l8VHLvHnqEegG+T6qhWCMb4I85CGafAW05xqc5GpiOstSXsdvNk1hp20KEk1DERzx/WmAN6I9kQndEoGUerS5O6eNcLbjXa3uG8VfheaimP1FQ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421953; c=relaxed/simple;
	bh=iF+Mw9HipAPdDJ8NHh3n/qPgNzBChFh5900zu4sUUO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/F4KtccSQVQ5wm0ah1CFj4K+lCcPZhZkBm2kq9rdzIX78G7fL4+AVAR5dQIM01+Lw3+UggrYwueJ+qc9/BizntjXe5lLN3ENFt7qXlPfFhkaWMg0cDu27Gh4W7fq5Kjmdulo1uhcvOjSkjQSkTDIgA9FnQCSS4XYPCduXNLsSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHm88eVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHm88eVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32823C4CEE3;
	Wed, 23 Apr 2025 15:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421952;
	bh=iF+Mw9HipAPdDJ8NHh3n/qPgNzBChFh5900zu4sUUO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHm88eVbEnGAuC4XciLGUhmGtG3eqtJcOtUw80qZ4QCQgCk4jm/NXGHPNTQ3MainK
	 2pr9XYmh4fB8w7qWXaQwbEyRS+EbN4yyDkgeS0lbW3Jpc/hcmds0ZTodk1j3PCAxdD
	 HO0MNO3jtWdNfpYHDnea6mWBPxJWRAGIsz3Zoeck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/393] RDMA/usnic: Fix passing zero to PTR_ERR in usnic_ib_pci_probe()
Date: Wed, 23 Apr 2025 16:42:27 +0200
Message-ID: <20250423142653.742023089@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit 95ba3850fed03e01b422ab5d7943aeba130c9723 ]

drivers/infiniband/hw/usnic/usnic_ib_main.c:590
 usnic_ib_pci_probe() warn: passing zero to 'PTR_ERR'

Make usnic_ib_device_add() return NULL on fail path, also remove
useless NULL check for usnic_ib_discover_pf()

Fixes: e3cf00d0a87f ("IB/usnic: Add Cisco VIC low-level hardware driver")
Link: https://patch.msgid.link/r/20250324123132.2392077-1-yuehaibing@huawei.com
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 13b654ddd3cc8..bcf7d8607d56e 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -380,7 +380,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	if (!us_ibdev) {
 		usnic_err("Device %s context alloc failed\n",
 				netdev_name(pci_get_drvdata(dev)));
-		return ERR_PTR(-EFAULT);
+		return NULL;
 	}
 
 	us_ibdev->ufdev = usnic_fwd_dev_alloc(dev);
@@ -500,8 +500,8 @@ static struct usnic_ib_dev *usnic_ib_discover_pf(struct usnic_vnic *vnic)
 	}
 
 	us_ibdev = usnic_ib_device_add(parent_pci);
-	if (IS_ERR_OR_NULL(us_ibdev)) {
-		us_ibdev = us_ibdev ? us_ibdev : ERR_PTR(-EFAULT);
+	if (!us_ibdev) {
+		us_ibdev = ERR_PTR(-EFAULT);
 		goto out;
 	}
 
@@ -569,10 +569,10 @@ static int usnic_ib_pci_probe(struct pci_dev *pdev,
 	}
 
 	pf = usnic_ib_discover_pf(vf->vnic);
-	if (IS_ERR_OR_NULL(pf)) {
-		usnic_err("Failed to discover pf of vnic %s with err%ld\n",
-				pci_name(pdev), PTR_ERR(pf));
-		err = pf ? PTR_ERR(pf) : -EFAULT;
+	if (IS_ERR(pf)) {
+		err = PTR_ERR(pf);
+		usnic_err("Failed to discover pf of vnic %s with err%d\n",
+				pci_name(pdev), err);
 		goto out_clean_vnic;
 	}
 
-- 
2.39.5



