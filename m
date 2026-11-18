Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020391;
	b=LM7+w1A7SJuSRZnTPd2mkoVismw6PnlR0XY4ePJEjrb5vqh9Fo1xjPC56gpwRWn//Jir
	 aketEotDFe1l66TNuoi1hzsmmlA0MrwXpGPL9eWbTrZBEgTKEVVYyJ0Vr90HDHJMhIEwd
	 JhFU03QXZXqWdayDl/l+CBXQ6tU9av0MuJVAaJccbRW6o1Hjd1Loh2B+kIZt8bfd2a38e
	 0iP7Y7LTbUxrjmdYmNaooCkTzKAB2vzdl/j4FmN4MAV88RokkAYvn1+NA5/7V/seorR8Z
	 miKFwk3ZPtAm4XIrfak0cq6GKMguSYxqB5SNbJppOSLHfseXcqrpr/tkelShzJeDGYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qwyqh0of9UICe540Tl8Iu9WvKlw9JB/bgdFOtHOMfN8=;
	b=pw42SxEWIR4fI57yEH0ra7CGgxFKXsxkMYL1fWZ44QjKN46DwsGEFYexA73BYbU52VwC
	 /Pf2U+dpwfbYQKARKa5RzAzBJjOHWwy75Cw99ED8PRqMZVfWR/pV4fQJqNeGrOfU+saiY
	 FBA2qf8MsXroqhHoBvjL4PCbZOYVLW+44BCqhoD7lYkPCEIPU5zoc0R8DfCwH/MGQksLQ
	 fUPj41lCnYO0caAJ2sbBY5PxFKMpbcOJE1bWuJn0eefL2EvpuYZ+/Ae1ugk7SsxQQN+yD
	 +gv40XSLh6DgADI+SijNm/PNN5IuR6p2cjNE7tVQYuu2CXzwGKehkNyQ3EXmLHmuJsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EhQuRbZM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26FE606A330;
	Wed, 18 Nov 2026 16:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EhQuRbZM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026F21F000C4;
	Wed, 18 Nov 2026 16:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020391;
	bh=qwyqh0of9UICe540Tl8Iu9WvKlw9JB/bgdFOtHOMfN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EhQuRbZMbL+yYFjswPIzbdpq1seC4KOkyKQ+x+QCxphD1NPZe3ikQXW17ZlfB7H6T
	 8ZK2qK78VfHXqv9rAjeWmklRvaXLE12LHSJpdbfZ9+FQb2kdsWLOn9IJs4aKkWP017
	 +H8bcxr272zRwIZjeasBDSDWRUbl4j54la5etE2U=
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
Subject: [PATCH 7.3 1936/2651] rxrpc: Fix aborting in rxperf test server
Date: Wed, 18 Nov 2026 15:52:56 +0100
Message-ID: <20261118150356.351658126@linuxfoundation.org>
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

[ Upstream commit 7f15923909866e76608ea6474368570938e783fc ]

Fix rxperf_process_call() to always abort if it gets a send error rather
than only aborting on ENOMEM.

Fixes: 75bfdbf2fca3 ("rxrpc: Implement an in-kernel rxperf server for testing purposes")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260824091645.415423-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
Link: https://patch.msgid.link/20261006133011.531806-7-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/rxrpc.h |  2 +-
 net/rxrpc/rxperf.c           | 11 ++++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/rxrpc.h b/include/trace/events/rxrpc.h
index 554dfb777b93e..56dc9b6140716 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -28,8 +28,8 @@
 	EM(afs_abort_unsupported_sec_class,	"afs-unsup-sec-class")	\
 	/* rxperf errors */						\
 	EM(rxperf_abort_general_error,		"rxperf-error")		\
-	EM(rxperf_abort_oom,			"rxperf-oom")		\
 	EM(rxperf_abort_op_not_supported,	"rxperf-op-notsupp")	\
+	EM(rxperf_abort_send_error,		"rxperf-send-error")	\
 	EM(rxperf_abort_unmarshal_error,	"rxperf-unmarshal")	\
 	/* RxKAD security errors */					\
 	EM(rxkad_abort_1_short_check,		"rxkad1-short-check")	\
diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index 441beb077742e..0bc3de061b938 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -527,7 +527,7 @@ static int rxperf_process_call(struct rxperf_call *call)
 		ret = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg,
 					     rxperf_notify_end_reply_tx);
 		if (ret < 0)
-			return ret;
+			goto send_error;
 		reply_len -= len;
 	}
 
@@ -538,10 +538,11 @@ static int rxperf_process_call(struct rxperf_call *call)
 	msg.msg_flags = 0;
 	ret = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg,
 				     rxperf_notify_end_reply_tx);
-	if (ret == -ENOMEM)
-		rxrpc_kernel_abort_call(rxperf_socket, call->rxcall,
-					RXGEN_SS_MARSHAL, -ENOMEM,
-					rxperf_abort_oom);
+	if (ret == 0)
+		return 0;
+send_error:
+	rxrpc_kernel_abort_call(rxperf_socket, call->rxcall, RXGEN_SS_MARSHAL,
+				ret, rxperf_abort_send_error);
 	return ret;
 }
 
-- 
2.53.0



