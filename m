Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040433;
	b=CTQZLhnLYPGZKoId0Z7tZXUoBQszjIs4t96Yn7pnongsX3AY28JSr+L8W1sQR3HjYjVQ
	 0LVmR2WlbdI9amzTFATmMEbIYASgtAOdqiISbb1Y1dVrdm2gfANiFSLP/Egdjo1NiSzhT
	 RO1YMz6VThpikz3RfOuL2imt14sc6v3sDCbgt2Hi85dUTsGCYM7C2Kp/9XSZBWSUPJyt0
	 hEuh3noFj9nzIFtwK9MpP/LGsRO5MhRSz70k7KqrLa/wXNtCrNDvoQR1cf5O4W0hNOWAs
	 wg613nDfXGKcnYKm0UoYC2jxcxFhoHhOKMTT0xhDt9ob56v7danGd14dEV38/DAUErQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k1r+6e7DZlGOx5AeDC0QVbYcjusVG0/aWFz7RNKHcmk=;
	b=Gydlm9D3aCu+KyewVNfFK6RmCNFo6ezJ18mVhrd2zniVGipEM6wvOrhMvIX9AO0ca9Bg
	 xlrD4PTUpq9cjFEgUtGbCu0XI7orLLcl7Y8Tm7Y4Gt8mUtp1ZZforbYrkf9DqXT7GvR6Z
	 ivEPjXxyK1+o1F+FhbbQ1QyJthEJ2ce1wN/D8FviyAF7fBJcle+EmL0ca+Zs2qxeims8s
	 HtbRKIG3h48Qqe76eFLI8HCVdI5RQL3SXALCdYACpyB6T+n6afNKqtrjD735yc9U8Fy66
	 RvmNIKbN1P6xJFpDS20r0U9AUZu9CfiRH2m4k0mmpr6Ykwwe3AyG3tmKN1yagDZ35yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2iryS4x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8194606A31C;
	Wed, 18 Nov 2026 22:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2iryS4x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B121F000C4;
	Wed, 18 Nov 2026 22:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040432;
	bh=k1r+6e7DZlGOx5AeDC0QVbYcjusVG0/aWFz7RNKHcmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2iryS4xArwJ/Jd2aAvBut08/esEe+5IrlbHpE+X4pJGy3NkdZtKmEwcl4Mb/X9+f
	 IajKFVuS+IyYYCHTuRQZ2KGfAPDzJcsUbU2oE8oUhcZoCJ0a7YqM9cWBttTxLILWIj
	 lGWWVs00dC5uE7/xiC1340waLKmT63nkRYJhaM/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2456/3318] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
Date: Wed, 18 Nov 2026 15:51:18 +0100
Message-ID: <20261118150435.114850603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanye Yang <quanyeyang@proton.me>

[ Upstream commit 724cd362162ca7ca5a250bec65efd74f7dad9f5c ]

queue_depth is taken from the server's CM private_data and later
used as a session invariant.  A peer can send 0, which the client
stores and then trips WARN_ON() in create_con_cq_qp() when the
next connection is set up.

Reject a zero queue_depth on ESTABLISHED, same as a bad
magic or version, and fail the handshake with -ECONNRESET.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/linux-rdma/CA+0ovCg_sG8gaZXXj9zmOrpxRt=8+-x9wvycVNUKwWmMbr6-Yg@mail.gmail.com
Signed-off-by: Quanye Yang <quanyeyang@proton.me>
Link: https://patch.msgid.link/20260922-rtrs-fix-warning-rtrs-clt-rdma-cm-handler-v1-1-2076c0ee1455@proton.me
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 776f8675308f4..55ea37d3796f6 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1858,6 +1858,10 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 	}
 	if (con->c.cid == 0) {
 		queue_depth = le16_to_cpu(msg->queue_depth);
+		if (!queue_depth) {
+			rtrs_err(clt, "Invalid queue depth %u\n", queue_depth);
+			return -ECONNRESET;
+		}
 
 		if (clt_path->queue_depth > 0 && queue_depth != clt_path->queue_depth) {
 			rtrs_err(clt, "Error: queue depth changed\n");
-- 
2.53.0



