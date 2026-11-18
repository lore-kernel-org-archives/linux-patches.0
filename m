Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057805;
	b=pLtwJGRVSfuFHkhOqwdHknspgp7ENAukLkYfnUmhPGTXx8/sZIFqWMzb2M4nDGgkAOCl
	 blV3GyCsL8ho7xSkJB3d2sz5KQg4kUMXMxArODR2UoUqIOtt7HEwJ25FhOrk7P67mHLIX
	 Vp6ZxviUFBAFSTBeB67WIaFOzsuvy3CYoWDaj937ktoa1xDnULdxXUwXM/3pXT/jwLVEs
	 aVQNDxBaPV8uK9wpQcmNuCKe+XhUbCB1Sn0Km8opydjVFJE0nXVG0ORbZXtJ9wc9xreBv
	 6VhIL1VJpfYzULsdVtV5wE/mE421vPRtGkReI6vFlpjysgdf7QEnZFKEMvjWQPAyfvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qanrFm4F8zpDrjZsMcy+ISaeZClW6SBngj/06NmWWWs=;
	b=K3sGPCzfNLfYe/tQM8C1fVnPAsJ5Q4hsRi22Dp+jGyc5qyt1QedAyL3UQBMSEagTDE++
	 rx4fv1RkzQ9V5Zqru6z/s0Ng1KvLwxvMB64ZZpiG2FkCJdGSTiSHzsj7q7bMz0NITiZDC
	 G/8Ls3x59D78ziCqot8NmtgljxIgq4BwwCwmHJzAT9+8w2XnOQyYJF3TE++bD60a7JzO8
	 lazyY/kDT7eUd+bGKwftXcHyjMLErTHb6JAkNLLdSDgZI1Bz8gddIEEpQAsX0yiECtXtn
	 qGpSTs2KKhun6xLfqPmvb/oj5ecZmldA1wXpakpwCEnUUSp05vp4tD3nsMSHRvcBYsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7GI51Er;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D41606A31C;
	Thu, 19 Nov 2026 03:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q7GI51Er
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DE91F000C4;
	Thu, 19 Nov 2026 03:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057805;
	bh=qanrFm4F8zpDrjZsMcy+ISaeZClW6SBngj/06NmWWWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q7GI51EryxAQNhNO/J4n+XH0K9J87vKlbFj7PThj89nhgRfzycp1MqD51YhXkVhJp
	 17I4BrFs8bfGnAGYufL+ePQpEtuMkfUG5oM84KQjelJYnpoEL06UBKhPaUfIO/2uBZ
	 Yluv191kmMTMcux6MJ/3Lu9ZYWPUIpDdMxSe8JDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YANXIN LI <fadouse@pm.me>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 0258/1848] ufs: use u64 for directory size in ufs_last_byte
Date: Wed, 18 Nov 2026 15:38:16 +0100
Message-ID: <20261118145923.053678803@linuxfoundation.org>
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

From: YANXIN LI <fadouse@pm.me>

commit 1eff23433e73d7da4f9e3529d2701e34962b161f upstream.

ufs1_read_inode() and ufs2_read_inode() copy the untrusted 64-bit
on-disk size into inode->i_size.  ufs_last_byte() then truncates that
value to an unsigned int before calculating the valid extent of a
directory folio.

A directory size of exactly 4 GiB is truncated to zero.  In
ufs_find_entry(), subtracting the requested record length from that zero
forms an endpoint almost 4 GiB beyond the mapped folio.  A crafted UFS2
image produces:

  BUG: KASAN: use-after-free in ufs_find_entry+0x583/0x6e0 [ufs]
  Read of size 1
  ...
  ufs_find_entry
  ufs_inode_by_name
  ufs_lookup
  __lookup_slow
  path_lookupat

The KASAN classification reflects that the adjacent physical page was
free; the source-level operation is an out-of-folio read.  A controlled
UFS1 test with CONFIG_UFS_FS_WRITE enabled also made ufs_find_entry()
return a directory entry from an adjacent anonymous page.  unlink() then
passed that pointer to ufs_delete_entry(), which cleared the adjacent
page's 3
2-bit d_ino.  This write result reproduced three out of three
times.

UFS normally requires a privileged mount path.  A relevant boundary is
a privileged automounter or image-processing service handling an
attacker-supplied filesystem.  The write primitive additionally requires
UFS1 to be mounted read-write with CONFIG_UFS_FS_WRITE enabled; the read
is reachable with read-only UFS2.

Keep the intermediate size arithmetic at 64 bits so non-final pages are
bounded at PAGE_SIZE.  With this change, the same controlled tests reach
the real on-disk directory entry and produce no adjacent-page write or
KASAN report.  A reproducer and full validation logs are available on
request.

The vulnerable helper is present in v7.2-rc3, v7.1, v6.18.38, v6.12.95,
v6.6.111, and upstream master at 1229e2e57a5c.  Runtime reproduction and
fix validation were performed in an x86-64 QEMU guest running v7.2-rc3
with generic KASAN.

Fixes: b71034e5e67d ("[PATCH] ufs: directory and page cache:  from blocks to pages")
Cc: stable@vger.kernel.org
Signed-off-by: YANXIN LI <fadouse@pm.me>
Link: https://patch.msgid.link/20260718190300.867109-1-fadouse@pm.me
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ufs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -211,7 +211,7 @@ fail:
 static unsigned
 ufs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned last_byte = inode->i_size;
+	u64 last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)


