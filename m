Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061743;
	b=fsWMww9aMNE6NGwGk7t7zdfKD868kza/uLCa6YsLAxZ2aZo2+J9530C1KoeuKOHbpbHd
	 0TRBaHZDELlYZiLtsm+JvhjW94gX/R+2VSU4DfZAd09pDET7noGtpivNRLCYy+0IWXL5j
	 MDcULKiAicOyP1qzFcY9J2lwTEqz46QhfafzDNAafRfPMw+mUa8+TDDUNN4/8T7rEd6BT
	 wrWY1RXHviO+u4hLO/IU5v+XDTwNIlvLgXHO7DDKbOv+ElRwkOAni9DWFApxUPJylXiwg
	 /BG0pWx2pijc+ozsacPG07www6xVdhhJyApMvfkr8L/7gdj7ji2RQxul/mDty6CaCEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NerCeUgWSCU8YFI6ji7x7NvDVSer4aBpXyLbrQP3P/A=;
	b=BtqH/o9TZ/cG8cxN9tN7vERRGYA5sILAdxvuelisbr59KRYt8VcYCr1xMghfNgInZBW4
	 haHdUSS9rc2/BZEC9FY6wQg5xVGBSl+T5mZILCRbbwIYPNQFrgqMUeWkCFfuIYbPQC1Sp
	 /6L7B1wlHw8ZW6s+u6lL6JGLl0SSoSsVSK6RFFnQXqsEjc4WfPWFEHAokJ0GvahB99dFP
	 SuVyAJRf3A7MgVlI486vbEsVZePrT+nD/OY4GAzYhoVclVPompMyeX01EnFrNUxq+ATrw
	 ZvgXfg4FTpxtjpOKe0Cgg9PPI0i6uWDna+L6mJinIt/1+sipGb/iQ07sRsNy+8CHQlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEdQ22Xx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0983606A326;
	Sat,  7 Nov 2026 14:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fEdQ22Xx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC2E1F0089F;
	Sat,  7 Nov 2026 14:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061742;
	bh=NerCeUgWSCU8YFI6ji7x7NvDVSer4aBpXyLbrQP3P/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEdQ22XxJQ6/vgeaay7pT9zaKq4OPiXo7zaw0GmbAwnEcVaHs09hAJFGswi7Qr2qs
	 ky1f6LtY1mtM6zhRd58RyYfzKWh8TWqL9w/ME2eRPxkL1eahyIhwC5tg1/QzqrVZdA
	 MJYZhCaPiWDvKyJVj1KQsCpy0XLW7q5RPZG0tqVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0746/1536] xfs: range-check bc_levels array access in scrub tracepoints
Date: Sat,  7 Nov 2026 08:46:02 -0500
Message-ID: <20261107135018.482244904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -39,6 +39,9 @@ xchk_btree_cur_fsbno(
 	struct xfs_btree_cur	*cur,
 	int			level)
 {
+	if (level < 0)
+		return NULLFSBLOCK;
+
 	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
 		return XFS_DADDR_TO_FSB(cur->bc_mp,
 				xfs_buf_daddr(cur->bc_levels[level].bp));
@@ -50,6 +53,16 @@ xchk_btree_cur_fsbno(
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
@@ -565,7 +565,7 @@ TRACE_EVENT(xchk_btree_op_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
@@ -606,7 +606,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->type = sc->sm->sm_type;
 		__assign_str(name);
 		__entry->level = level;
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->error = error;
@@ -648,7 +648,7 @@ TRACE_EVENT(xchk_btree_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d type %s %sbt level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
@@ -688,7 +688,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx fork %s type %s %sbt level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
@@ -728,7 +728,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 	),
 	TP_printk("dev %d:%d type %s %sbt agno 0x%x agbno 0x%x level %d nlevels %d ptr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),


