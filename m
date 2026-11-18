Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015941;
	b=4MoZz4x7l8NkK6XXYGbgSf5ckeJ+fwnlqUpOINnROwQNMHnt29ITJz+jzycz8eIZ051m
	 Lae9CKKRnlDhCmJGRbzEG9kW4cLQKQTzAyL7LizxrLbSW5221kAXh6VBsVIuyTTVBDECr
	 JinARAJovHqyAfa7XweGnXrCfjUeE0RJBbvwO2dpwplL0/KjwY1rlNRJJHdt7OxnK12yi
	 KRto57CGw+QHor208DDrmDEb1hM4FUIBrDUvp9uDFgtB/Zg1pl/KSsf/byiJ4kj3VBWFr
	 WBw912/nM5uBv2rdRYohn/zQDA57pXaWzAvE2CRDuWkZjwZxuD1Q0iJJCjHY7hiS32w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sf8WF4JHmCU/6WoIQNNEo3Vh7SYBsuEr5UZQ2om/hWc=;
	b=K0M8u2C4yJ4dcrKikbPB8M6cs6rXKtsi0CBquUWsPABUNpbt+uyq9+RpZ/YewpbrZPLq
	 RqDC0JpAG+iLRXr2psPIv3FeCqc+O2ID77XrflEcLkte6qzTLtJVf01esVtgVUAiMbOVH
	 eUNeSXN1ZgGIVRWnc0k1MRzYbv2EUXZySXUOZzIDwwIsbpoAVD0fio2EysJ1jEaOyzCX/
	 HtGFEIypK0/Rc2uTgbln4oNnHIZFeuEAYV2Jsr7xLd/dkZfCeYqSPSYwNlbkz5jchb4zi
	 PgNjGHnMnVr7EdOjgeOWqq2tKRYR/POfWpxh7KJaggbBfWyX5I15KXpTNOyrw5hMtyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdSYkwvI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2AE606A33A;
	Wed, 18 Nov 2026 15:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdSYkwvI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84901F000C7;
	Wed, 18 Nov 2026 15:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015941;
	bh=sf8WF4JHmCU/6WoIQNNEo3Vh7SYBsuEr5UZQ2om/hWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vdSYkwvIvwEBTBd4S5AXwPmHjOjmW8n9NeL3UfjPLYUFgZcnWWjjFNjAV6bN2K8PN
	 EaX5LYxX5NeEUHfKWA8aq2uQ+/SejAAjEr4KAE089pKxZbW2nUIqMj1oj8GZk1vMTu
	 QSQqqtLdOhYGZezZMvWKsVLg175Jj1TcRNgWRX1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0353/2651] RDMA/hns: Limit gmv_entry_num to avoid memory waste
Date: Wed, 18 Nov 2026 15:26:33 +0100
Message-ID: <20261118150300.548222419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit bb464eeadd301c3a53e9f92a2a472b73c42b74c4 ]

The GMV entry is a HW object corresponding to a GID. Since gid_table_len
is already limited to a maximum of 256, there is no need to allocate
memory for those extra GMV entries as they will never be touched.

Fixes: 7243396aaf12 ("RDMA/hns: Add a max length of gid table")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260907084901.2420703-3-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index fd198faf4ee47..103cc26197692 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2420,8 +2420,7 @@ static void apply_func_caps(struct hns_roce_dev *hr_dev)
 					 caps->gmv_bt_num *
 					 (HNS_HW_PAGE_SIZE / caps->gmv_entry_sz));
 
-		caps->gmv_entry_num = caps->gmv_bt_num * (HNS_HW_PAGE_SIZE /
-							  caps->gmv_entry_sz);
+		caps->gmv_entry_num = caps->gid_table_len[0];
 	} else {
 		u32 func_num = max_t(u32, 1, hr_dev->func_num);
 
-- 
2.53.0



