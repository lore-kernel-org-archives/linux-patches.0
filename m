Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030214;
	b=1CMPUmcrUvzTifcw5JkK0KxHZ8dtwLV8RdIvFEOifbeqeZJ6FWxgLXS+zhp2ey20dwxS
	 G3UECfbbgPenehaeYpq5Z56woZQLOTEGZIH/9kk5Q+umHkRuZ6jYltTgmhmQEnd5OPZzK
	 I/6Xu6zMvn1ZJhdSlLZMq8i4iAGDFiMr6Het68s0bNaAkZwHY2VZEQDilS3vFLI+xmtFO
	 DtgY8smye3JVC+coZnJ6KNdfk0iq4JORrA0rc9epG/jQYI9nx4JRnu5hNmw0wJTTtz8hp
	 fEGeLbKczKrkzMDOQRBZNFobRKD0HOHMnVDaCG2UEko3tb6I0d8Itb1s+KajYGV0IVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O7mFsM0EwSvfe/ru1U7tJqzjCvB2ASySqUDFEU99xqk=;
	b=cyIRKJAFRamyVyG4klw/W56vKQL1j94PSYRtkigwvRneMYryZ/Aldx/1OMvYg+9muu84
	 Y7eBgv4jdtLXx007tWgfyuMx9+kNliMT83Oa/tnodTymmlerjseGkVmNnyHtG8Cg0iQ4i
	 yV0Fh9u35AtgvXw4zaTNMiHGdpsIKCOTHQAbDj7RuIOKW+LdYP0mL+MkvQzu6JZC5wr/k
	 rW+qdTb3VXqOcTh8YXttyvOVBLB2K4Nj2ZSDYYhmUgMkZPt4mlQWb5OiekqvyZA6ThW88
	 NlBE8gllGl6OsaVtRmEJn/yBxhAZaj/7IrUcCDsXo0YssEWx+pIs+TtDv/1QwD2dFwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PAWhX+A9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20935606D377;
	Wed, 18 Nov 2026 19:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PAWhX+A9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CCE1F000C6;
	Wed, 18 Nov 2026 19:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030214;
	bh=O7mFsM0EwSvfe/ru1U7tJqzjCvB2ASySqUDFEU99xqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PAWhX+A9ouMtgZKj1+QUE/t10TcJ0M9u6C2g4ewUQA7WE/1uv1h0byDlIhBjZ9BHv
	 TOOJBqI93G7S7BtvknefYzBkGCE5yQ3o0TjISq5NPPwgu2Lz+wlN3VKaFYFKz/MHoy
	 OQxHSnWY+4ZyYmpqEXNe5knGkuxESS0Ec/CwOXII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0625/1756] RDMA/hns: Pin CQ buffer writable to match device DMA write access
Date: Wed, 18 Nov 2026 15:45:52 +0100
Message-ID: <20261118150033.775329536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



