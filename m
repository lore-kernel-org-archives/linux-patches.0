Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831703;
	b=GtW6lZ+qQN6uCgI742LflY601wL4KEwiGPHXmIBZKwC5jalbGDBiCT96UnTha/57l1Cs
	 bMofk+Qf/BgPAKqBfpjZ55GzrMpd8qUXclbvmj7nN+TCIVEcHdBXjScfWuizduNhT5DSo
	 WtFDk3QL3ivQ/Op/A0HfUTNRpQJ6FxEQQVxfR/oab5JBXJ5H252Zga2McxvlLcZ6J3tuj
	 p4VrqbBdb7Vq3ftF1/pMRO2nbFErWPA42V3/hHSlx0OLHlaG6BmtME0JGueqyMNkCfL7T
	 BSrbvdE1Nm2p6A3VhflGcQlH1/BK+wyQjYDQGE0E1XO3hu/wnPJ5ONiyo1DJRYyMTLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DAwYQNbUrMn1HzTYPQvJPGxwewLz6I23cz52KWZJJ+0=;
	b=bZYdm/WPrWK7FfD2te660JTKe1mYmEFgrMpo6H5ZyLWsf0JntuBF6JhtpkRXrXLBaRi9
	 Hepcu2fEqrzywGRj3X7cnqornfPi4ZKyRrxjleEkrdiTm5xWXraL1Y89ErBGcrShL738G
	 WfnYSenIBKRw/LG2BBP4iYPSxJyigdsq8w5NBF87MolmX9YQiDeuLjvR5CzAT2vEWxSMv
	 DDXp5DbANxhxIn7Xf1GqnGRSLL2UETmiq4E5otgoPomufMgdaEmHOF7MOQ0f0IvLZdUQ1
	 hq4MgJyO96WYhetx+SrkM9E+yB6erkzAMrIGp8Ke81wnOPKOa7A+eMkjhw1CT+AIWAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RXwPIsd/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DB1606D826;
	Wed,  4 Nov 2026 22:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RXwPIsd/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF041F000C1;
	Wed,  4 Nov 2026 22:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831702;
	bh=DAwYQNbUrMn1HzTYPQvJPGxwewLz6I23cz52KWZJJ+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXwPIsd/BMRR26u8ADtYvV1pMusX6hxoDbugMxbSsUOnljxmmcqSDqWnVdY3CCarg
	 jgL2GUSNOUDwrCZi/7/2IQPM74J3E9D+CE1wh/AYxINJPuspAstX1bpivD+c5xqBPx
	 Ak0EZVRzIX7FN27McsU4vs1YOeuZKWp4NxGLD+bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0864/1005] xfs: reattach dquots after changing inode ids
Date: Wed,  4 Nov 2026 16:09:57 -0500
Message-ID: <20261104211107.476959728@linuxfoundation.org>
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

commit 2f528e4a8f89daa6d0cc64b044f6f94c018fe9ae upstream.

LOLLM noticed that xrep_inode_ids can change the user, group, or project
id of any given file.  When this happens, we need to detach any existing
incore dquot and attach the correct ones.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |  133 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 132 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -41,6 +41,8 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -1762,6 +1764,20 @@ xrep_inode_ids(
 
 	trace_xrep_inode_ids(sc);
 
+	/*
+	 * We changed one of the file IDs, so we must detach the dquots to
+	 * prevent further changes from being accounted to them, and try to
+	 * attach the dquot for the new id to absorb any other block usage
+	 * changes.  We can't do that right now because the existing dquots
+	 * might be attached to the scrub transaction and we're in the middle
+	 * of fixing the inode, so we'll switch the incore dquot pointers
+	 * later.
+	 *
+	 * Schedule a quotacheck so the accounting discrepancies will get fixed
+	 * eventually.  We'll have to repeat this later when we do the actual
+	 * switch.
+	 */
+
 	if (!uid_valid(VFS_I(sc->ip)->i_uid)) {
 		i_uid_write(VFS_I(sc->ip), 0);
 		dirty = true;
@@ -2072,6 +2088,113 @@ xrep_inode_unlinked(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_QUOTA
+static inline bool
+xrep_inode_need_reset_dquots(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = sc->ip;
+
+	if (!XFS_IS_QUOTA_ON(mp))
+		return false;
+	if (xfs_is_quota_inode(&mp->m_sb, I_INO(ip)))
+		return false;
+	if (xfs_is_metadir_inode(ip))
+		return false;
+
+	if (XFS_IS_UQUOTA_ON(sc->mp) &&
+	    (!ip->i_udquot || ip->i_udquot->q_id != i_uid_read(VFS_I(ip))))
+		return true;
+	if (XFS_IS_GQUOTA_ON(sc->mp) &&
+	    (!ip->i_gdquot || ip->i_gdquot->q_id != i_gid_read(VFS_I(ip))))
+		return true;
+	if (XFS_IS_PQUOTA_ON(sc->mp) &&
+	    (!ip->i_pdquot || ip->i_pdquot->q_id != ip->i_projid))
+		return true;
+
+	return false;
+}
+
+/* Switch dquot, return dqtype if we need quotacheck */
+static xfs_dqtype_t
+xrep_inode_switch_dquot(
+	struct xfs_scrub	*sc,
+	xfs_dqtype_t		type,
+	struct xfs_dquot	**dqp)
+{
+	xfs_dqtype_t		ret = 0;
+	xfs_dqid_t		id = xfs_qm_id_for_quotatype(sc->ip, type);
+
+	if (*dqp != NULL && (*dqp)->q_id != id) {
+		xfs_qm_dqrele(*dqp);
+		*dqp = NULL;
+	}
+
+	if (!*dqp) {
+		xfs_qm_dqget_inode(sc->ip, type, true, dqp);
+		ret = type;
+	}
+	return ret;
+}
+
+static int
+xrep_inode_reset_dquots(
+	struct xfs_scrub	*sc)
+{
+	xfs_dqtype_t		need = 0;
+	int			error;
+
+	/*
+	 * If we changed the file IDs, then we need to drop the transaction so
+	 * that we can detach the dquots and attach new ones.
+	 *
+	 * Commit the scrub transaction so that there are no dangling
+	 * references to any dquots that might get detached, and retain the
+	 * ILOCK, as required by the dqattach code.
+	 *
+	 * Note that dqattach can cycle the ILOCK when creating a new dquot, so
+	 * this must be the very last thing that the repair function does.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	if (XFS_IS_UQUOTA_ON(sc->mp))
+		need |= xrep_inode_switch_dquot(sc, XFS_DQTYPE_USER,
+				&sc->ip->i_udquot);
+	if (XFS_IS_GQUOTA_ON(sc->mp))
+		need |= xrep_inode_switch_dquot(sc, XFS_DQTYPE_GROUP,
+				&sc->ip->i_gdquot);
+	if (XFS_IS_PQUOTA_ON(sc->mp))
+		need |= xrep_inode_switch_dquot(sc, XFS_DQTYPE_PROJ,
+				&sc->ip->i_pdquot);
+
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Now that we've updated the dquots, force quotacheck once again.
+	 * In theory we could be racing against a concurrent quotacheck.
+	 * Note that we can't hold the ILOCK when allocating a transaction.
+	 */
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	if (need & XFS_DQTYPE_USER)
+		xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
+	if (need & XFS_DQTYPE_GROUP)
+		xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
+	if (need & XFS_DQTYPE_PROJ)
+		xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
+
+	return 0;
+}
+#else
+# define xrep_inode_need_reset_dquots(sc)	(false)
+# define xrep_inode_reset_dquots(sc)		(0)
+#endif
+
 /* Repair an inode's fields. */
 int
 xrep_inode(
@@ -2126,5 +2249,13 @@ xrep_inode(
 	if (error)
 		return error;
 
-	return xrep_defer_finish(sc);
+	error = xrep_defer_finish(sc);
+	if (error)
+		return error;
+
+	/* Must come last */
+	if (xrep_inode_need_reset_dquots(sc))
+		return xrep_inode_reset_dquots(sc);
+
+	return 0;
 }


