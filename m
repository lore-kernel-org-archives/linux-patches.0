Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209287;
	b=Ui9kZNm8gAFyJurlWaCpd9+a9AMlK4xeo9fFgfXMUDb1GzZPi3uArTFR9RysmtJCE3W1
	 xeXytaJCL2KpbXYl33KJ/VXb41YhaaN3CHXaBC7mNzTYAFehgTJAYo6rh4VE/KgY50Qh2
	 rftmrl7Si692P+ATPtyJlV53s3kvcBUCxHJkNqgvsvSeQLyqT/wUyGx6pPij1xlYM2/Bw
	 zbYvvaN1tzLauymiU5Y6ic4J6UodczP5A7bRFmx2sMAN4odbNI3JdIg+1JQ7+Yue6s3Lc
	 1VnIIwKapdA2HvD3hdh9u7KhXqlbycpjZJ+USowN0m4FUknRqnlwbxcMro8T+UYNeUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/opjzXaHd+ZkUoLUTmYZyQsgwbmDq9nxYalE4HsejGE=;
	b=wGeISNLl2X1JnuzB5h3qvCnXDlm5S/A5nTFqzpkt96ZWIKlacdSIRfdIgpSQ4GT9KclI
	 Ci8IB750Ev3eNux1ePFmpsayXmjfADW3RqCN2jIX5UraJaeKx747IgRPO5H0K5lBI7PYs
	 UtLaFzgAWrlWZieiQJlBchdWzt/VtqStm5A7ngUOr/J3Heb9n3tdWytkFFtBu55N/gMy3
	 3MWKPBtqVYOV1nBhWyL3RsO6URuGX4MB6BA//8UHTn8ax/3UIHpPcGfafMpeBKYahMYME
	 Wow/Be2/pjWZgb6F6m/toX3uXApZNwGIRuJrAQpcGYxYxWSkwGYLp0yd74kLj3A7p6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MojJaTnm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC2D606A321;
	Wed, 28 Oct 2026 17:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MojJaTnm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9291C1F01825;
	Wed, 28 Oct 2026 17:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209287;
	bh=/opjzXaHd+ZkUoLUTmYZyQsgwbmDq9nxYalE4HsejGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MojJaTnm63XNTrzgtDoKBwVLR3NcxDsSQL9LYN6uTamwwW4D0DD82XXpRRW1WqeaC
	 Ta4kNH/qPgVpe+UwMVPfjEvMcFUOvszKEe60vID1vc506MJtZKIp+lOaVCU+JF4SNB
	 2HOioYg/QkBq749GsqJ5sSu1Z0K2ewrrMZ7o6eHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangerkun <yangerkun@huawei.com>,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 416/516] xfs: buffer pins need to hold a buffer reference
Date: Wed, 28 Oct 2026 17:59:28 +0100
Message-ID: <20261028170013.341015176@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 89a4bf0dc3857569a77061d3d5ea2ac85f7e13c6 ]

When a buffer is unpinned by xfs_buf_item_unpin(), we need to access
the buffer after we've dropped the buffer log item reference count.
This opens a window where we can have two racing unpins for the
buffer item (e.g. shutdown checkpoint context callback processing
racing with journal IO iclog completion processing) and both attempt
to access the buffer after dropping the BLI reference count.  If we
are unlucky, the "BLI freed" context wins the race and frees the
buffer before the "BLI still active" case checks the buffer pin
count.

This results in a use after free that can only be triggered
in active filesystem shutdown situations.

To fix this, we need to ensure that buffer existence extends beyond
the BLI reference count checks and until the unpin processing is
complete. This implies that a buffer pin operation must also take a
buffer reference to ensure that the buffer cannot be freed until the
buffer unpin processing is complete.

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 81274891036602355e72eabbb5184490f354b506)
Stable-dep-of: 816c330b605c ("xfs: factor out stale buffer item completion")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 88 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 73c548d5b593d..f864e0b8a8055 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -371,10 +371,18 @@ xfs_buf_item_format(
  * This is called to pin the buffer associated with the buf log item in memory
  * so it cannot be written out.
  *
- * We also always take a reference to the buffer log item here so that the bli
- * is held while the item is pinned in memory. This means that we can
- * unconditionally drop the reference count a transaction holds when the
- * transaction is completed.
+ * We take a reference to the buffer log item here so that the BLI life cycle
+ * extends at least until the buffer is unpinned via xfs_buf_item_unpin() and
+ * inserted into the AIL.
+ *
+ * We also need to take a reference to the buffer itself as the BLI unpin
+ * processing requires accessing the buffer after the BLI has dropped the final
+ * BLI reference. See xfs_buf_item_unpin() for an explanation.
+ * If unpins race to drop the final BLI reference and only the
+ * BLI owns a reference to the buffer, then the loser of the race can have the
+ * buffer fgreed from under it (e.g. on shutdown). Taking a buffer reference per
+ * pin count ensures the life cycle of the buffer extends for as
+ * long as we hold the buffer pin reference in xfs_buf_item_unpin().
  */
 STATIC void
 xfs_buf_item_pin(
@@ -389,13 +397,30 @@ xfs_buf_item_pin(
 
 	trace_xfs_buf_item_pin(bip);
 
+	xfs_buf_hold(bip->bli_buf);
 	atomic_inc(&bip->bli_refcount);
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
 /*
- * This is called to unpin the buffer associated with the buf log item which
- * was previously pinned with a call to xfs_buf_item_pin().
+ * This is called to unpin the buffer associated with the buf log item which was
+ * previously pinned with a call to xfs_buf_item_pin().  We enter this function
+ * with a buffer pin count, a buffer reference and a BLI reference.
+ *
+ * We must drop the BLI reference before we unpin the buffer because the AIL
+ * doesn't acquire a BLI reference whenever it accesses it. Therefore if the
+ * refcount drops to zero, the bli could still be AIL resident and the buffer
+ * submitted for I/O at any point before we return. This can result in IO
+ * completion freeing the buffer while we are still trying to access it here.
+ * This race condition can also occur in shutdown situations where we abort and
+ * unpin buffers from contexts other that journal IO completion.
+ *
+ * Hence we have to hold a buffer reference per pin count to ensure that the
+ * buffer cannot be freed until we have finished processing the unpin operation.
+ * The reference is taken in xfs_buf_item_pin(), and we must hold it until we
+ * are done processing the buffer state. In the case of an abort (remove =
+ * true) then we re-use the current pin reference as the IO reference we hand
+ * off to IO failure handling.
  */
 STATIC void
 xfs_buf_item_unpin(
@@ -412,24 +437,18 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
-	/*
-	 * Drop the bli ref associated with the pin and grab the hold required
-	 * for the I/O simulation failure in the abort case. We have to do this
-	 * before the pin count drops because the AIL doesn't acquire a bli
-	 * reference. Therefore if the refcount drops to zero, the bli could
-	 * still be AIL resident and the buffer submitted for I/O (and freed on
-	 * completion) at any point before we return. This can be removed once
-	 * the AIL properly holds a reference on the bli.
-	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	if (freed && !stale && remove)
-		xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	 /* nothing to do but drop the pin count if the bli is active */
-	if (!freed)
+	/*
+	 * Nothing to do but drop the buffer pin reference if the BLI is
+	 * still active.
+	 */
+	if (!freed) {
+		xfs_buf_rele(bp);
 		return;
+	}
 
 	if (stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
@@ -441,6 +460,15 @@ xfs_buf_item_unpin(
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
+		/*
+		 * The buffer has been locked and referenced since it was marked
+		 * stale so we own both lock and reference exclusively here. We
+		 * do not need the pin reference any more, so drop it now so
+		 * that we only have one reference to drop once item completion
+		 * processing is complete.
+		 */
+		xfs_buf_rele(bp);
+
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
@@ -457,16 +485,30 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
-	} else if (remove) {
+		return;
+	}
+
+	if (remove) {
 		/*
-		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure. We acquired the hold for this case
-		 * before the buffer was unpinned.
+		 * We need to simulate an async IO failures here to ensure that
+		 * the correct error completion is run on this buffer. This
+		 * requires a reference to the buffer and for the buffer to be
+		 * locked. We can safely pass ownership of the pin reference to
+		 * the IO to ensure that nothing can free the buffer while we
+		 * wait for the lock and then run the IO failure completion.
 		 */
 		xfs_buf_lock(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
+		return;
 	}
+
+	/*
+	 * BLI has no more active references - it will be moved to the AIL to
+	 * manage the remaining BLI/buffer life cycle. There is nothing left for
+	 * us to do here so drop the pin reference to the buffer.
+	 */
+	xfs_buf_rele(bp);
 }
 
 STATIC uint
-- 
2.53.0



