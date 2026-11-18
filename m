Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058914;
	b=qPJ8a83hKq3qIO5A+xkdI2GyNZBW/9xtGhGtOEecJ0nlMO4G/HPfCclimKUCSUxzUYTN
	 RdAUulgbxkMwT8oy4z0Eo6BDng3blF9qoP7epAUxhomE+bMw4Iul6ifNVC5kl2cTqLjfx
	 Zo99fVrVHHpaXaLd+OTmTUecLvNTdVV8c8URaWzG23ZR50BrsUuLYQ1YFHa9+JTRnhlau
	 aJSPvwgb+IwFQYBiGigiyWW5tCJXcElAtahqRz3Zd8DyOo4MCw5rwi5yzAE42UXRMeYrH
	 hJ/xXuTYPbZvAFA2efGoPfW4dBxqlJElb2MI4+s+rd1f76tNY0EEVSQe3yPgB6vPfHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bcHckDbbvKG56T8Q10gQhz6C8pKWXrOyab/xAnc619U=;
	b=u1Cu2lfnF4LeGivJK6gl7iQ8I0QVC9144csU7Z7K0j1/EhYL1SfsYvhFHV0BPN3pVeNK
	 4+mhLptaJ4ufBQBE4b6Lwezm9RYfAzS2NLU8OJy6MlOLYAOos0UF42XOhElD5QyLzdjuo
	 q1DG61mgoq9Mc1BF6ItILatn02uNwmB/sc7CQQ0KlLuGjkw8zZPDh3idQm6PwEZH0cx2U
	 LFnmWhh+PxMoveYXpJ2UpvP+zbmUysg0Jfkxdw9NN3V7IAeVIK1YoGD2rL6x9ZAJCXEq+
	 p3v/CX93MBnPPUAQ3yD9JsilfJRqe4cI5fJxZuDH3IYWK588UijN4FSEBqU979VLVSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2cWaEbE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C901D606A325;
	Thu, 19 Nov 2026 03:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b2cWaEbE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9EF1F000C4;
	Thu, 19 Nov 2026 03:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058914;
	bh=bcHckDbbvKG56T8Q10gQhz6C8pKWXrOyab/xAnc619U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b2cWaEbEnCt7GOPMgJq2QI5PmtkGWOTXWqI/iqS+bef5LDJMZNOLonv7gL1FLySCM
	 kA185WJ2O6Twsn3r6IQO1WoO9hUz7KZLD9QH+tWYA9YV3BamTREQMhs73sWiZVrGoq
	 3778oII617Hs/2tT+zu3WMWmTo0WD3taMrXm4IzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0655/1848] xfs: always report scrub errors in tracepoints
Date: Wed, 18 Nov 2026 15:44:53 +0100
Message-ID: <20261118145943.209174577@linuxfoundation.org>
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
[ sashal: Replaced cur->bc_ops->type == XFS_BTREE_TYPE_INODE with cur->bc_flags & XFS_BTREE_ROOT_IN_INODE for btree classification. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/btree.c   | 8 +++++++-
 fs/xfs/scrub/common.c  | 7 +++++--
 fs/xfs/scrub/dabtree.c | 6 +++++-
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 0175c0b33efac..56fb120baff68 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -44,8 +44,14 @@ __xchk_btree_process_error(
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
-		/* fall through */
+		break;
 	default:
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			trace_xchk_ifork_btree_op_error(sc, cur, level,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1fd24e68e13d8..502adf169ce43 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -82,8 +82,9 @@ __xchk_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
 		*error = 0;
-		/* fall through */
+		break;
 	default:
 		trace_xchk_op_error(sc, agno, bno, *error,
 				ret_ip);
@@ -137,8 +138,10 @@ __xchk_fblock_process_error(
 	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		trace_xchk_file_op_error(sc, whichfork, offset, *error,
+				ret_ip);
 		*error = 0;
-		/* fall through */
+		break;
 	default:
 		trace_xchk_file_op_error(sc, whichfork, offset, *error,
 				ret_ip);
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 74941bad930e9..24ac38014a784 100644
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
-		/* fall through */
+		break;
 	default:
 		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
 				xfs_dir2_da_to_db(ds->dargs.geo,
-- 
2.53.0



