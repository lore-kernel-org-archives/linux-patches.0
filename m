Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044544;
	b=CIxyi5uW17jsoRSWmFr+SvDTx+SizCc5xOV9cWfyaVbX+l0xX0tJanhhKSobGr2aG3cx
	 3gVNkCs1YhJQ5X+4iyNrSK9ttvCy8e4YQzG9XofJ5Hhr/d7FEnwHAIPD/Dhuj6qKXIuXN
	 d7t9IiiHYA3mzILP4guHFqiRdYsIFdTyCI56vIrsgqjVfWSJs6Fz4KXCM309AGuNwg4Be
	 sRnk9B4vz5RUDtMfGEfUkSTk31DISIanb6bYbgKGpmIpsr9f8EDB6xItQCe3oqHkIQ6qC
	 STnPJA39gUv/MIsySi67UkeSc1qRmCuecMDooNhvXYl0v3Nwfc0dpWoR5KhUSKxf27w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HYVUBjRWJpuqOJ/v8yQzGW5hzbkNFcN+5xqf3IOrmMU=;
	b=c07R9WT41DfWqgnrtRYOjv04ufqrGJL+fGBgj7R6hjntKga2McI5UjzuCqhS8HbwFQpy
	 LHmmNBGUFKL1zlycjMcm0Qrhqx8+KJFTqpuYD9xRPNqX3gX8tajxWQTHVcXXfH3hV7ef2
	 iy9vEoxv+uMw65GJPaRg/OXQLDg++VtnD5kv4Xh4q36wLW+yJd6//bL6CE+2KgbvCy+oR
	 Hu9PibDWEpLeA2uab1q9zwM8l0jluwMYdXU90ms+yCH5bXi3bzVCKwpHRR/sbkxGtBcjg
	 VN/44kL5zIm3yQv7zS/RiywdkhYlaifhCKHnyL6ipKWfw+yiiPLZ5OVynqlbgsyO/HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAhob7BP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDB6606A320;
	Wed, 18 Nov 2026 23:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAhob7BP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BF11F000C4;
	Wed, 18 Nov 2026 23:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044544;
	bh=HYVUBjRWJpuqOJ/v8yQzGW5hzbkNFcN+5xqf3IOrmMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAhob7BPT5pKTqEl8Z9k3wKeG1vDErH7mG96xeC0U1FHFIt713y47tG7yFtn+2Ri8
	 lHUZtJNX2w0OFZ0pbEy+BAXSuh7iotNHHcszPhgPLFgfIaaS+YXIxJpofzL5CH5qVr
	 sEebpG4EE/4sJs7jt0xM1d4+TdN67lvaiyJJ5Rkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0604/2857] NFSD: copy SETXATTR data from all XDR buffer segments
Date: Wed, 18 Nov 2026 15:27:18 +0100
Message-ID: <20261118150223.240517648@linuxfoundation.org>
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


