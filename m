Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831790;
	b=jvD5Qinn0yhfsclVNgnJR9sLHlXMZTUecHR74328mJrkoGxpXe7TvaY9SYwPHMhkFjrp
	 5pAWLtkz9nX0XVIjgDtywvJxBeYLyBOeHs6cbUJ5W9WeXoyY1iiVzroA1Rzz7yZgNlFzv
	 lbtjtYWr9wfX6RQwvincHXBC8cm+Jy7C+wHKXgQagDaZqHggwSYFHcZBdFA2yNo53K7I6
	 9XBi30a/yqtPoQC6zsjDRn/U+sMGAh3PWlHqHS7C1k3IIm1gocLmNWwFMnyu/AWeEdVij
	 STf9T0q2v4xGhTvrBhJLLxwy0WcIF9o0u79n/x8Jd16WaRek5c8CwryrEU6FiwUBJTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v6b/wJVquBv52E/A9zwezShDbhW4McjU9IdOIoEL8FQ=;
	b=MZccW0khnOeuaXIcsBLZffquz/664byHAIiocScu70FsO2PyJ9jVRc/lLrlCa3wNGQ/Z
	 H23dU3chsVlVeD+m1iJuI7NojLb01htKgln6xJiS5xrhZ3wFlbZVGZYq4sd2CAdpjRtHR
	 7Vl+xgiwilkYK+FmuJXGqLpjuEkN/3CMvhMI0zyIFS4UHBqHEWHp0faTsoYCjC1ETn+aW
	 dL4B3uICrkS9T5KdH4G5g/GYmYnV4G8KeSXM84er30JkcGdktHU8SZ+XohEozaUzRZbsw
	 g/2Ec7cr44NyQN3YNypx/kiT/soe+UDCYUyPrLRp4iw3XsHVXEDQ+VpXa28JYZeX9Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vMpn/YEk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8474B606AC37;
	Wed,  4 Nov 2026 22:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vMpn/YEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8221F000C1;
	Wed,  4 Nov 2026 22:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831790;
	bh=v6b/wJVquBv52E/A9zwezShDbhW4McjU9IdOIoEL8FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMpn/YEkcPbIKG57DZMOOefJYdnegstvWgWJRDOvthR2be7XXXZUot05RMXzB4kDU
	 OpJkJcl7364Nc47pfOjlSNV/xmkJ1Gt6JZaYZSVw4qXQjuYiYq9VWeil2n8Xrwronx
	 MZmyMQjo0nYbeSwfAWIX9piFQ641KacLp2f8i9QY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0887/1005] NFSD: copy SETXATTR data from all XDR buffer segments
Date: Wed,  4 Nov 2026 16:10:20 -0500
Message-ID: <20261104211108.073632920@linuxfoundation.org>
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
@@ -2172,10 +2172,8 @@ static __be32
 nfsd4_vbuf_from_vector(struct nfsd4_compoundargs *argp, struct xdr_buf *xdr,
 		       char **bufp, size_t buflen)
 {
-	struct page **pages = xdr->pages;
 	struct kvec *head = xdr->head;
-	char *tmp, *dp;
-	u32 len;
+	char *tmp;
 
 	if (buflen <= head->iov_len) {
 		/*
@@ -2190,19 +2188,8 @@ nfsd4_vbuf_from_vector(struct nfsd4_comp
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


