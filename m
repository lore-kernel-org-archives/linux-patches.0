Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024640;
	b=0v7DZ4Pqh0rm632dYqxG08ECGnglIxT2Hs0CYNjc/OPmmDy/WoRJo2anrk0/86sXRPi2
	 LjOOMUmfVMFkQuoEVzTqI2EDIqlYnJ0w6Of2/RLtWEFyisJVHwev428fggUzFvipRYrqq
	 wrpOriMK6eOkhkGDUQZBr6NwoeClSzAOOhp+dByvcVREOlBRazthX4gxVvJ1IJsPMaJVT
	 2keKUjwu1baNPZ/1GJKKMKtTBrK3ziKgf9ry82U0x3Wn/k00BcIV5kSHo8Jwz+ymF9Dfe
	 d0N+4yuewdZVEELOzryHkZput3xhWmH3hN0XLAyDGynjoqbWMXIiJahAass3IN+zMhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6WHZtk9AnAX3qAnTlc161sE6jH16z9iL/J0k26egZ0Q=;
	b=FhhPtSh5usDDHwclt1Jb34UTjiHZRCTN86P9bITXqnkq/NUkOmGflP0INHoIN2nMDB4z
	 0gcX5UNHdGjQH0hHkqeidB2E8K2JHd40WOymgukS0ZnqG7kyBbbEW5FkcaqqTCg9ZUlUy
	 nIeOJ8vlgLrm9wT/ME7J5UjlaTA9r4+wyCkvz/SjYWfvRrLPO6uVDxrFDOYnspWoxKJ4X
	 an2LQVWx4952QX1BsJLv9V5oKvRFRS8CRJYUAN12KWPHKxv0WOxIhKUuHKmDGZSHCYK9l
	 /5rUzZQNmyOKz6pThQIa4cqInca+2hpvw0IwoPCILSjWahWzoFAHsy81NtiXHm/25tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2CXKL1D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B0E606A325;
	Wed, 18 Nov 2026 17:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2CXKL1D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B025B1F000C4;
	Wed, 18 Nov 2026 17:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024640;
	bh=6WHZtk9AnAX3qAnTlc161sE6jH16z9iL/J0k26egZ0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2CXKL1DqTscZSRlekOihNfwKA1nYLji6AgjXbeYqkYfAV/kiO0O3bd1nAYrkFp78
	 Gl40IQl3TOUSszpVNrT3NOBHOZVzO6FMGwDpXbtwnPotxm2eIBoKeBRHGycXht2wQK
	 sMFsxMchNghd+oToWq4qW61mnCMZWnxGUZ5aSR1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0797/2151] RDMA/hns: Pin CQ buffer writable to match device DMA write access
Date: Wed, 18 Nov 2026 15:42:12 +0100
Message-ID: <20261118150151.116089440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit ce29f6e741844a78ad1977f2a550ede27ecf95f8 ]

alloc_cq_buf() leaves user_access zero-initialized, but the device
writes CQEs into the CQ buffer. Set IB_ACCESS_LOCAL_WRITE so the buffer
is pinned writable, matching the device's write access.

Fixes: 744b7bdfa79e ("RDMA/hns: Support 0 hop addressing for CQE buffer")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-3-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 150f5052d0b01..59c88b418c511 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -258,6 +258,7 @@ static int alloc_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 	buf_attr.region[0].size = hr_cq->cq_depth * hr_cq->cqe_size;
 	buf_attr.region[0].hopnum = hr_dev->caps.cqe_hop_num;
 	buf_attr.region_count = 1;
+	buf_attr.user_access = IB_ACCESS_LOCAL_WRITE;
 
 	ret = hns_roce_mtr_create(hr_dev, &hr_cq->mtr, &buf_attr,
 				  hr_dev->caps.cqe_ba_pg_sz + PAGE_SHIFT,
-- 
2.53.0



