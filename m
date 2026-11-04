Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831692;
	b=1Nsl+qwuG5z8tsIyvNgPYhyCxFGZwqlXngGIqQLyb3nZKkD4YrL2UQWbyjeJzhls+Qt+
	 5i/AIhrUnTBb5daG9Piye5oiWF3dORFe3SYpcRhk6iIkZqHduUOV5Gwvum9vhobY10y9+
	 OnuBE01NFngts06Alve0uH4lqWDIckeFfc1XQfl4WY872UhcAMYgi6h73y+j6EpkQty3j
	 4C1JStCDdvEkbPJ/z9WCPRv5moea7FHfxnP8/SMQolTlVHjOxz8TNWcVcuzEgoZwDR3LL
	 M5ZqvW48qCNEkuyyd/qZTdTcl+ofQtWGgBbAnhlRUjrCw3hrieAv8c2KDFrnsoZ3XFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fKJSjyg6mDsjjM5zlXfhmK3I1sJLR+yyxz6rykYJ3m4=;
	b=ezEVA4mN6dux7diFUlMIqY6vgOd8LXgwyhlfucOYjVwl5HFgKwlxxKKpTeMGNezSuUag
	 AstnSJpOMdh4lnMCr7gEfZg4Xyhow6pu3ht+rdX1Id5+h4j7TWYDWBUC395BzqrcYQhq5
	 SaoEnNQ9/F2+Ma3ZC6S4Dgg/3vWNeWZLb/FVA0WdS0wbrsj3ik7qxWGrTqtnhrXRZ+pUP
	 fJF/zrD2Q4YT2T4oGWok/5Dp/rqCmOFLnXlR0uKWS7jAv+ak3P2LRc1IkSCYxvrjqF5IP
	 X6+WEeRs2wmZ1x1xratk03glGHfIvQXuHB+Eo2rI4rQ+XKu5mOLoKBMd/QmtxguIuPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4T0uSuc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DA2606A33D;
	Wed,  4 Nov 2026 22:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k4T0uSuc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3C51F000C1;
	Wed,  4 Nov 2026 22:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831692;
	bh=fKJSjyg6mDsjjM5zlXfhmK3I1sJLR+yyxz6rykYJ3m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4T0uSucg2QKR7mSRfog2Lk/ynJnxBEUU99lAqU27TuTadttzxPHkzSNebNTuARQ7
	 ciKDvy9E5AlkbhqOBAC7Oy+fSB8IpT33RZo6r601Ty9nvTaN3/UqQNIKtYXP/B/XuD
	 INcJ1vwh9QNUqM1MAfX8AQK8IxHmEcQe6Yc8G31U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0858/1005] xfs: init inode number for tracepoint
Date: Wed,  4 Nov 2026 16:09:51 -0500
Message-ID: <20261104211107.317330355@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit e98643f794d0d7a7fde8b29276d74e09fa0d5d19 upstream.

LOLLM complains that if the xchk_dir_lookup call fails, it won't set ino
to anything.  ino is then passed into the tracepoint function, which
means that it reports random stack garbage.  Set it to NULLFSINO instead
so that the circumstance is more obvious.

Cc: stable@vger.kernel.org # v6.13
Fixes: 0d2c636e489c11 ("xfs: repair metadata directory file path connectivity")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/metapath.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -441,7 +441,7 @@ xrep_metapath_try_link(
 	xfs_ino_t		*alleged_child)
 {
 	struct xfs_scrub	*sc = mpath->sc;
-	xfs_ino_t		ino;
+	xfs_ino_t		ino = NULLFSINO;
 	int			error;
 
 	/* Allocate transaction, lock inodes, join to transaction. */
@@ -540,7 +540,7 @@ xrep_metapath_try_unlink(
 {
 	struct xfs_scrub	*sc = mpath->sc;
 	struct xfs_inode	*ip = NULL;
-	xfs_ino_t		ino;
+	xfs_ino_t		ino = NULLFSINO;
 	int			error;
 
 	ASSERT(*alleged_child != sc->ip->i_ino);


