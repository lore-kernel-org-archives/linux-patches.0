Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064429;
	b=E2r20ODMx+2dO07Kf+jKex86TrMd2X0dMGnOfkXyTuKhOLfbeLybqWCAfxANkK8XnGf/
	 O1oth0fgTrV0wjpquFXyZS24VYzsGuiRmC0EUtoJGoVKVVPDEwqNT8mfiyqxWhKnvMoqd
	 vtrZNH/yYuU7IEOyh/hbDrSEB2k0JLx8kiflOfbHRNeOlcZ7AiKl4pi9D+R/GH1k6nYdo
	 vS1kxdONTYIb6GGTQf1ATPSPp+eI9vNFdvrBgCy3I+J+NM8z4OoyOpKIvj4paPUasf5yJ
	 06uyh+Iuh2FCYv4nSaWrathZofzbj8Dfwm6w1TQjz6axBwulLkLkCtZIZ5u0RoIELcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9eYZWx9JuHCvuH3H4+29rheaXrMlvIFU+1OG2qUw3rY=;
	b=4XCpY6dQzoKFcpt7dIJg3AnaIxS5/eksOwYFgSwM3maTAi3gmLLxnnZM/z6ijjzRYyrE
	 EEULVJCB5EbkouUrGyr03QqmVm+oO9ZBXb5DUR/u2wa0StXYrKRF8u5ZX5qC7/IkBLta4
	 yJRuL9lEMPvda+ur9Uzg3RF9c4EztIJ9VmTARxqlsyfoCWYmLsD9enuZSXFR5aiCxRrWk
	 5Q+UeA/hO/IpABE1QMYsYY7buM2k59YT0bTm77+zUSkiQCEzC7j5f6irCrnvn69ff7pM2
	 qdu2tmNc/A3+5WD8kEORlopBeefRvO7sYRl4WFoXvtGybEugS0+0n9FZXpPzZ9d7htA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtKujigq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE3F606A9C8;
	Sat,  7 Nov 2026 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BtKujigq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE11E1F0089F;
	Sat,  7 Nov 2026 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064429;
	bh=9eYZWx9JuHCvuH3H4+29rheaXrMlvIFU+1OG2qUw3rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BtKujigq1QglBbRSd141uKVsyrQpMSUDQ4BaP5qijt4lrB0Tkt54SIe4YsnBH0RV3
	 z+yiKExCc+Qx5rQe1DAiSvk76CD70PsZdMcPtWMtHOltXAjhbaxXpV/+H6lhW0Yg48
	 YvBAjkG+5exV5vS6bCXE7f0l9GrgmFH4U+G/lnOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0478/1257] svcrdma: Grant credits from the clamped sc_max_requests
Date: Sat,  7 Nov 2026 08:46:14 -0500
Message-ID: <20261107134952.651993427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit b7037e5da3fb81abcd6309daecb112f1d5926760 ]

svc_rdma_accept() computes sc_fc_credits from sc_max_requests before
the Receive Queue depth is checked against the device's max_qp_wr.
When that check lowers sc_max_requests, the credit grant keeps the
original value, so the server advertises more credits than it has
Receives posted. A client that uses the full grant overruns the
Receive Queue, and the connection is lost with an RNR error.

Set sc_fc_credits after the clamp so the grant matches the number
of Receives the server posts.

Fixes: fc2e69db82c1 ("svcrdma: Clean up comment in svc_rdma_accept()")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260828135036.796842-2-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 927269598ac24..f949601b21447 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -471,7 +471,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_requests = svcrdma_max_requests;
 	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
 	newxprt->sc_recv_batch = RPCRDMA_MAX_RECV_BATCH;
-	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 
 	/* Qualify the transport's resource defaults with the
 	 * capabilities of this particular device.
@@ -492,6 +491,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_bc_requests = 2;
 	}
 
+	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
+
 	/* Estimate the needed number of rdma_rw contexts. The maximum
 	 * Read and Write chunks have one segment each. Each request
 	 * can involve one Read chunk and either a Write chunk or Reply
-- 
2.53.0



