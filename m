Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831493;
	b=kdTNxZre9C0mIa+KjfQ/iSX1Y7Jak8++gCgqVmZOEXeqPHgGSFEelHD/N70OvLwFkqiO
	 +vLidg6TGJydpAvGRR7y9+xx6xXXGbVFbk9SV+ugIqxVht/4Vwgs4+ETLInvhc1HV4cko
	 X6udy0islsXlrWsJ9ii3E9nJKHKFFrFY/nlyNYs9pzPTOu5FJFWTqIAJLXTMaVBkqmND2
	 L5zkwq4Q9yB8rFnlGncBk98T8tvcmasxcHm1rr93mogHuuejvbSi1QWeeiijUUp2RMFJ0
	 Uj9gIEZrqnk6ZhJw6n87OuxTOuf+YnnSTFRfoNKzyHAQious6BsM/faYN8u1gb0xMPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vGnIlqS//egG+VXEJIG68aQCEEhJddOidOxtNldk10E=;
	b=Y4zRVJJWLCYz8Zf+fSdTIPgP8Bx5eywqXOYCuddbLKb5Lz26RQ9oRTRQS6+h+2xbHJSG
	 w41hdqcsexCmVFfhmFwIWl2X4BhH26pzp7oeBJwnqXj4a1U8FtIHXut2It6yfzW3mukm9
	 wkDnrhzPhjD0/dd91mtx62DuRoq6/54SRdK4qLnyExz03W2Uw3fiR66tWKkUVuKQ4uOay
	 4sEqWEAJLnXFzgBSY71JzGJjrKrSyQXhLqxQKIVWibLvXzkA79RT3LAUK43ZjrTVu3qpN
	 BYNyE9bUJLmMU+GmKIObkGwk/hznD5lb6csTrZGON0uBinPE6v4XOUuJjD2CTZzwtAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WuPM+9dl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B313606B3AB;
	Wed,  4 Nov 2026 22:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WuPM+9dl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9924A1F00919;
	Wed,  4 Nov 2026 22:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831492;
	bh=vGnIlqS//egG+VXEJIG68aQCEEhJddOidOxtNldk10E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WuPM+9dlVsgIuTfdVhoc+hjK6NxYoeFfAxnsxAuisy9AdsDbwzLD4ZjkVMjKpbfRp
	 K7+SiyHGfS97fzipPb+VkRw2zq3mhz4gPNpAzSRiCIrvH02umdKRnG8JNCEW1D/xf9
	 q2kJWXxJ/4KjOJ0c373KAdW6P8AD2ishmB2sTEsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YANXIN LI <fadouse@pm.me>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 0737/1005] ufs: use u64 for directory size in ufs_last_byte
Date: Wed,  4 Nov 2026 16:07:50 -0500
Message-ID: <20261104211104.128649324@linuxfoundation.org>
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
@@ -212,7 +212,7 @@ fail:
 static unsigned
 ufs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned last_byte = inode->i_size;
+	u64 last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)


