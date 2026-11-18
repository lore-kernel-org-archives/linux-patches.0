Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035340;
	b=N+uS/3uXaY84KbTZ4h2XmSnjsHmw1zkn2Ry/jPsJ29FxX6y14nPvWPkxHF0xe39Bmi9U
	 H+SiV78ngD8wr8/B/3BkxtP+RydXDEv1M+H8ih5OgLxniVsV/cogBTif0q5aSgAALRQGa
	 rLD3dYIsKajPW115WuwJBmw2HmM2QbOJwaXhlm2Uyu0q0Kt8surwdMRr0bWWbwIpHrFLJ
	 Bn3uOKKkY5H6Z/tggKqn3VytixMOAfsSJbOp0ETWIWxaJVe90GebyVwyEFz64PZcm2l/E
	 us8tFQhDoq8pUv3BHuxGooAGx+pigtlA9Cx4nI0jRbF1bCdWmciDklpKhwOetzBpjZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=75djX4gS1VerkY8ugFFX/ZvQD5IExW2q2/JwzOyk5pQ=;
	b=syQmMTWIP9+Hg8szo34K3JFSZ//3/JGR3dQ6jK9NmWrwYU0+z/V8lSItnd4Nyh72flcG
	 4wkAGmobWIqIVuEX0P59z+HC0IgS4Q5doXYauxMx1c9hxpF6T2gMCWB9hQi4l3hmF1ru3
	 5tl0wZc4JS+6oQzjLEisKNEEwBcX2zCuIdueNZroGi+Iaq/H2Ryc6+lFgO1TDNc9guu5G
	 p4LTX39akd3dBl5RiLL0g8XUAkrpKPE0luqQEzDJi2DX+m8ohk3U4KEqWQFgleaz44rto
	 njaPiYyyh8cmB3/LHH74cgXOAAWDbBuSazw6zOsCmlkMn+MdHSCjPzTYyGLeR9DK0iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SfhqBzWU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB6B606A31C;
	Wed, 18 Nov 2026 20:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SfhqBzWU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5D11F000C4;
	Wed, 18 Nov 2026 20:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035340;
	bh=75djX4gS1VerkY8ugFFX/ZvQD5IExW2q2/JwzOyk5pQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfhqBzWUnNeIF8/S6uzgLDrQBWsTQ+6u/b/zC3QdcFQ0KhxtB/ZMiF/b+GRa955vm
	 dK/0YkvV41Ud8CcdePjNHDXnF3ttucZtV9HPBDUaJY1Rvw4jmE7JVJmIm7FcQhCs54
	 L/m3xznAVj93aKVwQS2z1qa6dwD5CEWm73n8QssQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0669/3318] xfs: bound inode fork length against the fork size during log recovery
Date: Wed, 18 Nov 2026 15:21:31 +0100
Message-ID: <20261118150338.186112609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 9232301894a06e664d8de2da97175cf98419bd16 upstream.

xlog_recover_inode_commit_pass2() copies an inode log item's data/attr
fork region into the inode buffer using the on-log region length without
bounding it against the fork capacity, e.g.:

	len = item->ri_buf[2].iov_len;
	memcpy(XFS_DFORK_DPTR(dip), src, len);

The only guard is an ASSERT, which is a no-op on production kernels
(CONFIG_XFS_DEBUG off), and xfs_dinode_verify() runs only after the copy.
A crafted image with a dirty log can therefore drive a heap out-of-bounds
write at mount time. The XFS_ILOG_DBROOT sibling already passes
XFS_DFORK_DSIZE as a bound; the DDATA/DEXT and ADATA/AEXT memcpy paths
did not.

Bound each logged fork region against the destination fork size before
copying it, and reject the log item with -EFSCORRUPTED when it does not
fit. Because the recovered inode is only verified after the fork data has
been copied in, the checks are done up front, before any memcpy into the
on-disk inode.

Fixes: 658fa68b6f34 ("xfs: refactor log recovery inode item dispatch for pass2 commit functions")
Cc: stable@vger.kernel.org # v5.8
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode_item_recover.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -467,6 +467,25 @@ xlog_recover_inode_commit_pass2(
 	ASSERT(!(fields & XFS_ILOG_DFORK) ||
 	       (len == xlog_calc_iovec_len(in_f->ilf_dsize)));
 
+	/*
+	 * The recovered inode is verified only after the fork data has been
+	 * copied into it, so bound each logged fork region against the size of
+	 * its fork now, before the memcpy below can overrun the on-disk inode.
+	 * The DBROOT/ABROOT cases already bound their copies against the fork
+	 * size.
+	 */
+	if ((fields & (XFS_ILOG_DDATA | XFS_ILOG_DEXT)) &&
+	    item->ri_buf[2].iov_len > XFS_DFORK_DSIZE(dip, mp)) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+	if ((fields & (XFS_ILOG_ADATA | XFS_ILOG_AEXT)) &&
+	    item->ri_buf[(fields & XFS_ILOG_DFORK) ? 3 : 2].iov_len >
+	    XFS_DFORK_ASIZE(dip, mp)) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
 	switch (fields & XFS_ILOG_DFORK) {
 	case XFS_ILOG_DDATA:
 	case XFS_ILOG_DEXT:
@@ -506,7 +525,6 @@ xlog_recover_inode_commit_pass2(
 		case XFS_ILOG_ADATA:
 		case XFS_ILOG_AEXT:
 			dest = XFS_DFORK_APTR(dip);
-			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
 			memcpy(dest, src, len);
 			break;
 


