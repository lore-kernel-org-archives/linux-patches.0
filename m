Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831700;
	b=iNeQn7/CrGfR2YFtEbmz1xT6L67VLjVwc63f5UVesY1iMQqFtXzegEmMAxXpgNahORsG
	 kNkMwdqAiOgDI4QPLazliNF/ulOoNqxxxmtkjAuHSxYxgacHDkOIRe8SnMJVOVxzQfoz4
	 C1RT6AjFeKGHT/jCfDLFCfyQs+r0OHWR+gKuFSegXENzaBX3DKSM0I3PWwYUJpPUG7v1x
	 BFCrz3Brz/KMB18ZUcCZdPpQlCcJe4gxbCudxASllFQKUiwRyXzmHiOnQpC2ryON/p5fy
	 jMHh33NXKTxNscFXsVbrDtc3yJpHIWg0OfuYmvP6Kkb2FwILpouXY5Np/f6A6eRQefQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SJ74aZ4Tloeg3oOPYWmRjX4XXw4EW5XNkambL2MPNNE=;
	b=ceM1djfXGXAKkWmbM2JZgP0gdOuWkkRjIlfvD4YKEqCYjXz8YTU/+ZwwwX2QbomjE3FX
	 KCjHNVQPtbzMseVcW1HZDWxShx+CFYBneUkx+Pu+WTJEExJgDE5eLdPzjOpXjdy1p54es
	 49MOpuV5xr48WpEHi8QW7kuNqo0Oc+bKQLMH+GjubNWgfHm22x30Y4PtK1xqw26hfjAao
	 7sqK1752e5Q+RDViHTRAuJxihUCa7+LGNwbyMaT8/E0kM+Mil7MewCWdTqiSRCkeiIEfA
	 UMpBvVaD2gNhFZKBSL4ox9GgphsebpWiep2TFtRG/apcQQp3nP2XRASYm19PfwYdQUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c8O2k7nX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DC0606AB02;
	Wed,  4 Nov 2026 22:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c8O2k7nX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640901F000C1;
	Wed,  4 Nov 2026 22:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831699;
	bh=SJ74aZ4Tloeg3oOPYWmRjX4XXw4EW5XNkambL2MPNNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8O2k7nXhdoLOc4BOIjDx2BwNalixyvS9ocE/cV4v+NbaeTN2k9y5SiF/8uaptL8J
	 xrJMQ639fslmJCsZgbrEDQrkimMCeKFudwgYVCr80rS0tPof5ENVuqInMMUX0eIV6o
	 rpj2ff3tt/7AYQTE4goerhnVVLiOdXl7yHKOOEkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0863/1005] xfs: range-check bc_levels array access in scrub tracepoints
Date: Wed,  4 Nov 2026 16:09:56 -0500
Message-ID: <20261104211107.450504954@linuxfoundation.org>
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

commit 73b7276b8a4b5eb272f3c3b36ea3042e786f4741 upstream.

LOLLM noticed xchk_btree()'s odd habit of passing cur->bc_nlevels to
xchk_btree_ptr_ok when we're checking the pointer to the root block at
the start of the btree scan.  This enables us to skip checking the
pointer for an inode btree's root (since it doesn't have one) but
doesn't handle per-AG btrees quite correctly.  There isn't a problem for
__xfs_btree_check_ptr itself, but the corruption tracepoint naively
walks off the end of bc_level[].  Fix that by adding a helper to do an
implicit range check.

Cc: stable@vger.kernel.org # v5.16
Fixes: 6ca444cfd66354 ("xfs: prepare xfs_btree_cur for dynamic cursor heights")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/trace.c |   13 +++++++++++++
 fs/xfs/scrub/trace.h |   10 +++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -42,6 +42,9 @@ xchk_btree_cur_fsbno(
 	struct xfs_btree_cur	*cur,
 	int			level)
 {
+	if (level < 0)
+		return NULLFSBLOCK;
+
 	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
 		return XFS_DADDR_TO_FSB(cur->bc_mp,
 				xfs_buf_daddr(cur->bc_levels[level].bp));
@@ -53,6 +56,16 @@ xchk_btree_cur_fsbno(
 	return NULLFSBLOCK;
 }
 
+static inline int
+xchk_btree_cur_ptr(
+	const struct xfs_btree_cur	*cur,
+	int				level)
+{
+	if (level >= 0 && level < cur->bc_nlevels)
+		return cur->bc_levels[level].ptr;
+	return -1;
+}
+
 /*
  * We include this last to have the helpers above available for the trace
  * event implementations.
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -577,7 +577,7 @@ TRACE_EVENT(xchk_btree_op_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
@@ -618,7 +618,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->type = sc->sm->sm_type;
 		__assign_str(name);
 		__entry->level = level;
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->error = error;
@@ -660,7 +660,7 @@ TRACE_EVENT(xchk_btree_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d type %s %sbt level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
@@ -700,7 +700,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx fork %s type %s %sbt level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
@@ -740,7 +740,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 	),
 	TP_printk("dev %d:%d type %s %sbt agno 0x%x agbno 0x%x level %d nlevels %d ptr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),


