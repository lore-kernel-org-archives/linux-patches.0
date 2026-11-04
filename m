Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831659;
	b=TxmxwF8HnpLNIbgTzk8cGu2Zg46nxxilT2PjptosoDTDZ/XbntdtPa8Xu4lFPzuKYTFI
	 OrviUr9zcFUM7eIx7sDZdtMUlhXv+ggGbjBehZbKVwKAqse/ZRk+C1VOp+MkxACylMMUu
	 ijpfJEU/4y9D68wFbp/RGYm+RtC2lBBuGMkzvaZWbIZPsEqglQN6z24TMImcnN/o9OgV1
	 ZSqjz6WkyxZj0iz38Ivg200x+tbFVvGJdVVQyS6NWdMfhjPY3JrSmyNYtWLc3mn678DNi
	 DLVBpqXUlfgQf0dSS5mZctJAENPeBcPxT06/9b/fnetQ2ECBRK8iME3uk2ss1E/It0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bb3d+39F93XScKEUBu6rr+fx4AI+G8IG7l8Z5RF3sWo=;
	b=HZmqg+reVNYtBnWZbVg2zLVe58eCCBWF/M1wMR9KBzb1AIrw0+XHfugCUGzVtXKOpNPk
	 tJsYqkRdMiegm3Xw1AZHmgn7QGgETapkJTwnvJWEZEk8SSH2QAeylU8gXiHj1Wkgw0aiY
	 lQCuFvH1Y2sAR66UuLAMZH08Mq2CQ9DoMa/+aA5T9U2ij5etSZy+WEPDEkcbZ2yCQJ8t4
	 UWoWhVAhtlCfPPZKQlg2QIv8J6AvAXNWsk593A1hfIYDl60JWNbb2IktEoH2sVrOCTrC/
	 3EbjD7BTvU9Mk3KIgWR/ffEjjIOorRXsL1q/5pfOQFZ8rzNC47NmBZ6WzNM5+AZn0vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zvf0pWXV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB42D606B2D7;
	Wed,  4 Nov 2026 22:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zvf0pWXV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696991F000C1;
	Wed,  4 Nov 2026 22:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831658;
	bh=Bb3d+39F93XScKEUBu6rr+fx4AI+G8IG7l8Z5RF3sWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zvf0pWXVi1YsiRGL3FyCfRDch1lRfrnKf9+wBsfuEz39l3IDQddst0wD7XK5lBJzo
	 CJmyAqyBgOheph/T7E8sNO28pPkS1jvrXa7pFVy9agbW9p0JEABU8OXcnqWSHowY3f
	 Ysaankvw3XpHjVn3jJU/Nu8YQ7bQNN3ebgpRsmy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0837/1005] xfs: always report scrub errors in tracepoints
Date: Wed,  4 Nov 2026 16:09:30 -0500
Message-ID: <20261104211106.771799090@linuxfoundation.org>
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
@@ -107,8 +107,9 @@ __xchk_process_error(
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
@@ -183,8 +184,10 @@ __xchk_fblock_process_error(
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


