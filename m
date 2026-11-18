Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044502;
	b=oimU3MCbRgm8hsEqHomNdbCDK3qjJw2uIae/lhOxpyFNtI4BwX7hMtKEf3bL0iww/RVG
	 IdB73FSCEiWCdAuitpNK3WNHKxX501B0LLq9mFNzN853I3Ox+hTZ1Bz7nj10tmWHHpvLI
	 Ds5SCIkazPRW3bhCz2wU1RipYBaHapJ6P0lyJ8mNLxjW3rG2FQH5TFyaKuF2v193uCc2P
	 6IP1clFFzSuig0Ps0bvJJaWuj7bIk+XcY42cyo5S4x8990orJ658zLmBohA4GKEEhaUWJ
	 juj+utyemnG4NkyHluJkp2SC0tZAenQhOfbWagghJ8HwFWKwa6d114n5lD4oFHCbSNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QCal5j1Jyp+5H/9KIEtvW4SixFp/NHVeOG35cc8+tHA=;
	b=Y2KtumZOYW9wKYJEIqUqaPSf5C6ggcBek8lxQTq7krSwffswAUxFz0PG4nZNG/oI+Ru2
	 HGPBdDLYMaImaujAP/xGdaj12p3/zF5iz3pRryqgQG/BkLmOnrl1N70daxfxIL2p8MY4C
	 MVYN6EPjxx1YOug/ZMNAqM73n1dt95iYgy9VP1KjT030i8N6FLgVTEJriUVRErDZeVnh8
	 ip4GSRbJ4h6nwVD4/1cAXBLiY3P3Jp5qXCCXiodB70cBRkTJEr2lr4S/dr9C1vQfZo8BX
	 XeZ4qfAxwAB1/kwPPb75TaPb0OsO5gxXolmJwsdmXsi8MqDo852OvG2qBdenD0t7yWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vi3Dy3ce;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031E8606A320;
	Wed, 18 Nov 2026 23:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vi3Dy3ce
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581011F000C4;
	Wed, 18 Nov 2026 23:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044501;
	bh=QCal5j1Jyp+5H/9KIEtvW4SixFp/NHVeOG35cc8+tHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vi3Dy3cer+sZfZC/NWhg2kdYVd2HI1B7mZmeNAFGCv5CFK0WIMFLVsgF5oBTyypc1
	 4oEvudXSzg4mvrniUIFW9rMfQXHZa23EThQOhBf/nbiSKwB0YbPJ5Kl2D+BnOoXJW1
	 J5AV2NTEpISA2vHUZX2zArtL5f2u1URzqifGkH5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0590/2857] xfs: bound inode fork length against the fork size during log recovery
Date: Wed, 18 Nov 2026 15:27:04 +0100
Message-ID: <20261118150222.725932224@linuxfoundation.org>
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
@@ -467,6 +467,25 @@ xlog_recover_inode_commit_pass2(
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
@@ -506,7 +525,6 @@ xlog_recover_inode_commit_pass2(
 		case XFS_ILOG_ADATA:
 		case XFS_ILOG_AEXT:
 			dest = XFS_DFORK_APTR(dip);
-			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
 			memcpy(dest, src, len);
 			break;
 


