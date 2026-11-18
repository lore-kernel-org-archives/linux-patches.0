Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044515;
	b=WD9XC5EjQWF1uo6N/8YQeniOD1BWlzgexCWQK60KRRJnO4J4s6PX0C6Gka/BPTj35lSp
	 rzC0Xpih7/p4VsBzMJbAD1FE1gNxNvHhc4xzhM3ZbRsPS4ct+FBAefSvnoUuTj38QbYmZ
	 JiLd766D8ej1ClPmzTYg5EAXtZeSuZw7JsYq0Pt+TaA29nJ1mi6mm+Me6lNViZGfdpFbU
	 5pkurBIZHZu/oE7W8gNdeC5Jplbu45fIDxzSFdjUMCpeo2i4/5iHGECkCfzg6pQ0lAH2w
	 9u79qIFgNl33e6odvjY2XcQChTHx6TTxk33vQCCc8AeVEXh2U6h+EnDTiBV2Mdw/nOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=11mSrVZhUL8ZKxYdpUG9nn80cNbL20LIL2yuP3OrSXo=;
	b=otdAHzpSLHIpjYFTboliU8h5TElnNnm0F5h0s8U1+UvhBN+Mm0eDuaoLvlSjvXWBEw6m
	 auP9rLrKxJPRQpn4G2P0nPegwUUevJxJ5+/dpIKk8RVqYUAvfsIwmzWloAjXgSTrdx7Lw
	 pYmAuT21Psk1NeBCuqy5pyQb2YfzNCAW/I/D1Pnqxo9i03BaFjJAWjit2QV1S5UhCxjeD
	 eHXswJk6r17BpPR+6zfLpv78vQjXKJ9W+huFDlAsaJQ7qFocZMAgNsMPRI8vzfF+tXeLZ
	 I2+K05s04Xvkpn5dY6003XQMthVy8hGNhzmI0Fr6Fp+Xq2A9jxGASt1nvs6gzxjwZdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wbmwsVSJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9949860A2602;
	Wed, 18 Nov 2026 23:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wbmwsVSJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16201F000CF;
	Wed, 18 Nov 2026 23:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044515;
	bh=11mSrVZhUL8ZKxYdpUG9nn80cNbL20LIL2yuP3OrSXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wbmwsVSJD1/PPfGViyBwbzjp6xPO3Vu5DYFI9hHWyBO4DBaHB7FrPjyjyGL1504xk
	 +cAn/XjyUV4i3dsZH8MEMi0FdTdM04wdsUEO5dFAdE6oQ6MRfbY4DdZsPQfATdzARW
	 EDV3na+JjnXamYdpEFWS17Vf8038/pkW499S3Z+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.1 0595/2857] xfs: range-check bc_levels array access in scrub tracepoints
Date: Wed, 18 Nov 2026 15:27:09 +0100
Message-ID: <20261118150222.911035986@linuxfoundation.org>
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
@@ -21,6 +21,9 @@ xchk_btree_cur_fsbno(
 	struct xfs_btree_cur	*cur,
 	int			level)
 {
+	if (level < 0)
+		return NULLFSBLOCK;
+
 	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
 		return XFS_DADDR_TO_FSB(cur->bc_mp,
 				xfs_buf_daddr(cur->bc_levels[level].bp));
@@ -32,6 +35,16 @@ xchk_btree_cur_fsbno(
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
@@ -348,7 +348,7 @@ TRACE_EVENT(xchk_btree_op_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
@@ -389,7 +389,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->type = sc->sm->sm_type;
 		__entry->btnum = cur->bc_btnum;
 		__entry->level = level;
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->error = error;
@@ -431,7 +431,7 @@ TRACE_EVENT(xchk_btree_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
@@ -471,7 +471,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 		__entry->ret_ip = ret_ip;
 	),
 	TP_printk("dev %d:%d ino 0x%llx fork %s type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
@@ -511,7 +511,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
-		__entry->ptr = cur->bc_levels[level].ptr;
+		__entry->ptr = xchk_btree_cur_ptr(cur, level);
 	),
 	TP_printk("dev %d:%d type %s btree %s agno 0x%x agbno 0x%x level %d nlevels %d ptr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),


