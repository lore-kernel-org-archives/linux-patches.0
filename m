Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058900;
	b=TxEj9k3qSy9UMAbf7LQrtikkpLyJKTnbRiqrrv3zLVRWoth+On8O6YzwkyxntLaWH/t2
	 DRTcW13xn12kB96wHL9w70LXgCOhBEVt87/jFmSCWe91yv7yYzU6ulNDtk7+fSLdO8xMZ
	 IyeoTXKjEQiq2J/sc9NEQgGgvFA73BbCmV4RdewRkpS4XSUxe6bhiYMHprATRMFQJtq+y
	 3QF/0iPCGbidgufaDvJvmsXlPvKjfdqFkWhdzGBmwR09tlc1fWCBzyOxtY6EsCz/BZwcu
	 CF8hUz9oLMLo3GDX35MJUuzeyB+r/VMMvPbbr6fuB26KBhECR77DjJqb5/XYcgW9rEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O1HjiCgoClBUgL2TnqJrAkVwXalR527p48tWIT/cgO0=;
	b=ceiJ908/5Fus2MB3oRLzIjKYWzU0bpKA+PzQyep5RWvOZshrIrA5stZJ6z9tLQ6Ov8cX
	 USm3aJVq1Mh2aMfO/UYj7T8nOiRec8x9eDNJL/LAVuPAS4c8YvRaOJuYT2RSJTfKCCyRm
	 N1HTO2AQePLj5EFMJoGjeL/ZD4N0Gi8Dru32RK7ajatNzTKJk7zGduXWMZ8KADHLZUPdH
	 W3bkbhH1GhEA/CVvW1+x0QlF7Rl9Q2/0asaEVMiZs9FvnC7Q6MF9owJHsEdehGTULc1B/
	 jFmSuiXXPGFmIrfoRTkfz4XKLgn3kdCqQtycLnPRHxJQ3SKmQcR1fDn3Xas1Ol/mPbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FCqpPCVq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF55606A32F;
	Thu, 19 Nov 2026 03:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FCqpPCVq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE67A1F000C4;
	Thu, 19 Nov 2026 03:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058900;
	bh=O1HjiCgoClBUgL2TnqJrAkVwXalR527p48tWIT/cgO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCqpPCVqPBjEoM7bn2Y6THxUsaq9J2GLQG6vXErq4udhzFIJX72Vs+5UMyzsrmdn6
	 EBE5WPO8B/QeKtpVSCxYf5ooCJMCug6jBYp6R59S9ZRnF/Psfsae5GV7XWQBvGuY7z
	 vw3qxSrpvdNzoa4jfk+a5bJfMDYNQSH15ekvZGOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0650/1848] xfs: rescan the AGs if incore delalloc counter is negative
Date: Wed, 18 Nov 2026 15:44:48 +0100
Message-ID: <20261118145943.023114938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 47b1e941bb55f735d82ba2649412260da78b98f8 ]

LOLLM complains that percpu_counter_sum can return a negative number but
we instead misinterpret that into a huge unsigned value and do bad
things to fdblocks.  It shouldn't do that, so let's add a retry loop and
an attempt to freeze the filesystem to (hopefully) zero out the incore
delalloc counter.  It probably won't work, but at least failing the
repair beats doing the wrong thing.

Cc: stable@vger.kernel.org # v5.2
Fixes: 75efa57d0bf5fc ("xfs: add online scrub for superblock counters")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: omitted the realtime extent counter changes in xchk_fscount_count_frextents() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/fscounters.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index ec2064ed3c30f..de7151f55d0d6 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -157,7 +157,7 @@ xchk_fscount_aggregate_agcounts(
 {
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_perag	*pag;
-	uint64_t		delayed;
+	int64_t			delayed;
 	xfs_agnumber_t		agno;
 	int			tries = 8;
 	int			error = 0;
@@ -213,6 +213,11 @@ xchk_fscount_aggregate_agcounts(
 	 * of the computation.
 	 */
 	delayed = percpu_counter_sum(&mp->m_delalloc_blks);
+	if (delayed < 0) {
+		ASSERT(delayed >= 0);
+		xchk_set_incomplete(sc);
+		return -EFSCORRUPTED;
+	}
 	fsc->fdblocks -= delayed;
 
 	trace_xchk_fscounters_calc(mp, fsc->icount, fsc->ifree, fsc->fdblocks,
-- 
2.53.0



