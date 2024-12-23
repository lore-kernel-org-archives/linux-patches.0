Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D620E19E98B;
	Mon, 23 Dec 2024 16:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970395; cv=none; b=sYoVaqwRMsU4BsgndTCOMe3FBfUZ/Cyb0hrgwJONa919cgLAG/Ub2IJeLiYYvSf3mnNc20Ko4St86WHZyel75Fy07+EnWU5dPR/9Bke3LneH1BTOiEnVKa6xmgdiFr4nfI/kEy/Hlh9UnajVz0SC8pAHMYaEphFB9PwamHNP59k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970395; c=relaxed/simple;
	bh=5SE9YadBbSGWl5mRF2g7Rl6zCho/2d/GL4DgHI1BKVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fACplW9dwzO4J7QaGoKsmvxuXZbwSm0qTi8nZFltqTZfTLKdPuvNCQ8vS3DsocAUgTVJsldMbFGQNjlAsX+k8YPHnRjn+HM1NhSYIy0DRt3p2qySGH4H1DtjKQy4Dcfov6BByvBmRCalKpfMulAc7+dP67c2ZIU4V+FLhrNujjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eC+J/xnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eC+J/xnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B10C4CED3;
	Mon, 23 Dec 2024 16:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970395;
	bh=5SE9YadBbSGWl5mRF2g7Rl6zCho/2d/GL4DgHI1BKVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eC+J/xnvwjOHHz52iWXOXk+VYNE3fDziUsSJUTQ3vRuEKfi0L2+9fMnGFiDNlWaby
	 tSnW+jnKEH9vQkj8/0o2P9C1GxMLeBub19jmgL2lC67TlPkY7C28zdQdM+eRCE8Mbf
	 G21WUKjhDZ0y73tdtKOEhahHTHHp0dZ9ELIzrzZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/116] xfs: remove unused parameter in macro XFS_DQUOT_LOGRES
Date: Mon, 23 Dec 2024 16:58:19 +0100
Message-ID: <20241223155400.708012488@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao2870@gmail.com>

commit af5d92f2fad818663da2ce073b6fe15b9d56ffdc upstream.

In the macro definition of XFS_DQUOT_LOGRES, a parameter is accepted,
but it is not used. Hence, it should be removed.

This patch has only passed compilation test, but it should be fine.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_quota_defs.h |  2 +-
 fs/xfs/libxfs/xfs_trans_resv.c | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index cb035da3f990..fb05f44f6c75 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -56,7 +56,7 @@ typedef uint8_t		xfs_dqtype_t;
  * And, of course, we also need to take into account the dquot log format item
  * used to describe each dquot.
  */
-#define XFS_DQUOT_LOGRES(mp)	\
+#define XFS_DQUOT_LOGRES	\
 	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
 
 #define XFS_IS_QUOTA_ON(mp)		((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5b2f27cbdb80..1bb2891b26ff 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -334,11 +334,11 @@ xfs_calc_write_reservation(
 					blksz);
 		t1 += adj;
 		t3 += adj;
-		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
 	}
 
 	t4 = xfs_calc_refcountbt_reservation(mp, 1);
-	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
 }
 
 unsigned int
@@ -406,11 +406,11 @@ xfs_calc_itruncate_reservation(
 					xfs_refcountbt_block_count(mp, 4),
 					blksz);
 
-		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
 	}
 
 	t4 = xfs_calc_refcountbt_reservation(mp, 2);
-	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
 }
 
 unsigned int
@@ -436,7 +436,7 @@ STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max((xfs_calc_inode_res(mp, 5) +
 		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
@@ -475,7 +475,7 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_iunlink_remove_reservation(mp) +
 		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
@@ -513,7 +513,7 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_iunlink_add_reservation(mp) +
 		max((xfs_calc_inode_res(mp, 2) +
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
@@ -572,7 +572,7 @@ xfs_calc_icreate_resv_alloc(
 STATIC uint
 xfs_calc_icreate_reservation(xfs_mount_t *mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max(xfs_calc_icreate_resv_alloc(mp),
 		    xfs_calc_create_resv_modify(mp));
 }
@@ -581,7 +581,7 @@ STATIC uint
 xfs_calc_create_tmpfile_reservation(
 	struct xfs_mount        *mp)
 {
-	uint	res = XFS_DQUOT_LOGRES(mp);
+	uint	res = XFS_DQUOT_LOGRES;
 
 	res += xfs_calc_icreate_resv_alloc(mp);
 	return res + xfs_calc_iunlink_add_reservation(mp);
@@ -630,7 +630,7 @@ STATIC uint
 xfs_calc_ifree_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
 		xfs_calc_iunlink_remove_reservation(mp) +
@@ -647,7 +647,7 @@ STATIC uint
 xfs_calc_ichange_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 
@@ -756,7 +756,7 @@ STATIC uint
 xfs_calc_addafork_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
@@ -804,7 +804,7 @@ STATIC uint
 xfs_calc_attrsetm_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
@@ -844,7 +844,7 @@ STATIC uint
 xfs_calc_attrrm_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max((xfs_calc_inode_res(mp, 1) +
 		     xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH,
 				      XFS_FSB_TO_B(mp, 1)) +
-- 
2.39.5



