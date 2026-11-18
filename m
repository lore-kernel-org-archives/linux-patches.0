Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052985;
	b=R0UEmTrxVujYLVctH2o5HhCEqaaCK//UkDADLIsDNaTgvfra41TV2auN8qxbe/59YxVn
	 aHCdT1Zcx7X6g49kJ3P+vknT/pRQ6CEmV4ky3UvKtMUGFx2rrji+j4R7b6U4vTyOcJ+X9
	 rHZ/41WrLnpeOOA4Xa3CE5+mHhqXMEMzsq7XKQ21hqqmECaM89o5WNywu6W8/rR93lCiv
	 fOSdwzJn/cRWRzbX3bNqtq4BLsTxm+hFi0pPDoYctC4viXzfwp3KtXvwI1CYWlCHd2q8d
	 T5WKqcLwa5nn2SFOGmPAREFbIpkMB0s7EBgMF/vt+WvPle087JyM/UhXrrpjV8aR3Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jMCRSvN2TWRA++2nw3+56o1e+jYnl5EIwoaL88JrtoI=;
	b=Mx7qehVdpHOhCWAPATbTfbrH4sUnOYd76nzeTJFkgWuYI50je/tat3KHqG+8x3mBpj6l
	 /26Zr2xQpZO3UHDoBsuh1ZHZ+N4pdYustWGOaoyKMs+uLTtDzKLSfHqmG0rgPsMjhdEzt
	 WxQgQA5JTm2iXtnosriDk9LZRrfFR0oNB4AsRCUig02O0rUCogBbjrBh2eD4RohHgE1nw
	 CFl2UOodq4j13A77MKI2WPdmDDJyYTRUSJS5tc3bahQxlD8SuoHekFlCasLOgTd2A57PQ
	 e78aiIhvENjP0sVfGr5UKQxyyTec9QN5bqWJsEgZ05uQHnS03hq7OUvsYK1dPAILShw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGQ3OdeM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB68606A31C;
	Thu, 19 Nov 2026 01:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGQ3OdeM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7273A1F000C4;
	Thu, 19 Nov 2026 01:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052985;
	bh=jMCRSvN2TWRA++2nw3+56o1e+jYnl5EIwoaL88JrtoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGQ3OdeMtsYKd7E+4UvX4bU33FRI+4YcP3bYxwh3UEy5Oy6+cYiOB2JTJ/tR42VoK
	 7N3bvxS6HkQuSSIMle837gCMDHkJEDjUvcw8RdqV8xeiF6YO24unAOt4D2JB0Vdtp5
	 e/m+2w4E2KJQ7VGBfhGgdadMIxkyPg6XpfXnPtso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0758/2214] SUNRPC: fix oversized GSS proxy token copy
Date: Wed, 18 Nov 2026 15:40:34 +0100
Message-ID: <20261118150042.066902646@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 62319c2534b603b416fa2aa2f3ef18c311f75010 ]

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
[ sashal: adapted xdr stream pointer and length access to argv->iov_base and argv->iov_len ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 8beca18863907..0468b9f0163fb 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1185,10 +1185,11 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
 	}
 
 	length = min_t(unsigned int, inlen, argv->iov_len);
-	if (length)
-		memcpy(page_address(in_token->pages[0]), argv->iov_base, length);
+	for (to_offs = 0; to_offs < length; to_offs += PAGE_SIZE)
+		memcpy(page_address(in_token->pages[to_offs >> PAGE_SHIFT]),
+		       (char *)argv->iov_base + to_offs,
+		       min_t(unsigned int, length - to_offs, PAGE_SIZE));
 	inlen -= length;
-
 	to_offs = length;
 	from_offs = rqstp->rq_arg.page_base;
 	while (inlen) {
-- 
2.53.0



