Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831773;
	b=W2hogQgikxSZz4N85e4j8O2j6Zyq2lkphOTjOo1Gtw0BSSrI8pYpdue9HFp50ioLU6v4
	 wjo9czgEeymqDKCB8IfOnLrNN0m4yLqccmhrK56UojtdQmf7qHmSxlYD3JGYsekTbX2ZH
	 KV7JAVB3MDEniIiDeNkYeZVxgYdSAsr7r0WV7G7r7MgjU4t6ril3ygipNG31ngeCosBE9
	 qdpJ2Q7h80hQJ25hpCm2fVT2vTQ+1D19/t90kRycJ2w3ciucS46uuk7sHXKMmg9mQrFOR
	 jTjm4wVwvtr8NoSOiQp/o5xvGqkIHeFZzZmcz2huv7cM840JeqrcG3bfzd6b9Wwzpzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0uIqIKsHSBo2azX4xWnWzZzrXr+tC06yUgpjzP2n6DA=;
	b=V448kTMPfBdjajj3R/k7S/oGxodDKz0y/p1Ga4ssu7uAChMV/ukvWfAcHLDQneR+MRsy
	 fFIdEM0wVIqnT4tbBY4SbQYDuH43BsLu/zGz2TPf+ECuCMaMoZJHML0neZwurpquBb8Fu
	 1+HTwvG+N5eIT8YsQFEBA2618CqRiAIJPxDG1FmT4bSknVp6aZtp7gV1EXnAvHBH37u7D
	 E5l7KVeAG1rtlsnbLScMsT2ptyNJWqAY55BDg/Uwh6ooptQXYtBwDpLauocHd45oSJCYQ
	 TV7miA0IbcNBWmkFXoFpDebbqLXiLEc6UyplN55RrvPQhkpjiiX1KZlZaxG6VAnHj2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUq7Xq5T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97916606A326;
	Wed,  4 Nov 2026 22:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUq7Xq5T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1001F000C1;
	Wed,  4 Nov 2026 22:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831773;
	bh=0uIqIKsHSBo2azX4xWnWzZzrXr+tC06yUgpjzP2n6DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUq7Xq5TF0g6K3QG+COCdl60EA8pEDULYFqM6Qyc9tjI0tTR8eSIfkPiOsfZNI7fR
	 yfnx2COsqQ5BnOoyPEKA6D+LXZo/+v29fQBkAQFF9ht2K2q1Sc+p2v0tMlsyuZ+gPE
	 B/067+/Grp4KmBY9JFv2LYJ8Vr6SWaalSv7dW2n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0886/1005] nfsd: clear XDR padding in GETXATTR replies
Date: Wed,  4 Nov 2026 16:10:19 -0500
Message-ID: <20261104211108.046856136@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit daba58690339ae86f1ebeb5197aa1369fae37e57 upstream.

nfsd4_vbuf_to_stream() uses a raw memcpy() for the first fragment of an
attribute value. xdr_reserve_space() aligns the reservation but does not
initialize the extra bytes. If the complete value fits in that fragment,
the loop that clears padding for the final fragment is never entered.

A remote client reading an attribute whose length is not a multiple of
four can therefore receive one to three stale bytes from the response
page.

Encode the first fragment with xdr_encode_opaque_fixed(), matching the
final-fragment path and ensuring that any XDR padding is zeroed.

Fixes: 23e50fe3a5e6 ("nfsd: implement the xattr functions and en/decode logic")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915160119.3105745-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -5543,7 +5543,7 @@ nfsd4_vbuf_to_stream(struct xdr_stream *
 	if (!p)
 		return nfserr_resource;
 
-	memcpy(p, buf, cplen);
+	xdr_encode_opaque_fixed(p, buf, cplen);
 	buf += cplen;
 	buflen -= cplen;
 


