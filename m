Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044541;
	b=waN35ZJag6JhlkTGLWkpXb35BiQmZqocZ5VE8mwg6/6vDVohhP4VUaC7idNYpkjTukRX
	 bya5ZeBQzzGfUYWPTd6cwZKhUBBVw+Klz9EnTuhlZN18N/QE2bT4fheaZwdyNqynu3zen
	 eXdFLmjmeBYzj+JKH6Jzv3NU1RBQB6acr76JA0Gs4cETUJ+UTE7XeEFBOIrcTbW3i3ls4
	 1JaxvC2ykLeHimjrLbquFviuYMX/tRNFYhhysWUk5eUcOQXPxcUsTOc/YmjjJfIkDyySU
	 tNT1OnsEEw0mZQ46eiBuvG9T1tlFcg4O4wVwFO3v5uc8vatZBWVnA06VoOo3dtVyixw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044541;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6lihO+I0WNr/oDRG54GxRvHDxbrJwqVc8fl6TBlkNdI=;
	b=TQ1hB5LtFPlGeWa879gMe1BVGgBbEdu57t7bo00KmEweUnY2pPK/LUZZMPpEXfKyI4oC
	 m5p7uzr5P+Pomwz6qvwzn54Com/6WF44pt4EnPM8KpFyZEc2mgSYN9EZvZiVOaZx26Uwe
	 TyfC2Bt73+4LgCf5p+7x0++iDwN/B0gKj/hbDRFAGwMepTRWQdeUu3jVxlTvZB5uIEg9r
	 KgaiOjPKExJ1xiSRAj7ElHVpx2Ic1FH+A5QnpAREFg/45uT9E98KWinQB2nraa7cUTaKy
	 ed1NZgee3PAuetJpo0+u1+ux2z6tWC12sX0Pp1ZPXesnGGEmGegpIephQhzIATUU8UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKQpfcRM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB44E606A325;
	Wed, 18 Nov 2026 23:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kKQpfcRM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8691F000C4;
	Wed, 18 Nov 2026 23:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044540;
	bh=6lihO+I0WNr/oDRG54GxRvHDxbrJwqVc8fl6TBlkNdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKQpfcRMtUsV7crvEdX1vSm+c2+ZwLWzs1985bGdvB3lxTsAH/Hx1Xy8NuxC46sK/
	 1GcD1y/is2B7S2rwtb0HS/ZoJ5RIGR+LMTzj0I31K/Z4P17czgSshdM6Jd/SaZfiHk
	 cmT0LPOGV/NxdWXKl2T/mmQ0ZHRg1DKeDTLyaeqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0603/2857] nfsd: clear XDR padding in GETXATTR replies
Date: Wed, 18 Nov 2026 15:27:17 +0100
Message-ID: <20261118150223.205113235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5044,7 +5044,7 @@ nfsd4_vbuf_to_stream(struct xdr_stream *
 	if (!p)
 		return nfserr_resource;
 
-	memcpy(p, buf, cplen);
+	xdr_encode_opaque_fixed(p, buf, cplen);
 	buf += cplen;
 	buflen -= cplen;
 


