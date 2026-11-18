Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051834;
	b=dPaJ3LERUr8y9ZmV1OZX+3hA0bsqc2VoVbUm3jrMTSIqI9P7KzU8PNSz3QoANnwE5U4+
	 Ms/vHNm8/9xlH+TiGYRENUEScDLxncqHzyjYwd7H0/sWiDxRvMVRanMWAGhepQF5PVo3p
	 T6YOcxkqNMOjy2rWUbUYkVJedbIuzw3cHLV2CbIbJz6uW4ryE2XJIuXanWk9Jf+MSyU0B
	 ZaRH7aSTpdmIgsEjKh5CEiUksHQ5xXqpXg29TCjyDUUtgExHl/Ws8+mCnogLOX/g3poAG
	 pFkpdpsVW8HlND+IVbwG9PxzmuUaIjh4YNpi3LcBsWfAHx68+HiO0NiRXHXTAP2NdLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SyFUSRnYL0Opoyidoo/v4pODsgaeH2aYPEjYmbzZJAs=;
	b=OqOcKg9mvw1+LCGyf8gJCwdjVuRSs8jlwQ/bHqX2vNCTWJD9g/53vQ2HGXN/Ig2DdqZf
	 NOZN8SGSCrU8cQDek10BrBO93USssftq5wBJmkdW+xrAzLFlfFaJDX9wbMpywXwAtR6+m
	 pDTLQUQLbMALXXnm7WM5iucLIPb5+lLwPf6AM/u04IhdRTyGpHn2wrFom7TQKDI+wJ47f
	 9sgTmnbNqI+k1CmGoKDlKXe5URtmiGOuT+wF3uWi6fs/lEmu1WkziauyVozZ+EdFQW03D
	 11uVAXe8iVyexLN6xtqQ02PBeGmRcRlMOgiUjMIzc5S/B5WkHtfWVW59NOke+2mQ1Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0IOGTox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E413D606A31C;
	Thu, 19 Nov 2026 01:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d0IOGTox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046F81F000C4;
	Thu, 19 Nov 2026 01:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051833;
	bh=SyFUSRnYL0Opoyidoo/v4pODsgaeH2aYPEjYmbzZJAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d0IOGToxAfKZqWeHKBgaRPAPfutui12UJhT+ZelR6aklWeNi/AnmpghpsepVe0/2M
	 JsxUCQ3BvX89UTqKyiivdLeNT++URhsaMkvUTPgjoeRPoog8wUuOpHCbAPiZx7X9kI
	 hGQARmJVkBS1yuhsHCr8xUcswMyMTkwpyeJS/BDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 0348/2214] NFSD: copy SETXATTR data from all XDR buffer segments
Date: Wed, 18 Nov 2026 15:33:44 +0100
Message-ID: <20261118150024.628385115@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit b01319947c69b0e3ea0fcd4b675eb892f9cad8a0 upstream.

nfsd4_vbuf_from_vector() manually copies the head followed by whole
pages starting at offset zero. This assumes that all remaining data
starts at the beginning of the page array and that no data is stored
in the tail.

However, nfsd4_decode_setxattr() passes an xdr_buf returned by
xdr_stream_subsegment(). Such a sub-buffer can have a nonzero
page_base and can span its page and tail segments. Ignoring that
layout can copy the wrong bytes into the value passed to
vfs_setxattr().

Use read_bytes_from_xdr_buf(), which observes the complete xdr_buf
layout.

Fixes: c1346a1216ab ("NFSD: Replace the internals of the READ_BUF() macro")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260915160022.3105295-1-qwe.aldo@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4xdr.c |   19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2117,10 +2117,8 @@ static __be32
 nfsd4_vbuf_from_vector(struct nfsd4_compoundargs *argp, struct xdr_buf *xdr,
 		       char **bufp, u32 buflen)
 {
-	struct page **pages = xdr->pages;
 	struct kvec *head = xdr->head;
-	char *tmp, *dp;
-	u32 len;
+	char *tmp;
 
 	if (buflen <= head->iov_len) {
 		/*
@@ -2135,19 +2133,8 @@ nfsd4_vbuf_from_vector(struct nfsd4_comp
 	if (tmp == NULL)
 		return nfserr_jukebox;
 
-	dp = tmp;
-	memcpy(dp, head->iov_base, head->iov_len);
-	buflen -= head->iov_len;
-	dp += head->iov_len;
-
-	while (buflen > 0) {
-		len = min_t(u32, buflen, PAGE_SIZE);
-		memcpy(dp, page_address(*pages), len);
-
-		buflen -= len;
-		dp += len;
-		pages++;
-	}
+	if (read_bytes_from_xdr_buf(xdr, 0, tmp, buflen))
+		return nfserr_bad_xdr;
 
 	*bufp = tmp;
 	return 0;


