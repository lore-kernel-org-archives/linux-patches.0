Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC0320E023;
	Tue, 12 Aug 2025 19:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026215; cv=none; b=BpqDzcNHhGeex9nFBI47RG3dh2PzEFa1gxQe2A8w37SbOORJEFvTmZETjbI7g5dIlbq9h933N3ZLKybG/+JCLmtvDojFahbN4MOdl/Hmwhjl2xTF84ws4i3+Mz8mxAZmxCiwpl0G3VYKshUfGdDHBTcWr9RCJDdhXgGN95OhyFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026215; c=relaxed/simple;
	bh=aaUta1AGroXNQ2sijrDW8DLobJR680CswAmQgZsOqBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kebi+TV++1J9FjoyUhVnaKg6uO1lvSEuWIg/AIkgYBXCAx8tg5WS51zhqahaSc3WQN/eU4rFCFtyasxKHdszmf+FAS0e2bmIhpNUaDX2yoVNs5ovr+4nx/AeHJCO3X9vEkIh5aQ+CyM1Eonc7j2epIFdCJaYcYmMvzxbX4Spliw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0AjUQkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0AjUQkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52886C4CEF0;
	Tue, 12 Aug 2025 19:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026215;
	bh=aaUta1AGroXNQ2sijrDW8DLobJR680CswAmQgZsOqBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0AjUQkMuns0o3tuYFxxXUdGBgLgSHTkIJft4I3allWSJq76v5pMBt8yiab0lI/Jd
	 4BKDgR5hHY22Mz8JG8yy3Wamn74Z5VlGhjhtdy/Qdxc1KrLVI9LgubiIuysiAlBJUh
	 /cNNwG2/T3Qw9iOIOuj47Lzs5rwFWzZ+sOZ929iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 272/480] RDMA/hns: Drop GFP_NOWARN
Date: Tue, 12 Aug 2025 19:48:00 +0200
Message-ID: <20250812174408.662877896@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 5338abb299f0cd764edf78a7e71a0b746af35030 ]

GFP_NOWARN silences all warnings on dma_alloc_coherent() failure,
which might otherwise help with troubleshooting.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250703113905.3597124-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index ca0798224e56..3d479c63b117 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -249,15 +249,12 @@ int hns_roce_calc_hem_mhop(struct hns_roce_dev *hr_dev,
 }
 
 static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
-					       unsigned long hem_alloc_size,
-					       gfp_t gfp_mask)
+					       unsigned long hem_alloc_size)
 {
 	struct hns_roce_hem *hem;
 	int order;
 	void *buf;
 
-	WARN_ON(gfp_mask & __GFP_HIGHMEM);
-
 	order = get_order(hem_alloc_size);
 	if (PAGE_SIZE << order != hem_alloc_size) {
 		dev_err(hr_dev->dev, "invalid hem_alloc_size: %lu!\n",
@@ -265,13 +262,12 @@ static struct hns_roce_hem *hns_roce_alloc_hem(struct hns_roce_dev *hr_dev,
 		return NULL;
 	}
 
-	hem = kmalloc(sizeof(*hem),
-		      gfp_mask & ~(__GFP_HIGHMEM | __GFP_NOWARN));
+	hem = kmalloc(sizeof(*hem), GFP_KERNEL);
 	if (!hem)
 		return NULL;
 
 	buf = dma_alloc_coherent(hr_dev->dev, hem_alloc_size,
-				 &hem->dma, gfp_mask);
+				 &hem->dma, GFP_KERNEL);
 	if (!buf)
 		goto fail;
 
@@ -378,7 +374,6 @@ static int alloc_mhop_hem(struct hns_roce_dev *hr_dev,
 {
 	u32 bt_size = mhop->bt_chunk_size;
 	struct device *dev = hr_dev->dev;
-	gfp_t flag;
 	u64 bt_ba;
 	u32 size;
 	int ret;
@@ -417,8 +412,7 @@ static int alloc_mhop_hem(struct hns_roce_dev *hr_dev,
 	 * alloc bt space chunk for MTT/CQE.
 	 */
 	size = table->type < HEM_TYPE_MTT ? mhop->buf_chunk_size : bt_size;
-	flag = GFP_KERNEL | __GFP_NOWARN;
-	table->hem[index->buf] = hns_roce_alloc_hem(hr_dev, size, flag);
+	table->hem[index->buf] = hns_roce_alloc_hem(hr_dev, size);
 	if (!table->hem[index->buf]) {
 		ret = -ENOMEM;
 		goto err_alloc_hem;
@@ -546,9 +540,7 @@ int hns_roce_table_get(struct hns_roce_dev *hr_dev,
 		goto out;
 	}
 
-	table->hem[i] = hns_roce_alloc_hem(hr_dev,
-				       table->table_chunk_size,
-				       GFP_KERNEL | __GFP_NOWARN);
+	table->hem[i] = hns_roce_alloc_hem(hr_dev, table->table_chunk_size);
 	if (!table->hem[i]) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.39.5



