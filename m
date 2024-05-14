Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9979033985;
	Tue, 14 May 2024 11:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686529; cv=none; b=PO+Vr6iLfVernZk2VHG0RbjcGeLYlObSyiJPV+s4xPHyPV+MZdIrmYCVdkXzbYcXnzdGvdZQLcIB4q1QJ4JnDW4CMxRVULM4p0bPO5Y3YaP0zof1Nk5bL5X/zw59ocEnmHQbe30rj+xubAGMlocv5Uxmpo3DHCEKWBGbsbJoH7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686529; c=relaxed/simple;
	bh=HVemwSqSrNiqVBa33iyCNJdNE/Zp/3rpsopRmNI6gCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk82p3uhOZUM/e63iNB3n79o4rmlimZtj2Gqfng40qZDbpVMPbqYgmRyLHilGX03i4cwm9UiKRPTc/1HzGtvHWJjZBRkTXH9nBveac2CVClQ0/DTiAifdhZyt0uexa6MfIXKr+3IBGmKNiJGhUkYwDrWZtd3/eLZZLmkvD+G9hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcmXKkl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcmXKkl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A4DC2BD10;
	Tue, 14 May 2024 11:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686529;
	bh=HVemwSqSrNiqVBa33iyCNJdNE/Zp/3rpsopRmNI6gCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcmXKkl8kfKzs5fFehBEIgg1Wo5MhQ9f/cqcVcSZUUVbZMqrY4tXOQtAGdcLlAxor
	 CYwjW71ExeAzxAPDzlYIlu/bNhvQ6s4ZjwWTCU0pfeeqK0V9lE2jgazQcuus4nIt94
	 FE4mv1UMSKJZ941ahfwLI+uKcS9k7U2B6KjMAAsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/236] net: hns3: change type of numa_node_mask as nodemask_t
Date: Tue, 14 May 2024 12:18:51 +0200
Message-ID: <20240514101026.775925968@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c693bb701ba3e..60b8d61af07f9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -873,7 +873,7 @@ struct hnae3_handle {
 		struct hnae3_roce_private_info rinfo;
 	};
 
-	u32 numa_node_mask;	/* for multi-chip support */
+	nodemask_t numa_node_mask; /* for multi-chip support */
 
 	enum hnae3_port_base_vlan_state port_base_vlan_state;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a0ac1748f4ea4..19a0b6c37c909 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -1856,7 +1856,8 @@ static int hclge_vport_setup(struct hclge_vport *vport, u16 num_tqps)
 
 	nic->pdev = hdev->pdev;
 	nic->ae_algo = &ae_algo;
-	nic->numa_node_mask = hdev->numa_node_mask;
+	bitmap_copy(nic->numa_node_mask.bits, hdev->numa_node_mask.bits,
+		    MAX_NUMNODES);
 	nic->kinfo.io_base = hdev->hw.hw.io_base;
 
 	ret = hclge_knic_setup(vport, num_tqps,
@@ -2548,7 +2549,8 @@ static int hclge_init_roce_base_info(struct hclge_vport *vport)
 
 	roce->pdev = nic->pdev;
 	roce->ae_algo = nic->ae_algo;
-	roce->numa_node_mask = nic->numa_node_mask;
+	bitmap_copy(roce->numa_node_mask.bits, nic->numa_node_mask.bits,
+		    MAX_NUMNODES);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 5207cb132c33c..fd79bb81b6e07 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -875,7 +875,7 @@ struct hclge_dev {
 
 	u16 fdir_pf_filter_count; /* Num of guaranteed filters for this PF */
 	u16 num_alloc_vport;		/* Num vports this driver supports */
-	u32 numa_node_mask;
+	nodemask_t numa_node_mask;
 	u16 rx_buf_len;
 	u16 num_tx_desc;		/* desc num of per tx queue */
 	u16 num_rx_desc;		/* desc num of per rx queue */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5a978ea101a90..d26539daf2cba 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -464,7 +464,8 @@ static int hclgevf_set_handle_info(struct hclgevf_dev *hdev)
 
 	nic->ae_algo = &ae_algovf;
 	nic->pdev = hdev->pdev;
-	nic->numa_node_mask = hdev->numa_node_mask;
+	bitmap_copy(nic->numa_node_mask.bits, hdev->numa_node_mask.bits,
+		    MAX_NUMNODES);
 	nic->flags |= HNAE3_SUPPORT_VF;
 	nic->kinfo.io_base = hdev->hw.hw.io_base;
 
@@ -2136,8 +2137,8 @@ static int hclgevf_init_roce_base_info(struct hclgevf_dev *hdev)
 
 	roce->pdev = nic->pdev;
 	roce->ae_algo = nic->ae_algo;
-	roce->numa_node_mask = nic->numa_node_mask;
-
+	bitmap_copy(roce->numa_node_mask.bits, nic->numa_node_mask.bits,
+		    MAX_NUMNODES);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
index d65ace07b4569..976414d00e67a 100644
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



