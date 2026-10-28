Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212481;
	b=Xq0HKHMOT15ioV4KlnTDowXQqr2Lv65V5I9oyXsKadUSMQOV8q/+sPcgBIkpmXcm3rCk
	 nFIwHtaYJykoVhOkH6WjGii39h+M1t/Bkg1rX8cBdOqX06J/veySLDnV6v7kd6AxrA6Yf
	 Xlo+zQ2jwwXu77XPnZ4sgUD4RrEPrUoDIFoZ721z6GJaqyS4zZsmRTUF1F6nK1uysPnU1
	 BrZAtoaKewwQ6BpqWx/r2FCGUzDmQ5QB7OkOPdgzYKa65+8cKpZJClN7XRjUxcxH2pode
	 lC9F3FB3ZlcslJZluP6k9NccGlc1a8zHF3XNJ61OKlzsCseWtjEpx2Eys+8qbUr9Grg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B88/GYL/cLiIOgsNqK86TR4lkypPyORoc8g+b6mJjEo=;
	b=dJiYIrrRdhl84UgpF2tv56FrDpraS0BnpPoOhSiBTq1tVLFXivv3Zs7+/W9DhCEEog/e
	 EBjic6/qEJfGILUftl74gzQAWZjJur4/dPER/1wllwhAfjOmYR5g/k3kuhoJK3Ae4X10L
	 TSKDTPwf7xJBgyXLWB4Nh1zAfuLLd1TPTUfgsi/T4uK19DLUmX+Wuf8ARE9poZO3uIJaI
	 bH37HK5ONWm2mbnI69JXsBUto6csbbSwOOe3QvPfqiJm4VzUV1sDzrxN3CAB9qR7OKBDl
	 kD6YY4f/nNJDo9BNqVTqw2LJKHCqWgNPXHmVLj/5X5QeWNlsvSr+xANWfb1c5IDWVSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QjzDjgVP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939FC606A31A;
	Wed, 28 Oct 2026 18:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QjzDjgVP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2FBA1F01825;
	Wed, 28 Oct 2026 18:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212481;
	bh=B88/GYL/cLiIOgsNqK86TR4lkypPyORoc8g+b6mJjEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjzDjgVPqtkYo4UiS3mCHWvWYylowCmiXZ7q1hjpD/zXPeB0pIJsumE2cH8pC0Byn
	 1v/QhOuuhfYORkdNOpa7YRVWjyH5KlkdBAlwLFlEmN3TABzthD3EzrpRhZvPztB+aP
	 SYKn3GKOYT6+QT9KJYXdOLWzjpRRWagodH7Bh9hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0170/1887] xfs: fix cursor and pointer handling when recovering iunlink buckets
Date: Wed, 28 Oct 2026 17:37:46 +0100
Message-ID: <20261028170503.104702487@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 65f39d09d73718611cee40399179323b5d4ead00 ]

LOLLM pointed out a bug in xlog_recover_iunlink_bucket:

1. We don't null out prev_ip after releasing it, which can lead to UAF
   problems if the inodegc flush call in the loop fails.

at which point I noticed even more bugs:

2. If the inodegc flush inside the loop fails, we also leak @ip.

3. We set prev_agino to agino having already advanced agino, which
   results in inodes with i_prev_unlinked set to itself.

4. If we exit the bottom of the loop with prev_ip set, then prev_ip
   aliases ip and we also set its i_prev_unlinked to itself.

Bugs 3 and 4 introduce loops into the unlinked list, though these loops
don't surface because we immediately flush each unlinked inode after
loading it.

Fix all of these issues.

Cc: stable@vger.kernel.org # v6.0
Fixes: 04755d2e5821b3 ("xfs: refactor xlog_recover_process_iunlinks()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Replaced unavailable xfs_agino_to_ino() with the existing XFS_AGINO_TO_INO() macro. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ffd52f5a4b897..bf510a6fb92e4 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2694,12 +2694,13 @@ xlog_recover_iunlink_bucket(
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_inode	*prev_ip = NULL;
-	struct xfs_inode	*ip;
 	xfs_agino_t		prev_agino, agino;
 	int			error = 0;
 
 	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 	while (agino != NULLAGINO) {
+		struct xfs_inode	*ip;
+
 		error = xfs_iget(mp, NULL,
 				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino),
 				0, 0, &ip);
@@ -2709,11 +2710,11 @@ xlog_recover_iunlink_bucket(
 		ASSERT(VFS_I(ip)->i_nlink == 0);
 		ASSERT(VFS_I(ip)->i_mode != 0);
 		xfs_iflags_clear(ip, XFS_IRECOVERY);
-		agino = ip->i_next_unlinked;
 
 		if (prev_ip) {
 			ip->i_prev_unlinked = prev_agino;
 			xfs_irele(prev_ip);
+			prev_ip = NULL;
 
 			/*
 			 * Ensure the inode is removed from the unlinked list
@@ -2725,18 +2726,20 @@ xlog_recover_iunlink_bucket(
 			 * complete.
 			 */
 			error = xfs_inodegc_flush(mp);
-			if (error)
-				break;
+			if (error) {
+				xfs_irele(ip);
+				return error;
+			}
 		}
 
 		prev_agino = agino;
+		agino = ip->i_next_unlinked;
 		prev_ip = ip;
 	}
 
 	if (prev_ip) {
 		int	error2;
 
-		ip->i_prev_unlinked = prev_agino;
 		xfs_irele(prev_ip);
 
 		error2 = xfs_inodegc_flush(mp);
-- 
2.53.0



