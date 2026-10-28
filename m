Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213561;
	b=cIJNnlXVSaM0kDRD0XRdQ93YKdcdco0nEJ+ddkEi2Y0ZvSqguYR4h01FjxkOdbx473p0
	 Cq6W7LYIuEyxaa3zYO9uqUgj9RPCfdPyXAh0urjjXmjbw2Kr5+ovT84YC1jmXwVIzG99X
	 DanxUvTIOSyWKXJu+l9yEuX6+ejKBzTqdFveuqo/CFKwNs2KJ5U/e+H+VmzeAHTyLppzv
	 N/KCgpib1HWL+Y1QTmvQI8VqNgdM0RaI3MwJFOfErBn6sIXR6G3gAXQSJXyVck8ODu94X
	 OgnajSQKRI7AOIqio7TYjC4Xt8D6n2jL/ijaSke2IllGCKw6nrtamZ1L0ZCOR5+kUzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qP60F/DI1eOI8jrqc2OY6Ur40NTGib8jK/y88qNClBU=;
	b=PtyjCkNUEqvjjevGdUcatIJSjiQTXnsxh/2CSZoh13Kyp8DFpYz8I57cJ2pn17nl42Ia
	 4Ljy7Om9ttfsBCmmQRA1KvuY77dUqbwX2BxChWmY943QS9tWS0radPQ9dL/cZ++EfNJLH
	 EFIG7lph9zMcv1YhTnnIE/CsAAIsDn7DrPt2RadnWaVlP5Obq6WYe4v6zjuRNEvS8muSW
	 pp2mxrDnvW/e2SDp8aNJldZrwkKsoo0C/QUbcxtaKgJeSvc/gxo4r8RTu1IEU57bZP6pa
	 zBQaHovGVKCoGqIJtZHcajw6V/SeGOLrprH0Vw86HPPfUWskOXmMw3iSzsuljWCXuJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ze8P9ehq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC232606A31E;
	Wed, 28 Oct 2026 18:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ze8P9ehq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069AD1F01825;
	Wed, 28 Oct 2026 18:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213560;
	bh=qP60F/DI1eOI8jrqc2OY6Ur40NTGib8jK/y88qNClBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ze8P9ehqr05z4xOruNZkfYvUodGqN69syMjODQdH9nPXUvfcInKfoFoYFCpgmmi4d
	 2kggi+YriXmttLn9Gp4FtTV17f3HgbaoAzg+qL/sehlolmLEZfr44LxFWg/OmBhCBj
	 X7SXZYxAAio7jAa3EYVMtgdL1qbV3ktn01UU36fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Carlos Maiolino <cem@kernel.org>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0549/1887] xfs: factor out stale buffer item completion
Date: Wed, 28 Oct 2026 17:44:05 +0100
Message-ID: <20261028170511.862891506@linuxfoundation.org>
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

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 816c330b605c3f4813c0dc0ab5af5cce17ff06b3 ]

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 1b323b3c0eb93..ade89a233e686 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -541,6 +541,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -590,13 +626,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -607,22 +636,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.53.0



