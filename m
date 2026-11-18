Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035558;
	b=sY5IgUk6CY2Z01XzAcvxUNXUs6dulnh5mUz/gY8c537Uafa6vR19hlFqmgWqDc4Ocj4J
	 YyN+KPdlWpH8aybDy57H7Q6pU4KlSJjNKbB27NJBM8muo1dUoaZm48Rew5hqVKJCA19OF
	 kWipCGjLGh+YGAV6kW7GSQ4OFH1Gv4evU8ubXIOXWogYL9DER8L+AUowZTX9BrUYJuCM1
	 Rq52DBa/ynu3yoYO9g+I0zniYbsr5SISFQ9Vb+5FtX9SHuM05M0NiJyN24KDIimyLjj01
	 SfmN694LgZJiJdYV3TsiYo/oXoCDNeGQ8f3d9I2yd/Laczo+86u3p59qB3HkI152kfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JmQ1y4KpZpLl06RuMkL+WRDel0vVD3cOYMbUK4Bm9/8=;
	b=WZGnGZfenlwiAXMvnbmeWiLVza1bIOw59+Rl86J56aHqxhi/oAn51/R/vEVKaLuNjMUp
	 O4JtaOVW2P89wdQjrR5VzrFlOevx8ku2z867aoHOUTa5B2dug1hhRnia0dAokHRHqz2bP
	 vLGAyGG5ogGMa3AoPKDHSm08RMeVnfd3rq1zBMttF/JOtM6U6zDTO4tk4NCMMb0T+T2dx
	 3rYb0uRzbCUm9uanZXcnoZSMUYiEd3pskC/kEbGMVd08FRFw1EmvBICsda4xRW4yR6YyL
	 p8SCVM1UmVKLm9S+ZDoy2JA0sSfx04NC12phhLBESjFB/QvZ0fh+GWYiEFVJLIbO/uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ffbY8znU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558F8606A320;
	Wed, 18 Nov 2026 20:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ffbY8znU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46721F000C4;
	Wed, 18 Nov 2026 20:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035558;
	bh=JmQ1y4KpZpLl06RuMkL+WRDel0vVD3cOYMbUK4Bm9/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffbY8znUi9jrmebQ2WRipivLbvYN+hN8XEDiiopKPyT+LIVB0l5Ch9sD4PWsUEalh
	 EjNsoA23vMa28ZrPjRdkYI6FIPga75hkRzELN2jzkcItYj8ILPbRFAVWyp69CG9dVH
	 chVgU42O7QONUYXTiqjmWR0KYhzf3PSaFY9RKIWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0701/3318] SUNRPC: fix oversized GSS proxy token copy
Date: Wed, 18 Nov 2026 15:22:03 +0100
Message-ID: <20261118150339.392462348@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1095,10 +1095,11 @@ static int gss_read_proxy_verf(struct sv
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


