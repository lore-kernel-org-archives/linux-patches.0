Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035166;
	b=SM8cX8U7WkzswLSHYHNq6ybyHY+QkYX7/KVuITurrmoP9nxyEW1Ylc7372zNYTp7Scpl
	 7PtHfWohZc1EjZGyBO/hgFLPEYz92uU5WVIEyZYXVuN2vJkZ4OSAFf6yhGnKcTlkf3AdL
	 Nw6eUjPNTmlFKIHDS9YDssZtIGv8yJ2D1aBM/tUnljJnDzt0Spxqa+Flz40esQALZ6DPo
	 s+AmqJms/7YKiz+8KOIBZcYIVTe0ez/vXhVr2Yi24rf7V4G3Xt/tpt/EZ8echz1SeAHEH
	 47NnGJoKsO/L/t5gRsRO1rOh42MzSjle/PS4VjVdPvQnS/usIgmSurhDys1ddSXkkfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J+9bQ0TptxtghN2hqzyBchRxf4PdExMoMDlTuFaDFss=;
	b=uhe5fNYHZb0T0XRLrOllGVVZ+10kYa7PmtWG6bO166lKmKfCOdRSoxOgkFexauqrcDrr
	 Z5i5re8pcPt9lw/VLVRn0w7s3XztQNGEagZMW2g9urUGdx+TcXayX91mZYOwFSQhWZl5v
	 xK3jsSujKKiEwoTu6Vkubn0OzYm5DW89Sccq3QP8n0f5+wqRmnZp8oJpx1FwD+WtvWJCI
	 AEr1CFM42bp9v11l/YEBP91KxIpq7NUDKcI0mTVrsx/VJNsovTH5vIUL2hQs0clIDbu8j
	 e6XoEU28bfa+DP30rGi5/r7mu8Z9Sx0ZnJDphvZwmyYUW2m+WHVNhGzmQuBJdiw1g0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7rpfrBY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200B1606A31C;
	Wed, 18 Nov 2026 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E7rpfrBY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA791F000C4;
	Wed, 18 Nov 2026 20:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035165;
	bh=J+9bQ0TptxtghN2hqzyBchRxf4PdExMoMDlTuFaDFss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E7rpfrBYtNfXunoRA1ksDthD76pXNm55jdgkZbLmsy1VAAXOf7XadMcxwtRcUOP/V
	 mKcBW3jXXVl1lXBUaaALnxQPu9yfzIu8sBM5paiqeo4vA3PU5GRZQxEJGcrwiEOZLk
	 B+4dEeUpZl+6c6qB3FeTnPr5aRgckWzI3g5BQjXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YANXIN LI <fadouse@pm.me>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 0628/3318] ufs: use u64 for directory size in ufs_last_byte
Date: Wed, 18 Nov 2026 15:20:50 +0100
Message-ID: <20261118150336.708716578@linuxfoundation.org>
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
@@ -221,7 +221,7 @@ fail:
 static unsigned
 ufs_last_byte(struct inode *inode, unsigned long page_nr)
 {
-	unsigned last_byte = inode->i_size;
+	u64 last_byte = inode->i_size;
 
 	last_byte -= page_nr << PAGE_SHIFT;
 	if (last_byte > PAGE_SIZE)


