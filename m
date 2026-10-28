Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214431;
	b=JzFia//MEHpCImoDPCg+MdvgLHQ1k6MbDiUKE/PdGUNh75QtTH8rQsUZHShzDxRrEYw0
	 UgHVNgQEwbHlnNumg6PDlx/TH+0dUIYOG8O9c0vLrK0s67lehEgJAb76TGlAu6fruTJTW
	 UYCy6VYqeUnbqWGurHiOhuY9ow+FgiHihirHDF69QZiwQxyrBLZuKgDkdakkaD7F17pxf
	 Li8fTSZeqRjeiXSlHY1gh4dVEPFEkTTkLnKVtUodtqdDUlffMetfkxBXQCKmRPWWI1dvY
	 IdAO9JsoUx6Ip73X6ttBE52Lm1uBe7KNo1OaYxCNBt2PnUUdyvOb4LKo525Nr2+qULw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/KCh5w2e1cY1b08f+D621gCQNumLMz+MA518rOgYs0A=;
	b=gE2fQ1PXLqTxaAfvohd9j09azUj2F9kM6/6ofMe9S/cVQ4wvjZwT8ZTyhC1QFqKClLQ7
	 M7FHihka+Acg4C829PHPnKbLP7JsMX3p267EmLY3Z1jeRwiYE+fxNGD3gE/BL28SwFnUC
	 h3eZxh8II0bNEE2D3LQQ0qo8UVJ+BznAmFH4ZAzdudh0RG6wB6v5gBAhoBLOrUBlTJfLB
	 8P3Fmnhix19G+Yw/lAEPnrLtL9xkdwGlgZ4U7TP8LFAAOgNugdP9NpTDdcnUrBLWAFGu9
	 FLvOPtbTxkJTuYW/RFeBCGlLV3JQPL/bTaLK/zGrS2iyNHBiHpQgTyVy2Xj9W/QL7Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jomR7rmG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3818606BF98;
	Wed, 28 Oct 2026 19:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jomR7rmG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218511F01828;
	Wed, 28 Oct 2026 19:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214430;
	bh=/KCh5w2e1cY1b08f+D621gCQNumLMz+MA518rOgYs0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jomR7rmGJtcwz6whV6gyj7G0QV32bWGxP9ZlK2X21kabphgMxxNezqklYn2DU31UF
	 gS8CJQcqGEDUdbLnqAfTQ9QjMa5vCNM/5oU3Di90ZpY1R3f8r5S/SeyHCZERDq4Y2I
	 vy0Bmlf2ZnmmP1b1nII93mhYFu1I3xNF9tdATP3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wenglianfa <wenglianfa@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0813/1887] RDMA/hns: Fix double destruction of rsv_qp
Date: Wed, 28 Oct 2026 17:48:29 +0100
Message-ID: <20261028170517.927849772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wenglianfa <wenglianfa@huawei.com>

[ Upstream commit c6957b95ecc5b63c5a4bb4ecc28af326cf8f6dc8 ]

rsv_qp may be double destroyed in error flow, first in free_mr_init(),
and then in hns_roce_exit(). Fix it by moving the free_mr_init() call
into hns_roce_v2_init().

list_del corruption, ffff589732eb9b50->next is LIST_POISON1 (dead000000000100)
WARNING: CPU: 8 PID: 1047115 at lib/list_debug.c:53 __list_del_entry_valid+0x148/0x240
...
Call trace:
 __list_del_entry_valid+0x148/0x240
 hns_roce_qp_remove+0x4c/0x3f0 [hns_roce_hw_v2]
 hns_roce_v2_destroy_qp_common+0x1dc/0x5f4 [hns_roce_hw_v2]
 hns_roce_v2_destroy_qp+0x22c/0x46c [hns_roce_hw_v2]
 free_mr_exit+0x6c/0x120 [hns_roce_hw_v2]
 hns_roce_v2_exit+0x170/0x200 [hns_roce_hw_v2]
 hns_roce_exit+0x118/0x350 [hns_roce_hw_v2]
 __hns_roce_hw_v2_init_instance+0x1c8/0x304 [hns_roce_hw_v2]
 hns_roce_hw_v2_reset_notify_init+0x170/0x21c [hns_roce_hw_v2]
 hns_roce_hw_v2_reset_notify+0x6c/0x190 [hns_roce_hw_v2]
 hclge_notify_roce_client+0x6c/0x160 [hclge]
 hclge_reset_rebuild+0x150/0x5c0 [hclge]
 hclge_reset+0x10c/0x140 [hclge]
 hclge_reset_subtask+0x80/0x104 [hclge]
 hclge_reset_service_task+0x168/0x3ac [hclge]
 hclge_service_task+0x50/0x100 [hclge]
 process_one_work+0x250/0x9a0
 worker_thread+0x324/0x990
 kthread+0x190/0x210
 ret_from_fork+0x10/0x18

Fixes: fd8489294dd2 ("RDMA/hns: Fix Use-After-Free of rsv_qp on HIP08")
Signed-off-by: wenglianfa <wenglianfa@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250703113905.3597124-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 25 +++++++++++-----------
 drivers/infiniband/hw/hns/hns_roce_main.c  |  5 +++--
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 1c180a6b1c078..122be4aae304d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3013,14 +3013,22 @@ static int hns_roce_v2_init(struct hns_roce_dev *hr_dev)
 {
 	int ret;
 
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08) {
+		ret = free_mr_init(hr_dev);
+		if (ret) {
+			dev_err(hr_dev->dev, "failed to init free mr!\n");
+			return ret;
+		}
+	}
+
 	/* The hns ROCEE requires the extdb info to be cleared before using */
 	ret = hns_roce_clear_extdb_list_info(hr_dev);
 	if (ret)
-		return ret;
+		goto err_clear_extdb_failed;
 
 	ret = get_hem_table(hr_dev);
 	if (ret)
-		return ret;
+		goto err_clear_extdb_failed;
 
 	if (hr_dev->is_vf)
 		return 0;
@@ -3035,6 +3043,9 @@ static int hns_roce_v2_init(struct hns_roce_dev *hr_dev)
 
 err_llm_init_failed:
 	put_hem_table(hr_dev);
+err_clear_extdb_failed:
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08)
+		free_mr_exit(hr_dev);
 
 	return ret;
 }
@@ -6939,21 +6950,11 @@ static int __hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 		goto error_failed_roce_init;
 	}
 
-	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08) {
-		ret = free_mr_init(hr_dev);
-		if (ret) {
-			dev_err(hr_dev->dev, "failed to init free mr!\n");
-			goto error_failed_free_mr_init;
-		}
-	}
 
 	handle->priv = hr_dev;
 
 	return 0;
 
-error_failed_free_mr_init:
-	hns_roce_exit(hr_dev);
-
 error_failed_roce_init:
 	kfree(hr_dev->priv);
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 5702176a733ab..e6eca4105c1a9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -835,6 +835,9 @@ static int hns_roce_setup_hca(struct hns_roce_dev *hr_dev)
 
 	spin_lock_init(&hr_dev->sm_lock);
 
+	INIT_LIST_HEAD(&hr_dev->qp_list);
+	spin_lock_init(&hr_dev->qp_list_lock);
+
 	if (hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_CQ_RECORD_DB ||
 	    hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_QP_RECORD_DB) {
 		INIT_LIST_HEAD(&hr_dev->pgdir_list);
@@ -979,8 +982,6 @@ int hns_roce_init(struct hns_roce_dev *hr_dev)
 		}
 	}
 
-	INIT_LIST_HEAD(&hr_dev->qp_list);
-	spin_lock_init(&hr_dev->qp_list_lock);
 	INIT_LIST_HEAD(&hr_dev->dip_list);
 	spin_lock_init(&hr_dev->dip_list_lock);
 
-- 
2.53.0



