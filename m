Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061674;
	b=qpGTBOGchQB2giomBeDgIivNUKtI3gzIiHgIwSmPCLJ9VagzOs4ABi0yxFCBeFbQA8EV
	 ysTuu3cBnFKpCZMnCBqWpCCHtGRc/9PKmfwkJDBn55NZRUtGSEQ19RXXw+hGFhgZv8l2l
	 DsOe3WoZJkQKhrGUqFnraitfeUJl9Fdro3MPzqL6dmFtOo7jSlF15IwJm2Lx3r2dzDpzB
	 0+toCCyQqEwI/stvhcdlmtUQV9hzWejnhETsQqm+PqSBTbSPDeojmkgfFGqR59SpEbjmt
	 86m84EPgm4X5GXq3XuPaUHCRb3jQwr81/d0G6AwNmnOO7MfXZZmvPsdvLrVmwDl4Jnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NbiRE+AXXBitzvfaozpmHd624QYBJt4dzM5E7h/SU/g=;
	b=K6UcufHKmrkEkFG2aXG0yvOarX5lBFX1tNzafijrqay2k/O9DNgYoWrujZlnDc3E/oDB
	 L5R5I+Y6guyrUi6tJs1g/ezsLfAKsW+rBjCY0YPlbnAtzGiD/DkvNYGi3gXx+B1vc3fmt
	 rHlKFvd5drObqtgwxnf+XjI5a/WE7hTez+cRBp/QAr00lZtOrj6Gsfk1UVEgzCrroAQ51
	 y2jxR8NRGdZQjGaY+tENmGzPlQ/rWIxghfJqAw3I+ZoUhcqRtn3ACsopNL681D2TSGBb5
	 lwXjUfPBoUecZfs/2x62ONEDcG9Ybcw3ZvT+cwUIhHdGpjoUwWpDXCHnz+GKUe+Ow+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Q/0EO84/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B9C606A332;
	Sat,  7 Nov 2026 14:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q/0EO84/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55A31F0089F;
	Sat,  7 Nov 2026 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061674;
	bh=NbiRE+AXXBitzvfaozpmHd624QYBJt4dzM5E7h/SU/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/0EO84/1HQJGOATcnz9rVBPv0UyEenktblyQufVyhS+mQjArcQ4iThZ2LcVxDSzS
	 8BElckQwDm2UR3EfAxfXU8zZClfyaH73F+KnSC08KycWc1HNGMA9krSMDwv9LVT6B0
	 ANgZ/B2qRZrX/CYmuK1FbjB8mRfVTvzFADAORypI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0728/1536] xfs: always report scrub errors in tracepoints
Date: Sat,  7 Nov 2026 08:45:44 -0500
Message-ID: <20261107135017.950517713@linuxfoundation.org>
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

commit 1ccc8f553d885d49c1bfe141ea1f331511940b3a upstream.

LOLLM complains that the error processing functions in scrub will
sometimes zero out *error before recording a tracepoint.  This makes
diagnosing problems harder, so let's fix that.

Cc: stable@vger.kernel.org # v4.15
Fixes: 4700d22980d459 ("xfs: create helpers to record and deal with scrub problems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/btree.c   |    8 +++++++-
 fs/xfs/scrub/common.c  |    7 +++++--
 fs/xfs/scrub/dabtree.c |    6 +++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -46,8 +46,14 @@ __xchk_btree_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
+			trace_xchk_ifork_btree_op_error(sc, cur, level,
+					*error, ret_ip);
+		else
+			trace_xchk_btree_op_error(sc, cur, level,
+					*error, ret_ip);
 		*error = 0;
-		fallthrough;
+		break;
 	default:
 		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 			trace_xchk_ifork_btree_op_error(sc, cur, level,
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -102,8 +102,9 @@ __xchk_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
 		*error = 0;
-		fallthrough;
+		break;
 	default:
 		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
 		break;
@@ -167,8 +168,10 @@ __xchk_fblock_process_error(
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
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -49,8 +49,12 @@ xchk_da_process_error(
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


