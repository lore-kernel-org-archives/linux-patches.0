Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061714;
	b=jta/BdrTqWSWS/eq6QmOO/OJAe3mYI8G4WDgtaOad/PVwAFJrETrkthcYglKc88Q9UFR
	 SlFJiKLzbueifB2wAAKYgnole1+T1cP9nTxmVMiVqIapDhm6F+9Lg4TktQexBFBEcBHxX
	 7RgIAvzyS72PyqkC21TpAL7/BUubTL40KzlnMj8Bnvg5DNBkmfwRRLtmvU8uWQ+yb18hT
	 LcAU9gYRcrrYj/7iRGZKG4mXFWn3dgNy6XnehRGJUe/3o8BhQVq51p+6UWJ3QAPGi1nRm
	 Lnl8YINtY8aXWTA9gxK9sgCjP/Po6BSGzXd30HLXEa9uEE9/x+lnLJ600ydGDcf6TNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=961WekF6F7XH557FZK2n6IJI6kkl7U56/yu+D3T0eeA=;
	b=Ber4v4sR+A9HJQ7HbnY/KvvW3IZe7QHwFCjUQWGQ4uUcJdYEP4FfTeJl1nJe0W+IzStA
	 PTAFwXQxHsT/tIxVCwGaeJEb/URnU3krk5zCZ2bJKzXKsI52BZaqM++OEpTI59IIZgMwC
	 preKvXP718HtFxhO559XLvFkodv3++AAykXS9nr+po7WdtvJgIJZHVb1rfbJqIgF0AHxK
	 WsH0h7iYK+piBByNVkJoxnjXFgCZLSGyUGJg1BqdXFBJQ5nStw7MBEikcJVKJpg1Xd+tl
	 3axMsd17jNuBUnCbH3bwQG4ZKFKlPnD1yLk2BhE/mSJdQCVAxR+miPOjXGlPwAZ2uVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+cw6T39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EB6606A32C;
	Sat,  7 Nov 2026 14:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l+cw6T39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45F61F008A1;
	Sat,  7 Nov 2026 14:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061714;
	bh=961WekF6F7XH557FZK2n6IJI6kkl7U56/yu+D3T0eeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+cw6T391cfig3e/ZS8PkYlwE36e49Fvrk9czVHUKt43LNJMxzD5au0K+0sgGb5gS
	 +byNZmjPAeKclDXZkUsl37tSBx/ajBStf97HiUR3U6LK1c4KZw3XIIx7EJHrc7R7e2
	 hZNi2+1a8IhZrtSQ3vr4tEfp2tgKJM8hklJTFqLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0761/1536] NFSD: copy SETXATTR data from all XDR buffer segments
Date: Sat,  7 Nov 2026 08:46:17 -0500
Message-ID: <20261107135018.907076292@linuxfoundation.org>
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
@@ -2145,10 +2145,8 @@ static __be32
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
@@ -2163,19 +2161,8 @@ nfsd4_vbuf_from_vector(struct nfsd4_comp
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


