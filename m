Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619837;
	b=K6mQ5mmGT81IkOxu4PJImo7sPA6jYaQOobgI4ydcGnsPBrb4g21PMfjlMWW9/Rabz0a+
	 N61zbNRt3S7+Z3ESMOeVyd3HVZncNRjJzUpad57fSgi5Zkdg8J5FyB/20TmWx/IrO4haV
	 xsSM5Le2T4MSRClGZ70lBORmSGZANS2QlLUVhoTznxVpRDdfe+Jbq5jN+fUVQID58HVsA
	 kdrbhuZCdKOdj9Qk4V1o4AdWEh7Jel+PeoE81nmZ5Ups2A7oHWMAg+ildhP/0GQ58SsaV
	 ZeiXXX5YhR86BxBF2CiA+91qPajp4mxcApMMsNZ0dD37sDAEEKWJdbfYCttEKkiYnuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gCAMYhewz8NE11HbEreurbbxPgdBcsSwk9hRXfNMF2A=;
	b=lUcjCHXobmZyXrvAzQesu8DZUjGzZUfc7qsRNCbWeLgoNjeCkK1dksveE7EG8unz+4cI
	 tXKshPE3sn0Gc9YedwU7yfyTOUQfxvh4sLALsFyKXqYYJBuLTToJM/zha66raWnLqxMau
	 hpLVEDgcGlRxxM+RNrvouVSuj+kqqVflBYt1zM0uCq0/1l1z63JVokiYdykyfNCkyrYCk
	 C2ERCGrOj73G4qBQcsrbomlywqJWFaL77rI6cRGcrL0UhABxrMvuxDNj7H/LnRXiqmF6Q
	 SF63jKWpsRIyLTtgeq5SJjoGVjGkfSXux1slTzwBxjITfq6jWlNqUI0zv3Q2tshNlGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGYQhsXy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10C2606A33E;
	Wed, 25 Nov 2026 15:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGYQhsXy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FDF1F000D0;
	Wed, 25 Nov 2026 15:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619836;
	bh=gCAMYhewz8NE11HbEreurbbxPgdBcsSwk9hRXfNMF2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGYQhsXy8MEUpJ0lVFlgINJa3c9gPYvvupgmNMxU1bMzKHFN9XxC0QhlQuIA7eFna
	 fgYCGaUMuskTXB/XIW8Thf8+IB0N/64EgYw9qnuwTiRv5tXki+/2/Ym+depDKy3Omn
	 dMfUZTB40pLkBsep/FdbxGg5U3U8pmM7LwT0cdNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 7.3 0722/1005] SUNRPC: Fix TCP-with-TLS transport class identification
Date: Wed, 25 Nov 2026 15:34:20 +0100
Message-ID: <20261125143838.673638823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -3525,7 +3525,7 @@ static struct rpc_xprt *xs_setup_tcp_tls
 	transport = container_of(xprt, struct sock_xprt, xprt);
 
 	xprt->prot = IPPROTO_TCP;
-	xprt->xprt_class = &xs_tcp_transport;
+	xprt->xprt_class = &xs_tcp_tls_transport;
 	xprt->max_payload = RPC_MAX_FRAGMENT_SIZE;
 
 	xprt->bind_timeout = XS_BIND_TO;


