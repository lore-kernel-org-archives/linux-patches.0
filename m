Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034543;
	b=wioz7meXi2W5wtYpbl4r6pW/o420J/1n5cj7U19tzVS00gq1zGSaU3embu5XhMxZcY8g
	 8Z+2NmT5GoFqS//3+81qpHMDJH7kcX+YfKp0uoDVO2ox/e14/MGTAS9n0/uF+RHL4VVTQ
	 8iAWEAm8Ik3pfkpZbTM1WiRenjDLt7kIJyqdDeaCK0W25Dfa9wfoqAz+dziguspJKlqGc
	 mJq3usIcqax890oWJYoQmSgeeCjIWrp6J7En+Az/LkSfCsW8CXcnpEVMY9S0TVLGI6USY
	 9zgVS8EJGzDLXyRkXrB6cUBXk1yi0b7t19u7CRJ+FHhYI0QFQsKQj95lJVX32f+yQRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UJKXC2uddDRdeQeCuueDQIqsWHfnbBipnjHXx4eaf38=;
	b=4E/Ku7FdYmc2tUXdOHelBOTzdC+1zoNGkY0usLP5CVIOI1khq9sgKqSMJ8pqXtg3U1ln
	 5/2MbC2P2XQFnX+d+XE27Mxyy0wRqR9MDw1cF/RMgASYj2oxfHKY4kOVNBd4Oq27H5M8X
	 fAQuNAm+ufZlowc2ZHPxwIA57ZgW+3+rjoZ7bsPCGjaxG+KsjpS3kMTP9raNVe+cyyO6h
	 u2nROMjkzJbpAsPb626SL2I3oOiIgKCehF/1rcC4LlXHwvsWb6rv0K2r7wVVo6VhdgwG5
	 CC1RLDqTH5cnxU+O4rDMDkR9dTbJ0vatB8+eLGcyTMZmUfDKdb3++w0zbtU4tsUwrUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eZCzGG5d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BC5606A31C;
	Wed, 18 Nov 2026 20:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eZCzGG5d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0AF1F000C4;
	Wed, 18 Nov 2026 20:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034543;
	bh=UJKXC2uddDRdeQeCuueDQIqsWHfnbBipnjHXx4eaf38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eZCzGG5duwOZN8axGBl1tu6TS8EJSIE3buU1DrjUJo7YM9irjjBWRrPZtRLKeboHt
	 HSkvUUlCxL2dnc9MorWynBCmKOfM6rpa3PFOnpStXQLyeFwrsMmfLeXGs3VPCBVP8n
	 /0R94w9+97JgnnN0+PgJzLnPiXafcLhXBwbvjXJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0407/3318] svcrdma: Clear sc_cm_id when ADDR_CHANGE replacement fails
Date: Wed, 18 Nov 2026 15:17:09 +0100
Message-ID: <20261118150328.674648944@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 01500306e1d50de7ca7a2cdcdfa28ac0523eb747 ]

When svc_rdma_listen_handler() handles RDMA_CM_EVENT_ADDR_CHANGE,
it creates a replacement listener cm_id and returns 1, telling
the CM core to destroy the old one. If the replacement allocation
fails, sc_cm_id still points at the old cm_id that the CM core is
about to destroy. Any subsequent dereference of sc_cm_id --
such as svc_rdma_detach()'s rdma_disconnect() call -- is a
use-after-free.

NULL sc_cm_id on the failure path and guard svc_rdma_detach()'s
rdma_disconnect() call against NULL so that the listener can
be torn down safely when the server shuts down.

Fixes: d1b586e75ec6 ("svcrdma: Handle ADDR_CHANGE CM event properly")
Cc: stable@vger.kernel.org
Acked-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260527-rdma-follow-on-v1-5-1b09bd87b6cd@oracle.com
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[ sashal: added an extra NULL check before rdma_destroy_id() in __svc_rdma_free(), since this tree's teardown lacks the early sc_cm_id NULL bail-out that upstream has. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 85867dba0c016..2ff5451481dae 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -303,6 +303,7 @@ static int svc_rdma_listen_handler(struct rdma_cm_id *cma_id,
 		if (IS_ERR(listen_id)) {
 			pr_err("Listener dead, address change failed for device %s\n",
 				cma_id->device->name);
+			cma_xprt->sc_cm_id = NULL;
 		} else
 			cma_xprt->sc_cm_id = listen_id;
 		return 1;
@@ -582,7 +583,8 @@ static void svc_rdma_detach(struct svc_xprt *xprt)
 	struct svcxprt_rdma *rdma =
 		container_of(xprt, struct svcxprt_rdma, sc_xprt);
 
-	rdma_disconnect(rdma->sc_cm_id);
+	if (rdma->sc_cm_id)
+		rdma_disconnect(rdma->sc_cm_id);
 }
 
 static void __svc_rdma_free(struct work_struct *work)
@@ -614,7 +616,8 @@ static void __svc_rdma_free(struct work_struct *work)
 		ib_dealloc_pd(rdma->sc_pd);
 
 	/* Destroy the CM ID */
-	rdma_destroy_id(rdma->sc_cm_id);
+	if (rdma->sc_cm_id)
+		rdma_destroy_id(rdma->sc_cm_id);
 
 	kfree(rdma);
 }
-- 
2.53.0



