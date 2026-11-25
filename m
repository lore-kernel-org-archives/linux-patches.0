Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621935;
	b=1IPndY0AW4dkJ05dKHHYkWVsjbnfgc8WAVp4dQfieFxCPvJtFf/vXLuXwOATSwZRtCv6
	 U7X3OsYvNAWv3nyoqigoOTZ84dRqUxvfZEAf5L54BrCbfkNHWzQItKGdxIR/kqY0sghaW
	 Z4x/gg4BUPgEgopeThEBH8IegzbNpTBfaAAu80zRkfxX8vZyt0+1tTKHFRkAfJ33lrX0X
	 BiDXfWZMgpsSwJqaIzODRXIbMUmVylTsR7rB8OCFRaleVfJAhlKRMkCwrB6HvysvfnMYD
	 dnsoRuRp+Ww7esAPw2ShqZvnUt/4NirAz7j24AsOSn/x+cJHWLvzdT6kyOmwSk1b42g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SQSmlFtp2qS+FZTIrTmbVewKmTUhPo3f915+cVb/Rh0=;
	b=Jb/GoTO6z+9lVdDxmzvqF0SKttqNa8bnj0ozJFqas6zMQQMsJy3q5h90+vNeBlBRkw2k
	 VkI5yD0SYVubnrSWk9r8bYhYcKILLqo7PzAUFYm88CBUvLlZ5waL804uj7RPSXLAWS5uG
	 mDvK5Q2ZkTtYEgCedWCf0uIvRWgRdhAcRlckXBUlsgTmTNSAC8wU1HRDWennUPPszoG6/
	 zbrVwTD5+NKzS1fDUvtojmSFdOgEo+tdecCHqMDlnCNaSh0IznIgIS2rf0i5Yq+PAOGq1
	 5PvQjORae5DA+zCzbiIK21MFLXEh1UmQ7Tzv+Lt8zmGn1z5azKYVwg9W3kn7fjLyv/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KJVM0QRp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB58606A321;
	Wed, 25 Nov 2026 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KJVM0QRp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD151F000D3;
	Wed, 25 Nov 2026 15:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621935;
	bh=SQSmlFtp2qS+FZTIrTmbVewKmTUhPo3f915+cVb/Rh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJVM0QRp6b4t51H+wt2NgDDlyym1ESwDfOVxW+ZX2XmAqHd8ra9o9sZyC9SM9+x7R
	 TfDLLmBtI53WBn7wAaRUBtssFyYnBwwIj1TALDn/XNLuWeCcWUwA8i1ZZxIH5+XDjj
	 3w13EtONDg6mQUSDdYMCL1s7f26zHqnZe8Gln+14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 379/990] NFS: honor UTIME_NOW atime with explicit mtime
Date: Wed, 25 Nov 2026 15:29:06 +0100
Message-ID: <20261125143830.971485920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 2ffcf17d26dabef5793aeadf75a23c595a72be08 ]

When utimensat() requests UTIME_NOW for atime and an explicit mtime,
the VFS sets ATTR_ATIME but not ATTR_ATIME_SET (as it should). The
delegated explicit-mtime path calls nfs_set_timestamps_to_ts(), which
skips atime, but nfs_setattr() then clears ATTR_ATIME, allowing the
syscall to succeed without updating atime.

The delegated explicit-mtime path already updates ctime locally.
The VFS also supplies the requested atime value in ia_atime,
even when ATTR_ATIME_SET is absent.

Check ATTR_ATIME instead of ATTR_ATIME_SET to also apply the
UTIME_NOW atime value supplied by the VFS.

Fixes: aba41e90aade ("NFSv4.2: fix setattr caching of TIME_[MODIFY|ACCESS]_SET when timestamps are delegated")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 970e67768d67e..f74273cca3503 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -662,7 +662,7 @@ static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
 		inode_maybe_inc_iversion(inode, updated);
 		cache_flags |= NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
 	}
-	if (attr->ia_valid & ATTR_ATIME_SET) {
+	if (attr->ia_valid & ATTR_ATIME) {
 		inode_set_atime_to_ts(inode, attr->ia_atime);
 		cache_flags |= NFS_INO_INVALID_ATIME;
 	}
-- 
2.53.0



