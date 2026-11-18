Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035390;
	b=sgX955r2eTga4WEQLY5eViOtEcdR+2q1I5IBYYjzwNAg/YwkGyLZRUphIQA7gR6dtbJb
	 +30JQjuWUe4B/Zm5ItUh5VaDqojYoGalCn1joC/QxmWZ6GzDEZeohJWaaoPPHO48qBcaL
	 rmvDRjLqlhbQ34aGixLwLlmqTg2BsKxZ/xm/IMAq58cWEX7+V0PUU8XqHyeLCN9SHKXBq
	 DXBLHlYr6vv5TpfEhdYaKhkY9QjetVi+UXh4LPSgWaqQj+UzUGUJU4yvxtnFd1TN3TQrm
	 WQP/tbGQO+FeA2ierzLWj+ou65JdNrdpaUABZsU3SxXI08kN8cJJIPhBUgz26P//V8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bOIW6u3eTOL+OUCzGLOxIzXsVdLnGehYwZj7rx1IZug=;
	b=FDgQqmqZ37s6cOL/bvTNGHFCz5AUWS4mZhBLY9RizJrGFrgWBR6YmG0YvwkkxsgwLx+d
	 +eRbVFY5z4VtBx0zMLM/ytCg2PU3uGs6GiM+NrIpiCbla6YfQxpr5ciqJ9U0sbxPE0zYv
	 5lkOjNdnAgyYBsDp+JQz2W7/8St447NMxNRDW7QBqBI7ZeoJwG768wPtd9tf3j7V3qMKQ
	 /gkZTWED0sL5AnVbZxDfjOB39JnaMV0ZjWpzWp+PSrOjyaIgwZHR6M0PCS974rQZWkv8e
	 wDF1aSbMvssj1AL4+BBNR8IC+iJW9MzxNfbhQvWTB/dKhrh9geA8vBxFfhYfPTpuB3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVfgFGz2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8833C606A31C;
	Wed, 18 Nov 2026 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVfgFGz2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2D41F000C5;
	Wed, 18 Nov 2026 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035390;
	bh=bOIW6u3eTOL+OUCzGLOxIzXsVdLnGehYwZj7rx1IZug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVfgFGz2u0Mdp4ekDj0JHjrNK19eCkh3dsLxqRhsKxBCr3p5g+sdlUWN7ZcO8vJcE
	 fl/JKyLbUOIUnmObBfRFw9rkqI9tTBKtHvAo8KhvWAelW1pIbaNP5UAN9/ifi8CAPz
	 FT9KVhfAN7EyyE6nT2186jm/GFR2tj1sT5DTicXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0685/3318] nfsd: clear XDR padding in GETXATTR replies
Date: Wed, 18 Nov 2026 15:21:47 +0100
Message-ID: <20261118150338.769604718@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5048,7 +5048,7 @@ nfsd4_vbuf_to_stream(struct xdr_stream *
 	if (!p)
 		return nfserr_resource;
 
-	memcpy(p, buf, cplen);
+	xdr_encode_opaque_fixed(p, buf, cplen);
 	buf += cplen;
 	buflen -= cplen;
 


