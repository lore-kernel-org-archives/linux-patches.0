Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623128;
	b=18GxZ3T3noIu6MNv5wPFa/e/pjorXkvb0bPi32Pe1dko+453Sv0DMlEVinDXyFFyqk9s
	 vlByDxYimu1o7O1AE6Hdhedirbsu6EX7ry1eUwe6QQUIR2XFzOkFvPFq+fOk6MHZsbXHG
	 1RbZr9YfTfTsj2xPJlhlHHnRjEXZLigGRZSDL5RprIpG+msnTeb9kUVaDDbFlnIhpKm1x
	 yqQVASykFwTLt6j4wkqUuTbSa9ygIpXIQfdJX1NT6LHNqGsXi1eD4tJq2nNUDNKLDcuPc
	 B0H9Qmh2mFfjMDfKhhcjGw5uoqjAfiursUuvbwgerYp/UkXLl4tHRQWsnHkJs/BOwsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uQkmaGrwkVHPKmk8oM59oilvWiaWBEtQ4t8A3TQJVHc=;
	b=e27b7edsQgakYNGPXBLe2NV7zFwEYe5LUj3YWjY0slSMof9G6pgTvQdF7JNHc8t+8SE6
	 Fg0vBC5+qsup2AVCIq5AObRlp04NwUmEJ624LY2AJ27At8FqqHuF3qkWQiyauUErq+Vcd
	 usxtb98MePu0b8SH0sAxc0WeBODtbS5pbbhtRS7BbTZVBbYAAYfflYqtAv7Zd0mFrK/w2
	 H4zfqPf2CyfQ03i3ujptIPxMoZgwBfvccqx+XH2XfuQxcv1wN0zYscg4x94SeeSJz+bsH
	 H3kSnyJjCaaLpF1KLdyZBEslxHg7Z0JVyYJHNmU1dX3WFD1Myej+DubV2Y8ug3U2SEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sjv00AmM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B895606A321;
	Wed, 25 Nov 2026 16:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sjv00AmM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12CA1F000C4;
	Wed, 25 Nov 2026 16:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623128;
	bh=uQkmaGrwkVHPKmk8oM59oilvWiaWBEtQ4t8A3TQJVHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sjv00AmM6/pcc4RLRMTxSpYr+4dQiLW9OOC3dtVF8WP+zcraaJ4V4lUx912jNf6uD
	 Mp13LM+53hAoppLZJcWna58ZO80oK8CAykKSK96gbl19qnu12en5vTdrFpKpeKR0N8
	 oB8pb9uIK1gL4P9TTRxDSKPQUuDmjGbRuvjFMGqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 760/990] SUNRPC: Fix TCP-with-TLS transport class identification
Date: Wed, 25 Nov 2026 15:35:27 +0100
Message-ID: <20261125143839.860019063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

commit 0502c7e7f171a8c9c892bdef89e6aa6f44d7b2a3 upstream.

xs_setup_tcp_tls() assigns the ordinary TCP transport class to
a TCP-with-TLS transport. When rpc_clnt_add_xprt() is called
with an unspecified transport type, it inherits the class
identifier and can create an unencrypted TCP transport.

Looks like a copy-paste error from the commit 3 years ago.

NFSv4 trunk discovery uses an unspecified transport type when
adding server-advertised addresses. If the additional transport
passes server-identity validation, it can be admitted to the
client's transport switch.

An isolated loopback test reproduced plaintext application RPC
transmission for TLS- and mTLS-configured clients, including
an unpinned TLS-client RPC that selected the added transport.

Assign the TCP-with-TLS class instead. With the fix, the
plaintext-only test peer receives TLS negotiation probes but
no application payloads.

Fixes: 75eb6af7acdf ("SUNRPC: Add a TCP-with-TLS RPC transport class")
Cc: stable@vger.kernel.org
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Benjamin Coddington <bcodding@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -3524,7 +3524,7 @@ static struct rpc_xprt *xs_setup_tcp_tls
 	transport = container_of(xprt, struct sock_xprt, xprt);
 
 	xprt->prot = IPPROTO_TCP;
-	xprt->xprt_class = &xs_tcp_transport;
+	xprt->xprt_class = &xs_tcp_tls_transport;
 	xprt->max_payload = RPC_MAX_FRAGMENT_SIZE;
 
 	xprt->bind_timeout = XS_BIND_TO;


