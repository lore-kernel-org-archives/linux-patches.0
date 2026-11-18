Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035432;
	b=d1OrUKnv5pj/QosfoM+0wzODOvwm9hM/pryY85WNYZnnRvSFLxUTdN9b7sGuZswC6wi4
	 crPCkaT9nXCnhhJuv1alrki/6m6A6fTid0Wuc2CJZ7Xy/fXVlpk42QOSdGhYggCik4Bvb
	 LT82vn7Iuk1pn9OLp6yizecEJGrWI+aJfXx3f+HaV/qFRxsFlqI/AWV62o5vGcBxCLDix
	 ej0a41nQf/47u87U8h0N1ZdF4s01RwxAlHnhC+5QBxinm47EOnVkmuEjhp3G8LLUPDY6b
	 +KI2eD9eBsRpGKQ6fKrsfc70B4R/duwNe3FUnOX3gm80fM7h3VBRgNJL0bQXUzWjpxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yXa0YGaG0Hx+c4U6kkLQDEBN2pWrlJImfYUPaI26AFc=;
	b=jVmMi7Wwka5dE7oMri68Z8TBhIOq1s/r8eIF7Ge7YmeVIrwIqUx5hj2c2i5cfNwYUkuX
	 R1YlCz2GL9owkJhdoMnqbo8yVtdlOvgpFYDGvyVemg5xiynQDec75kxqmiIH38Q5B1D56
	 hgZ+q7R8gOE29pjyLGqJKFk4cWk8o+yUqM5oaL6F3z1SpOi47EA8pGg/1DuV1bWaJFrsJ
	 RKwS0aiM8nU3dWvPxAEKNpaHNIHMEFZg1y/UhaPe/31vyddL2fcGvikj0mQrPYirpKvBH
	 9kQU6FHOPg7GPdYhoImuUwKgqzKbYKsGGCDTCNu3B8zx0it+o6YxyXl0ehqqRWTJsXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITH3bAML;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C128606A325;
	Wed, 18 Nov 2026 20:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITH3bAML
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AD61F000C4;
	Wed, 18 Nov 2026 20:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035432;
	bh=yXa0YGaG0Hx+c4U6kkLQDEBN2pWrlJImfYUPaI26AFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITH3bAMLyIAIyAqEQUPDn1QJEyC45EpplvBDgPfi+FqEPA93qgnZu1IwLbsJed01h
	 mq6IMTcD1Oyh7x304URxgEacSyrrQ49ZIESa+MwvclXi3O0ibmJE75TycigigWD4EJ
	 Q5yr9UUtV3XmPy2YJ03wpWeLwVQ799afwupvo1gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0695/3318] nfsd: propagate SETXATTR value decode errors
Date: Wed, 18 Nov 2026 15:21:57 +0100
Message-ID: <20261118150339.169699619@linuxfoundation.org>
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
@@ -2251,7 +2251,7 @@ nfsd4_decode_setxattr(struct nfsd4_compo
 						&setxattr->setxa_buf, size);
 	}
 
-	return nfs_ok;
+	return status;
 }
 
 static __be32


