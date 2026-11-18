Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048825;
	b=eyMH1pz4lJelT/3L3MVkhWmQybzaFhNP+Ky83Ab4Sd35ZzEI+nvfMkBpv0intu7b+cSO
	 4LRG4Ofs06ZNxFqjrc+yXnDBQb5v6Yiy2CXeheqSenzWiJjWkDkGpN8nMVdQGY8114KQ2
	 oj72jowPTIfajX6rgRasRfZOB1wAEhvPkyItqP4Y/jqzjcskGF3y1hWjfqJ+8NOWYcipF
	 SPnD/fxeF3RH9RfX/GQiZNZCy1DTYb4q9+8qAhzEVHfDETvsL3hbudXb8hqYE/bhLy0/q
	 x2n31M3n/60iW1YDlJ3sxRPD6pfjbzrj9rvOv+8sMFJbS/9if4JPhc78id/bSAhWyXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=umc23dYxeZLHC3xyBNYW2z/v+MScXFnNILA5/66RkX8=;
	b=2P1ayxmgc4eePkemjGYLmZDoaerrpiJXkT7wtadm/B9bihU67smvWa3OrNqbLNrT5HrV
	 nU/IhF4M6yrOMaltqIyLzmf8gObvBD2hjSQG+yy7NgUFLi7ssRrd+P2GHe/WNaDPjXPYy
	 Pj2vYSKPPmnG4BA+MKq4fr/sF9/gjs5mMU7KAxt6BS6dn0DHT1jDRXl+N6s848MXvOoGh
	 ApM4Srn0oGijiIFt4SJN8SmF33DL5hhdrzITrH0lT+63/fsuyZ7OldA21XdBwrTD6lsp4
	 ebLh4Fu4wtMyLbPn1m75Ptn5COlfybWIXD+fbat1kIBIAc4UO13Bz7Aba/asgUTIEoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2R9ui4m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 157E0606A31C;
	Thu, 19 Nov 2026 00:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2R9ui4m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644501F000C4;
	Thu, 19 Nov 2026 00:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048824;
	bh=umc23dYxeZLHC3xyBNYW2z/v+MScXFnNILA5/66RkX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2R9ui4mHxSWtWxAAKwHDZaQxHGQYNJ4dOzMKV3nleyg9GNTA3h74bHaSpM7NIA/V
	 qPzWySJMhgkgGv2L0RienOCifN2TyfbbcUoY9TLItNPHUGnXewbr39W9i0/yBolV/O
	 CKknaY8LDcANBWXlIE9A7XHSRGWSpkcsRZSd3R7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2134/2857] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
Date: Wed, 18 Nov 2026 15:52:48 +0100
Message-ID: <20261118150318.239477192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 6dadf9f20e8e9..1e8317690488e 100644
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



