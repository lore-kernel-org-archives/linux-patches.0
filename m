Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020386;
	b=5mUvjJV4grHN6Ro0MpNmeomlBMrNGU7vikBXoqJfN4PL2V8DkHfmo93KCQqoRhk6H8jV
	 VWNQvCgevSBPFWDy78C4bhDqeYm+iUfDGgYObNvztYHFgXZwNZ1ZWzePwmYMAL4QSGJQI
	 bVjKIumLHWrou16lT42Q1kwizp9WFrunpogqGzPfzlR4vIYXYtjlQ9ONbwFxeVDKn6mjH
	 NP48/vP3EslzMtv/Z/doWVjI5eGkmcB+cbYYENS5RwOQh9PzqAJTc5Zwgb22pNzE2gdgT
	 uNa/LlZr36n67cUVs89KTI+2JVydSbAH/Zxckj66PA+qvTs63m8dVikog6Jrq6B6q0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R2QYyESjAvMIdvjoBs4YjvkRk/A9rEOCbmG64TizqsE=;
	b=GobOoNwSUOSa+5W049rOIYnBCrKbozYbQY9s3mYTgemLdpQ5PFog4JKv3zeskICoLT+4
	 QLYvNACyIsB2bE6S/93SE1NiW32dAN/3vgHtBKhupGX5k5vXlNM7WqHE3Bmgj0iFcbZzC
	 A3me6HMqGn6nq6fyLgTl7QaAA1lpldN4ve52jT7eKdiJr5ydJV1I8/FyleLIsoBmBdbTW
	 zk3YYhHDmVHuKikXQMaUWIfuSz9/qv+BPYTv5bdznmKhsMe2Cn3fLs+1hSreZQYtyqvuJ
	 KazoEZvNdj922yvPxFS0SsA5B929lNpRZPZZI+obD/yecR1MzUdkKYoNWaiepPbxvyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYygcXwn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813C5606A320;
	Wed, 18 Nov 2026 16:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xYygcXwn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABC41F000C4;
	Wed, 18 Nov 2026 16:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020386;
	bh=R2QYyESjAvMIdvjoBs4YjvkRk/A9rEOCbmG64TizqsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xYygcXwnZvWSWKehyicCgOte9I1bMdkA8whqJO4dmsEygaePuEaca5/Alz+LrjE4o
	 BYG4KEQd2jMyMmEXbazQ78efD4sxg4QGSZ8UrBSPseMmrzxFu8fFh2vDvzrM27GbtJ
	 Zoxy4CCKaXJYApcUEJNaxIQcpYZ2l6VxoDVCj2Hc=
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
Subject: [PATCH 7.3 1934/2651] rxrpc: Revert "rxrpc: rxperf: Fix missing decoding of terminal magic cookie"
Date: Wed, 18 Nov 2026 15:52:54 +0100
Message-ID: <20261118150356.290459766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 6a815a4bb314b..02f8ed2f74c05 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -495,18 +495,6 @@ static int rxperf_deliver_request(struct rxperf_call *call)
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



