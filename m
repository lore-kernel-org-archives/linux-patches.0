Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061730;
	b=4tg1+DPt95tTAAyfsBjHDAaE8mbImCQ+/N7zl0awS+aQahc9WpvsNSDEEgCYFzt035t8
	 Cc784toSSgFOo9emx9HlRHNp/vmFfFRd4ymgQuQMp9P3uPHcixcLRyGfb+sVTCvBGq3kw
	 bkurD8OPBEb5nVGrWibtBvC5Z/SMXWDaAI5TD3OzHKlzwJfjRVIOcNQtmn5QI6N2A6z88
	 eRtTt6hrjPPy0JA4EdjexYe69ouDQRUQH7VX9LK7P5id5HfSZ0rARkTcrKdlMJXXSbs3G
	 +0kbQ7Yhp7M+CcY3za7hFoEeK35F0UajLj52fOeWzyx7x+WxoBTseQBbco5P6iP3qJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oYPqRLYehh+49EsCGkWQdTTcXdKKIOO/Q0cdxWZAlss=;
	b=c3NilHzO0AzgNQdyANSvThaU3JFhb75sk0JlaX7G937Wm5E/BRWAj5L86RacicNqC6CU
	 hgd7TK8rWUV6XN0SrHT/AyUTCaAeFvpkFqzxxJgduLhx3GV4TPK2lVohQQa6HlW9QGodG
	 5BQHVuQjgfiaOy53gTdcTl97vteO8yDAcPuEaQuofVrdVod0cwviJQlxHeiN+e5oKCmXa
	 AYDz4Wb23+iBZ/0iyVDRDLLQIqGtRhX7UAQWxt1HGRaq9fCM34R9kQtITTzQL/2WETcHc
	 W9PhrOFLxtuu6M1k3r86DAoqGOSVS5WUv+LpVqnM7TyFLj978JsOlc9HXWdDoRoLlcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sbd0CEhk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E8C606A32E;
	Sat,  7 Nov 2026 14:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sbd0CEhk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359131F0089F;
	Sat,  7 Nov 2026 14:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061730;
	bh=oYPqRLYehh+49EsCGkWQdTTcXdKKIOO/Q0cdxWZAlss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sbd0CEhkqixb/1pITAltK6AQwSkYvPuP/gIrs+ufFDjRMOOEUtf5I8Z4sd+0m3ab1
	 sFhIEgF1mtgdUoC0tPpDFNiCmNKbt0tqHqLmDrnTOUX5PX6UIho43eaFQdGJeNd4CC
	 3Op1b1ODwQAU8uQdxTRZaeCAdUjwDLsas3J5bfhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0772/1536] nfsd: propagate SETXATTR value decode errors
Date: Sat,  7 Nov 2026 08:46:28 -0500
Message-ID: <20261107135019.215714137@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit cfcfe0b38a66bbc4122c78a2b75e1b97b3534761 upstream.

nfsd4_decode_setxattr() stores the status returned while assembling a
non-empty attribute value, but then unconditionally returns nfs_ok. An
allocation failure can therefore leave a NULL value buffer paired with a
non-zero length and allow compound processing to continue.

Return the decoder status so that the operation stops on the original
error.

Fixes: 23e50fe3a5e6 ("nfsd: implement the xattr functions and en/decode logic")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915125636.2849626-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2279,7 +2279,7 @@ nfsd4_decode_setxattr(struct nfsd4_compo
 						&setxattr->setxa_buf, size);
 	}
 
-	return nfs_ok;
+	return status;
 }
 
 static __be32


