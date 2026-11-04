Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828981;
	b=hVy+arwVMjYYEtLg4E2kpJBWNtroEhBEa9CWMEF9lotUnXPe8cWbpbOq9o8C6sbLLXTP
	 GODqU+yFJ5hCgMYWwPFg6oIeYC/ji5hJLmc3JxEoNVz+g6ih5JJlde8mjhVOfnA/lmIfQ
	 Tzv82M1d/CP1/Dq678lAGqvaX6UxLKXNZk/mw/UZBFjKBFgsOerUyqHiNdoTiJGAsSYtO
	 FHo9K/JL4furjlpD57uLyLyFQhP40PH0vDPuKI1kUs3w4YLBy4tx3kHseFh8EiIiJgvKv
	 CCyikWFG02+KK4ANcRs2ig9DaeCkDn3KFj+EcQYZQuhjMnBoaHRSwajdrfzNZfZ2j4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g1RxMc3RCkm48g9Rh90g93EbhzaogPZhiBEpKvK/dMg=;
	b=t9sno9xLD+PyW/VjVjJIB7BiDyFzE1ihZ+YAWEzNADtdkOuEInh3PfoOvBnxfLmHsscW
	 f35TvlFBS0P1TlzE00CSIBWuxOBDEpwNtFgoXxB25EL+XK7PZWQz13iq19gniM+Uaj2J4
	 FYhlYTQd1GwOHl7PESFp/AScslgXY6Mvfs53QqWeFfED1O0+DTOG9jORUuPvTaB0OfoBh
	 AY9/GnJIk7K91ckU4g/yJfkBtQ9jWbTGtm0eO8Fqv48x5cF6VxU0ya+MTgmfJ0hBrkJY/
	 gGKPea9UCIEkLSrB4jt35HC57NiwSQvWD7IPYqOSnFOuzONWAKgIcAjFO/F/sE+L0bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T/HFGxmL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63B16070746;
	Wed,  4 Nov 2026 21:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T/HFGxmL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479901F00A02;
	Wed,  4 Nov 2026 21:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828980;
	bh=g1RxMc3RCkm48g9Rh90g93EbhzaogPZhiBEpKvK/dMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/HFGxmL5O/y7MKPe63WbW4FTuUC7lJ4dOJIf6a9LvlmGIArkQezZRWRqEEmX4tDc
	 8xzFXY50Qf77SHy3Ry1FR/Z8Bq+fNkXMEl4+KDEi99MPzz1anXD+DJl7eEE1ZkYNC5
	 rMXTVjL+kbVlctJDXpUpaltsMZx5GFvpKwWgHTSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 367/547] xfs: init inode number for tracepoint
Date: Wed,  4 Nov 2026 16:09:11 -0500
Message-ID: <20261104211048.721623873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -522,7 +522,7 @@ xrep_metapath_try_link(
 	xfs_ino_t		*alleged_child)
 {
 	struct xfs_scrub	*sc = mpath->sc;
-	xfs_ino_t		ino;
+	xfs_ino_t		ino = NULLFSINO;
 	int			error;
 
 	/* Allocate transaction, lock inodes, join to transaction. */
@@ -621,7 +621,7 @@ xrep_metapath_try_unlink(
 {
 	struct xfs_scrub	*sc = mpath->sc;
 	struct xfs_inode	*ip = NULL;
-	xfs_ino_t		ino;
+	xfs_ino_t		ino = NULLFSINO;
 	int			error;
 
 	ASSERT(*alleged_child != I_INO(sc->ip));


