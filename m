Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828880;
	b=qcZxx6CxLJDbIluFEAHQSg957emDRw+XEeF6PyKz7t7KatIOer2ix890+T4tn/GPvQGB
	 7aq/n0P3Hv9XYRdNkiavkOfHwOZ4vKI9TroPrlyzxgaFRcaBtGOckd73BUd1ZZ5H905kR
	 RsNtq5b7hpbn0Ib5aSNB/WO0oFmfC3DSddCBc8zwxUE6ZHosJx+lBahfUxqytDp71sT1M
	 VUafIX4JK/jAXEt8MzFgV4LXbo/Sl/ItOGxk/ZTyuYOYotLyJDoE39ZmGcUFJGipiQyiM
	 qq3mGxNrCRKesx5fhKzvF36FMa1E/+liQw3nfOvm6n+5xD69plVG51xUyIW1Rr6dueQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UtRUcn0pYcfEXw5EthHnRbyROntyURQu2z4L80mfWUc=;
	b=0+63BjdnaXVif9ug8Iey5EXEBp+lsCbJz72dWOL1/NLz3lo0S3YNoZiF8Vug6m2G6Vkd
	 3Q8MjE5XuZ4DV0rDwOvphb7PstRLGT5EUQs7fo85aJqZUs4KsTsRrVgF5nC8nueS1wKH7
	 YJg7/YWPPPz6ml5PidC5m578Y0JFrSDiaY2gMhSHZUjXBpf2Hhr4KTKfc4QOuDbQpxP/V
	 wpwm38kiMvTn0XcQYh/2MHg9qFkGJyKG4+/RKNoIWrW7PyFUl4ip9Ff4d0yIg8rjJlY31
	 QhSxfodZWUOlMfS0EIbox+6BpM292FdBKGmyshsg6Mfchi/JH2MAexeZzRnWNcvFb0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqN6NsAf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26B76071AC2;
	Wed,  4 Nov 2026 21:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqN6NsAf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AD61F00919;
	Wed,  4 Nov 2026 21:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828879;
	bh=UtRUcn0pYcfEXw5EthHnRbyROntyURQu2z4L80mfWUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqN6NsAfOLtIHDIKcem8RN5V6EXLLEV1H3BvZFxm+Rg1cOzC+4f1sR2CsBD3yZ8y+
	 B1oS97Izfgz6Kkpf1G/PfIONVoybGW8IOYAyqJMnUPi/qKFbqZAD0Slda1j8tihAYU
	 mY3eu/Z2POPh10CcWbt1UwKJ7YnMxlXdneTI4Bv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 298/547] xfs: clear the symlink zapped flag if inline symlink is ok
Date: Wed,  4 Nov 2026 16:08:02 -0500
Message-ID: <20261104211046.665024382@linuxfoundation.org>
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

commit f8d0d90f2e24b1f4a14796ae63cebfd820cadfcd upstream.

LOLLM noticed that we fail to clear the SYMLINK_ZAPPED flag if an inline
symlink checks out ok, even after a repair.  Fix that.

Cc: stable@vger.kernel.org # v6.8
Fixes: d9041681dd2f53 ("xfs: set inode sick state flags when we zap either ondisk fork")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/symlink.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -70,21 +70,20 @@ xchk_symlink(
 		return 0;
 	}
 
-	/* Inline symlink? */
 	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
+		/* Inline symlink? */
 		if (len > xfs_inode_data_fork_size(ip) ||
 		    len > strnlen(ifp->if_data, xfs_inode_data_fork_size(ip)))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-		return 0;
+	} else {
+		/* Remote symlink; must read the contents. */
+		error = xfs_symlink_remote_read(sc->ip, sc->buf);
+		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+			return error;
+		if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 	}
 
-	/* Remote symlink; must read the contents. */
-	error = xfs_symlink_remote_read(sc->ip, sc->buf);
-	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
-		return error;
-	if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
-		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
-
 	/* If a remote symlink is clean, it is clearly not zapped. */
 	xchk_mark_healthy_if_clean(sc, XFS_SICK_INO_SYMLINK_ZAPPED);
 	return 0;


