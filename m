Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037494;
	b=BSNJGnwxhzLVyqoHS3uffu6CT+D45CfzGxBFxbp7SCa6mfCOegrx5tVAKfIHkSMc0GEg
	 efLXplQEZmD9Pk/XGK+s+SKg+D7IX2aPq9cowzxM1xeoRQxqyJU0cg83j71zHekHmZmhj
	 1+C8ZTXrNZj04WTZTVyM/0X2My79fiOw0CAzgRbhCg31MCo9vgImW5k6b9tLh8LQ1Cd0j
	 J3qmhoqQ3OHFCvufjS+Wmpg6Qi/AjQWu9cOugtlxaejAe7YI+KOVHk8wdKkcvrAh6Cv9u
	 xt9p9/lfkaB/ZfnR8TzZvjVqCdIEb4HFELdRb5b6jzfIW0axiwU3+P8F0gUlj3O97kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=38EdhMesqulZ5CcPF5Li4TctP7mDFJy+uFNRqV7VEXs=;
	b=hU3PtVVBE2+irchSp3wrdbSEFa7c4MI58c1+QXqLEXEGsnCm00wBLDNCgvxh/8qgxhm/
	 IUVXBWOsywgXTTpccujkSj718DliDmJWvWlPujRPkUgxdKa3YSEaHvQfcLomfXb26l0AM
	 A1jN4asNoD5dnbL3+Wz/ewCR6Q9VITivno8IGO39wHI780RnfIXmzwnue5mLRAAWtSkAi
	 KIkMODgxe42aQesxuVc0SJ3ZTBLVoWF3DYfqAK4PBaPu2ui7A43ipSSxbZQG5fy+O+Q0m
	 wXey9oJv5LKFWjpbSrI5jwcGfha7M6E+oNQqB2yfhe6wHkgHy6S+qP687ux8QTLZhmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYQ6NuAj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3812606A320;
	Wed, 18 Nov 2026 21:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MYQ6NuAj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038221F000C4;
	Wed, 18 Nov 2026 21:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037493;
	bh=38EdhMesqulZ5CcPF5Li4TctP7mDFJy+uFNRqV7VEXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYQ6NuAjg65Xzt5EgRiEwoKcJPKIuBRsszb4MkpE8zNbp8GW6Pza+iYRvfG1qgOuW
	 lsVFZXR4BXb0CdapodrjeLfQeLRwA7VBan3FLns0f4mUwIH/6Nd7lYupFCRMdR5pmq
	 7Fn1D+ZZNDcsrlAoZZUseGQ/abRiwNUzET5b1ycM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1415/3318] 9p: dont decrement a server-owned zero nlink
Date: Wed, 18 Nov 2026 15:33:57 +0100
Message-ID: <20261118150403.123670082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>

[ Upstream commit 4e915aa8566173b44146bc46177c85afbe6bdf96 ]

A 9P2000.L server can report nlink=0 for a regular file that still
exists.  On a cache=loose or cache=fscache mount, lookup stores that
value with set_nlink().  A later successful unlink calls
v9fs_dec_count(), which still calls drop_nlink() for a non-directory.
drop_nlink() warns, and the unsigned link count wraps to 4294967295.
fstat() on a descriptor opened before the unlink shows 0 before and
4294967295 after.

The warning on the unpatched kernel, trimmed:

WARNING: fs/inode.c:408 at drop_nlink+0xac/0xd0, CPU#1: trigger/188
CPU: 1 UID: 0 PID: 188 Comm: trigger Tainted: G                 N  7.3.0-rc4-00537-ga3ff15db6820 #1 PREEMPT(lazy)
RIP: 0010:drop_nlink+0xac/0xd0
Call Trace:
 <TASK>
 v9fs_remove+0x529/0x750
 vfs_unlink+0x2f0/0xbd0
 filename_unlinkat+0x340/0x6c0
 __x64_sys_unlink+0x46/0x70
 do_syscall_64+0xe8/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>
---[ end trace 0000000000000000 ]---

Directories whose cached nlink is at most 2 already skip this
decrement, because the exported filesystem may not maintain nlink
(commit ac89b2ef9b559).  cache=none skips it as well (commit
574aa0b479947).  cache=mmap does not take this path: it sets neither
CACHE_META nor CACHE_LOOSE.  A regular file on cache=loose or
cache=fscache still does.  Its count came from GETATTR and may
already be zero, so skip the decrement when i_nlink is already 0.

Verified on 7.3-rc4-00537-ga3ff15db6820 with only this change.  A
server that advertises nlink=0 and accepts the unlink no longer
warns, and the open descriptor stays at nlink 0.  An honest server
on the same mount still goes from 1 to 0.  A rejected unlink leaves
the count unchanged.  cache=none is unchanged.  With panic_on_warn
the unpatched kernel panics on the warning; the patched kernel does
not.

Fixes: ac89b2ef9b559 ("9p: don't maintain dir i_nlink if the exported fs doesn't either")
Cc: stable@vger.kernel.org
Signed-off-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
Message-ID: <8B490036-EBB0-4A36-AE39-F294F7C79649@stu.pku.edu.cn>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 3fbfd6aa1a361..6ce79084017fa 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -526,6 +526,12 @@ static int v9fs_at_to_dotl_flags(int flags)
  * nothing and races with concurrent metadata fetches that may already
  * have observed the post-unlink value (nlink == 0).
  *
+ * The same applies to a regular file whose cached nlink has already been
+ * driven to zero by the server: in the cached modes the attributes come
+ * from GETATTR and are applied verbatim, so decrementing a link count the
+ * server does not maintain only trips the drop_nlink() WARN_ON and
+ * underflows i_nlink.
+ *
  * @inode: inode whose nlink is being dropped
  */
 static void v9fs_dec_count(struct inode *inode)
@@ -534,6 +540,8 @@ static void v9fs_dec_count(struct inode *inode)
 
 	if (!(v9ses->cache & (CACHE_META | CACHE_LOOSE)))
 		return;
+	if (inode->i_nlink == 0)
+		return;
 	if (!S_ISDIR(inode->i_mode) || inode->i_nlink > 2)
 		drop_nlink(inode);
 }
-- 
2.53.0



