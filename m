Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831689;
	b=fEoGwn00o4yCevXjzaZqfxjTCN5h8uP1KojKneaGO6lzCkNkhC7GbtuOMcURBKzBEGDx
	 O/K72rfnf8X8DDT8bsbwGcev++Q9GuVmjEA0HbGBDsFW7iRIjKW6rK5ej3a8jqGxXF35i
	 OdjShNIZAJVsmTwfLcn76eZsiEvNgWxe0bUkPWzrCO2uH82GpjFUefQaaJlO+CbEN82zg
	 8O69s5o8ClrxlNFJNe7J1V3c8mPjC2Ik4XxJs3wSLoptOyS5CqPjl3HGGkRWidrpHI90d
	 B18VYUWj4Lzr9WBuMD0NATLPz/DPb+WjRVu92N28++Dm5O0RoiJf+fdZ5HmyHYk/7Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LwSLPYaGuIp1EnWy7p0hYOXQxVTN+hdv/BflgMs2BTw=;
	b=lCPIGmuWtyEIi75bziJPnuRE6ly4jF+56zZTf1t8qaqr6uSIXLvzimLBTKvjegoiPrno
	 nBPaaCyiJl4dxlJ5jIuH+jmU3TsWB2BRMk8ifCuc+ONGae6oamQPKICPSJ7E53YnYGg6t
	 9h32+NLs4K4B8KTi3LowJe4unlVxXSIRGnRDw+PgLHTDgYWFzjU0zwNo2pmvMNDbDThTp
	 HiQrdSlWZFl7q+7o0EP6VPPd63T8Zeb/gyThCnVQo7bG1dcGicrZ6hCwwpiMj/pPj5r3M
	 hE6b4qbANnIQb1iCsAmFYQ6a0j8WTRAlsrLq9SVRx6A7Eq8XApnquHkCjL5z27gq89A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fy0+soGX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05115606A33D;
	Wed,  4 Nov 2026 22:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fy0+soGX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944441F00A16;
	Wed,  4 Nov 2026 22:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831688;
	bh=LwSLPYaGuIp1EnWy7p0hYOXQxVTN+hdv/BflgMs2BTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fy0+soGXV6k9mEdm17aPbkMzPrtx1jdx6Kr/rDGcSMxLvI/MM7pB+oF5rBELYxh6m
	 8BIHP/hMDIk5XVEgsMSNIftPe2NTLwafKgBWBww4ib4WNEbHrnKbTZHy8S9DvX2YKk
	 C+7xDXjyVp1rypHn0DOXVM0ilnOZvF9rgMtYfkBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0857/1005] xfs: fix data fork block count check in xrep_inode_blockcounts
Date: Wed,  4 Nov 2026 16:09:50 -0500
Message-ID: <20261104211107.291333243@linuxfoundation.org>
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

commit 147f9f8300cb284923e08bb8a7b32ba9681c45ed upstream.

LOLLM notices that for non-reflink realtime files, the @count output of
xchk_inode_count_blocks includes both the file blocks on the realtime
volume and the bmap btree blocks on the data volume.  Therefore, we must
compare this value to rblocks + dblocks to avoid unnecessary failure.

Cc: stable@vger.kernel.org # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/inode_repair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1720,7 +1720,7 @@ xrep_inode_blockcounts(
 		 */
 		;
 	} else if (XFS_IS_REALTIME_INODE(sc->ip)) {
-		if (count >= sc->mp->m_sb.sb_rblocks)
+		if (count >= sc->mp->m_sb.sb_rblocks + sc->mp->m_sb.sb_dblocks)
 			return -EFSCORRUPTED;
 	} else {
 		if (count >= sc->mp->m_sb.sb_dblocks)


