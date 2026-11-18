Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053104;
	b=HOIVaeyIYz0bTQh51mm8DXzlS3X0rxi5U3GNI3KuLWE0XXbe55n8pPJap6xthiYvKs4G
	 5/GXmSPlsHdeXW4SBk2t7N9vjH3Klk2bu0XKNJh4yXss6A6bKf8bOEHQVZT6RKN/4dOyY
	 oUZn+wxGHsK07lpAZiCPyPcjCbhwXQjDjWrHc8qbQJnEcowdSpWIy5ZoBH8PNlkGZaA0M
	 Vwgd9jXslh7EC7LK2NIU+Bhs2Ak3gzhP9USJ4/l/U1rhiDLBTsdLwLuU/E8P3KKIOMYwi
	 BoyQWCTJeWWXvEWSbX+UnumwSI2o8ZESLXogfHCePVqYC5lHWXgIM2acs+nDbDc88/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wifLgrEbLFd/URu3E6pVN/sSc80GWtwqaD/eDzysSw0=;
	b=eLjZW3Yhm6nzQfeqoIrOVXgvVwUViGgo4oPjN6Hy9YMsWMtfBIvCT6H636FDMMSu21LI
	 RrDRjAU9sHqfIQF5ZtNc2GfpoqXqbOTL6JFIaP/Ao6yCCbVqKl54TatQra43MD6kMrcbs
	 PUtWEEaohsXq+kWQZWsxc2t7c7AAVC8mKeFPWUvkwr/H/vu6lUAmYDYlUjBVa+B+4/kOz
	 nkUQo8DnQQjOpLTlpXOgZgjHnxLpnV+7vVyken10u2Pd+OMCFXRWgsckoqB0o18AfA7aV
	 bUidv/kSIAE3jp5iD/NwekM6Vt1H0SCqMaITNYIrVv2Rl9ScPB0QnSgncjgzAd0f5Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxtRYWMS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB02606A320;
	Thu, 19 Nov 2026 01:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cxtRYWMS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAE61F000C5;
	Thu, 19 Nov 2026 01:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053104;
	bh=wifLgrEbLFd/URu3E6pVN/sSc80GWtwqaD/eDzysSw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cxtRYWMSfkh1oEwChSNnIJNTsHLmUGQk0FzfYmJC2ZW30Y44b3Ga6XaQihleI6Gs6
	 lelLKPTDCCSr7ORfl6miTJN+qpp1nCUQYZpOK+UzTnLYRSb34qdu1m59tNcEckOWAl
	 JCk1v/NNfTcGAbeKJPQA2pii57B+P3HDkPpfOM1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0802/2214] xfs: allow softlimit with no hardlimit in quota scrub
Date: Wed, 18 Nov 2026 15:41:18 +0100
Message-ID: <20261118150043.589991215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 342c2e00b3a99099a7088f7b8c8f075670c603a9 ]

LOLLM observes that the sysadmin can set a user's soft limit to a
nonzero value and the hard limit to zero, so those aren't corruptions.

Cc: stable@vger.kernel.org # v4.15
Fixes: c2fc338c87a31f ("xfs: scrub quota information")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: omitted the quota repair changes in xrep_quota_item() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/quota.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index d6c1b00a4fc8c..201672fe29b5c 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -102,21 +102,21 @@ xchk_quota_item(
 	 * suspect, which is why we flag it for review.
 	 *
 	 * Complain about corruption if the soft limit is greater than
-	 * the hard limit.
+	 * the hard limit and there's a hard limit set.
 	 */
 	if (dq->q_blk.hardlimit > mp->m_sb.sb_dblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_blk.softlimit > dq->q_blk.hardlimit)
+	if (dq->q_blk.hardlimit && dq->q_blk.softlimit > dq->q_blk.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_ino.hardlimit > M_IGEO(mp)->maxicount)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_ino.softlimit > dq->q_ino.hardlimit)
+	if (dq->q_ino.hardlimit && dq->q_ino.softlimit > dq->q_ino.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	if (dq->q_rtb.hardlimit > mp->m_sb.sb_rblocks)
 		xchk_fblock_set_warning(sc, XFS_DATA_FORK, offset);
-	if (dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
+	if (dq->q_rtb.hardlimit && dq->q_rtb.softlimit > dq->q_rtb.hardlimit)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 
 	/* Check the resource counts. */
-- 
2.53.0



