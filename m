Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDC419B591;
	Thu,  6 Jun 2024 14:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683399; cv=none; b=rqUXvP9Ikqiznizg5zNptnAb2NSA364co4wX3djdzZ4QPyLieDMNPqzfl1FbK8S0oFSc5mB8tJuD0zjjKWyCVYOHTN7ZENMFaPb9C+39zHe09EIa8O5AMIULzqgCF89uoMaaYVA8F/b6YFYnW+TrxW0DJ7JzfHxvwuJwkhFNVJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683399; c=relaxed/simple;
	bh=bQyCn3cHwWpiruJRJr2j20SAQkiYIV7ebpeh0C0yt2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5Z3ogXjYJonF5YirJwyL4TYmIK7KXdKEhAiOprjemOoXxLXkoZNK6gHUOY5wjaEw2aWYd2j9Sb6RoQOTeCn6NonIxn+kPuj5uL1UIPwLsmkGoQo8ljMUrt5GEmVkxyN6qxrVcfJLdeTlNJRiQiJOANQOREbgc5NSQNmyWVmmeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfLbCzFj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfLbCzFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3D3C2BD10;
	Thu,  6 Jun 2024 14:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683399;
	bh=bQyCn3cHwWpiruJRJr2j20SAQkiYIV7ebpeh0C0yt2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfLbCzFjYd1Pib7T3Xl7SQ13i4m3G8zxOK2ltokC7jjyyNoV66oqGwWFT/wmnwMqq
	 yVFOvYyG4PIuwGn2J+kfYtPfW5nk0Uz8PAybbXvraGfcea6K2DQcV2Buqgd+9XBATs
	 r1EjxVm0nMf5NfseLwLlWYYqJF0XO0FihvenK7BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 343/744] RDMA/hns: Use complete parentheses in macros
Date: Thu,  6 Jun 2024 16:00:15 +0200
Message-ID: <20240606131743.476564925@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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



