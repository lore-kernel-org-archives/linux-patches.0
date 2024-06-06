Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9E719ADAD;
	Thu,  6 Jun 2024 14:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683365; cv=none; b=ABUxIhevvmcWDWKyUWFGXnU+o5j/qZy+4inOE7S15MoldKhWW/WjiMQ2UmwuePayhK/NT782iPiQZmfcS9LOi87bZMtiHiV2wmAkAd2K5BqTISR5F9lvoUBuuAVBW9ArYlRygnQdoqgWv2VK/UM7Hcc1CqckOcNh8EEeKvvP02E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683365; c=relaxed/simple;
	bh=lw62V058PJMT55abaI/euw8B8fHFrlua/Da9SkabtSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2v6IhhJRHzZ5eRoXJx3/0vPO7ZN+BFzT35I9nZcK95sDLP06XKrnTjU/k2YCsujc/s9pK9ML3QkWnF19Cb5GUrdEycMVK4rbj6IUCz7KkW8iHRUm/3cgKTyy0i+YaWQrmxWJkAUdY8zkuA5X9y+C5oZCDNfPTtzj11bHHAaGg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ilh/s8vg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ilh/s8vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B07F6C2BD10;
	Thu,  6 Jun 2024 14:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683365;
	bh=lw62V058PJMT55abaI/euw8B8fHFrlua/Da9SkabtSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ilh/s8vg7FcxNGVS8QTPUyMKt1nufXsVKRVYu9StlSYsFPcKViBUELkOv3BEXtJEM
	 37mjtaLacFcaS2eQ3d38EPfXyqoSe16baYosS34guplg/VLdtrkt8dZSwUTPxERUgX
	 BtXeXiv/6No2R/RRDUKFXIkShxfImBlMD6GpBza8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/473] RDMA/hns: Use complete parentheses in macros
Date: Thu,  6 Jun 2024 16:02:50 +0200
Message-ID: <20240606131707.803584953@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index 7d23d3c51da46..fea6d7d508b60 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -61,16 +61,16 @@ enum {
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
 
 struct hns_roce_hem_chunk {
 	struct list_head	 list;
-- 
2.43.0



