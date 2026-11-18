Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017864;
	b=TpN08un7cKQ07BI/L1zI4reRdOLqY1KQ9OGRUY1u4QowFLiZ8fRk7P6WKjWxXBQyr+3/
	 h1yaBatnyOjWJY/QO3cjE6ryIsw5db06m1eTywIMAQxBFF6mmrzjtdoxa4z1BagdsklVd
	 AW0SsgdnpsI0YJ94XEYwQaSZgdVFqGToYposUq91NJQIhosJ3Fl2y1IjJpHfl9D0Fevo1
	 KcMgDVYrn6ipgsa50S6vTVlsXeMBwzZMXCKbDBdAomg6BJWdrG6jMdtOPYlBAjx3SjVGR
	 9uz/Fr4h6gYDWRrX/9reD1TgvW6N5fSVpmG5nOuURTlpIRt9pApmCqH14QlQm0KZKjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4BBbkL84tNjUrudjVSbBjAf8eFBHL838bnPLPTQ15Hs=;
	b=VAZt+xWWTF/873h45tgE38iYYuYdRLLJGWb5EQfpCM8nNjLLECsiUZpVWKyFGhk7gd9N
	 hhgNdwzvOnqOORvRaxfsA6L08BYB0TlX0XsjFUbZnLTiSuOOKJK5qIzzIZdFku+gz4Qud
	 SLSpqBJX5l+4O3zQCRjGgQ/2srfFRunmmHEhSZZaXpgjHLjfss86gO+SAw2+gfCmJkYds
	 RucPe6eHFSQn1uDeAaLI36+SFktmDHMspMw/PWryaHNQuteDgwK0Rw/iUmJaXffpZcUEc
	 Yvt+EsbWA/pR3kBAPshwl9Ug5u0F678yCDTbvKHiMvEJaW+6Yye+Aa1yYvwAtheCb8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYpzg1y3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0E6606A31C;
	Wed, 18 Nov 2026 16:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYpzg1y3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBDF1F000C4;
	Wed, 18 Nov 2026 16:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017864;
	bh=4BBbkL84tNjUrudjVSbBjAf8eFBHL838bnPLPTQ15Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYpzg1y3sOBlMMTIsw6621eCY2GjIQ5FxaB0+GKW+ETF3vta77xdim/PONlx901YZ
	 nOugzeF4E45fhLqZ3pQ55WCRnEu8XSOaTaGtr7MqgnAlnCE++J0yWcxsXDrUrRxnhb
	 Y4tkLdi+sLwtJQlEoC5MhUOvSlusFQpt787EIab8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1035/2651] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
Date: Wed, 18 Nov 2026 15:37:55 +0100
Message-ID: <20261118150325.230171647@linuxfoundation.org>
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
index eac38b57b00d7..7fbbb9a536072 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1853,6 +1853,10 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
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



