Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061690;
	b=QwzQlCWAkb5Fip/ygVOtZmmxXIkmks5t/B0RfIH4obFD6RoK6uCzB2kECPiPF0gxOgb+
	 nUtSRMCI/KhaMqxlsc2Xp6rgmoE+NLC2GLB7ZFoU5B9FbtKt1P7vHjDwcFLFU6WZoubS1
	 UggFqVNS1g7wHtvi6uR+/fhEkH4ZBmdcaF1iwedBZ2bPCH1Z6phjI2ns6tRDYsjvBYoET
	 0yVqderADLEksBIbS8ZtczquHYzxITScGbTaYcjRymapiWH9MikNGGvWBa7ydE610g6NP
	 8qMeegA+eUroKLQ++O1t4iiVpSpHi44lu3xNpkWqLb9dI8GvdtUfNPpT5BIdHaHUGjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MGvrM1rxZDMdlbTkLUfvve5gqWP2oH34y4VdsnDRInc=;
	b=04ResUFHu7IqM4Dn/iTukk6cRNaM0i1LrbILseH+3pe+mxSXzzY2JiUjiwoVPQ5w9FKf
	 7plppWTRqbX7k5HU60iApHbdX3EJrc9UOlFZw4rLRdC4qG8JtrAGICyrUaMoKXQzJGAkQ
	 J4Dv87Xt43S2AjHExEyo70CW7SS4C9N2fvfsDOjx9ahtPeolQxbIX/6jqnMreyvl8pOja
	 eprGrVs23rqsRqBtDwvklSOmc4K0ZgCfLnqJmfJ/2wrzNYaupfaOBNz+Zj1clyC8Oai9g
	 Cq8hqQz5zI9H14TZhZbR8M2kNa03wE99i5epU4+2qEjPUbT715h1RPK/qCpYwlHrQZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WuWNEFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4CA606A326;
	Sat,  7 Nov 2026 14:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2WuWNEFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD051F0089F;
	Sat,  7 Nov 2026 14:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061690;
	bh=MGvrM1rxZDMdlbTkLUfvve5gqWP2oH34y4VdsnDRInc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2WuWNEFFaLy/PoNs/5xrCct7EVPfAzSZQHx2GGIH+c5vMO7mMCdgWMcs9roaxn2Oo
	 vaLm+SOO8kE0wr+0kYJ63N/JH/4j99m+ClNgiKqSfKyBiK7SEwtaUMzEOpefpQIkn8
	 aUN5yBFeOTuehgk0PaMrij8tlShwOoWfBxZ6JJLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0740/1536] xfs: fix correction of unwritten extents in quota file data fork
Date: Sat,  7 Nov 2026 08:45:56 -0500
Message-ID: <20261107135018.306527949@linuxfoundation.org>
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

commit 6f2792720673f569fa3e1f68181b9d6fd26802b5 upstream.

LOLLM noticed a couple of problems with the code that fixes unwritten
mappings in the quota file's data fork: first, we should zero the ondisk
contents as part of converting them to "unwritten" just in case we crash
shortly after the conversion.  Second, and more importantly, it noticed
that we fail to resynchronize the iext tree cursor after modifying the
iext tree.  If the tree shape changes, we could be in a world of hurt.
Third, we should force a quotacheck if we reset an ondisk dquot.  Fix
all issues.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/quota_repair.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -418,7 +418,9 @@ xrep_quota_data_fork(
 	/* Check for data fork problems that apply only to quota files. */
 	max_dqid_off = XFS_DQ_ID_MAX / qi->qi_dqperchunk;
 	ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
-	for_each_xfs_iext(ifp, &icur, &irec) {
+	xfs_iext_first(ifp, &icur);
+
+	while (xfs_iext_get_extent(ifp, &icur, &irec)) {
 		if (isnullstartblock(irec.br_startblock)) {
 			error = -EFSCORRUPTED;
 			goto out;
@@ -442,16 +444,35 @@ xrep_quota_data_fork(
 
 			error = xfs_bmapi_write(sc->tp, sc->ip,
 					irec.br_startoff, irec.br_blockcount,
-					XFS_BMAPI_CONVERT, 0, &nrec, &nmap);
+					XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO, 0,
+					&nrec, &nmap);
 			if (error)
 				goto out;
 			ASSERT(nrec.br_startoff == irec.br_startoff);
 			ASSERT(nrec.br_blockcount == irec.br_blockcount);
 
+			/*
+			 * We just zeroed the ondisk dquot, so counts could be
+			 * wrong.  Schedule a quotacheck to fix that.
+			 */
+			xrep_force_quotacheck(sc, dqtype);
 			error = xfs_defer_finish(&sc->tp);
 			if (error)
 				goto out;
+
+			/*
+			 * Set cursor to the next block past the extent we just
+			 * converted because bmapi write could have merged
+			 * records.
+			 */
+			if (!xfs_iext_lookup_extent(sc->ip, ifp,
+					irec.br_startoff + irec.br_blockcount,
+					&icur, &irec))
+				break;
+			continue;
 		}
+
+		xfs_iext_next(ifp, &icur);
 	}
 
 	if (!joined) {


