Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831838;
	b=pHbS9QJ9m850NKV/Ahymw60Kb3PVXzhp52h6dTfLilks4TReAJfsfiIoZwlKX/GoaMo0
	 ZJbI0gHHilSS0RFi120HvTS0HUpz2UlYrNp+hkuucI7GAX3XeU08FaDMNsQwfoJs2AT7z
	 ztiQr56+FW9/Ct4M1Aj/T5G6DpqyojNIVvwwrvMvBxzcIyRATYkKPhZvzGjnPp8uNuEL8
	 xl1hacabBOLO9nc+KjMUbx6lxqsNociu9bBrDbe5qrjN+HCZiTf+gO6tBGIGRKOnEfrKW
	 Zlf8QzGGd/8oVHMWe7koKfUFvYr9EyxIJc+75OABXy1TjTiZcvBb+SduXkQaMJFObIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D3XwNrEVeZ9AobxuV/P7penLcKfhJBct903pc/tPYc8=;
	b=R2v2fav98nRyKbLH56Xt0RqAWYC9jMK0ttLD4/SZcWZEAqv6KkLw1KSdMc5R8n2+R9G3
	 NWRv83M0xvNyKG5JUP/NwMPzoGGvcAY5zKwLxHWRR5Njq/Wu3L8nttbZO10IQkLU2XY+n
	 yrJT5Gba98p9fOkoAIhD5y4H7q9ezYePCkzSDAk/xIKvaCZAqwSmt3vazdvTMqqqS/PEP
	 Z4OvYL7AxWMbej9MVNX/Ue/0f/hpU4PPPYFP80KHRIo0eQYEnkL0/yJlZBfgBNp1aNPSw
	 PhNKB0PWUG3ggAumRoFTXMqIVB5LIMWdGcr3INR7XLsegEqrb3Xd3TI2EbcP/X+It3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=baIKygZ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28D9606A842;
	Wed,  4 Nov 2026 22:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=baIKygZ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBFC1F000C1;
	Wed,  4 Nov 2026 22:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831838;
	bh=D3XwNrEVeZ9AobxuV/P7penLcKfhJBct903pc/tPYc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=baIKygZ4oy73epg/LGOiajXPCZE0wgmSiL/cBCiEGFgDJSOa1bd/zsAp4Xulbrjx5
	 zAXpaY2J6m53/xjsJt30QWDvQ20PTyUdW1hDwHUbMzh4GT0fOsqqEoHf3/GHpoQ60g
	 JWfTwGEIZoAJ26rk9d1txcY7EAYWXaTjEVu3HBmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 0884/1005] NFS/localio: report the stability a DIO WRITE actually has
Date: Wed,  4 Nov 2026 16:10:17 -0500
Message-ID: <20261104211107.996979159@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@kernel.org>

commit 077d39c1ac8c9b2e2fad8e66a2ba6250ced1a860 upstream.

Since commit d32ddfeb5593 ("nfs/localio: Ensure DIO WRITE's IO on
stable storage upon completion") a DIO WRITE issued through LOCALIO
is persisted before it completes: nfs_local_iters_init() sets
IOCB_DSYNC|IOCB_SYNC on it despite whatever the caller asked for, so
that the buffered head and tail and the O_DIRECT middle of a
misaligned write cannot complete out of order.  The reply still
reported the stability that was asked for, so an UNSTABLE write came
back UNSTABLE, the client kept its pages on the commit list, and the
COMMIT that followed ran an fsync for data that is already on stable
storage.

Report the stability the kiocb actually carries instead: FILE_SYNC
when IOCB_SYNC is set, DATA_SYNC when only IOCB_DSYNC is.  A write
told FILE_SYNC has no reason to COMMIT and sends none.  Buffered
writes, and any write that asked for at least what it got, are
unchanged.

Fixes: d32ddfeb5593 ("nfs/localio: Ensure DIO WRITE's IO on stable storage upon completion")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/localio.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -911,6 +911,7 @@ nfs_local_do_write(struct nfs_local_kioc
 		   const struct rpc_call_ops *call_ops)
 {
 	struct nfs_pgio_header *hdr = iocb->hdr;
+	enum nfs3_stable_how committed = hdr->args.stable;
 
 	dprintk("%s: vfs_write count=%u pos=%llu %s\n",
 		__func__, hdr->args.count, hdr->args.offset,
@@ -926,9 +927,20 @@ nfs_local_do_write(struct nfs_local_kioc
 		iocb->kiocb.ki_flags |= IOCB_DSYNC|IOCB_SYNC;
 	}
 
+	/*
+	 * Report the stability the write will actually have.  A DIO WRITE
+	 * is persisted before it completes whatever was asked for, see
+	 * nfs_local_iters_init(), and a caller told so has no reason to
+	 * COMMIT data that is already on stable storage.
+	 */
+	if (iocb->kiocb.ki_flags & IOCB_SYNC)
+		committed = NFS_FILE_SYNC;
+	else if (iocb->kiocb.ki_flags & IOCB_DSYNC)
+		committed = NFS_DATA_SYNC;
+
 	nfs_local_pgio_init(hdr, call_ops);
 
-	nfs_set_local_verifier(hdr->inode, hdr->res.verf, hdr->args.stable);
+	nfs_set_local_verifier(hdr->inode, hdr->res.verf, committed);
 
 	INIT_WORK(&iocb->work, nfs_local_call_write);
 	queue_work(nfslocaliod_workqueue, &iocb->work);


