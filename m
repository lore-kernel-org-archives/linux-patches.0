Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053369;
	b=bVG1zly7N5fGtgyMvvug8Orz1Tk2Lbm1BTUeiOF1yeZ731dzQLoHtopu0OH/keYYoSOH
	 WQ0gsBp3sZVaNS3uoxzITjjPkDCtKlKHuJQASy3hnPpPTjZldhlMp29tQqLu9tQGKW0Wb
	 0RV1IbulDu7A758C3dAxY0zjvouTQtaywmYOykDgO8TYa9aR7AIyqDzuVdHt7W4yhRRdg
	 NBsdKYarayr213WjRaQbF+L8pQfBNU5Fq69fXgE13oJImNKlHNtjv0EESPtuhkyM+lyi2
	 tRzQNPJqJbnTN5zlb+1V3NIIAR7RAUgegRKoIcYA22r4t/7SUNqa47Owp6Rg8lIKWpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tbRkI7wm//NcVxxp8Mjjrvkg4ccuQyX5p+HMub4Njw4=;
	b=L7kAHrNi91ridMBzCEyEkcy0TgWWgFZpIhf41pzfUSk/Vx3rgLApyEzeEtQUI/dyyzg+
	 4o4NheXuikcpJl9NIPW89EenLrakMT5Z8JYZLjEN3Qs3d6XZXw/d9ltAO6SGJ3upYCDjl
	 U4bDMBy7ZtKuzG9HCeLNyGl4zjKo55pZCdQBftcpvNTgsztTt6G1rDslZHovZxMzOCNTs
	 mJU25GA50ettE3gFttbnt6wiRy9WfaIM7YRqP+mB2KlN5EVHWU7kjRbC1N1uVaqXYaITV
	 yMkgCRLGUnhvN2xq8PiSf697Xce1uZYAbTuS5sO8QCTHSqy3g7fZZrVOiZcTLM3w5/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vc7xvFqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165D3606A31C;
	Thu, 19 Nov 2026 01:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vc7xvFqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6794C1F000C4;
	Thu, 19 Nov 2026 01:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053368;
	bh=tbRkI7wm//NcVxxp8Mjjrvkg4ccuQyX5p+HMub4Njw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vc7xvFqrhVR+OGz+GwQbzf6SNeGaD4Ikn28lP8ArZFli4QE7M792owf44zLrXn0ro
	 g7c3k83oJUQrBFs4iHqJX3QY4D47VSWteNFbWlkAxCMrrVFjZ/k8LSXycpej8n2Gyi
	 Q1gELWBQ+EUAbggvuJlkvAvRgZvS6xHIPBBSC78w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0845/2214] 9p: dont decrement a server-owned zero nlink
Date: Wed, 18 Nov 2026 15:42:01 +0100
Message-ID: <20261118150045.986782579@linuxfoundation.org>
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
index 2caea3390d6a5..6b9c6590a2659 100644
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
 
 	if (v9ses->cache != CACHE_LOOSE && v9ses->cache != CACHE_FSCACHE)
 		return;
+	if (inode->i_nlink == 0)
+		return;
 	if (!S_ISDIR(inode->i_mode) || inode->i_nlink > 2)
 		drop_nlink(inode);
 }
-- 
2.53.0



