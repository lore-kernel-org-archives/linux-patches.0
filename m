Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041688;
	b=QQAO/VZBGgliHIDQLrk7O9lkxaAgCd0U57kQFD1glXyuJvbJ9xrbp9Ic4N8EvsKOreLZ
	 FhZyFuhBwdGh4gTvbYh4bJu33I04NxC/1cOyVhfSwnyAR51s0pDGtmoZC9c1R7FEcZhEt
	 BsiumvBQSt32xf+IqEqKH8CU5pKUubDV/7Hu7e8QzpTUXS3gQOXmOdyjlgJODGWkqCRdn
	 EIyx7zhdD/AD2LjbZ+FZjd9KdwebMje0cdgav2yg1KN/pMmad5saKYqXb3yHQRCabU6MX
	 EC//0ClOEs7rpjIR9+wb9PCD0yP/b2Yrs39hmUzCBqSd0ASXIIjMjRqCbvni5s2LJTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K5AysUcCwE8/QjuZ0I7iXz0AMz04v+NKUyltElVQcB4=;
	b=BmeZorevG+wiepOO9LY3iwPuY3cW2RpjStHI0Xev0od6JE0eAFmZEflmAZsD8yv1+9t9
	 jbvng1lg6K2O0je+6jqaaGE6YivaPeIB+DJ1r+sPf8s4pzAex1lmyYIpYe/5gtPqrcZ8b
	 go87lVTm7ZOYTgAz9+6kp1bH6sLlnWe8l5CGrkeakYq0JKmjTYxE1NeFNg0gIDcvxkU06
	 9sIQ/jach8pCm/q6bVXRUJ4GmU1CfARHtEGB44M0LraPOJNeTN6GcRosiY+ZT3HtWPrGM
	 TQT7oerLBTQxTWQXJsBmcxIlABcQ3DYDQ3pV3HNSnfHigS+2ZhEigQ2qYHK3cv/09ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6eSSTiK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C08606A31C;
	Wed, 18 Nov 2026 22:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y6eSSTiK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9E61F000C6;
	Wed, 18 Nov 2026 22:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041688;
	bh=K5AysUcCwE8/QjuZ0I7iXz0AMz04v+NKUyltElVQcB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y6eSSTiKx5TXYPgQc8aymmh9rjN827lBuVYDCOi/F6bejlE3EjH5uxniSufTxUs2L
	 dAAmKyay2J9Y0rIAfgGoimXw8iGpDw50DHUez/QQHHk+Rg4MLGZf90VBZHuq0shYlI
	 2XgQINhMC0Wuz4yIOd5oB5egDlntBkWlqiOI+j5o=
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
Subject: [PATCH 6.6 2904/3318] rxrpc: Revert "rxrpc: rxperf: Fix missing decoding of terminal magic cookie"
Date: Wed, 18 Nov 2026 15:58:46 +0100
Message-ID: <20261118150447.592550509@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

[ Upstream commit 870143cfdac1cad166d1dc03fbef915fac0c229a ]

Revert commit c34d999ca3145d9fe858258cc3342ec493f47d2e:

    The rxperf RPCs seem to have a magic cookie at the end of the request
    that was failing to be taken account of by the unmarshalling of the
    request.  Fix the rxperf code to expect this.

Actually, this isn't true; it's just that other Rx implementations ignore
the extra data in the request and so my test programs are sending too much
data without noticeable consequence.

Fixes: c34d999ca314 ("rxrpc: rxperf: Fix missing decoding of terminal magic cookie")
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20261006133011.531806-2-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/rxperf.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index 66565dd24acf5..25903cd294637 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -494,18 +494,6 @@ static int rxperf_deliver_request(struct rxperf_call *call)
 		call->unmarshal++;
 		fallthrough;
 	case 2:
-		ret = rxperf_extract_data(call, true);
-		if (ret < 0)
-			return ret;
-
-		/* Deal with the terminal magic cookie. */
-		call->iov_len = 4;
-		call->kvec[0].iov_len	= call->iov_len;
-		call->kvec[0].iov_base	= call->tmp;
-		iov_iter_kvec(&call->iter, READ, call->kvec, 1, call->iov_len);
-		call->unmarshal++;
-		fallthrough;
-	case 3:
 		ret = rxperf_extract_data(call, false);
 		if (ret < 0)
 			return ret;
-- 
2.53.0



