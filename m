Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026849;
	b=nPrRG/XosUoAfUXId8+iO60mTtyMGfd09wvi8nd+TmASmXOS7qWgAdWC7b3F8N3hKwXG
	 0/4eGHBXsRhtHNm1UkOysZ2JV5JWOZnshXVZnabgZUbMn4UUquaF8OEpDWOzOgkEmxf1H
	 FkzwYAZ21jaLpWP8oyWKqCVUKs24fKVUGUKWOR9TRD4PeQ4FjTAvtUvFBCjKMzNyuWx4O
	 qt+NahGZNdr7xpHwHuWwdJTKrGFsF5plJSe/fbSFm3dDKkcYfL1RXTl1E1CnIhfGsP/t5
	 v3ej0Or6Uc8Rz1pap0DP8o182nGoCDFq9xeN5n/rv1EFtn+q4eyobjiCszLPcsIjanQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=chg/wRyDVJ3/BGEOvVU+k6mP+ZvWvf5drD8Qgmp/Y40=;
	b=47tap2Q6TCgQerghV7J4GsWE95kEePRPKwXd7/Cxcrnias7Vt4Nca3h0lkwwgFVtmdLW
	 NK+uTUjsNhssQEVonKKdr8TlF3rHu4TNxt8ANKFGC/NaFXV/54GIJf2HFPCbSHiu2Vbdr
	 VYZYDYK0LrQEJjdVOtcZU8m8sllYc/B4Bi3lswy958teEP0Bar9/2B6PO3lVoe0LifOmz
	 PP5hfAfWG4uQR+8+WZycNEds4wAnm4kZu+DcXh8Jda4yWfBD7EolH7w2jVEZUXwIlftjw
	 kxcA8G89bGDKWmPiwT9HMcLNCMA/RkqVgDPF464dlHU0Sis6RBP4nOFOuE+/fssje9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXcLioEU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D62A606A31C;
	Wed, 18 Nov 2026 18:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXcLioEU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 066D81F000C4;
	Wed, 18 Nov 2026 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026849;
	bh=chg/wRyDVJ3/BGEOvVU+k6mP+ZvWvf5drD8Qgmp/Y40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXcLioEUXr5WO3lNCUnwZUJ8SY4sJmBCvG0pfAlOwFuGmr/lnNYvnVmd92h1VBQWP
	 5exUSsn8Ntpmm3q2RPfTX8fPE0nJmjotD/hZQXbFROOgPrF4G0BEQcMnFo2EdVgFA2
	 zXAcRh0402lRbgPtkoOe6FxCWJY3Dn0VvVqHBUd8=
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
Subject: [PATCH 6.18 1581/2151] rxrpc: Fix aborting in rxperf test server
Date: Wed, 18 Nov 2026 15:55:16 +0100
Message-ID: <20261118150219.474280760@linuxfoundation.org>
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
index 0c158d067307b..4e7ae130f36b5 100644
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



