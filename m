Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061619;
	b=ARSni3nD5Cg+IIz1Rzw1qMMt6RqywfrhICD863hPzNk7B/tvZSk1ZpA8nlOqa8v+e5dn
	 jq8z2vysYUKGYX8Ueh73mHANQG26C8plW7t+3ZnEr0oxJf7+GTfB20v9BmkYuP7zJixHc
	 /dcHRcODlhKJQ0fzkkoDH7SOsXbuO6oalQ0s76a+osCXvaZfRiNLFOfwjv6qTIuJX3Dfn
	 uaHUkuOttxWUamxoCwuX+zoTvac3AVH/4ZsIDptU/ZST/q2OTteo+pG7ohjtjBo+8oXgR
	 KX9Q+1L4lsnVgm2BeR/jMRTHlPizzTXyFT2GePhrIwfIDWcXWOnlWHJrGm0NabLZoGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JlSgmQZVY2iuAmrzbPWv6bB+ybpeXM6nsb/k16OODTI=;
	b=aEvFjyraNdaw+kw1P2RufUefANeySnEa+sMeVFeCQz1cLKfyQ38MxdyRl6BZNuD+Qpt+
	 IP+yBr8otMY8TMfeckdQZK8hpCUPaWVBp1RlT+T4i6N3pxDEck1DjxAAR7hR8fXYvbMB5
	 Ah+CBl2pJUawAr+2cZ4lieJJeOxr9RsZZuSTc5EKdXUKtqQhNdEcVQxAL0EJxw5k2O9on
	 fcG4rfxvnPSVjfmBH7SDkRYS582bdMToircM9wRVqaKaVa5Vt/xQAgl/tOxHxWq/oZUwj
	 477VpNpgYw2S7KBBAnWDGFEjlZtb0ZQRaDVLRVf80OKMLVPxXFOOO0QA5BksXw4MVhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=drPiJh4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA6C606A326;
	Sat,  7 Nov 2026 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=drPiJh4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793EE1F0089F;
	Sat,  7 Nov 2026 14:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061618;
	bh=JlSgmQZVY2iuAmrzbPWv6bB+ybpeXM6nsb/k16OODTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drPiJh4cOpEWgyn0sVWAABLARhUVdv/Pzf94IgVchXB+VYlmCA0PAqGMZM0UOyybk
	 tnhCeNkgFoy8WlJuNUap1X+13zvTP6hqNEveTq3BAMA/hAObIWiqhSBG+7lN/hdlEv
	 352+e2Q+9oFF48eEyNi+8cOjH0gI+RxWDOSVSPEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0687/1536] xfs: clear the symlink zapped flag if inline symlink is ok
Date: Sat,  7 Nov 2026 08:45:03 -0500
Message-ID: <20261107135016.785175244@linuxfoundation.org>
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


