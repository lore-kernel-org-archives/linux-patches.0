Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055557;
	b=UFajHJbLSYlB0PQyNUpzyO5mSTx92CZPbNx8grv4TFSX11KId2LQ5DIYGLSuQCTwTyYP
	 V60uRgAP9zOr9wUVhXc6vmIAwF3yeJAaGxocIJL4BCJ5RFWNtFKfyfrYKRfNFdCvMygqf
	 Q+bwRVgEthhkPvw1mTOcVPIB4lZbLRa7E1Qd3IX6e0W63qtjqpKJ9bLdOGjqwkblNP8mt
	 IPrngdnm1TbLS3jEa27EyuegBLA60OrD2zrGFKvl8jZaISB15OB/LwoKzoe//w8BhhLMb
	 X1vzAUVZaRK0sWT2IwUgIcw1R2qocNLAlYgVitDxlX8PIblaw51pObg+33pTO7GHk8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B7Rd8HOPIS951I6oo0HzihLpfkXpFEwy1lhi2amxeHI=;
	b=D1bCuDfQghbugmR1l2Tz9/F2xEnj09jxkVEKzWMMTp9WTfT/7mV9iMfd1BVinbP6GB3O
	 r0qaVCIKwgRd+IL+uF82UbFFZttGr2Qi9IE4QT4tEvIwKs2TuCXzAQr7AXOg+LsGdQryy
	 8tDWetcjyd8Bp//WFR5VAumcLCYOOgzC9OM0Y6PVUsKkNjBcIAcTFDglRnguIV+kAe5R/
	 RkFv+KO4kVUzLquvbFy/utUzsGvtXIut6VuBgrQGplaR/R1iqRWxVnXTZ9AI+hg//Chnu
	 fVBJo1BTIjc0bTSLVuF7MtDimAuSqBqNC/ttXCBVKF4c9W6RZ2c9llJCfdTtko0hXxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqLYMBxu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333AA606A31C;
	Thu, 19 Nov 2026 02:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YqLYMBxu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0E81F000C4;
	Thu, 19 Nov 2026 02:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055557;
	bh=B7Rd8HOPIS951I6oo0HzihLpfkXpFEwy1lhi2amxeHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YqLYMBxu2Dmd+VJSoQ+O/omM68gUGQHujrVg6CG0GJI8otacYRpGOTzIF12j+FT3T
	 Jjb3oii0P36jhpJTSizWxcRuc8jJzq3J71HxUPKxfXUyCvkUhleTJddbTXsAB+OPUM
	 1Tz80hJGbRpUfEIxtED4faOJCmky0n/QskB9isio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1673/2214] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
Date: Wed, 18 Nov 2026 15:55:49 +0100
Message-ID: <20261118150118.766729152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 90c387110641b..792dd2defaaaa 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1847,6 +1847,10 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
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



