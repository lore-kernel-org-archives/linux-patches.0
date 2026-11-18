Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061024;
	b=d0iH5PxtEE5vMGd/1T02q4E07ExYKw0D/7rwFeZJFdOPyk2UXgKKeFdpaCMW7mY5NFQK
	 fwTaOwfTstjjY2zw2y8YQ4awQwvqz1SqFI6HyivSI9/xLiNZZI4zdASHRb715PF2EU4oa
	 POTfor1GGLvhqC+MOJEhDUy4MaMT7EN8j0u54pjbaKK0+0ljVS31RyEe7MdTKvIQ1V7l5
	 AI8TLNBVaJMnij21h8Z5VsZ53enu/6bb492whT48AA92cqJMhmmWYXa6t9iqreXC8X7gi
	 /fc1kCCruWtpsNKD5OIRb9hFln6XtL8eC8mWIIGR4UWSTzH3G1V+nRt3S90v3pMIX1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IS6+QCaJLCwcWqI9B2HX55UDvyRv7yivkAg2thcQPl8=;
	b=2IaWRf+5VjgTiECSBy5bK8IJ/WDCNij33djqlkTLkHj/X1Rs6Co3xLa9VEsE4rmjYRb1
	 VKUQURG2+wssLUVYn8EZ023ATEb82h79IXqGEX1UxtKKaap0eOXZCR3uIleWujpbD1j/y
	 PaDbbNEO1XH9pzqAb4Dt9k+pl4rb07g/pZXYOTjEppkfItX6ujrilZ2UCQbWFyC2EO92Y
	 cOX0LTJJ50KQwflkds3CeUxxA0C1yW1+xP9R3ZclKqU8QLsrBoOs6gT+X5cv1XLM2+z3N
	 fXMmtiNqTT1sVkCtmlKR2Snjqw/+Qi/X/SMh7n8yW0lHSbdO39vKHDLAw7yaBYRlO1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lkcbIgT5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBC3606A320;
	Thu, 19 Nov 2026 04:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lkcbIgT5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F98B1F000C4;
	Thu, 19 Nov 2026 04:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061023;
	bh=IS6+QCaJLCwcWqI9B2HX55UDvyRv7yivkAg2thcQPl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkcbIgT5p1gonHcIIDxedE3Yp2WJUk3rCtqOKGBAQ9LFFqnZOhNITr2V69xeKXnU3
	 lJhkUUlwP8X8lZfdWOac/1+EkvhFjlqCFRpP4Ynn1TFeyemWEsY84N0469MLwtLQxL
	 yyEQ8d/hVhTHUWl83+kBlxAbqdwYHfZ+U2wMGMfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Quanye Yang <quanyeyang@proton.me>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1405/1848] RDMA/rtrs-clt: Reject invalid queue_depth from the peer
Date: Wed, 18 Nov 2026 15:57:23 +0100
Message-ID: <20261118150018.330268832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index adeb2782d70b0..a4aa4c8bf35fc 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1727,6 +1727,10 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 	}
 	if (con->c.cid == 0) {
 		queue_depth = le16_to_cpu(msg->queue_depth);
+		if (!queue_depth) {
+			rtrs_err(clt, "Invalid queue depth %u\n", queue_depth);
+			return -ECONNRESET;
+		}
 
 		if (sess->queue_depth > 0 && queue_depth != sess->queue_depth) {
 			rtrs_err(clt, "Error: queue depth changed\n");
-- 
2.53.0



