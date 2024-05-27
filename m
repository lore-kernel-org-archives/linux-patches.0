Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98C71EEF7;
	Mon, 27 May 2024 19:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838534; cv=none; b=TIIRhsB8y1kvzhZWGIuHiDN2Nu+fSUr+f+lin1s8KSAHg59vdaJXEiFrdObxkqJ1nqgw2zr/MA1EyR1ZLt20J9FCgzPYGmJP5XOht7ZkN2/cZdF1SfcI6WmGSKa/CGmV5XP8y+p2XaUOsBTy1tCzYF+tQwBd3en+3BqiKi49Nhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838534; c=relaxed/simple;
	bh=7Szf/rRIkJgDdW8jJ1Ue0Snx+U9n2ktvx/a4uH2rd68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjQ92Le5F5LByqSYikMhORvn2jgO1jPRy599nhvwFIdhf3/yAQczp7xRkPX74SsOpmBThpAeM7r7Ah6x+lOKgRo70nafenVJWjr4ipDxtJtSvejO6xgO0FdYS6Bfy0ycANj8n8yVzO9ecjpYGTq+tYZZ/QhGJSs+7B6ZOeoMzdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5x4SjuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5x4SjuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339ABC2BBFC;
	Mon, 27 May 2024 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838534;
	bh=7Szf/rRIkJgDdW8jJ1Ue0Snx+U9n2ktvx/a4uH2rd68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5x4SjuSHBZuN+f6rIqdj2/LqhY8clRvsTm+zw+TCDk7tCte4FU7SFlOrJu57FLme
	 lXTSI+0BOf+d17xby9LyClUUwJpTznnal6+LRjZRqR4boWDynq1TiWfarmg6NDbXZh
	 Jsyo0iQs0U0G2cHXEs3UjVlJ3xC7d1Xj7AnBqT9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 429/493] RDMA/hns: Fix GMV table pagesize
Date: Mon, 27 May 2024 20:57:11 +0200
Message-ID: <20240527185644.318088580@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit ee045493283403969591087bd405fa280103282a ]

GMV's BA table only supports 4K pages. Currently, PAGESIZE is used to
calculate gmv_bt_num, which will cause an abnormal number of gmv_bt_num
in a 64K OS.

Fixes: d6d91e46210f ("RDMA/hns: Add support for configuring GMV table")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-8-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 34e58e09b15d8..9c9a707d26d67 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2105,7 +2105,7 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
 					 caps->gmv_bt_num *
 					 (HNS_HW_PAGE_SIZE / caps->gmv_entry_sz));
 
-		caps->gmv_entry_num = caps->gmv_bt_num * (PAGE_SIZE /
+		caps->gmv_entry_num = caps->gmv_bt_num * (HNS_HW_PAGE_SIZE /
 							  caps->gmv_entry_sz);
 	} else {
 		u32 func_num = max_t(u32, 1, hr_dev->func_num);
-- 
2.43.0



