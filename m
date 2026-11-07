Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061628;
	b=cFxfjiqF1uPLY530Km8Q+sBc0jqRs3EevvXSiXVFEMdff+fpYLGB/Td8tYszz7Javyuz
	 yRbiPBWyv0Sn0ohrL5rwZyUtGXLVpD77W1KfqvL4SuVeubfPywoG9S4CzjMnpYQs3OKlR
	 I/TN8Vi7yD0FROoG0cyTgJKFkNH0Yto1dZOMF2kHfgbosdM7GAjdAQdAu5hMTvhPDSr9G
	 uaINT8jejGa8etZ8BUCD9tGutqswnu2RXea7oTkkz4ZKilhCx13a6e6726vDhavbu1Fm2
	 uT2uXyA0Ixsff4KIsen4I9eDuViDHQeXwYJLjjYxlQtXiXLphuTLhEkHWJ4Jt8ev/yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=skwwk8fPnKyDh97EPTd75tBzjNCPNht4uWg0dmniggw=;
	b=NG3rmXlbPnbJrOI5QJUqtKJvQHFyHQHtA9V4wUgnjDw6TzylmJJ2gUL9xzow7zdE+B0U
	 UxNQFKvo91Gq7saMbAx+q8Ch241BpS9Zzt2MVHommmOpvdSKz4jhFffXwK1jJMGL7Xuft
	 3wwVnRRiOvGdfggUnl6uomvJ+SobQ00YHulDaCGIRFXO1/gAvKGSObB/O7suYsRW+492c
	 JXKB+9qDDeuj+U0QpbOez3VGM32xAiREDDVlnoT3Ogf8TWEVRTkKfe5AnQ4QMPjuAJK2C
	 2j0bTMWCFHbnqEI+fuSv+kGLncLtPE2m6nveiVovqT2F5/dheFEGHPoldvK7pxscJQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuzGvnWf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D11606A330;
	Sat,  7 Nov 2026 14:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CuzGvnWf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425851F008BC;
	Sat,  7 Nov 2026 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061627;
	bh=skwwk8fPnKyDh97EPTd75tBzjNCPNht4uWg0dmniggw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CuzGvnWfEEK0BH75i/wYz6FaIER+BlU4HFY0mmnwBL0Fe2CCmCL2gtTaDzsmyZJ8d
	 apmzmuziUuZVYiHcHwPuyz3JLwPOlcANSRyPXfPJDXv2Z3L3Ek+Sj+/HW7sDFKbrkv
	 4mdSFcUrFLz6/x8g3F3OtQgXLAKWeV92tCDRAePk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0693/1536] xfs: online quotacheck must dirty dquot if enforcement adjustments needed
Date: Sat,  7 Nov 2026 08:45:09 -0500
Message-ID: <20261107135016.953579717@linuxfoundation.org>
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


