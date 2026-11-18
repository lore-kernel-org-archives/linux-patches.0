Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058856;
	b=nobKzxqcVzLaHSEox9gjUbdCIpnkLicAsmcOi1lXYMYcYQ51f3vKuJgPtUM8BpiPnGHN
	 L82/i8DBDhVVRRtTF6FQft5eNBaA2vwBTPJhg9pF7xOCCbA3dmfz/52l2bdwyTnc3sF0x
	 oN9+rRU0Ur8KotaYwnV9T+ZN9An3gWPcxTCRfmaEc2QIs5XcMbmtkx7/62WQBjQtLw4iC
	 kDk0fD7Ob+pVG/yd77a50olTcqw82957mm0dwdG/BhsSWTZnlZ5pJdzycW0eaIwTFzh+E
	 LcqGoZ/tIBn5irgVm+AGREnTDu2Ft3QWsc8B3Hp5gDICyplYM4X6KXcw++L6s77TFGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y10gqLsPFszQ/mghrmSRH/HcKxDkPsBQxEIP/WWo8Kc=;
	b=eFA+N7Z+Cxn9xUyuQaP7eOIhjgeEA09bR7RSCSwdyRhQ7W4G8hTRkc3EmQNnbpE10K5h
	 g+KiUDt2AGUKVtm/taXUiael092QCD5VKQ94kp+Qr32Pf4YwFISPQ7iOcoFVEGbkPoWuP
	 Rh1dunbweZ9utgyacwHFwEyjAGIr7aGJkhEYr6xDFtqpEv3uYDB6BlspZfkGNcKOH/Glu
	 PfDKrgXoUpESGogDJlFu2MqOB6pPdiTWno13NQ0NKwb1tH3THJxAt/Yipmy+ccOCcaY3z
	 i82DQkxvoId+IrhWKkvitcIDbWScqVmDzmASYTT03v8OaHSvttYqdOrbvkZuz7RGhiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Skgzxux;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22EE606A320;
	Thu, 19 Nov 2026 03:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Skgzxux
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F5D1F000C4;
	Thu, 19 Nov 2026 03:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058855;
	bh=Y10gqLsPFszQ/mghrmSRH/HcKxDkPsBQxEIP/WWo8Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SkgzxuxAcrRVnCLKMFt3DuI8CAcMv5PQaA5nIgJWBejVODXssYNu91UsXjy4Ua7h
	 LzJkct3BQ5raiXbHYkg4eyI+nbABPvkyAcB5bGY2VUP2Jggiiek3D0dWRAH/09c00n
	 Eu3KHIsApD7TDtndpidCtn9qZ2KvxC9lF2V78YII=
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
Subject: [PATCH 5.10 0636/1848] afs: Fix afs to abort the rxrpc call on send error
Date: Wed, 18 Nov 2026 15:44:34 +0100
Message-ID: <20261118145942.382974108@linuxfoundation.org>
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
[ sashal: replaced afs_abort_send_error with "KSE" to match the older string-based abort tracing interface ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rxrpc.c | 34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index 2e68abf627f5d..f75e8b361e294 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -469,10 +469,9 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	return;
 
 error_do_abort:
-	if (ret != -ECONNABORTED) {
-		rxrpc_kernel_abort_call(call->net->socket, rxcall,
-					RX_USER_ABORT, ret, "KSD");
-	} else {
+	rxrpc_kernel_abort_call(call->net->socket, rxcall,
+				RX_USER_ABORT, ret, "KSD");
+	if (ret == -ECONNABORTED) {
 		iov_iter_kvec(&msg.msg_iter, ITER_DEST, NULL, 0, 0);
 		rxrpc_kernel_recv_data(call->net->socket, rxcall,
 				       &msg.msg_iter, false,
@@ -854,6 +853,7 @@ void afs_send_empty_reply(struct afs_call *call)
 {
 	struct afs_net *net = call->net;
 	struct msghdr msg;
+	int ret;
 
 	_enter("");
 
@@ -866,20 +866,12 @@ void afs_send_empty_reply(struct afs_call *call)
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
 
@@ -914,11 +906,9 @@ void afs_send_simple_reply(struct afs_call *call, const void *buf, size_t len)
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



