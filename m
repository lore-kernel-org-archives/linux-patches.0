Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828960;
	b=ND9lh95uetmlrgMmz23n3HiB3bSpWjl331/TJbBTthrG5W4vk25M9nAH82AbOqQ/O6u9
	 1jLSj1MzYW1iuGtYMXcWnDw39SgAJTKt7BTAKcWjfjw9aJgpSnV/4gT28+rJHfhavpx/c
	 aDeoB3yZcouUVRYIXtv8qs7YKxkuYZXbC07y8+aqD2AJfa+g2teWh2HPh68RGw6m7q/sR
	 K0E2pIz5JWYQHuMgrdFfdvcq4Iry1Z+LgusOe80hEaB7sYAckX4qllU/kwUed+eiqwEnH
	 WpiE+joykeepdogZCLJENOQE6vp1yVAEcGUEJxlzlgmd29z/CCJsSYwq5a3sSC4jsKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R1XvKuY0EAevieHitWbZNYQnwD8vYPXcwkjLYJsul2Q=;
	b=HBkd+joWj85CnkCCXRBaaTLkqr6CjonsjsX2nStbx0uMHTv61sQJ9FJx7YXqOzxrxEiy
	 fP3dKH9RUtkZypDNHTdoRl7klAQaZkqYEORkDGWgAlR15/ptz4rnyMi1qNYRL7/sPqL+J
	 nMy1Rf4V/ByF3OAeVOMmyNAquP2WEG6wWTBSr3jhjsCyf4SmHRMxNqpeakpehPOZrzmB+
	 8Vizby5EwbKwGW8b9ypR+L4/gDIjVkMxM0tuRZ3jhbsQhLEREXWGOKsC5OKoH+ycGtt1V
	 yGvolAenc5iqwTQrUpIpAAlnGTcN+zyglVt7h3bRd0sPiysWG/lXfFHMNAqahLZtjZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XDKEcUUp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51BC6070740;
	Wed,  4 Nov 2026 21:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XDKEcUUp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875981F000C1;
	Wed,  4 Nov 2026 21:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828959;
	bh=R1XvKuY0EAevieHitWbZNYQnwD8vYPXcwkjLYJsul2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDKEcUUpNoVtJJIXa41PyJigljGqoGzue1T6huPYFbJH3TU/pZm12NRqLqSqq310O
	 muNwddX1igeEqZ9JQvGYGHt5g7fgjzF5QPUxSVwGH0o+II2PT176CweEiuSeX/HHT8
	 FlUXjfiD8Q+gqc6wm7cmLBcaqLgda7AG6LtPzakg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 346/547] xfs: always report scrub errors in tracepoints
Date: Wed,  4 Nov 2026 16:08:50 -0500
Message-ID: <20261104211048.097508032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


