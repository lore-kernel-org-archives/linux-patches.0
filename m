Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058994;
	b=E1XL4Isfry/bCZqgAy2TW0bVvzG/vjpe756QcLCFmYRgamZvCSr7LrNVBNbRBq1+FCZt
	 OYKfAdO5MtlipwBlnSlGi3xkSoxZoJCsZ6zLcvq9pFhxCjDDNCd588vMmzNaAxf/Hb9Ds
	 fpO+uDaUuv2aev1Wb13Cj8NQO63r7lEWeJK5tp8T03jH5A8ZOHv5MGRen4ExUkk9d3A10
	 bYxOIlgitplN3G2MemtozYurRiBZN0tw2XXgtDiioV8AIY2c8A2jOzIHt0GOU8Gh2w6Ru
	 yWApsSrsN32zuiV/U5R5mV7M9tOkDqj7xCpe6Tkq6SCk/mPLZWtu2kb8/QbPUe6FLUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W3OggRR6BiOg2BAFwsKnpxF5HPbNeIk6qA3A8gPk30w=;
	b=SIZHDj3t1HM4mzEMqb/r/8SWb85A/wrynmtxryrz2hsYgfWCv1Lj6ykLuB3U98HT2Xzp
	 wgpl/smTRwyPleLqUhTpVY8IYjyzQmIw55Jc9CyoSc5/t+KHJp/Ui6+aU8cnkK6Glqfpl
	 Y7FfYB9raSzUn7ZcEQWCurcwdh/5uPYfvfQ2/KlTPaIrMi+gcLL7yCOoNFvtdEWwdqvsg
	 I/XEZY5eqzHBucVTGdF/NH5p7MJwYNE/0kE+uAbKIpon6uu8fkMuT54BJh9VktCUMQE6G
	 JEiYEYr7bxddhJ2usLE+ZhjuNP3thTQRmmFscfE4fih76SnytnjEiBLZQBfWRPwsybg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=du7vF3HO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD817606A320;
	Thu, 19 Nov 2026 03:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=du7vF3HO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1136B1F000C4;
	Thu, 19 Nov 2026 03:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058994;
	bh=W3OggRR6BiOg2BAFwsKnpxF5HPbNeIk6qA3A8gPk30w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=du7vF3HOqnvedFxamuBkqcYB7E7QkbpebKvnG8olady4alKEJzYYBzI8QzzYpKPP0
	 oo+zmTYKpN0iUOyTvxzvilHNWNOs4bJ0+brwGEj2+TbxETh1P/0MBgk6C4sVZvFHY7
	 G3WEbldTakqjLBcXcFxcX9wafni+0qsZzznFp3M4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0684/1848] 9p: dont decrement a server-owned zero nlink
Date: Wed, 18 Nov 2026 15:45:22 +0100
Message-ID: <20261118145944.603541254@linuxfoundation.org>
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
index 74ecf2c9dcbd9..eb666ac84ea16 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -521,6 +521,12 @@ static int v9fs_at_to_dotl_flags(int flags)
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
@@ -529,6 +535,8 @@ static void v9fs_dec_count(struct inode *inode)
 
 	if (v9ses->cache != CACHE_LOOSE && v9ses->cache != CACHE_FSCACHE)
 		return;
+	if (inode->i_nlink == 0)
+		return;
 	if (!S_ISDIR(inode->i_mode) || inode->i_nlink > 2)
 		drop_nlink(inode);
 }
-- 
2.53.0



