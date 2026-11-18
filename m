Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024861;
	b=ma1HXSma4fYSQwT7o8FQWlvkJCszwSdDqS3YQiBlX9M/mwLcIq+4+KF8C9+9gHuc8dMg
	 ZTg7VlCzgVg4JRWBZiDNRMA+DHA1z3WjDuzAGM1YV4Cqnj2qJ/eJpjVsRTipS1hPl0HLt
	 rsfN6BZhvepj+85DuyPzQx8u9cEgxIBltW9mVhdiSnlWvxI4d+EQl29QDEwpUDyWOxtTY
	 ckVvu2ddBLi8wf6coztBsSfRj7eT6h+zeZILAnRh96sAOimZc/AnFxHTUxvEu+2qNTjaw
	 tFVq86EwFFGkJJTFRDZ+/lcpfGVm3A/xjatiFNT2NFxC+UZxFHyZATKg0CLmajygMgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t8yDpdmwolEl5WqNSeR+0+c6JyqyyZNFvp+Cz4B4BY0=;
	b=NnGPYuOe8i5vTG8ylRSRCr+2SSwD9bufZ/uisXHaee/vZCusEa6+Sg+Yifq9/EeT/Vnm
	 ErPMuIfTEdxvGBfYG86mjqtAsUpSrA5WObWDmZS5kuxCV/Dmrp61xIWGtDXfCYskA1ghE
	 lWt1IoZ9kt8o+l4L/IaNrUYz6EFG6BKIswbbrsuov+Kls+rJLMPoEwZwOpEvpmSXmi9py
	 9VKZj6kVgORzZ0+Cf47h5Um2oAVleGH1mAug3xVTbZaT0jzm2jJinBcKzaNHzLIScbJVE
	 IBMuamjQqdPRHARzJhYFchZw8dEj64b0Qbgq2IHhKB9xDGI4sC0LEDOeQQFzkS/5Zug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ki6Dr/5p";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8599606A320;
	Wed, 18 Nov 2026 18:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ki6Dr/5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295BF1F000C4;
	Wed, 18 Nov 2026 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024861;
	bh=t8yDpdmwolEl5WqNSeR+0+c6JyqyyZNFvp+Cz4B4BY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ki6Dr/5p9C8loCbwJJ47IEslMz/7FtyrEsGw+YPiMv5sM8ncnvKHrB0jQQqxf66kj
	 rDWs+B4xmJgnnasPdv4BrZq65exgLfics0RDGkYKF4i7OirgKAw7e0yYWlD9wm4L5Q
	 rDCv+qbw4MKGENLfIc+YLfaFwQI6sI4cY0CGSZ3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0876/2151] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
Date: Wed, 18 Nov 2026 15:43:31 +0100
Message-ID: <20261118150154.191455213@linuxfoundation.org>
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



