Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01884145B26;
	Thu, 13 Jun 2024 11:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279924; cv=none; b=CS0BbqJm/yzRlmz1UZu/n+Hg6CM6TD0GVn/PZcN48/JX5iE12SYyaktieZCXwDeRpTMgjL/0YvfR9FSMDxdYFcKniDvRqBjj9j78yeWeapyi0WF3fWOecuADlFmqHD1VUzrbnD4KqRJiFkKUOAULCMtdoQl+SVbEQ6+PMN5/Od4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279924; c=relaxed/simple;
	bh=TVS44nGvf79vM/j5YOB1KMFx7T2wa7FIlg8M78m0bRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLjtPzage2U5Jj/x0SQOl/GppqTTVnUMqpl7pC2Tq/WIb91IeDEH+KqIlZ1QgZfL+fjTiWvbSQZTFkvwc0c6c2zGafZD/4C0aGyZSofxW3HofDT0l88TN8QjqI1PsKvjRqfTtiSd0Cnztw/NWTbM+E31vmNChlRDw4qR5UCd5uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7U4oncJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7U4oncJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5F7C2BBFC;
	Thu, 13 Jun 2024 11:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279923;
	bh=TVS44nGvf79vM/j5YOB1KMFx7T2wa7FIlg8M78m0bRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7U4oncJ9fbA+Tmmm4Agzuw8bY26bYifyp5DfvD9u4GBbiP57XDkyfhkuoqYmlKxz
	 jmnGaZg8voP6UgJYFQkIOTI300yy28+Mvfi0y+XVxoaQetgJ34naFiLMmCBzsf5tSU
	 W8XjRJXFHoYMWxBgv/9s0XWCEIbhm9B54k/aSpuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/202] RDMA/hns: Use complete parentheses in macros
Date: Thu, 13 Jun 2024 13:32:59 +0200
Message-ID: <20240613113230.900660390@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 4125269bb9b22e1d8cdf4412c81be8074dbc61ca ]

Use complete parentheses to ensure that macro expansion does
not produce unexpected results.

Fixes: a25d13cbe816 ("RDMA/hns: Add the interfaces to support multi hop addressing for the contexts in hip08")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240412091616.370789-10-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
index 3bb8f78fb7b09..2bca2069135d8 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -62,16 +62,16 @@ enum {
 	 (sizeof(struct scatterlist) + sizeof(void *)))
 
 #define check_whether_bt_num_3(type, hop_num) \
-	(type < HEM_TYPE_MTT && hop_num == 2)
+	((type) < HEM_TYPE_MTT && (hop_num) == 2)
 
 #define check_whether_bt_num_2(type, hop_num) \
-	((type < HEM_TYPE_MTT && hop_num == 1) || \
-	(type >= HEM_TYPE_MTT && hop_num == 2))
+	(((type) < HEM_TYPE_MTT && (hop_num) == 1) || \
+	((type) >= HEM_TYPE_MTT && (hop_num) == 2))
 
 #define check_whether_bt_num_1(type, hop_num) \
-	((type < HEM_TYPE_MTT && hop_num == HNS_ROCE_HOP_NUM_0) || \
-	(type >= HEM_TYPE_MTT && hop_num == 1) || \
-	(type >= HEM_TYPE_MTT && hop_num == HNS_ROCE_HOP_NUM_0))
+	(((type) < HEM_TYPE_MTT && (hop_num) == HNS_ROCE_HOP_NUM_0) || \
+	((type) >= HEM_TYPE_MTT && (hop_num) == 1) || \
+	((type) >= HEM_TYPE_MTT && (hop_num) == HNS_ROCE_HOP_NUM_0))
 
 enum {
 	 HNS_ROCE_HEM_PAGE_SHIFT = 12,
-- 
2.43.0



