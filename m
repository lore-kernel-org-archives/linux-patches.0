Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044440;
	b=owcCcvn4BdXpRlHLgRUuBpMR8HxWCB58oPZ9MQ3r0Tz80xxe1KVMFcG9Lvypgy8A28O6
	 Z60HZUReKLepansTc3/nf+Nr8wnp63RhxDvIkNZoxxM+igtMlUyzXIX6IxeOPtjeiVhnO
	 a19QQGKYb3wSOeVZZFno75wh1VasU9WvGQ812YFWI53k8sECzU3+01OW2qjoEdbmZLC8D
	 6vKD0we6IN33ORfmqXHZFpuwo4qYPgrt2q3+6vPcF5sIm+9SAXgBJZxfLiaGg4TFTxi5M
	 PDzYr6o5MJi3LLfJ6SLhG5tLfQiy+GAY4T3eofWummo44UdY52vFxlhrADvq+blc6dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V4B+6diEXq4cgv4WaUzCDQPYRI/vXLbqJnAsLSJPRAE=;
	b=3e7D1oM5pvovSP0aY8UOCJ/q7BY26HnpWUGA6KLYOvPZPYQdySPzJ3pi0MgQLZCTequk
	 liiQmv2lXRx9NvV2hioImYDO+vt9i0biSHh9gvC7hoIe7xAXk15eDhEsb0BkeOE2T0DG/
	 CIkTROXgtgfhyrrmSu3Wx34Tbfa0QxUHVwy8QnF8MIlG3yYLdLjB94NwnsxitBFrRuYkS
	 sq1D25jpiKIaT04tXuzbEHs6q07TczpPPYE7TEJahEuVPVY+h/UhDNIQ3ISl5v+7tRTWe
	 Y9yK6iC1KA5pVtnT366tRmiHX9jjo0PaETjjglNM9S1TCs+iHOZzC13wALzB5Mk+L0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClVDU8hc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF56606A31C;
	Wed, 18 Nov 2026 23:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ClVDU8hc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9503C1F000C4;
	Wed, 18 Nov 2026 23:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044440;
	bh=V4B+6diEXq4cgv4WaUzCDQPYRI/vXLbqJnAsLSJPRAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ClVDU8hcavxwQPFoyfkz7UsmZKmlc6mtAh3oZ0hc4rWnNtZGiWoq/jhHSG7QrCzse
	 ib9nHSCQJZVbDMJA7INnwrS/uJy5Bph7YZvD0zP5nf8BhCwbq/AQBQl0+RZAnYvboa
	 sbIEDyvgWRmQhU7otzA1spytuFQXk/pp6ovMRoLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YANXIN LI <fadouse@pm.me>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.1 0566/2857] ufs: use u64 for directory size in ufs_last_byte
Date: Wed, 18 Nov 2026 15:26:40 +0100
Message-ID: <20261118150221.866461391@linuxfoundation.org>
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


