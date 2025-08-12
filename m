Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D62B61FFE;
	Tue, 12 Aug 2025 18:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022558; cv=none; b=B7NX9dKD67bv1oQpGH+aN9YHceIDChebkkNKBxdDT42No6dPGjvWx92jeGPb2argAVkWiICjVE0hFj41TZPEt9a8R8xmgRPGlFK2yBK180rGekqBrS5f/iDajr9bW8Jk26w5uZQHKOkfd5K1Q9bLaoZDHJCROaztOsI6CW7Pttg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022558; c=relaxed/simple;
	bh=iYqNi5jNYihHh/RWySoqUJzGdtnuWTpt8DEXfkCAobk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlHjYjAWgiFey+3XFdPhJQ8ecYC8rTbLkLvSVC2RrvRwvKhZtfGz7+5krH84DtX9DG12nqXabcc6r3fjGtwzi0b5TbPS2q3G9N+0QGnYvloR8oMUQAWGowZhS/KmWeUDSJMHyVQQULdT88QFA6OBXcVsuPPYvwaeQi7ymnv6t4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKGYMZHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKGYMZHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A126AC4CEF0;
	Tue, 12 Aug 2025 18:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022558;
	bh=iYqNi5jNYihHh/RWySoqUJzGdtnuWTpt8DEXfkCAobk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKGYMZHQLklJ1xpIWlYKMjlOVKwdYZjXPdP0yerg63EHcMKkVXUqAQBKZHfXKis1r
	 V7p9intCL9N2kPYlLWgBWX9LDF9uu1u7qGzlZDb2di/WD4bca2kT5SS0QbUgdxBM1A
	 Z31M7DZ5/en7m8LlmWPGBZ6tpP6kYUaqgIjLG+Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/369] RDMA/hns: Drop GFP_NOWARN
Date: Tue, 12 Aug 2025 19:28:08 +0200
Message-ID: <20250812173021.950884922@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



