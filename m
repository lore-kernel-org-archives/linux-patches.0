Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831554;
	b=HOMdj04HA7N4cCD7CIDjRzloczep+alGYm1nXqnbSmoE57TOSfLXO8ng9kAq8eZ7+tqk
	 kEjNWZO8p0d/CGfDR2ay5g1Zke7FGVtB2seFtH9IZkNgLRObrB6HSygyHH5xc4fdc5csd
	 u4xXFcS+FaEp3j/L8kKWS9wE69IhuHPboMba2TipiOVQrl6G0xf9TFyQFz3+Kn10npj8q
	 9qqcqEOfXAUzv7TqVHR8MoAgljDOhU3ZeEIcTGxe1hh4WgMLP+u1VHzx8RKy5hdqaIvLO
	 8fP4ISnbTz+FZmf4j+XV1WbSYaeenVljC5NIF4xTIJzBp0xGl3vl2BjSJFGzUNEYEsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=skAYuL4YVJkdbrBdsqGzD50YJfyjp/3truE9yL6Nfts=;
	b=u9d8TCacQnhcmWPKqWyNzxwZQGXSmFmuhiVSX/AKnDeorRmRD+nbEICkynPG4m710Ps6
	 wRZIw+2i2v4pe+dCTfvI0ZmR2qdxJHCmK/MXHMP+mzwQMeDb664wbVla9ueSrqhc0L1R1
	 mX18ijw4Lc0Yu94mpnYjyPwQZ+5MWZsYN+HXgcCITho5dAWpmWRNWR4XxF2wz3gSw4rCM
	 6xaq2IZhqPIyvDjPlc3HoLO7RYUpfQsWKtfEzmOpXAjBld0cmb0lTJahrN49A9f8I/L7y
	 xw5MMvyRroajPcHpA3R8Zl8XMYjVQZGS9s65LXDnurPkYwV3+3SMQh9CWkhXUxFzOvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GY83yH8Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE49606A844;
	Wed,  4 Nov 2026 22:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GY83yH8Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677761F00A02;
	Wed,  4 Nov 2026 22:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831554;
	bh=skAYuL4YVJkdbrBdsqGzD50YJfyjp/3truE9yL6Nfts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GY83yH8QX3V4XK5Bf7H0E5P7c5q0EA94sekxIOQBHTGP6seqUwoLucsTDtrjQ8US+
	 /SMla5N5aB4zte3VdudHtCxDL/wQROTx8iJHD3f8nUCgVwp58J21jiZeRXyfBlrObp
	 lG65E9KZT6fbyL2M4SwCuUcBVRDPpH9yDKT3ZX8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0773/1005] xfs: clear the symlink zapped flag if inline symlink is ok
Date: Wed,  4 Nov 2026 16:08:26 -0500
Message-ID: <20261104211105.032130788@linuxfoundation.org>
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

commit f8d0d90f2e24b1f4a14796ae63cebfd820cadfcd upstream.

LOLLM noticed that we fail to clear the SYMLINK_ZAPPED flag if an inline
symlink checks out ok, even after a repair.  Fix that.

Cc: stable@vger.kernel.org # v6.8
Fixes: d9041681dd2f53 ("xfs: set inode sick state flags when we zap either ondisk fork")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/symlink.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -70,21 +70,20 @@ xchk_symlink(
 		return 0;
 	}
 
-	/* Inline symlink? */
 	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
+		/* Inline symlink? */
 		if (len > xfs_inode_data_fork_size(ip) ||
 		    len > strnlen(ifp->if_data, xfs_inode_data_fork_size(ip)))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-		return 0;
+	} else {
+		/* Remote symlink; must read the contents. */
+		error = xfs_symlink_remote_read(sc->ip, sc->buf);
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+			return error;
+		if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	}
 
-	/* Remote symlink; must read the contents. */
-	error = xfs_symlink_remote_read(sc->ip, sc->buf);
-	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
-		return error;
-	if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
-		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-
 	/* If a remote symlink is clean, it is clearly not zapped. */
 	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_SYMLINK_ZAPPED);
 	return 0;


