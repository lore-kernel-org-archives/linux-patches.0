Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831567;
	b=f+fOcEzeIo7n6xtcg0v/qNWprb7HWHr7nMEAbiaJSZVO3Q8Mh8CKLonHWFDcNNH3ll7a
	 FyKktKFAdaaIXuEzyrDgEGgcP/t/brHZpSTYhQmlPBb65BUjFxvx2DjU908T2EfNUme72
	 BVAgiggwNOaokc3DSmyYlG2oqL8K+mTESPJgX1eAttxREzR5GjsG2iURhSt50Fi1/i2Ym
	 1gfyrSAuFlhRWLgF0R2xeMhsj/q4UHdOgoc6uAwSp39ZQFNuzT+qZ6Y5ACboQwu2ab5Ll
	 lX4f02hq2LmLea8LUaB8zTTWfhTtMoCVJ51aYzKT8qxMRSZh0FntMoYCxeQ9KgxVkpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=48I6r1pciWWh1I6m8qjfGLt5cn3jR7Eh9yV8tPkUE0s=;
	b=zV4deh4pnHGGdY/50RpZotYoAClTrUFvQeYiFidurrBg6vYBa9Zaxi9wYeatSMwf6I9W
	 1uI0cpJy2q7TlVZC9djgfPfm+qm9ELCi/FxiJpuqZSGOA5/y8R+q1wLJ7oCxYM+qbSxJd
	 vFVEqq4fppO/ZuWk06fmq1BKzM8obRxLaYv/dhjK7B8Sf/6ESBKaLpoEE5dpcVRNCYcE5
	 OhhTpnXPWlRjVA9ewKm0mKmPo2+n8xCZLS/WUSdAfIzC76Em7UBebG5jrbf66oH92auHe
	 L4Kwg5SWD99HP4pmMIuyETZay6dwW/F8FPKMzp++78fW5GA9foVB+cKWMEB2RiYpUiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBj6QO2Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF232606A844;
	Wed,  4 Nov 2026 22:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBj6QO2Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425781F00A02;
	Wed,  4 Nov 2026 22:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831566;
	bh=48I6r1pciWWh1I6m8qjfGLt5cn3jR7Eh9yV8tPkUE0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBj6QO2Z1azgQyKoPJDjPhoBLeCdW+NgzbJlp0wjzyRnBYTpPsb0DOqCON9qli36J
	 D4NUsfVRECDEs0MzRWLQkrP6OoaTcdfXxeybSrC5SvwvCfB55IMrlYDfwy/Os29OdM
	 lEq2gFITUT5wXOenz1YpmFdfhKb/f+GochXS2frU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0780/1005] xfs: online quotacheck must dirty dquot if enforcement adjustments needed
Date: Wed,  4 Nov 2026 16:08:33 -0500
Message-ID: <20261104211105.214236430@linuxfoundation.org>
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

commit 244425cf63d7e3a0ff5736b41f0e0afe807f7031 upstream.

LOLLM noticed that we have no way to force xchk_commit_dquot to call
xfs_qm_adjust_dqenforcement if nothing else is wrong with the dquot.
Therefore, add a new predicate to force the dirty flag if the dquot has
zero limits and there are default limits; or if the grace period timer
needs adjusting.

Cc: stable@vger.kernel.org # v6.9
Fixes: 96ed2ae4a9b06b ("xfs: repair dquots based on live quotacheck results")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quotacheck_repair.c |   51 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -39,6 +39,54 @@
  * dquot is locked.
  */
 
+static bool
+xqcheck_dqres_force_dirty(
+	const struct xfs_dquot_res	*res,
+	const struct xfs_quota_limits	*qlim)
+{
+	/* zero limits mean that we should set the default limits */
+	if (res->softlimit == 0 && qlim->soft != 0)
+		return true;
+	if (res->hardlimit == 0 && qlim->hard != 0)
+		return true;
+
+	/* do we need to adjust the timer setting? */
+	if ((res->softlimit && res->count > res->softlimit) ||
+	    (res->hardlimit && res->count > res->hardlimit)) {
+		if (!res->timer)
+			return true;
+	} else {
+		if (res->timer)
+			return true;
+	}
+
+	return false;
+}
+
+/* Decide if we need to adjust the dquot limits or timers */
+static bool
+xqcheck_dquot_force_dirty(
+	const struct xfs_dquot	*dq)
+{
+	struct xfs_quotainfo	*qi = dq->q_mount->m_quotainfo;
+	struct xfs_def_quota	*defq;
+
+	/* root dquot does not enforce limits */
+	if (dq->q_id == 0)
+		return false;
+
+	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
+
+	if (xqcheck_dqres_force_dirty(&dq->q_blk, &defq->blk))
+		return true;
+	if (xqcheck_dqres_force_dirty(&dq->q_ino, &defq->ino))
+		return true;
+	if (xqcheck_dqres_force_dirty(&dq->q_rtb, &defq->rtb))
+		return true;
+
+	return false;
+}
+
 /* Commit new counters to a dquot. */
 static int
 xqcheck_commit_dquot(
@@ -93,6 +141,9 @@ xqcheck_commit_dquot(
 		dirty = true;
 	}
 
+	if (!dirty && xqcheck_dquot_force_dirty(dq))
+		dirty = true;
+
 	xcdq.flags |= (XQCHECK_DQUOT_REPAIR_SCANNED | XQCHECK_DQUOT_WRITTEN);
 	error = xfarray_store(counts, dq->q_id, &xcdq);
 	if (error == -EFBIG) {


