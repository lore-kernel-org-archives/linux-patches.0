Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046119;
	b=SlmGyPjXhOCt0VssKUAz4dZpcXyeD1nHwtNDgFblDKlFEJl8c5sBTRSg07RQa7ljrh9R
	 +tbNbIcdaU7BkRApqDCfp3rWoDguAf4uRznn8EPtZ0BtvyKEzgYpf7nEuUaNS6bEhI5S8
	 z7s5B7/eQLMEgKHbLigAWU2e8UkKXS636VvBfythFuNL0oB0HJS05Yzex2gS5FoT95447
	 6BFSRWL8lB+Arz6I7KdZJdPQplFl3TNsTCQ9IpCiXnW1UJ3/DJmbsMT6pdVRlRz7y6Ce4
	 iOBZTcubYsmmolWHpXzYHumDzW8JPdmBaRKR+Z/Sq8wO4vKfZwkNCMvXO/QPmOtrvCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+k0jV1b945F+AfzHm9XfUBPOKmxgS7oSX0tx7cM9Xfg=;
	b=Doxv4TQXVZygqB6nVMEa1aifk8PvBpD+m8EH73J2vvJ+JnjxSjE+2Gyro9AXC+jdRjVJ
	 SAh6HzI+EtrFnaoQHdlqEdAfYgUmho/H8i9pvqtTvK3l8ZTIh40IG7E+mRrdGia8Bvyxi
	 aDkarB2QJp1xCR8/sxt78gR4RCGoJMlwKOF4joL+Zt8pki09ai/rzB9rGfV3cydzFCuKJ
	 w0kk1NspFmPr4WN2MQjwmGkywt5o9SLJazHVy371/gDAjRI2IzcHug+FpdD7x+VWQp61W
	 TVRQYgD1lHml3xjuUN0BKmG7Wp0+BtAaG6WepF+uIySnjfa2TwLhsba6zzyeqk+X7RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qR5Jhvwj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F29606A31C;
	Wed, 18 Nov 2026 23:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qR5Jhvwj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070E21F000C4;
	Wed, 18 Nov 2026 23:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046119;
	bh=+k0jV1b945F+AfzHm9XfUBPOKmxgS7oSX0tx7cM9Xfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qR5Jhvwju3rTkeGy9S1v+/8KHMVtiQvSVxCz3KiU9Ys53P21ESpUsCtzf8GgMbIhi
	 kWDlzqmz9IQpMm6FXtd5E+Uk53NFW8fqLM+lHIjMcKEsPARx37y3x3zqmhutC1syzz
	 AIopTnSfXjHEcitseOTqGTqfnPNew25ptEmMX9R8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1160/2857] xfs: always report scrub errors in tracepoints
Date: Wed, 18 Nov 2026 15:36:34 +0100
Message-ID: <20261118150243.354101112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 1ccc8f553d885d49c1bfe141ea1f331511940b3a ]

LOLLM complains that the error processing functions in scrub will
sometimes zero out *error before recording a tracepoint.  This makes
diagnosing problems harder, so let's fix that.

Cc: stable@vger.kernel.org # v4.15
Fixes: 4700d22980d459 ("xfs: create helpers to record and deal with scrub problems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: replaced cur->bc_ops->type == XFS_BTREE_TYPE_INODE with a cur->bc_flags & XFS_BTREE_ROOT_IN_INODE test ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/btree.c   | 8 +++++++-
 fs/xfs/scrub/common.c  | 7 +++++--
 fs/xfs/scrub/dabtree.c | 6 +++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 5403ef11a21c2..bfd1dd4af9c74 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -45,8 +45,14 @@ __xchk_btree_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+			trace_xchk_ifork_btree_op_error(sc, cur, level,
+					*error, ret_ip);
+		else
+			trace_xchk_btree_op_error(sc, cur, level,
+					*error, ret_ip);
 		*error = 0;
-		fallthrough;
+		break;
 	default:
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			trace_xchk_ifork_btree_op_error(sc, cur, level,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 23de5443a12a6..b0b124943b79f 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -86,8 +86,9 @@ __xchk_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
 		*error = 0;
-		fallthrough;
+		break;
 	default:
 		trace_xchk_op_error(sc, agno, bno, *error,
 				ret_ip);
@@ -141,8 +142,10 @@ __xchk_fblock_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		trace_xchk_file_op_error(sc, whichfork, offset, *error,
+				ret_ip);
 		*error = 0;
-		fallthrough;
+		break;
 	default:
 		trace_xchk_file_op_error(sc, whichfork, offset, *error,
 				ret_ip);
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 1cfdba5b7f831..3b9655b3df426 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -48,8 +48,12 @@ xchk_da_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
+				xfs_dir2_da_to_db(ds->dargs.geo,
+					ds->state->path.blk[level].blkno),
+				*error, __return_address);
 		*error = 0;
-		fallthrough;
+		break;
 	default:
 		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
 				xfs_dir2_da_to_db(ds->dargs.geo,
-- 
2.53.0



