Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590881;
	b=RfpeMpw0RgbFc4F6lwTVv0oRN9VLmGG/JOVljEJkxumCgWpZ1CO7JzLj/IsirKxdU0OY
	 2ZuW7pfDsrnx7ZgsCmLTT/TIBrJvwSXw9kcgnuSawgMelxRaxXhPhGNH/Bwh1m7YwBjxH
	 iqUuoLDSyR6kTzoKpgDV1QkHDZGqd1VkRkAPh4Nc8kqbxTprbhyM4LaUK2O94JWfm8w8n
	 cv8XvKzrRV2quyaT/MEi7jaSwgVyrLxlaX9HaQpBiEfIywwbJYUCq8/FNCFl69zclu2kR
	 lfGcxSFoK/TtetoSgE/l8kpI0lw0Nqu4d4u4qvFsgzS+1IP/TxVUpuVIJ1O9jyZaCdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IJYvhvyAg6wQAdG4WgRpUyecEsBUwylsKLgnLkTTvEU=;
	b=jDmbUiOh/9VdC55alF1UFC14xGdEZzwCwTcZi/bbjyreA2DOljZ2cqhS2sVrXgZHyqEK
	 RE4s6hYLokO+Fq4Ijm+EiEQlnopwHcfeJ76uMMJBe/6ORXyOqm+0D3Ptidq5AInsstIPY
	 mVbmiBzk9fjGWM7jDwP054D3RsYfSMV1u+ui7aZalZ8vrz9jpoG+xOiyHlJ8cOm3XhuOA
	 GiSpb3vH7h4gFEZeCZoDWvJMqH12KA8nzudM936a04Qrlq82Fxb68EiFcr/f09Tyz/EO8
	 a8Zb6VvANqAXejBEzxyk0PtRUZaT4hmGZW6U6WVuYEbLUOByBlFeACTz2uH96KXLoPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anZu9t0B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBBC606D4B4;
	Fri, 13 Nov 2026 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anZu9t0B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E68F1F000C4;
	Fri, 13 Nov 2026 17:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590881;
	bh=IJYvhvyAg6wQAdG4WgRpUyecEsBUwylsKLgnLkTTvEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anZu9t0Bz8SHgLoJMKkUxBXmY8e8ttcLRbJC/lTNwpzi/3A5mqUMLrBOBNKx45hMW
	 0Maw9rZOL2zHoyU7shJej7rOE1guLgBiXyMkzGXiSHZhkw0vttxSgIyvVEa8Z2AyYe
	 2I6XICIJTZn6un3C+Esy+DXjsT7iwzZ88YltGPeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/670] xfs: dont try to repair rtsummary if the summary file isnt computed
Date: Fri, 13 Nov 2026 10:44:00 -0500
Message-ID: <20261113153814.142108432@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

[ Upstream commit 6e82b7641889ad0198f3bf17a5e4c6fe7aab0850 ]

LOLLM observed that we can erroneously try to repair the rtsummary file
if we've not yet computed its contents.  That results in a corrupt
summary file, so let's add a flag to track whether or not the incore
data is complete.

Cc: stable@vger.kernel.org # v6.10
Fixes: abf039e2e4afde ("xfs: online repair of realtime summaries")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Adapted xchk_rtsum_compute() to the existing mount-based realtime bitmap APIs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/rtsummary.c        | 9 ++++++++-
 fs/xfs/scrub/rtsummary.h        | 1 +
 fs/xfs/scrub/rtsummary_repair.c | 2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 746990ae0ec1e..942f93b1e22ed 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -201,15 +201,22 @@ xchk_rtsum_compute(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xchk_rtsummary	*rts = sc->buf;
 	unsigned long long	rtbmp_blocks;
+	int			error;
 
 	/* If the bitmap size doesn't match the computed size, bail. */
 	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, mp->m_sb.sb_rextents);
 	if (XFS_FSB_TO_B(mp, rtbmp_blocks) != mp->m_rbmip->i_disk_size)
 		return -EFSCORRUPTED;
 
-	return xfs_rtalloc_query_all(sc->mp, sc->tp, xchk_rtsum_record_free,
+	error = xfs_rtalloc_query_all(sc->mp, sc->tp, xchk_rtsum_record_free,
 			sc);
+	if (error)
+		return error;
+
+	rts->summary_computed = true;
+	return 0;
 }
 
 /* Compare the rtsummary file against the one we computed. */
diff --git a/fs/xfs/scrub/rtsummary.h b/fs/xfs/scrub/rtsummary.h
index e44b04cb6e2d5..af1ab64c3f212 100644
--- a/fs/xfs/scrub/rtsummary.h
+++ b/fs/xfs/scrub/rtsummary.h
@@ -17,6 +17,7 @@ struct xchk_rtsummary {
 	xfs_filblks_t		rsumblocks;
 	unsigned int		rsumlevels;
 	unsigned int		resblks;
+	bool			summary_computed;
 
 	/* suminfo position of xfile as we write buffers to disk. */
 	xfs_rtsumoff_t		prep_wordoff;
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index 7deeb948cb702..536f0b8e3bfd0 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -110,7 +110,7 @@ xrep_rtsummary(
 		return -EOPNOTSUPP;
 
 	/* Walk away if we disagree on the size of the rt bitmap. */
-	if (rts->rbmblocks != mp->m_sb.sb_rbmblocks)
+	if (rts->rbmblocks != mp->m_sb.sb_rbmblocks || !rts->summary_computed)
 		return 0;
 
 	/* Make sure any problems with the fork are fixed. */
-- 
2.53.0



