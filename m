Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831755;
	b=tgTgCgZUcJNDWHMOD31sxBSD1myFhKBub78PWShQ6QlA6W7qyV6rNM895F5DFjlkj7yB
	 VztrO/H3HaUYYlQSSSAl30n/jmWHZA3x7lct4BfIc/GN1dcf4iPkg/X1bMcQYuFVp5awt
	 WkZmMAkaqlXe1xLrH1sLFsJOZ4FeV5iqWrNsbWB11gE8poBurf5OIYTLRktoTbHK70XMp
	 d/1XUkcHSlrmU42FtSPlfaz8eSo6uvAZj9fCfU00/r4UasMxrNF9MExSRRS20kQa8An0Y
	 T6hPVWoK3LqevplnOf4B2UQ9LQvSlxjtUQuTdwaIQPzvnZ6IIGacrgGm2zETE2wk6vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T4tuluO7UAjZQ19eb7pEoKovgk4a3XZsKo8z09IEDJE=;
	b=EFyJxDLmZZwOKDrgPmsjvWBB4H3qI1p6v4AauAjzLYsj1loXhPx4Nqi2zto8Ou1gfp7W
	 uGDKDxNiULzdNhn5VdfKS9CUIF6sZDQtjKpcgtXGkPaMxMXz2RzRiiJRcRZzLXXqD/3lH
	 GXDNY15byvF77/rdCpZ5YsNmw3dz34FFJ8yRJhLsCzP9iHKgZEknB1B08tdQDT99soEgu
	 oDHmY5te/xw1Xr+MmrzB7FjeTYZdDHZkUZYVuMTfs+4WzipzltI5JcTHCTemcH38zqiXC
	 8X10Cr4ScOl4yCxjTpcDkYnj0sm03UFKGVAli0AZOLbn/Ssw8c/pGNQ2jpjOkcCb/CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZXziL75;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE606606A31B;
	Wed,  4 Nov 2026 22:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZXziL75
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9831F00A02;
	Wed,  4 Nov 2026 22:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831754;
	bh=T4tuluO7UAjZQ19eb7pEoKovgk4a3XZsKo8z09IEDJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZXziL757+X/NnRWUa1fHw2R6wS4fK6bI/MDSffomC+06nZjvyvNFNIOOzuGgC3a2
	 kPi4+uKfakjT/lwROS1v/+cpTHpSlcfiQTXoX8uuVVK/+iBuUltc6zFyKygBhk9FMF
	 qlAzagbznnn1+ZREgA8aoo8s9a2mETJThdBMyZqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0838/1005] xfs: always zero the whole shortform header when zeroing attr fork
Date: Wed,  4 Nov 2026 16:09:31 -0500
Message-ID: <20261104211106.799003734@linuxfoundation.org>
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

commit 52aa50cea408e27454d206cccecbe4f694a6c1e1 upstream.

LOLLM noticed that xrep_xattr_fork_remove can decide to reset the attr
fork contents to an empty shortform header, but then fails to zero the
padding byte in the header.  Fix that.

Cc: stable@vger.kernel.org # v6.10
Fixes: e47dcf113ae348 ("xfs: repair extended attributes")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/attr_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -970,7 +970,7 @@ xrep_xattr_fork_remove(
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
 		hdr = xfs_idata_realloc(ip, (int)sizeof(*hdr) - ifp->if_bytes,
 				XFS_ATTR_FORK);
-		hdr->count = 0;
+		memset(hdr, 0, sizeof(*hdr));
 		hdr->totsize = cpu_to_be16(sizeof(*hdr));
 		xfs_trans_log_inode(sc->tp, ip,
 				XFS_ILOG_CORE | XFS_ILOG_ADATA);


