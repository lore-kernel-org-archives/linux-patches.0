Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831277;
	b=h6CHawvpQUG06OafS0BN+ezoBsa3mKwODohnj9LyZ5D+ZYA0ktG8H2aFrZ2s9fXeLjVI
	 VVun+7w7zwUwUzBHVvEEYEjmDbAY6jGm+6d3VTYl6JwwzZ9dZmkdYbZ4LEuHdCsbsHDCZ
	 WZOuDJNIm/UQWXrPd/hsyBhj212qIfh2QdefvY2e/6VzXVxmc+dAE/BpIUzojYICHOsyH
	 BdN3uHLr1DR0aOJcauLSvpm4M8aIlrIkIe4ph46DWhu+Ky1jW5BCmfCRKwy+KnnpKTRTE
	 pfZy8DvWasRpN3eCHWvOI+Gw1cHRTFtDhQbCHbsjC8AFTmqCUvkllOR2nN7mfwH1PQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MBeYXpzUXXNJUquJCHgf+ZrPmpNLO1iDNd/YXnqyTvY=;
	b=wmajloRPth7/URO/qxsYjJM6RJpFN0XOK0rF9XWbJOvjJTRddOlP3E2X6XDayn72itfg
	 GyDVCJd8hwzEJzTUGljrAAn3ZvLDm5RTZ5siLslyZs6YqvnxDW4UTQseRzRuevz6NdLqB
	 fc26KaJwnJvSxoJEKOMv83d4veu1hx1Z0A4hBWwIjod3Zgcrlw3s7vfqSkCcpc22EfEd+
	 DQlcDCS4t4BDErTWX3K0UOIRqev1AzAHX7h02LGxFLh6cdwkyUJWD5EnwMN2qZZc3mkMz
	 aKPIsZWIuCd89ORuP8KGjHGN5pxTiqDuGnftkD1zPjladqT0QKwZK79GHBWT0qXlWYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPI4SrPA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8E1606A329;
	Wed,  4 Nov 2026 22:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPI4SrPA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9661F00919;
	Wed,  4 Nov 2026 22:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831276;
	bh=MBeYXpzUXXNJUquJCHgf+ZrPmpNLO1iDNd/YXnqyTvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPI4SrPAiPuLSHgT6KocE4F1rqvxVi5U5Bw2K2ccF4fMpJp73Y7OoDSSQoExErrCY
	 lj9DYSOWut4Ak/AlvfPwwR5yTwYi+esIiUypadoCOKm6d1y6fvEFWn+a4X5ai7mnPf
	 4Dt7GGCcMP51gZBNv/NDZK0T9FqRT6NXfLT1IXEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0590/1005] xfs: dont cross reference rmapbt with bitmaps if theyre incomplete
Date: Wed,  4 Nov 2026 16:05:23 -0500
Message-ID: <20261104211100.392365863@linuxfoundation.org>
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

[ Upstream commit d7b92cbe566f6fe54368f62e4b515d9f80c43a18 ]

LOLLM points out that runtime errors (e.g. ENOMEM) when we're trying to
compute space usag bitmaps are silently dropped by the rmapbt scrubber.
We ought to flag that as an incomplete scrub instead of reporting
cross-referencing errors based on faulty data.

Cc: stable@vger.kernel.org # v6.4
Fixes: fed050f3452da0 ("xfs: cross-reference rmap records with ag btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/rmap.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 39e9ad7cd8aea..bd792b304af68 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -493,11 +493,18 @@ xchk_rmapbt_walk_ag_metadata(
 	 * If there's an error, set XFAIL and disable the bitmap
 	 * cross-referencing checks, but proceed with the scrub anyway.
 	 */
-	if (error)
-		xchk_btree_xref_process_error(sc, sc->sa.rmap_cur,
-				sc->sa.rmap_cur->bc_nlevels - 1, &error);
-	else
-		cr->bitmaps_complete = true;
+	if (error) {
+		if (!xchk_btree_xref_process_error(sc, sc->sa.rmap_cur,
+				sc->sa.rmap_cur->bc_nlevels - 1, &error)) {
+			/* only set incomplete if we didn't set xfail */
+			if (error)
+				xchk_set_incomplete(sc);
+		}
+
+		return 0;
+	}
+
+	cr->bitmaps_complete = true;
 	return 0;
 }
 
@@ -567,7 +574,8 @@ xchk_rmapbt(
 	if (error)
 		goto out;
 
-	xchk_rmapbt_check_bitmaps(sc, cr);
+	if (cr->bitmaps_complete)
+		xchk_rmapbt_check_bitmaps(sc, cr);
 
 out:
 	xagb_bitmap_destroy(&cr->refcbt_owned);
-- 
2.53.0



