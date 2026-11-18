Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052552;
	b=l4+Y1kbA5iXxGor4XBVPAPC88xnVgqPsyD+4hiMzHazoN77s3T1P5rMFf6nZRkdsO7WN
	 zIrLPot07WhI8xMfkgoSEmy8LB7XcorV7rQtvIiEyOWyFj0qMJzdD82RugiiqjU56dsti
	 muRQwjM8+0MEIW+ELrxDQ6nP7wWQRVx5fqF2lVpu3rmFJAT72H02gdm7/uafaDk1PME0X
	 EdTgPLEmCEc9KdrX7aFcp8APLdvKXlvML1OjKJ8ZlJg3vezfdGqj7nJsLozyK3y78i/bA
	 YAFoC1kxNi+yL4yuJ6LkgbuXjBsetyeQ2N4hzrhqI9mSIJXsFU03GjrghliJXseDhhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mC9ltnbeInBkrcnglULoJU4Tpja9q6Dm+MUEQrSooe0=;
	b=ud0jiI53MgKa4AU2hCLiDaQ09R+HuEfxoKXHPnNAQ/WcjuhLQVqlpcPRpqvTUXYevYWW
	 FtrLM6x+gIQ7FKWtJK4x8kIEoZk0QLNSl+6wDGmjxZ0+CeUxgHl/kXy3CnXSLYAi295jg
	 q/M1EI+/Sg5VoYrveGLgNfYB4pRkUN86DzxGudITrn9e+K5MnzIiEi0nVEpq+eiqEZThL
	 WJnX5uRoTzLoOIkMHEUJYYx1i2LxWPdX91QLY62ue2TO6/AWCSCvNvFUpDxDo3sHp0bPC
	 zEAiG7oV6dE0KY7RH0rvrUlUfkBswBD7QXDFsqK3cMSa/fw62apPjBCJIijvU2JVVxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sF7VgUHd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E288606A31C;
	Thu, 19 Nov 2026 01:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sF7VgUHd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8033F1F000C4;
	Thu, 19 Nov 2026 01:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052552;
	bh=mC9ltnbeInBkrcnglULoJU4Tpja9q6Dm+MUEQrSooe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sF7VgUHdTto20A9dZ9d43g7GDjXPbBtVRSvp7rHSpCKehpX6Sdg+9o/BSpZZiFi3c
	 m8qZo0xsaJyJ1TSg6D+G9UlZkYTSGtfPcp6HrMCYzQQKmkx4ziEVsdcTpDKKQHkUpX
	 HMzrNNckgWs6V1xNW5urC8MxsYxFF1oNMeJrgwyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0577/2214] svcrdma: Grant credits from the clamped sc_max_requests
Date: Wed, 18 Nov 2026 15:37:33 +0100
Message-ID: <20261118150034.024417546@linuxfoundation.org>
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
index 45b0fef0b5e26..e8c8ccf8ecdd1 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -397,7 +397,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	newxprt->sc_max_requests = svcrdma_max_requests;
 	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
 	newxprt->sc_recv_batch = RPCRDMA_MAX_RECV_BATCH;
-	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 
 	/* Qualify the transport's resource defaults with the
 	 * capabilities of this particular device.
@@ -418,6 +417,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_bc_requests = 2;
 	}
 
+	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
+
 	/* Estimate the needed number of rdma_rw contexts. The maximum
 	 * Read and Write chunks have one segment each. Each request
 	 * can involve one Read chunk and either a Write chunk or Reply
-- 
2.53.0



