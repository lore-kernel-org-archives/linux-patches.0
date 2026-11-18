Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026844;
	b=Hfi+fjTW8tNIHTYGNS+FfwRsvApMXWc7qMKVXh9G8lEriJEkhXLx9iQG4SMKAV17N2+u
	 kjryjLKjN7E50RuuNBYCRsqEYPnuPvWo8QGWRJf8PsJaNDr203ajAgGANgPaUv1MfQsj3
	 7FFG76cAst1eNCSWz5kox+SDlCs84JPG1bfVS8r18YLvvWZ4m2WH4NdjA+eRdQHnPcZj/
	 l00cY/E7znUjvBHSJkMD706cLhWtTlSks28Wf9mV/DmS3WnCSAPaeIWOcVBGQMGWq68JB
	 tBjsSGIud3zxDVEG6P/tDkyYtmSuu3T2HMPKqXPCFq2vbe6lBWkr4xlwgbKtQ+7EwKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+s1ncyBuLBXZrREOM6K273jLX956wQfEawX7nyJVqGU=;
	b=V/WQxu5xJz2d48MG6Zr/dc/RBM2pIOT+CeXZnMZVovDtgjFel5MYLOxBbPIzn22yhMdB
	 wAADZKuzV0c73JRnTsayk4gbKTh+g59OBE/1VKPrADAlU7oz9dupCQ6u7CzC4cdEdcUPy
	 WU+aKV10IH+CcAMu0QLyvptMwuvnCrjBilvE41Tu/gwVrUPO8Oc9WM1OONg968XqF3YPj
	 7toShLy9Y6X8g6+9vW8STFctuUd+79nR6A7KSlBJ0eOGN1xuiUJm1WsFA/YO4BQfmPHFN
	 tBBG7lNvDlr2zgH3eGm2UW52YMwnWD9qEL6Gixce23Nuij8WvwAXtwrufm67lBL8bTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yOz6W3cg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAA3606A320;
	Wed, 18 Nov 2026 18:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yOz6W3cg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ED41F000C4;
	Wed, 18 Nov 2026 18:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026844;
	bh=+s1ncyBuLBXZrREOM6K273jLX956wQfEawX7nyJVqGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yOz6W3cgcJTvSe2pqHYfqy07nZzMtRNnKVXaIbvSt+MRdU602GRpjAT+g8sQWJ7t+
	 ITJh8Ma0lJ5cZwEoMd8r0kQ8sIkTrq8QxpLVZhigA0PJssH7QjJ32w78NxqUH2uET9
	 XKhPg7BwWPViH2AfcIcbfOMhSSliTJXMkwkFGta0=
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
Subject: [PATCH 6.18 1579/2151] rxrpc: Revert "rxrpc: rxperf: Fix missing decoding of terminal magic cookie"
Date: Wed, 18 Nov 2026 15:55:14 +0100
Message-ID: <20261118150219.401855215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 91ecd5d64bc34..c816820aedbdd 100644
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



