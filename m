Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053121;
	b=HglPrL8lvFaTp3C8f4fgWW8PWtHMfiWqxv4/sNvEhIFYEgDMSn+0c0etlpo1ry9tuNX0
	 d/jqNKyM1q0FldmLl4pKYSJxg9dvIPFZRH2r4pLUKU3O2ULBzpjQqnwcfvbpHd3ljirpO
	 5ACxeseikQGmNL1Os8IzcF7IHcaRqjqTwNzc+4CHYAvh/M4HZDwbkXeqrl6tBAKdcDjhe
	 s4Xnc6PCl0WwRpXBQRyvQ62E9RZCJQogavbTfo2uI65vu84CfLahkxgYy+3JNaHz9Cxie
	 Tk4S3V7eskjySAHhEqaQzgnwueCxFEg8eKwGl2fnciy3nqx2dkmqLwiFCWqfUMAzx2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053121;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iI+q1h5MEgQmieiGyRKXXXx6cx7rh5uNThJZJxq+dlY=;
	b=LZuKzcmB5fX5IuvtdEqE5cKrPvvHMORulUZQqSDzDNU4q03Ds+8ESbRWCV95+rW7GwMn
	 moPEOqPP3v3PAVd+aF/pYNOVEtuGJ8yqoTseHyBNeqM7XXfYTpr8hna3Ld/yDoDxplRX9
	 yZSlj66DxQpqpHDep98O9ZYAzJJgwpHckiOor/TPRmPGkTUd2wobfCFaLPPNFXM5T/ePH
	 GfUBa9xmP7bk+HreNVom9VSV8hvSeu9NcLxyPvpAGOktxJlht3Labf0RT4iS8NqfCO7Om
	 Z9JTsqp5uwWHRj54hoPGCu5n31at8jkdVA0xi6uP5jklx8xQNneH7aixJ3WsFnq93gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XzkvxpTe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1098C606A320;
	Thu, 19 Nov 2026 01:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XzkvxpTe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F93A1F000C5;
	Thu, 19 Nov 2026 01:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053120;
	bh=iI+q1h5MEgQmieiGyRKXXXx6cx7rh5uNThJZJxq+dlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XzkvxpTeRu9/4JCZI58xUhNaxPrWDd0hgIbxOPqvlA/o6DzhfftbaAJbSPnXfUe+g
	 9F/i1j8c4lC3hqDgPqzYivfYjOCNwPozB78u+prbhEJqj4k7WMsewjAa5817lQtkuj
	 boOdJJWxIvbCPe4zTefHf1dibPGt6nyg3fo5XHfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0807/2214] xfs: always report scrub errors in tracepoints
Date: Wed, 18 Nov 2026 15:41:23 +0100
Message-ID: <20261118150043.764670297@linuxfoundation.org>
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
[ sashal: Replaced cur->bc_ops->type == XFS_BTREE_TYPE_INODE with cur->bc_flags & XFS_BTREE_ROOT_IN_INODE. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/btree.c   | 8 +++++++-
 fs/xfs/scrub/common.c  | 7 +++++--
 fs/xfs/scrub/dabtree.c | 6 +++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index eb4e49b8b8479..9e9aeec3b202f 100644
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
index 96d5806637300..bbc9cc2d3e2b2 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -84,8 +84,9 @@ __xchk_process_error(
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
@@ -139,8 +140,10 @@ __xchk_fblock_process_error(
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
index ff34b3e4f3ef0..bbb45c008778d 100644
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



