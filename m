Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061742;
	b=QDJmWVdCKZ/pfFFE2bVJ1gC4l0YF1dLyCjcHaZ5qRcH5ukzR9iVwl9IZkECuAdUxudMJ
	 YL/iVGRnbnOY0JAX5Wmbfy4Fl4ihnr+r0gkyfi/y+BHAzP7j8zhrJHK0FHjyls1Y0YATi
	 zwiP9XDlawot98CvmTMJrks4qz52M+hO/TDJ0lC6Fl3JJqqMzcevWp5oy8AMnwDsDYdgh
	 7hOjccFF+aqS9+SrpI/nXaYWe2Qpb4jPagDg28FJlZRMQ4Gv8x50FeOHy1lyQ1CUPLPLI
	 WNJO3fizd1WY44/WHwlEKy2aRwMe9advEYtZtk9G3Zl8l1JWZhgonMgKBMZ3Zco27gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=s6yGTVRqdEFp0W0vs24ekBrICiHKQfIlC6sYTU3JFLs=;
	b=apjxCg1qoO94E9pcvVEV7JIX2irYTby6fvws36iurg+/tIpF7O14QLq8v1zTkUaRnUB7
	 HkjRZQAJsKGzgilYxo/jGzQ+3Ur4PF48oiRZVzwtpBF8qwr7cA5oh8qZN+h5wbtrMxIAM
	 fwD/QMRWmkf5xrFIZdX/ZvdILjD3QG1TDfqcKCOeCZBa48gn6JyblR8Eu0HWajLQJHF6V
	 vKkWnaMIsOapopsNT4KKXIsNtlhbGBFUV4N364hLGAZEHbs1u48TZBiOqFOSNHzdSvSr3
	 Eyx0BAT4RU8HqU/t+S7k8B6fjUVjB982+VLWoQE+4IIZZDfigHpJMSRSAxPXK5WV/FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VvZ+nJsq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F31606A326;
	Sat,  7 Nov 2026 14:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VvZ+nJsq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D56C1F0089F;
	Sat,  7 Nov 2026 14:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061741;
	bh=s6yGTVRqdEFp0W0vs24ekBrICiHKQfIlC6sYTU3JFLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvZ+nJsqnSTCD0eqh9IucYq7rLQH33IjqwMW7BaavWjmeBLJOXy6hu4ut7YeAx9Yp
	 JXqPhUB0/HDLSPPVuc+eXyPXqm6IB3DL661WifbnU9P2Nu4Pcyc8nwb20rSvo7SlsO
	 IvJb4MdYZAQhZQb+yN9pI2q34Xm68/7/C+cr1jNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0781/1536] SUNRPC: fix oversized GSS proxy token copy
Date: Sat,  7 Nov 2026 08:46:37 -0500
Message-ID: <20261107135019.474443249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


