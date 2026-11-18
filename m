Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058797;
	b=JMcoTOmHXweRpcyvWpvGdF9PWR5M8eVuKMi3UST4ogsuYpHK+v5hN1n2JGNdd3XL7W79
	 /79lJVq9c/bN7vpSd8Rg54Q3uHNUUN1GYd3QcoyG9HaE39eCf+n5AqzLIsW5DzjcV0rn1
	 XJBlE7II0YWT3CIrnfTs9Wbw+Ni3TVscgaSw9ainqok6KZXlE7ZxGucppFL5I+AU2n4Qx
	 M1mkmSrd8NyfCFjuR4+Yx2ouP6nyJRd+ARMroh5cz9QStgjZG9Kcv3okiLnEWIq1Ye9bB
	 5DBznIovGhU96tcxJlBdBGjJBuCvX8nkFMBhW9qOtIEK0XhtwNc/HR8Sr5zAkQWe3AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0rFOy7LUE6mMwrodntZs8yEpW6AVdId5lwJVEiVVhm8=;
	b=ZSMtGLWYNVmbm/Fnee4vEbszPhf3E+jZyquOFrtUWMSat3jzppWU7OUKQT7dCw2eUfr8
	 Woqms94JzJgvjsWqNY2Mx1Ch1Q0ZfiA0O8xjkcKgjv/qRFAgxS+A37bVk/t/Ge6OSw8Xk
	 4y7WkkioKeKxhlvKIQE0HYr8LO5UcsoUda1/LjSeaGvv305sKQooM0F3gmTnS3WIY/jYl
	 beGorwn2vUuKz3VqJUvv7pGRLimnPes7QfobMAs8fCsgqec9xRFiesdt2n4H3d7bsjy6D
	 GLQ1ZjADGddoCam/ehHkcPT8l6EbzyQq64F+N+1CXyCPbpbZUwyzpKk7Cyb2lh1KxwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxphsjuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA26606A31C;
	Thu, 19 Nov 2026 03:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HxphsjuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9771F000C4;
	Thu, 19 Nov 2026 03:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058796;
	bh=0rFOy7LUE6mMwrodntZs8yEpW6AVdId5lwJVEiVVhm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HxphsjuLt8C8xeUzlNt3wRy4ILkJSWfNikQLsOJqMNOWNTt8fK94JI3oaOxcsKujI
	 PvVczC+D4ltOAoxEwE2TyJwHUYxUkCeqaoipn4KcKNyIpvHeZfez/5zpPHK32DnvDr
	 3Trgdiy3sgVc5zGy/fHfzaeoc8atXjc20nqw+c1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0612/1848] SUNRPC: fix oversized GSS proxy token copy
Date: Wed, 18 Nov 2026 15:44:10 +0100
Message-ID: <20261118145940.922325915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted the copy source and length calculation to argv->iov_base and argv->iov_len instead of XDR stream pointers ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index ab99ffb464ffa..8ebebbdef911d 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1183,10 +1183,11 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
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



