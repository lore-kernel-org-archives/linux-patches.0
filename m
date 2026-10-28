Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213781;
	b=CBM9ZRM0mhzCDFxhL03L0jkSvQTS4t2y9ntFcH/w6So08pB9UhDjhYyA/NZ5rvzEC9Pd
	 2OKsmy9sHLd1OJSlC3JRT24nNNQFXVLFq/YTFVC66xAUa8V+e3WFzPZmmumsG2Z/kBNW1
	 KemrGDt3Fb32RWpozni0KunKrjRp88M49c6jVG3efxeD6ZzB6x9Eonq3IWdcvLH6qeDKy
	 E3Zf0bRJWSa75ZmQ2ZaCEpB9KbhoCyzGtvOKSO5DcE/wHmC+qQNLmWinrB2bR0ouKN9fl
	 VNoNm3FwTeJW8UraYrPyNQq5mcMUChUMERepIRxejzbXE/FThTicSloOmoDGoCbv7+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sN/1VqpmIRV+k+o+zTvuS4B5DUr3sOBaiE55xVc4t/M=;
	b=LKOwGtBT0i1m2lBD0Z282WGjTzVL5vqUlJ3/TBjJ7S0LwSznZFMiZxMIkYS7TrlZkrD4
	 AIjUi8HoiL0vcKiGSNppD41oOy/9KBuYWWZ95UzOtuixYXxFxSos/T6QTDzyHDvZrjfj+
	 UvGknhy2opIMbTUBgJTYSIOLCDS8xUbg+IhxczYJl/sMNg2qieHLxOdMwUsTJM3fiaP3G
	 G7MHRBm/ZVNMxC50Ff0EGTY4xawXB+5aGUR0mScPc5yJGlmlBxqpQhTdxTTkarulhkGf3
	 C+JpFEmoh7Uudr42DD/+inaowl9mJCu5w6SHVXgrupy1yURCDaZmZIcQ2Tk9lcvdwjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZdanG+Ol;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE88606A327;
	Wed, 28 Oct 2026 18:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZdanG+Ol
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017991F01825;
	Wed, 28 Oct 2026 18:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213781;
	bh=sN/1VqpmIRV+k+o+zTvuS4B5DUr3sOBaiE55xVc4t/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdanG+Ol9WcSIJg0ZF10x+KKRtZzYPjL7MZeqqd+bAC/eQIl2edn7fUt2DB+9HQZ1
	 aduV1zuxj52+kMT9VKOThX0QPkmKQMVKUdWIDsXBAkToPR5RwJTWoxs62OomMnK+E7
	 25mb6Sy1gST36pKYw+o8Y3pZAqr9NYofFgXpw9eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org,
	netdev@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0583/1887] rxrpc: Fix delayed ACKs to not set the reference serial number
Date: Wed, 28 Oct 2026 17:44:39 +0100
Message-ID: <20261028170512.689425732@linuxfoundation.org>
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

[ Upstream commit e7870cf13d20f56bfc19f9c3e89707c69cf104ef ]

Fix the construction of delayed ACKs to not set the reference serial number
as they can't be used as an RTT reference.

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Eric Dumazet <edumazet@google.com>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: linux-afs@lists.infradead.org
cc: netdev@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 08c117bc083ec..3d9032fae9d91 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -87,7 +87,7 @@ static size_t rxrpc_fill_out_ack(struct rxrpc_connection *conn,
 		return 0;
 
 	/* Barrier against rxrpc_input_data(). */
-	serial = call->ackr_serial;
+	serial = reason == RXRPC_ACK_DELAY ? 0 : call->ackr_serial;
 	hard_ack = READ_ONCE(call->rx_hard_ack);
 	top = smp_load_acquire(&call->rx_top);
 	*_hard_ack = hard_ack;
-- 
2.53.0



