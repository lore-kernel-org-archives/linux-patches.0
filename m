Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053113;
	b=xVaHyUqTfpPi0/rGwy6MWT6fFRNJKKGsWjV4Lgi+Jal7h8rAponXQA4L3n/d4XeqYPp0
	 rBoRJdQ8wjcSKj/t5ryZam0CBl5QLA7XzJIoTNdEiGK1IVt3P9idbd40F1Bygzf9sO2lE
	 o3j7jHeX4gCGA00L4nkhnHpvSAr14YCut/Z1cVZlwbhJA4+4lyyrzNEORAJj+A7tC9x8Y
	 jdcidp1Sq4tAMEJn2n+++v7HMXEE8QhKS0A9o2OEjF+Zar2MRvmd+nPC/RG6aYQNzIEpl
	 dY+krtyGd2aehqXRd1zk3SaLkhA4nxCOa9J0ksD9Hg9VC49Z2YdEbMh/1Gx73B+ZUJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x3sWY+08CnkU9iqZ71M0J7Sg5AQsRXZ6GHZolAK/MEE=;
	b=N+jKx3a0Y4xOJcCY164VsPiBq9x4Hdv8a+9Sl3hv2a/pw+va5Pky+yBCf1mgNLNfO7z5
	 FadlJOH96akmP+gIWCKayW1Puf4sLSHAsb2PbdLGlnqGQxYU8Xdan6epMv6h0cFdooRn6
	 zWtkK5m3YBL0sOSkA30u1qWK36x9jrQsPFeQlCn3+3J4fi9bPyxfDXDAhr2DsGT6RUSvq
	 ottwAfEfNWSVVOVwK0QyjmXyagGhfeRS1TNMPBPk6F/8Kzoh22Fwqp2KVs99/Z7JODyP+
	 iwCoLbhfsNmCiNNk3No8tVoIJc5i0NWKq5fPoenYDwZZ4fx2Zm984U3/FuGrdU+nUxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GLwHlFPZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65FC606A320;
	Thu, 19 Nov 2026 01:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GLwHlFPZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1611F000C4;
	Thu, 19 Nov 2026 01:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053112;
	bh=x3sWY+08CnkU9iqZ71M0J7Sg5AQsRXZ6GHZolAK/MEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GLwHlFPZVG6RdSc084YfzHNuo+HfABVyrnEmE3wRen361Xg6EKoFxsaRVwgCoBv1M
	 00UWEtwm5GTvo14hxoObgkYuXran1SMrMQdqJrlGpZvykeE1CFCb3hzKf0FYdkOuDo
	 aexd5jhoubZRti/kv0/HEgRdpl5ttnPFoX/bkMPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0787/2214] afs: Fix afs to abort the rxrpc call on send error
Date: Wed, 18 Nov 2026 15:41:03 +0100
Message-ID: <20261118150043.068685888@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 3e6af08a571fe2943a006acf3e890f36322602bc ]

Fix afs_send_empty_reply() and afs_send_simple_reply() to always try to
abort the rxrpc call rather than just aborting on -ENOMEM and otherwise
abandoning it.  If the call is already complete due to network failure or a
received abort, this will do nothing.

Also make afs_make_call() always abort on send error; again, it does
nothing if the rxrpc call is already dead.

Fixes: 08e0e7c82eea ("[AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC.")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260824091645.415423-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261006133011.531806-6-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ sashal: adapted rxrpc abort calls to use string reason codes instead of trace enums ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rxrpc.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 624ca9a2bc8a1..45073a7369122 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -400,10 +400,9 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	return;
 
 error_do_abort:
-	if (ret != -ECONNABORTED) {
-		rxrpc_kernel_abort_call(call->net->socket, rxcall,
-					RX_USER_ABORT, ret, "KSD");
-	} else {
+	rxrpc_kernel_abort_call(call->net->socket, rxcall,
+				RX_USER_ABORT, ret, "KSD");
+	if (ret == -ECONNABORTED) {
 		len = 0;
 		iov_iter_kvec(&msg.msg_iter, ITER_DEST, NULL, 0, 0);
 		rxrpc_kernel_recv_data(call->net->socket, rxcall,
@@ -821,6 +820,7 @@ void afs_send_empty_reply(struct afs_call *call)
 {
 	struct afs_net *net = call->net;
 	struct msghdr msg;
+	int ret;
 
 	_enter("");
 
@@ -833,20 +833,12 @@ void afs_send_empty_reply(struct afs_call *call)
 	msg.msg_controllen	= 0;
 	msg.msg_flags		= 0;
 
-	switch (rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, 0,
-				       afs_notify_end_reply_tx)) {
-	case 0:
-		_leave(" [replied]");
-		return;
-
-	case -ENOMEM:
-		_debug("oom");
+	ret = rxrpc_kernel_send_data(net->socket, call->rxcall, &msg, 0,
+				     afs_notify_end_reply_tx);
+	if (ret < 0) {
 		rxrpc_kernel_abort_call(net->socket, call->rxcall,
-					RXGEN_SS_MARSHAL, -ENOMEM, "KOO");
-		fallthrough;
-	default:
-		_leave(" [error]");
-		return;
+					RXGEN_SS_MARSHAL, ret, "KSE");
+		afs_set_call_complete(call, ret, RXGEN_SS_MARSHAL);
 	}
 }
 
@@ -881,11 +873,9 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
 		return;
 	}
 
-	if (n == -ENOMEM) {
-		_debug("oom");
-		rxrpc_kernel_abort_call(net->socket, call->rxcall,
-					RXGEN_SS_MARSHAL, -ENOMEM, "KOO");
-	}
+	rxrpc_kernel_abort_call(net->socket, call->rxcall,
+				RXGEN_SS_MARSHAL, n, "KSE");
+	afs_set_call_complete(call, n, RXGEN_SS_MARSHAL);
 	_leave(" [error]");
 }
 
-- 
2.53.0



