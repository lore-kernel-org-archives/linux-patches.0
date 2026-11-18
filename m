Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057906;
	b=FTczsiQbbjYcRKCYUpKSppV1+5Z+S6QvZ8xJYTELl3hsQX8N6jrmvECt91iE+AjsxvaD
	 gm0zCYSjJOi+aSbbQZn5Xe97sdgd6GFIRQZxNM9GFe0fc+NudzV7kGCGlrIfg9rEOG6Lt
	 Cj9KNU8yUiAngISE0/MNGP99MP1zu73Zqywm9dBGoc5q7jsnhYK85kmz3XT8zGEkwiIfw
	 lVdlVDFGCJwNnTVuoHkLrrSvtZZz4KD5GwYjj1MzBxrHaoH4zA+JWheUmtUgNR7xAtz9k
	 8TAyWAYA0Rl26dUN6t9x4cwLy3unAj3elEL5NRlXeQNxv6BfZkC85iJqLRPSrXL4vFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4JD4H9LYlOTgsNGKM3sGuC8Yr8RjT2UiqfhgVhXJ9rs=;
	b=ju5NpRgeAIcT6yqlvPDoaPdDBy3adZUaO1+dxI6+fc6ACuH5kg1aEbD85dTOY43M0R1t
	 ujn5Ydic3P123aelAXcCF/RzEI7zNBA9foFqFSOfTFBs8GRscPwhuhnVlyNMcgvj01LbQ
	 phaTHIMg+8tNSWcttqpDsM0YjJf9oj8phwXSRGd07zFU5AX3dAE1dCTN5RXVOt8yKYRZp
	 Qc+37fr1kT0zvnk0dGZ0NdeE/Ltfzvu3v9YJVRIz10n2O+kYgWMOUyxWXbA+fSWLdAJvi
	 whzo2IUt74BadjZLJ/PkPaXcKdQvVnYtdz5AlJqZYW9liABWeH1z7VuX5HUOGuuOiXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJHgs7ij;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C4D606A31C;
	Thu, 19 Nov 2026 03:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UJHgs7ij
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C12E1F000C4;
	Thu, 19 Nov 2026 03:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057905;
	bh=4JD4H9LYlOTgsNGKM3sGuC8Yr8RjT2UiqfhgVhXJ9rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UJHgs7ijpPf1/uURfQhhJyJvZlZLcl1JORgkPx2hrry7x8J8TIGH4olGq3uwna7Ff
	 2oG10H3+kfAZgqzJr5aFgGXXqKBMrxEQXVU+EZqzq0t/lGSFhYWvkw0YWDZhRfioIW
	 U5ShLlLfVPDxYW0CNA7ymnDy+BZ9XocL66j/YJsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0295/1848] nfsd: honour client-provided attributes for NFS4_CREATE_EXCLUSIVE4_1
Date: Wed, 18 Nov 2026 15:38:53 +0100
Message-ID: <20261118145924.413961209@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neil@brown.name>

commit ddfabbc7840891e09cd500ab97c9cd36b650ec24 upstream.

When a file is created with a v4.1 OPEN which requests
NFS4_CREATE_EXCLUSIVE4_1, the request can include attributes to be set.
However when the mtime/atime are set to hold the verifier, the other
ia_valid flags are cleared, so no attributes requested by the client are
used.

This code was originally written for NFSv3 where NFS3_CREATE_EXCLUSIVE
never includes attributes.  When it was updated for v4.1, the fact that an
exclusive create CAN include attributes was not handled properly.

Fixes: ac6721a13e5b ("nfsd41: make sure nfs server process OPEN with EXCLUSIVE4_1 correctly")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neil@brown.name>
Link: https://patch.msgid.link/20260717093001.1972119-2-neilb@ownmail.net
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -357,8 +357,8 @@ nfsd4_create_file(struct svc_rqst *rqstp
 	if ((iap->ia_valid & ATTR_SIZE) && (iap->ia_size == 0))
 		iap->ia_valid &= ~ATTR_SIZE;
 	if (nfsd4_create_is_exclusive(open->op_createmode)) {
-		iap->ia_valid = ATTR_MTIME | ATTR_ATIME |
-				ATTR_MTIME_SET|ATTR_ATIME_SET;
+		iap->ia_valid |= ATTR_MTIME | ATTR_ATIME |
+				 ATTR_MTIME_SET|ATTR_ATIME_SET;
 		iap->ia_mtime.tv_sec = v_mtime;
 		iap->ia_atime.tv_sec = v_atime;
 		iap->ia_mtime.tv_nsec = 0;


