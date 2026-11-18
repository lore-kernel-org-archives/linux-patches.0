Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030523;
	b=JuGs6DTWkFdmhQrcurOrW5bU+0SUn2o5iC7jrgm9ASmUghwARtv58Oa4UnAJ9Aocw9pA
	 lYQs5kRz+zFvSzgDoT4e06/mbR7DtIWNOK8iFtS23nmXAqS7EZfM+qfY3QEkc0nD8N5h+
	 2KoH/fsV/U0o23v4+bN9kT+Dr6LDTPHtnCawcwefa507z9UGOrGQ58sgtC/fKxT5jBjAI
	 Ib5cJGZCauw4KJSEPkKxHK2dek2Vl5XpSDd/UgjQKNMMoKBgUjFWH0ykLTHYkaI9mjcAV
	 xFfAVBP0ETVulnctUblkO7ie/S2YO2tvn/FDk/AoioQK62U4G9Wb+xaFGt3JIQWPVww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h3D21FziMvZTX1cYlQq/mr4Ujyz6MUuctBzZSUbNat4=;
	b=MblMv0TQNk+5y0psgBQQvBNQ8IVUIhLo4ZtiB0Btrflzrke28AbZcjHEkPk3geoOeRmY
	 affgxF0pGFhnsnAK8OTxuB7u4CX6xYcdwbApkqujAlCW+oAwuy+zz6XywRb7FRW3JRD+u
	 0GPfD2gk6puApsjVing8eU8ST1vTXv2KbMSsjul9dJlpju+BTDzEhbhIC++IZu9QA0KcK
	 rfvI1Se/X3192G30So2sK9QbO9ctsRlHnHoEpvi8OubNQYX2EqZKAvDq1+eTmw5Krdb+H
	 y+JYQPOyPM6T0KgNYtYYaYM9Ol32+CjHq2EO4VCykrBY/9/kP/ucZt7PIbN4pKZIa3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PyCL5Hng;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45A2606B10C;
	Wed, 18 Nov 2026 19:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PyCL5Hng
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8281F000C6;
	Wed, 18 Nov 2026 19:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030523;
	bh=h3D21FziMvZTX1cYlQq/mr4Ujyz6MUuctBzZSUbNat4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PyCL5HngjlWqo8ZuNglvm6sh6yomd9r37Isjf/dwiRCGD3vTsC/XB72VlBpObR22j
	 umv76so3wJQiqvLDuAQdMsAvUz0X718mwtRzTHtXRdDPuHk82Ko9heVxG+MjiBi7at
	 i6XuezbzhCYvhzUc4NnT1MfKfkLzWRxL3KySN9mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0694/1756] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
Date: Wed, 18 Nov 2026 15:47:01 +0100
Message-ID: <20261118150036.831953680@linuxfoundation.org>
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
index fea3b17611c50..96f76dfe18619 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1859,6 +1859,10 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
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



