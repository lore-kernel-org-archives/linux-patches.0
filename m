Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9ED43901B;
	Tue, 21 Jul 2026 22:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672918; cv=none; b=m0ON/lNOMi07UFpwTzw48wEjxO5ZL10oyJ/6BrhsmjpNR+a8Lp+HamI7RDQKbccAGJ8JZrCb1jHj3/AncBao0YGmIkaCWCz9jehgwZTwapssmsWpYyUdRTx1Xob0r74or6Kq10dcNHuMpNzdFj+iZiixAQ/yg8hZK0CIOtsdhn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672918; c=relaxed/simple;
	bh=PT/xNl5r6LB9cIiy1KQAbd7aBKGjocxx9jV3wII1gNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdGlCkVM5wYAyKhT0Q3qTme7eMd8YM1TWX0inXId3LWC+oO/XTTrCpqHaq84VfQm0KSkjAUd8Urq0cmmEPzZyGpsqJCQhuZvMxAIr9L4/iIqxVrMjoMgt87i7JxDyhEpmXScOKw4MKGcZ3VAewb5dKFht3rP3xtLTBu87nRK93Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aalvxRHu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aalvxRHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C65E1F00A3E;
	Tue, 21 Jul 2026 22:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672915;
	bh=mHMgIff7dSvPZEpdqHlyrPnoGGhwXB7R2vT+c3GGqDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aalvxRHuZRHP8zv572AeovVEOnvv7a49exUNaAqXLKl+c2u3o9JvEzx1piCwjzeM5
	 E8H2bbTyHuRPoNXP8SARou2B7LMSeBN6ymcyrsjbEIFJ2VCp54WG5w9U4nt4494oz/
	 oB6cvD9+VbYELn0mAO8slDhLzeoNA5qUBOYXrcms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 804/843] xfs: Remove dead code
Date: Tue, 21 Jul 2026 17:27:19 +0200
Message-ID: <20260721152424.153940625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit e62c720817597f259b81f1ff004eb042293bf046 ]

Remove tht entire xlog_recover_check_summary() function, this entire
function is dead code and has been for 12 years.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Stable-dep-of: cc9af5e461ea ("xfs: use null daddr for unset first bad log block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |   59 -----------------------------------------------
 1 file changed, 59 deletions(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -39,13 +39,6 @@ STATIC int
 xlog_clear_stale_blocks(
 	struct xlog	*,
 	xfs_lsn_t);
-#if defined(DEBUG)
-STATIC void
-xlog_recover_check_summary(
-	struct xlog *);
-#else
-#define	xlog_recover_check_summary(log)
-#endif
 STATIC int
 xlog_do_recovery_pass(
         struct xlog *, xfs_daddr_t, xfs_daddr_t, int, xfs_daddr_t *);
@@ -3382,8 +3375,6 @@ xlog_do_recover(
 	}
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
-	xlog_recover_check_summary(log);
-
 	/* Normal transactions can now occur */
 	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
 	return 0;
@@ -3526,7 +3517,6 @@ xlog_recover_finish(
 	}
 
 	xlog_recover_process_iunlinks(log);
-	xlog_recover_check_summary(log);
 
 	/*
 	 * Recover any CoW staging blocks that are still referenced by the
@@ -3560,52 +3550,3 @@ xlog_recover_cancel(
 		xlog_recover_cancel_intents(log);
 }
 
-#if defined(DEBUG)
-/*
- * Read all of the agf and agi counters and check that they
- * are consistent with the superblock counters.
- */
-STATIC void
-xlog_recover_check_summary(
-	struct xlog		*log)
-{
-	struct xfs_mount	*mp = log->l_mp;
-	struct xfs_perag	*pag;
-	struct xfs_buf		*agfbp;
-	struct xfs_buf		*agibp;
-	xfs_agnumber_t		agno;
-	uint64_t		freeblks;
-	uint64_t		itotal;
-	uint64_t		ifree;
-	int			error;
-
-	freeblks = 0LL;
-	itotal = 0LL;
-	ifree = 0LL;
-	for_each_perag(mp, agno, pag) {
-		error = xfs_read_agf(mp, NULL, pag->pag_agno, 0, &agfbp);
-		if (error) {
-			xfs_alert(mp, "%s agf read failed agno %d error %d",
-						__func__, pag->pag_agno, error);
-		} else {
-			struct xfs_agf	*agfp = agfbp->b_addr;
-
-			freeblks += be32_to_cpu(agfp->agf_freeblks) +
-				    be32_to_cpu(agfp->agf_flcount);
-			xfs_buf_relse(agfbp);
-		}
-
-		error = xfs_read_agi(mp, NULL, pag->pag_agno, &agibp);
-		if (error) {
-			xfs_alert(mp, "%s agi read failed agno %d error %d",
-						__func__, pag->pag_agno, error);
-		} else {
-			struct xfs_agi	*agi = agibp->b_addr;
-
-			itotal += be32_to_cpu(agi->agi_count);
-			ifree += be32_to_cpu(agi->agi_freecount);
-			xfs_buf_relse(agibp);
-		}
-	}
-}
-#endif /* DEBUG */


