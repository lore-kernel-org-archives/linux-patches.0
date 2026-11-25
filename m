Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617729;
	b=mAgKFPNLtXD0uLstVfssfzJvjopwDAuYaHH9S3W4fj/a99ELj7FtT1v0cYxkSfr/dJ+G
	 Ztn1+UpVHda7SLR5AVubyXW8SETA7UkJJXzZNM9q00huvaHJARvzoHZ/SapZRzKBHvXFz
	 pjuUllTpn7jD2dtnSUS9ziig2PMLwV7EWAFczgc5QqwYXVhC0CZUAalSspHOT4rj2TVoS
	 mgqRnZwGZawNOtw9og3KXcW5/61YZp2OgHaTXwj9n3Ffhmx+kjGKoUD8iY786hEHCyqAU
	 BVQYHgNTX45ijrviHvFbcv9gXz0hWdthnUVpqnglJCTWFHuYYZ0/b9G9gikTmrRQpNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3YwKoPT73KGPzSQftHkUjHY4CEOOTzB0M1D4iAYeyKg=;
	b=ywTW2fQteGcvwZ98bexERqMzkDuEXVCssIixM0SBDZkjPJcfzZO3jPo70LE19m1aC3SY
	 hKkeOD3sMkOrrVnZtrFP4dct9GkSaH7C2GKSH6/jnf0a+56jajEzP9uKZouBsjbuSm1IN
	 uZEY+EsYAwUz2gS2xHbBRcQYomgTsHPyG+GtXZNB1L5bA6balGDz3fccfSfQoQ/cMexct
	 5Nrvqn4nrl7L7gbyqPR13T5p8iPzKsdLQcC+Nj6YPnGhRkXrRL2upMIhqywPPy1HTO2xR
	 UE6e5J3KtrtiY/FVyhFGnn1CZi1RoOvPfatAk0Tp/EYhW9s1EAkZX+XNKybrMMdGxhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kB1/Ily8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D369F606A31E;
	Wed, 25 Nov 2026 14:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kB1/Ily8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9951F000CA;
	Wed, 25 Nov 2026 14:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617729;
	bh=3YwKoPT73KGPzSQftHkUjHY4CEOOTzB0M1D4iAYeyKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kB1/Ily8inl/2VpEpydlNGi5wfU4KwvUGHveP+qGMZVQz7TP8E4NojAG+Su/uBHma
	 R6cToiKw9jrgCK/pLGPV4m9uN1siZe68YN+YCi686lWhFtND5vGbpFowl4YmkuN/D0
	 HgcoL+Rk2hl3TZgTYtZhyG+yKxl+ZqsMebAENVdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Barret Rhoden <brho@google.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0055/1005] 9p: treat read return values of 0 as EOF
Date: Wed, 25 Nov 2026 15:23:13 +0100
Message-ID: <20261125143823.031030580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barret Rhoden <brho@google.com>

[ Upstream commit a3a6212c7d67baebebd0e4c2cf2ae1b75eb9231e ]

If your 9p server shares a synthetic file system such as sysfs, the file
size from stat often disagrees with the actual file size.

Treat non-error reads of 0 as EOF, except in the case where the request
was for 0 bytes.

Tested:
	git@github.com:hugelgupf/p9.git, served "/" on 10.0.2.2

	bash-5.3# mount -t 9p -o trans=tcp,port=12345,cache=none 10.0.2.2 /tmp/foo
	bash-5.3# cat /tmp/foo/sys/devices/system/cpu/online
	0-47

Fixes: eb497943fa21 ("9p: Convert to using the netfs helper lib to do reads and caching")
Signed-off-by: Barret Rhoden <brho@google.com>
Message-ID: <20260702090941.1298188-1-brho@google.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_addr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 13cf87a5f90cb..a48cc34b9a23a 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -99,6 +99,7 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
 	char *target;
 	unsigned long long pos = subreq->start + subreq->transferred;
 	int total = 0, err, len, n;
+	size_t to_read = iov_iter_count(&subreq->io_iter);
 
 	if (S_ISLNK(rreq->inode->i_mode)) {
 		/* p9_client_readlink() must not be called for legacy protocols
@@ -131,6 +132,8 @@ static void v9fs_issue_read(struct netfs_io_subrequest *subreq)
 		__set_bit(NETFS_SREQ_CLEAR_TAIL, &subreq->flags);
 	if (pos + total >= i_size_read(rreq->inode))
 		__set_bit(NETFS_SREQ_HIT_EOF, &subreq->flags);
+	if (!err && !total && to_read)
+		__set_bit(NETFS_SREQ_HIT_EOF, &subreq->flags);
 	if (!err && total) {
 		subreq->transferred += total;
 		__set_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
-- 
2.53.0



