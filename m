Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856BC2CCA3;
	Tue, 14 May 2024 10:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683496; cv=none; b=emXMW6ySzFqd6jxNkjnjFBO0ezgEwUJQnyvaBGM6MIrCJclR6k7Gm4uBujZi6iiPLRjbtYNbLgkuLu6rB4LiQpk4OdCP9XrQgaR/D09Zq3Pqpkm4z/7Kp4i3GqPFSncM9rlWmZ3/duwHYIDCFt4UrTz78iE1bgCqgGV/FLc09qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683496; c=relaxed/simple;
	bh=NDp1JJ5a9vaDiIR6KE4eQ6xKCAIB0P1f/m3QBOdsMKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QG9XutmHCEpKw8a+Y5k+aBDVcQ6jXZfi2cxQHkRGvL77ipR6eUGwFK+l+FaR5dNdNCXn8xOo46Z0/VjD1uyNbDG1Fbp6hVTJoxpT+r0IcKIFqDEKG4HKHaElJ1w0P+AB0OI/oxfH5Ky6/kOiA3E6LzBW3WQ10b8hNtWFI+nksak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swjUuCbS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swjUuCbS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69C4C2BD10;
	Tue, 14 May 2024 10:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683496;
	bh=NDp1JJ5a9vaDiIR6KE4eQ6xKCAIB0P1f/m3QBOdsMKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swjUuCbSKNw8xOG21THDeN1/7AMpn14OpHOOaiAZKjyV221gj8fzZHPormbz3pCof
	 IKbxlBgYtarsziO/SRKVN4ydVayBtVyMhySIY9064zo32Tpuy2vb8OAwmq/HjmhgBq
	 d3ePppEgmVG/bwNiyfACCN7XZQX8JQErT84Oni9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 228/336] net: hns3: change type of numa_node_mask as nodemask_t
Date: Tue, 14 May 2024 12:17:12 +0200
Message-ID: <20240514101047.223201702@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang Wang <wangpeiyang1@huawei.com>

[ Upstream commit 6639a7b953212ac51aa4baa7d7fb855bf736cf56 ]

It provides nodemask_t to describe the numa node mask in kernel. To
improve transportability, change the type of numa_node_mask as nodemask_t.

Fixes: 38caee9d3ee8 ("net: hns3: Add support of the HNAE3 framework")
Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h               | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 6 ++++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 7 ++++---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h | 2 +-
 5 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index d7e175a9cb49b..2f7195ba4902b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -895,7 +895,7 @@ struct hnae3_handle {
 		struct hnae3_roce_private_info rinfo;
 	};
 
-	u32 numa_node_mask;	/* for multi-chip support */
+	nodemask_t numa_node_mask; /* for multi-chip support */
 
 	enum hnae3_port_base_vlan_state port_base_vlan_state;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 895e07f5c4fc8..6b84c1313f9bd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1756,7 +1756,8 @@ static int hclge_vport_setup(struct hclge_vport *vport, u16 num_tqps)
 
 	nic->pdev = hdev->pdev;
 	nic->ae_algo = &ae_algo;
-	nic->numa_node_mask = hdev->numa_node_mask;
+	bitmap_copy(nic->numa_node_mask.bits, hdev->numa_node_mask.bits,
+		    MAX_NUMNODES);
 	nic->kinfo.io_base = hdev->hw.hw.io_base;
 
 	ret = hclge_knic_setup(vport, num_tqps,
@@ -2448,7 +2449,8 @@ static int hclge_init_roce_base_info(struct hclge_vport *vport)
 
 	roce->pdev = nic->pdev;
 	roce->ae_algo = nic->ae_algo;
-	roce->numa_node_mask = nic->numa_node_mask;
+	bitmap_copy(roce->numa_node_mask.bits, nic->numa_node_mask.bits,
+		    MAX_NUMNODES);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 0f06e94d6c180..d4a146c53c5e9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -885,7 +885,7 @@ struct hclge_dev {
 
 	u16 fdir_pf_filter_count; /* Num of guaranteed filters for this PF */
 	u16 num_alloc_vport;		/* Num vports this driver supports */
-	u32 numa_node_mask;
+	nodemask_t numa_node_mask;
 	u16 rx_buf_len;
 	u16 num_tx_desc;		/* desc num of per tx queue */
 	u16 num_rx_desc;		/* desc num of per rx queue */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 0aa9beefd1c7e..b57111252d071 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -412,7 +412,8 @@ static int hclgevf_set_handle_info(struct hclgevf_dev *hdev)
 
 	nic->ae_algo = &ae_algovf;
 	nic->pdev = hdev->pdev;
-	nic->numa_node_mask = hdev->numa_node_mask;
+	bitmap_copy(nic->numa_node_mask.bits, hdev->numa_node_mask.bits,
+		    MAX_NUMNODES);
 	nic->flags |= HNAE3_SUPPORT_VF;
 	nic->kinfo.io_base = hdev->hw.hw.io_base;
 
@@ -2082,8 +2083,8 @@ static int hclgevf_init_roce_base_info(struct hclgevf_dev *hdev)
 
 	roce->pdev = nic->pdev;
 	roce->ae_algo = nic->ae_algo;
-	roce->numa_node_mask = nic->numa_node_mask;
-
+	bitmap_copy(roce->numa_node_mask.bits, nic->numa_node_mask.bits,
+		    MAX_NUMNODES);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index a73f2bf3a56a6..cccef32284616 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -236,7 +236,7 @@ struct hclgevf_dev {
 	u16 rss_size_max;	/* HW defined max RSS task queue */
 
 	u16 num_alloc_vport;	/* num vports this driver supports */
-	u32 numa_node_mask;
+	nodemask_t numa_node_mask;
 	u16 rx_buf_len;
 	u16 num_tx_desc;	/* desc num of per tx queue */
 	u16 num_rx_desc;	/* desc num of per rx queue */
-- 
2.43.0



