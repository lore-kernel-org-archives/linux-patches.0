Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214428;
	b=ihybLW2jSmBKz8RLd/MkYOFV2b3P/PQRCPcHmxGn9hOeQe50PAQIU6LhxIfPGsmFMX51
	 6nBMm7/P+2tKqD1+0wR4DiCZd7ND4HvptaC8nepZl+dua23C1Z1lhL7hsZ2gFK85CLOv2
	 4daxEX5CwYVbsTwCqFMZoIsvXT/7Aap57XqhbS8K1jkTNi7mB8ReK9fHfsFctVfceUTiJ
	 lPLMv1ou61oQyz6AVVRQNv7eMpuTAuWZzbOAY8SvjSPq2hDisRvKthu4Pb8BHgwPOLMKB
	 EkxsBoRV7A2KO646asSYR4oNpwI4z8pesES7Bm0lLRNJ64d9PHBTvuf/I4s6+Snb3Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b8YDCuN4fNjomDMaRFhoMHGsak+XZwJg+pV1Ol+6t2A=;
	b=tWOWyOlHbHgDcSNTQMup8S51POI4jSAY2mIX4qav3B1vWSgLMLykXUI906g+l6rxe1Zj
	 fQNjunTJK0z9FwoHCI+uPv+C9o5oC3kUhoPT/2BMex9E3Gd34q6hYbtVuTlEVmUe8QAhm
	 ryCSiDTYo5x46zlRPtE3VUSIlP/f+RdgyWgC1IOFyZpp2gYJ+y482CYffZzFKY3aV6rbs
	 h0slKFPS0Fnb0VKNllTlDJBY/s3ITvhblUZdPC4e3EsMpfg8XBc4aaUw9mh7jfl3L22Yo
	 TrRgvSW8o+DyVWj8sKhk6U5erF13+n/aG49iO0pgcoEqJRzlw1BDrTL2pUf8/tDBfvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soeIkLF1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F7D606BF98;
	Wed, 28 Oct 2026 19:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soeIkLF1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ABF1F01828;
	Wed, 28 Oct 2026 19:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214427;
	bh=b8YDCuN4fNjomDMaRFhoMHGsak+XZwJg+pV1Ol+6t2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soeIkLF1rLCpDhWeqXsTUWKgJnJMMezffaevM+fHUd34CLW+u7OIg3oydPToylHXn
	 QEWj1hREa5N0drxr75Byxhqz3NGoAzrntBRUFIvnDeW94rKv/bzGRkQitml0fKqVBG
	 Frz56dyvK17ewnWYRdLjS5QBUIU3cAhz/Q3LOGqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Junvyyang, Tencent Zhuque Lab" <zhuque@tencent.com>,
	David Howells <dhowells@redhat.com>,
	LePremierHomme <kwqcheii@proton.me>,
	Marc Dionne <marc.dionne@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0812/1887] rxrpc: Fix bug due to prealloc collision
Date: Wed, 28 Oct 2026 17:48:28 +0100
Message-ID: <20261028170517.906657192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 69e4186773c6445b258fb45b6e1df18df831ec45 ]

When userspace is using AF_RXRPC to provide a server, it has to preallocate
incoming calls and assign to them call IDs that will be used to thread
related recvmsg() and sendmsg() together.  The preallocated call IDs will
automatically be attached to calls as they come in until the pool is empty.

To the kernel, the call IDs are just arbitrary numbers, but userspace can
use the call ID to hold a pointer to prepared structs.  In any case, the
user isn't permitted to create two calls with the same call ID (call IDs
become available again when the call ends) and EBADSLT should result from
sendmsg() if an attempt is made to preallocate a call with an in-use call
ID.

However, the cleanup in the error handling will trigger both assertions in
rxrpc_cleanup_call() because the call isn't marked complete and isn't
marked as having been released.

Fix this by setting the call state in rxrpc_service_prealloc_one() and then
marking it as being released before calling the cleanup function.

Fixes: 00e907127e6f ("rxrpc: Preallocate peers, conns and calls for incoming service requests")
Reported-by: Junvyyang, Tencent Zhuque Lab <zhuque@tencent.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: LePremierHomme <kwqcheii@proton.me>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20250708211506.2699012-2-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_accept.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/rxrpc/call_accept.c b/net/rxrpc/call_accept.c
index 4a1e5d7a07262..8001c330b2be6 100644
--- a/net/rxrpc/call_accept.c
+++ b/net/rxrpc/call_accept.c
@@ -151,6 +151,11 @@ static int rxrpc_service_prealloc_one(struct rxrpc_sock *rx,
 
 id_in_use:
 	write_unlock(&rx->call_lock);
+	call->abort_code = RX_CALL_DEAD;
+	call->error = -EBADSLT;
+	call->completion = RXRPC_CALL_LOCAL_ERROR;
+	call->state = RXRPC_CALL_COMPLETE;
+	set_bit(RXRPC_CALL_RELEASED, &call->flags);
 	rxrpc_cleanup_call(call);
 	_leave(" = -EBADSLT");
 	return -EBADSLT;
-- 
2.53.0



