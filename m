Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74D453A7;
	Fri,  6 Dec 2024 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497516; cv=none; b=n6ziMF2kLpZIUgFt51QMaVM0bxsN5mt9RHjWojukagP9mCfSD9TB0ktvw3pg69g7T6b7WsXalZsoIoPg9SVZ4oP1FmWrYFmOR9O+6I5JrErE3ywGxg+Vs0HPBuFNjGP5ppSZd+Zjz817fh3TPi1kETa6lSIhQTdrsz3+JAyKf/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497516; c=relaxed/simple;
	bh=xwua/LKVXTeHfzxRBO/qd8BNplJ6RP23WP8sc4uViN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJkyytxBjPT7h4g6oKql50j33Hqf1bqoRltb7uzh85m7OvWZS1WIn0WbRei+jTIc4qX9YVqd59r1FJKZJjjuAoKcyxUV258ovwGuMk0Sby3qY0V0BVMpcPXMDPRCu7zv5QbnnTefKAMUxXl5pVs84DzpVxHujfeBd3biUKWWf7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItpWYYaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItpWYYaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C60C4CED1;
	Fri,  6 Dec 2024 15:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497516;
	bh=xwua/LKVXTeHfzxRBO/qd8BNplJ6RP23WP8sc4uViN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItpWYYaGTJHm2UKDAB1XHH+Za794BJP87KIpEekxG6zx+LgsMIghK8bE3wHGKoGuC
	 yXbmZ+gImrdvceF1HDmGba5SfAJ6BLD3ImSh9bS++PH1kmxJm/TmfqFn9OymobkR5Q
	 LmRqotVCMZVGV8eb12uFeoZOMne1NhF6VXQnJ+Yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 282/676] RDMA/hns: Use dev_* printings in hem code instead of ibdev_*
Date: Fri,  6 Dec 2024 15:31:41 +0100
Message-ID: <20241206143704.356824364@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit d81fb6511abf18591befaa5f4a972ffc838690ec ]

The hem code is executed before ib_dev is registered, so use dev_*
printing instead of ibdev_* to avoid log like this:

(null): set HEM address to HW failed!

Fixes: 2f49de21f3e9 ("RDMA/hns: Optimize mhop get flow for multi-hop addressing")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20241024124000.2931869-5-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 44 ++++++++++++------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 7ebf80504fd12..65c5583e83412 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -337,7 +337,7 @@ static int calc_hem_config(struct hns_roce_dev *hr_dev,
 			   struct hns_roce_hem_mhop *mhop,
 			   struct hns_roce_hem_index *index)
 {
-	struct ib_device *ibdev = &hr_dev->ib_dev;
+	struct device *dev = hr_dev->dev;
 	unsigned long mhop_obj = obj;
 	u32 l0_idx, l1_idx, l2_idx;
 	u32 chunk_ba_num;
@@ -368,14 +368,14 @@ static int calc_hem_config(struct hns_roce_dev *hr_dev,
 		index->buf = l0_idx;
 		break;
 	default:
-		ibdev_err(ibdev, "table %u not support mhop.hop_num = %u!\n",
-			  table->type, mhop->hop_num);
+		dev_err(dev, "table %u not support mhop.hop_num = %u!\n",
+			table->type, mhop->hop_num);
 		return -EINVAL;
 	}
 
 	if (unlikely(index->buf >= table->num_hem)) {
-		ibdev_err(ibdev, "table %u exceed hem limt idx %llu, max %lu!\n",
-			  table->type, index->buf, table->num_hem);
+		dev_err(dev, "table %u exceed hem limt idx %llu, max %lu!\n",
+			table->type, index->buf, table->num_hem);
 		return -EINVAL;
 	}
 
@@ -487,14 +487,14 @@ static int set_mhop_hem(struct hns_roce_dev *hr_dev,
 			struct hns_roce_hem_mhop *mhop,
 			struct hns_roce_hem_index *index)
 {
-	struct ib_device *ibdev = &hr_dev->ib_dev;
+	struct device *dev = hr_dev->dev;
 	u32 step_idx;
 	int ret = 0;
 
 	if (index->inited & HEM_INDEX_L0) {
 		ret = hr_dev->hw->set_hem(hr_dev, table, obj, 0);
 		if (ret) {
-			ibdev_err(ibdev, "set HEM step 0 failed!\n");
+			dev_err(dev, "set HEM step 0 failed!\n");
 			goto out;
 		}
 	}
@@ -502,7 +502,7 @@ static int set_mhop_hem(struct hns_roce_dev *hr_dev,
 	if (index->inited & HEM_INDEX_L1) {
 		ret = hr_dev->hw->set_hem(hr_dev, table, obj, 1);
 		if (ret) {
-			ibdev_err(ibdev, "set HEM step 1 failed!\n");
+			dev_err(dev, "set HEM step 1 failed!\n");
 			goto out;
 		}
 	}
@@ -514,7 +514,7 @@ static int set_mhop_hem(struct hns_roce_dev *hr_dev,
 			step_idx = mhop->hop_num;
 		ret = hr_dev->hw->set_hem(hr_dev, table, obj, step_idx);
 		if (ret)
-			ibdev_err(ibdev, "set HEM step last failed!\n");
+			dev_err(dev, "set HEM step last failed!\n");
 	}
 out:
 	return ret;
@@ -524,14 +524,14 @@ static int hns_roce_table_mhop_get(struct hns_roce_dev *hr_dev,
 				   struct hns_roce_hem_table *table,
 				   unsigned long obj)
 {
-	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_hem_index index = {};
 	struct hns_roce_hem_mhop mhop = {};
+	struct device *dev = hr_dev->dev;
 	int ret;
 
 	ret = calc_hem_config(hr_dev, table, obj, &mhop, &index);
 	if (ret) {
-		ibdev_err(ibdev, "calc hem config failed!\n");
+		dev_err(dev, "calc hem config failed!\n");
 		return ret;
 	}
 
@@ -543,7 +543,7 @@ static int hns_roce_table_mhop_get(struct hns_roce_dev *hr_dev,
 
 	ret = alloc_mhop_hem(hr_dev, table, &mhop, &index);
 	if (ret) {
-		ibdev_err(ibdev, "alloc mhop hem failed!\n");
+		dev_err(dev, "alloc mhop hem failed!\n");
 		goto out;
 	}
 
@@ -551,7 +551,7 @@ static int hns_roce_table_mhop_get(struct hns_roce_dev *hr_dev,
 	if (table->type < HEM_TYPE_MTT) {
 		ret = set_mhop_hem(hr_dev, table, obj, &mhop, &index);
 		if (ret) {
-			ibdev_err(ibdev, "set HEM address to HW failed!\n");
+			dev_err(dev, "set HEM address to HW failed!\n");
 			goto err_alloc;
 		}
 	}
@@ -615,7 +615,7 @@ static void clear_mhop_hem(struct hns_roce_dev *hr_dev,
 			   struct hns_roce_hem_mhop *mhop,
 			   struct hns_roce_hem_index *index)
 {
-	struct ib_device *ibdev = &hr_dev->ib_dev;
+	struct device *dev = hr_dev->dev;
 	u32 hop_num = mhop->hop_num;
 	u32 chunk_ba_num;
 	u32 step_idx;
@@ -645,21 +645,21 @@ static void clear_mhop_hem(struct hns_roce_dev *hr_dev,
 
 		ret = hr_dev->hw->clear_hem(hr_dev, table, obj, step_idx);
 		if (ret)
-			ibdev_warn(ibdev, "failed to clear hop%u HEM, ret = %d.\n",
-				   hop_num, ret);
+			dev_warn(dev, "failed to clear hop%u HEM, ret = %d.\n",
+				 hop_num, ret);
 
 		if (index->inited & HEM_INDEX_L1) {
 			ret = hr_dev->hw->clear_hem(hr_dev, table, obj, 1);
 			if (ret)
-				ibdev_warn(ibdev, "failed to clear HEM step 1, ret = %d.\n",
-					   ret);
+				dev_warn(dev, "failed to clear HEM step 1, ret = %d.\n",
+					 ret);
 		}
 
 		if (index->inited & HEM_INDEX_L0) {
 			ret = hr_dev->hw->clear_hem(hr_dev, table, obj, 0);
 			if (ret)
-				ibdev_warn(ibdev, "failed to clear HEM step 0, ret = %d.\n",
-					   ret);
+				dev_warn(dev, "failed to clear HEM step 0, ret = %d.\n",
+					 ret);
 		}
 	}
 }
@@ -669,14 +669,14 @@ static void hns_roce_table_mhop_put(struct hns_roce_dev *hr_dev,
 				    unsigned long obj,
 				    int check_refcount)
 {
-	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_hem_index index = {};
 	struct hns_roce_hem_mhop mhop = {};
+	struct device *dev = hr_dev->dev;
 	int ret;
 
 	ret = calc_hem_config(hr_dev, table, obj, &mhop, &index);
 	if (ret) {
-		ibdev_err(ibdev, "calc hem config failed!\n");
+		dev_err(dev, "calc hem config failed!\n");
 		return;
 	}
 
-- 
2.43.0



