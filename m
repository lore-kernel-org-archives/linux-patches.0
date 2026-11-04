Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831690;
	b=y53mPinHpH1j1dWb+lMPbgPc25Qg3M9zIdg/67Sk6QaI/dHOvV16OOmB24vCJLsUzIDG
	 jqX9Gz0RMlevcCb8unJ/GbAu4ONOeudBzGjIyTCl6xHc882/40HVWK44fW78NmkwiWO8s
	 KnwHtYCWy88f+S+IUey4oZ4tCxmoGNghHXfgdxE0TlyE3DWT5+1ft7nSkr/LvNrnQTvEy
	 AfbPdTx8tn+6yIDvY/84aKeUCCXSW3knv66Mznkqomj0ztuX58nrOcYZtnDqrjOUPqHWd
	 6TFlyIqJhKPEqqtVcSmEJAnuHPKal6U0An/Yd04gpwFbRkoaIFitpH7tF2ueFubmkbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EpGNv1nEDAMZSzZpqof6BrguQzHZy1T0PekLsCzJt6U=;
	b=MInSFRykb1VTD57xRV24g6+3j/HygQljgj5FHhku2h9BXsKc8u1wGHYO/h16Rguq1tTf
	 kB8Oga1kH7nzTnDYVq8yIzXSd71EgrGLNYHfbNZgSmlQI0iWAvMnLB8AOMh/qD8T7st5/
	 zPKUvfb7pkxrEKu+5nbAzL79R9WNAXreEBSK6QbXzkiCJ/7MOWVMF4jvg3tntgr29uaDf
	 ZW15enho50x/sk5S45bruUSdc81j7uraTmU/ERqWWnndApt40PEKlnzXuo+UNL8pL6GDk
	 3n42twVuVo4VFAkiftLfAEyDwLPlwApg5y7AveB2GFa1TVuugVhqV7SFc4I1OWM93vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pdcaiwaz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89836606A33B;
	Wed,  4 Nov 2026 22:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pdcaiwaz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28ED31F000C1;
	Wed,  4 Nov 2026 22:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831690;
	bh=EpGNv1nEDAMZSzZpqof6BrguQzHZy1T0PekLsCzJt6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pdcaiwaz1Oipk46tckaoVMUvGFbxDENvay0ZU424IrCgv8qrqrWujaYGtJQ+TaXoF
	 GsYN5l0+FvRWUH/dJecCYjxQkTK/WrSe4TxqN0+moSF0L0/tIKo3/J0EiIyNoW/gf7
	 S+K3+jQh7TTETY092pkA+twl7Mv3aDow1yCbmI3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0840/1005] xfs: bound inode fork length against the fork size during log recovery
Date: Wed,  4 Nov 2026 16:09:33 -0500
Message-ID: <20261104211106.851017137@linuxfoundation.org>
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

commit 9232301894a06e664d8de2da97175cf98419bd16 upstream.

xlog_recover_inode_commit_pass2() copies an inode log item's data/attr
fork region into the inode buffer using the on-log region length without
bounding it against the fork capacity, e.g.:

	len = item->ri_buf[2].iov_len;
	memcpy(XFS_DFORK_DPTR(dip), src, len);

The only guard is an ASSERT, which is a no-op on production kernels
(CONFIG_XFS_DEBUG off), and xfs_dinode_verify() runs only after the copy.
A crafted image with a dirty log can therefore drive a heap out-of-bounds
write at mount time. The XFS_ILOG_DBROOT sibling already passes
XFS_DFORK_DSIZE as a bound; the DDATA/DEXT and ADATA/AEXT memcpy paths
did not.

Bound each logged fork region against the destination fork size before
copying it, and reject the log item with -EFSCORRUPTED when it does not
fit. Because the recovered inode is only verified after the fork data has
been copied in, the checks are done up front, before any memcpy into the
on-disk inode.

Fixes: 658fa68b6f34 ("xfs: refactor log recovery inode item dispatch for pass2 commit functions")
Cc: stable@vger.kernel.org # v5.8
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode_item_recover.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -507,6 +507,25 @@ xlog_recover_inode_commit_pass2(
 	ASSERT(!(fields & XFS_ILOG_DFORK) ||
 	       (len == xlog_calc_iovec_len(in_f->ilf_dsize)));
 
+	/*
+	 * The recovered inode is verified only after the fork data has been
+	 * copied into it, so bound each logged fork region against the size of
+	 * its fork now, before the memcpy below can overrun the on-disk inode.
+	 * The DBROOT/ABROOT cases already bound their copies against the fork
+	 * size.
+	 */
+	if ((fields & (XFS_ILOG_DDATA | XFS_ILOG_DEXT)) &&
+	    item->ri_buf[2].iov_len > XFS_DFORK_DSIZE(dip, mp)) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+	if ((fields & (XFS_ILOG_ADATA | XFS_ILOG_AEXT)) &&
+	    item->ri_buf[(fields & XFS_ILOG_DFORK) ? 3 : 2].iov_len >
+	    XFS_DFORK_ASIZE(dip, mp)) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
 	switch (fields & XFS_ILOG_DFORK) {
 	case XFS_ILOG_DDATA:
 	case XFS_ILOG_DEXT:
@@ -546,7 +565,6 @@ xlog_recover_inode_commit_pass2(
 		case XFS_ILOG_ADATA:
 		case XFS_ILOG_AEXT:
 			dest = XFS_DFORK_APTR(dip);
-			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
 			memcpy(dest, src, len);
 			break;
 


