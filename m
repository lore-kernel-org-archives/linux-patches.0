Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831783;
	b=NQy5awtQQhkWfyNmWoSiLo4Jbjw/am2n0zfl+QXuKJjRY1nf2BXRLJa1ZPrRz87aJgw/
	 mq+rLW4E7nPg27RXxY8ozc6X20TV5ue22sdld3H1HsZSR2nG01xZ71BzmlUmOTfw808VB
	 IP1+OQ/JoegBl02xplMlh1TVQuIF5UWohIEZb6k5+Swi95mOUlKuwbBfMXIk8lP2U+Lpd
	 /2R0sBdo6A0Z6aQhukE/NyksfUp6m+bYKPAkGirW5bOnPxDIHm+HE61dJsVC7l4GmQu+M
	 o+djJ+gjv2IkNfyxYn2yewEF1Bg5m2jiK35WXvrMISGe8wj8cux3kqaRIAULzvKp6Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3iovlTx8zEJcNK181vswUrd1iRLZULm4+u/ogpWNlI0=;
	b=zLtC6K/qW1jG66lMQj37/bJnpjmatpzlMN84g22yxqL4tw7h+PQ4/CH4Pl3R7otgTrhj
	 L06iRCsuFzM+vE0aIwwNE0fcH2lndAPPQ5n9nQneQI8hV2S5OQqdP4HaoMn7K4mznunmL
	 4dUVnGMNzak7vJ/SxbDq4n0Pp3pMldNCCcQkBwPh8PTEvNTeWXvJjkSgmerFpWiIjFG1C
	 fetFssT/SQz0PIE3omwkHfXOxRCWvcPoklhTlJ6eZlWxGla6wMMptZI6C5G3tXsEPatPh
	 7ulvna17Dlatbd+BZPHX93M/ZYz5BVf9Z1IuopuvZ7g2xEBkKDOvM0qv7+977LHlXNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7Xv2VtD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20EF606AC2A;
	Wed,  4 Nov 2026 22:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7Xv2VtD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC681F000C1;
	Wed,  4 Nov 2026 22:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831782;
	bh=3iovlTx8zEJcNK181vswUrd1iRLZULm4+u/ogpWNlI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7Xv2VtDcLcy5EL72r8xUAVNSfVipUZGofJ7WeVPO3wjsEXTvhnD9MO2HCx4rnNPa
	 vEKl3czPEfWK18Vf7r4Z/nr9t6j4QUzPAW9zetjABt6WwQgO8IKZ2O07LKjA+yIZ5S
	 fsqvloTa2/jC0XdEUjuydx2E86+NxYKFYAgF1bmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0909/1005] SUNRPC: fix oversized GSS proxy token copy
Date: Wed,  4 Nov 2026 16:10:42 -0500
Message-ID: <20261104211108.637799137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 62319c2534b603b416fa2aa2f3ef18c311f75010 upstream.

gss_read_proxy_verf() allocates one page per token chunk, but it copies the
entire linear head of an RPC request into in_token->pages[0]. A UDP datagram
can leave more than PAGE_SIZE bytes in the linear head, so a large
RPCSEC_GSS INIT token overwrites following pages.

Copy the linear head in page-sized chunks before switching to the request
page array. The linear head itself can span multiple pages.

Fixes: 5866efa8cbfb ("SUNRPC: Fix svcauth_gss_proxy_init()")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Assisted-by: Codex:gpt-5
Link: https://patch.msgid.link/20260910125120.3798995-1-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1085,10 +1085,11 @@ static int gss_read_proxy_verf(struct sv
 	}
 
 	length = min_t(unsigned int, inlen, (char *)xdr->end - (char *)xdr->p);
-	if (length)
-		memcpy(page_address(in_token->pages[0]), xdr->p, length);
+	for (to_offs = 0; to_offs < length; to_offs += PAGE_SIZE)
+		memcpy(page_address(in_token->pages[to_offs >> PAGE_SHIFT]),
+		       (char *)xdr->p + to_offs,
+		       min_t(unsigned int, length - to_offs, PAGE_SIZE));
 	inlen -= length;
-
 	to_offs = length;
 	from_offs = rqstp->rq_arg.page_base;
 	while (inlen) {


