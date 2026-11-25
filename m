Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625383;
	b=H2hHq1QzGFrzX/4Mhr1P/UrwNyoaPMVOhF8rVkyaMt3aegnp55zmZQLGIFnfjWwek7yS
	 sUDi9RRPMqZgPzj6SqNWxrwhELQgvaAqj/CTCypqpSE/tkZUIMtur6tqkz3tHXqq28mrr
	 rXXH/98nDl+oPgc8rdy03o8KYr0MGtw+q6yci+/bfiCLdNO67I8yw5H5xTSKvMkA9WuNr
	 Sxmx9ykZD8I8u2ZBwS43EnhY/zhzRp3lJSkstH5Xi6eh/Uf1xVzLRntuLHftqvFq35u1N
	 VI/MC2iAGNNLqcQEJlhK4oB5hXr/3Hn5+BfYhjZwayhSnGff/cDh6tcvjr9nmt3CnQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yrfHSKHIJoA27fxBVXEw085l8UHlapjyCWksInN/34c=;
	b=RbxE4E4g0zIv+zm6o5aB+R/pp6oomn7ubkrkiJuvtHLc8u7z/W9y9wr8rg9/bq3+UGtj
	 Jcutlt3K9xhu6HwbdH5Q36uAA5JvMQAblDbUkXZmayjEG55JqOLkJjqFmUEmkTBFd0gfb
	 PLOlTi74s3mVBcubEvNG1CCRUTB65Lo+4MeoR7kLxAxpvh+rrOyww4xPrYrTXGpo97Y6B
	 vyg4tVPTnm8zNRsjxFFQunBnrab0jBKPLVyoQ69UpQHCix3hKdom+Wtpukrv27a1cZaQo
	 IDHriTJiIfhBsGNCXB1hKo8NcfTTjwUzXxxmxgjvE932Trqoh23dLsFDmEM/b3bMhag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y4fSsrN9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F9E606A327;
	Wed, 25 Nov 2026 16:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y4fSsrN9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFD31F000C6;
	Wed, 25 Nov 2026 16:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625383;
	bh=yrfHSKHIJoA27fxBVXEw085l8UHlapjyCWksInN/34c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4fSsrN9+WORa+SFDrmGjalv++IrPRHdUpbB3f6Ppi5vpGqCBlHAonsIw3m9qfkDT
	 my2uwm/7Yv1P1hdL2pqH6kDoxhKr6JmgT4Fca8FjVJFL2IP72LCH6zMEIcn9fJ6zIC
	 sKW8H0/TQfGN29mlhjZ53omwWsDkM1RiQv8bnEyE=
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
Subject: [PATCH 6.12 497/816] rxrpc: Fix aborting in rxperf test server
Date: Wed, 25 Nov 2026 15:34:05 +0100
Message-ID: <20261125143900.693847204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5e29744e45037..a292b6f08258b 100644
--- a/include/trace/events/rxrpc.h
+++ b/include/trace/events/rxrpc.h
@@ -27,8 +27,8 @@
 	EM(afs_abort_unmarshal_error,		"afs-unmarshal")	\
 	/* rxperf errors */						\
 	EM(rxperf_abort_general_error,		"rxperf-error")		\
-	EM(rxperf_abort_oom,			"rxperf-oom")		\
 	EM(rxperf_abort_op_not_supported,	"rxperf-op-notsupp")	\
+	EM(rxperf_abort_send_error,		"rxperf-send-error")	\
 	EM(rxperf_abort_unmarshal_error,	"rxperf-unmarshal")	\
 	/* RxKAD security errors */					\
 	EM(rxkad_abort_1_short_check,		"rxkad1-short-check")	\
diff --git a/net/rxrpc/rxperf.c b/net/rxrpc/rxperf.c
index c16afe540d09c..d7215f939bdb3 100644
--- a/net/rxrpc/rxperf.c
+++ b/net/rxrpc/rxperf.c
@@ -526,7 +526,7 @@ static int rxperf_process_call(struct rxperf_call *call)
 		ret = rxrpc_kernel_send_data(rxperf_socket, call->rxcall, &msg,
 					     rxperf_notify_end_reply_tx);
 		if (ret < 0)
-			return ret;
+			goto send_error;
 		reply_len -= len;
 	}
 
@@ -537,10 +537,11 @@ static int rxperf_process_call(struct rxperf_call *call)
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



