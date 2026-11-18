Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046240;
	b=AN+9os0fFpFvB9mStKqt/4/JD4Gj7GJfm2XqD0oSZZ6S7Nz3y+46xiNxi2B6vXsznq8d
	 7+Kl3s/WyUueyUaWWWoncbtrFHZp7LtkfUZRqrJeTJYuovzGMnrQv7EFzGMDFluztiK9N
	 i+nPbh2X0UsgpHVnOIFEp0tvvvYlsHP5mw3yu4pww/1uCdEYwRyWmnLirJzVnjoG0xZW7
	 Xk9jh5A7TfdHEx5HefdbuEhzkJdQ13DTWe9ACJczMznSIvZtujWn60drwBN2qHdKb/kE3
	 UbGny3ar1gesvWY37ilJh3CIyD8R3idMB0jrZsmamK9GyHS9LHGfIPAY3aj6Pjy47ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/3VrO8OvUVlKc115tCGjEqbRiGGEgus5+9AzdTRHlJs=;
	b=3eDtLJdf9hbPAjAx/dJO74NEPahDqyPg3/H8kKUR+RlRxvVDZOlEcothwbAWr8edBn+e
	 E66psadbB8OFzTgpY0taB2E+HzwsKfM+tY1OHY8kCEZk/fuKDr0Wx+KJa6Jy/UlPcqXJw
	 1nub2Nb2xwJmupmG1/O+BkcoBlwaGNF1PwBkr5DO90ta92O2miMAYhZXxQgXgDYMbIMsh
	 Uw+m31l5Ny2D4BRZs1xBMgQK4qhWxi26nFKHf09UAB4+wKuqW41peILWMcXOrroWgOoni
	 yuwCuPMrrm8fGboSL/V4wqa1U0CXJ2BXlIE2OSppU7YNoMdMAhbkDLtKJSPlClPxS+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aecIJBf/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119D2606A31C;
	Wed, 18 Nov 2026 23:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aecIJBf/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F0D1F000C4;
	Wed, 18 Nov 2026 23:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046239;
	bh=/3VrO8OvUVlKc115tCGjEqbRiGGEgus5+9AzdTRHlJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aecIJBf/mvWeM/H9EEUQ/bgRoE1dX4684JN+68bZE9OxHXvXLw/5zwSzMAosOBOZV
	 0N+2QrAja9hzQpZ9i2gJg44rna5wJGzjUMT3IgQf+9FkoyMEBW0tA1mK9csrnJTuSq
	 SFb+t++hKjc/VeFQboLQiiI3WFimrGKREbboBaP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1203/2857] 9p: dont decrement a server-owned zero nlink
Date: Wed, 18 Nov 2026 15:37:17 +0100
Message-ID: <20261118150244.916594660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1e7dce8101279..ba670d86894a9 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -541,6 +541,12 @@ static int v9fs_at_to_dotl_flags(int flags)
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
@@ -549,6 +555,8 @@ static void v9fs_dec_count(struct inode *inode)
 
 	if (v9ses->cache != CACHE_LOOSE && v9ses->cache != CACHE_FSCACHE)
 		return;
+	if (inode->i_nlink == 0)
+		return;
 	if (!S_ISDIR(inode->i_mode) || inode->i_nlink > 2)
 		drop_nlink(inode);
 }
-- 
2.53.0



