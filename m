Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213965;
	b=U0UcaPno0hUCGjC0t5NvJrSF45MfU+cHmaKG2nFlF28t6kpks/VZ03nB6vm3Y+kS15fO
	 3qc1jE1O3Lw+RHYJzLHFpkOW7BcfijAozPJhIuEdBPrxTJJz6x+TgehScRYzbC5ICtkrj
	 rzA3QWZsTP0xUFqrrt++3konRvxrjBxfHwORyUs+qzsmI/bvlJ9UpjbM4x0TIn3Xvf4lr
	 XoMtJB+qQGx8CKEJiqhBwJTmbyDW8JtHotDG7dKRse6lydnDxPj/bB7Dsn0lv+cOolMHI
	 1m+3wUd12fv3XIvbpIjJAFTp8WLQzBj1lK+/QbfMIxjuao7RrNkkd+zqo/JEbnG8RqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+H2FGkDbyJhSjP+MR1X++jkiJraYni5eks8BGERTL9k=;
	b=1FxSB05hAk/7kQhvVgF8HNX/b21dEXa/TQvVtg1f6IzlvjEsTNPIkIvTFzCbQw5rJ+Ki
	 eo+oBASinWl1HRGZUqQ5yY8a2mvIVobrtyPXakEuNZwZFJtnhqjGo2Q9RtgAJkx+Lswcw
	 SKXdeoyvhZVxfbzvjh9S1tN4L5fJAoHmyyGs+kl5/7ygrIn8P0smu6YDZpo9VtBIOvvcV
	 Reob7gMvBO5wlQ31raYR2PzLaBUoXLa9Fo1vcXISJeJqb1eTttzb0YNAbUEFDrsDxC7Kx
	 o7mWhOFUPUmw7KTNa4qNK+VooKeY03Qu95se8zMeqtuJzzmxGesRzdlKrHI90+yRwLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KaZEoxJu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F901606A323;
	Wed, 28 Oct 2026 18:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KaZEoxJu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA321F01828;
	Wed, 28 Oct 2026 18:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213965;
	bh=+H2FGkDbyJhSjP+MR1X++jkiJraYni5eks8BGERTL9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KaZEoxJuZQPIVKxqCY7UWEGB0eZGuYGdM7kDY4Zgnax12X6nPfGjYkX0VhBSm50ey
	 766pdH1FCqAxRG149iJ+ve161rkbUrhaV5HCtVWM8Ycrz5GHbGyIdDxqS00aDp//TT
	 Mor5UPo63Au90Sat1zK4AZdNgmxcpJxl+FWbV5xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Showrya M N <showrya@chelsio.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0692/1887] RDMA/siw: Add sendpage_ok() check to disable MSG_SPLICE_PAGES
Date: Wed, 28 Oct 2026 17:46:28 +0100
Message-ID: <20261028170515.160435313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Showrya M N <showrya@chelsio.com>

[ Upstream commit 4e1e3dd88a4cedd5ccc1a3fc3d71e03b70a7a791 ]

While running ISER over SIW, the initiator machine encounters a warning
from skb_splice_from_iter() indicating that a slab page is being used in
send_page. To address this, it is better to add a sendpage_ok() check
within the driver itself, and if it returns 0, then MSG_SPLICE_PAGES flag
should be disabled before entering the network stack.

A similar issue has been discussed for NVMe in this thread:
https://lore.kernel.org/all/20240530142417.146696-1-ofir.gal@volumez.com/

  WARNING: CPU: 0 PID: 5342 at net/core/skbuff.c:7140 skb_splice_from_iter+0x173/0x320
  Call Trace:
   tcp_sendmsg_locked+0x368/0xe40
   siw_tx_hdt+0x695/0xa40 [siw]
   siw_qp_sq_process+0x102/0xb00 [siw]
   siw_sq_resume+0x39/0x110 [siw]
   siw_run_sq+0x74/0x160 [siw]
   kthread+0xd2/0x100
   ret_from_fork+0x34/0x40
   ret_from_fork_asm+0x1a/0x30

Link: https://patch.msgid.link/r/20241007125835.89942-1-showrya@chelsio.com
Signed-off-by: Showrya M N <showrya@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index b98a4100aeebf..1f06a7cb76500 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -338,6 +338,8 @@ static int siw_tcp_sendpages(struct socket *s, struct page **page, int offset,
 			msg.msg_flags &= ~MSG_MORE;
 
 		tcp_rate_check_app_limited(sk);
+		if (!sendpage_ok(page[i]))
+			msg.msg_flags &= ~MSG_SPLICE_PAGES;
 		bvec_set_page(&bvec, page[i], bytes, offset);
 		iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes);
 
-- 
2.53.0



