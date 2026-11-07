Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061483;
	b=1Vg1lmUIyK79asXSokA4sqPx+Mt5grpGBU+lLRKxk8Wj8Kx4NR9Pv3tRyNqYdfkuSbkT
	 JPOmd+Av41p+sh5NXycP5M2u9R/mmJs64DCZy/ejvpHBAULJ9d9gYBFv0+WESSdkjC6E/
	 ZCwkMKQaY6cH2Sv/jLCRqkbcpwua/x6F6bGy36SAsUZyoowa/yBya+ywVmktskdSZB+mS
	 iuwG5jEOaYB1g88WLFtKz1Qt8e2IZECLDfliTuTQT1qPdas+N5mgSBiys9y6lR7TkSzv5
	 l40JvTglCwv2ilU7Pdazl6JPBqvoWVsG6n4T/w6UZUZxOed/o6qnB0hzlN1MZ6qVNWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JzDQUaUNKqEnIrkfNycqqBBhHq3jH5BBnI65FfO6V/A=;
	b=iqD8WxP6Q42n2BXdKyh1BoEqyUfrpM+SFb9cltBOyo2QXdphjXqTKAHS4+gFSUMN6qhM
	 FlrWHfcWMd4HDuhyL+w4xCYa/7z69REsAIOocX1FPeieN3FtyT9fwfNyVMmpwEasFgTwf
	 CHTtjufcE9vl+H+GxwEMyJNwdAVRZZnz2N0T64qpnmnQylNBFSBdyZe1A1N7jNBzWNtDY
	 i+jHgqYc78tLkl0M8Ra8AvHYv0REC/k9HRF2CkN7ib8HuC0f4ejmshzcEIWSTmWNQyZ8o
	 cSrvxaTseR2EDVIgD9y21FY6ZzjKPb0Stj9XcLlibMWxG3YcD1KTBENNdqGoF0vsZhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0/yx/63E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B9C606A326;
	Sat,  7 Nov 2026 14:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0/yx/63E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94751F0089F;
	Sat,  7 Nov 2026 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061483;
	bh=JzDQUaUNKqEnIrkfNycqqBBhHq3jH5BBnI65FfO6V/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/yx/63ETWQQFyOsFRyo9taoZj47YDain/UhksJHR/osvqIjtQZQv4lg3ztl3cFb7
	 6jlmNrRfpjfCxc2ehWmRks9CnIy0rOdtU3Hd297e1PhUcyRm4cjTdqpQe3LPdhVZhh
	 67HtLC6VV/9nAP+Nu2zS5RFuFdo6G1ro8RxVxGs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0542/1536] smb: client: flush dirty data before zeroing a range
Date: Sat,  7 Nov 2026 08:42:38 -0500
Message-ID: <20261107135012.848745496@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 8f8d32c1044f70e46e87550e039a15ff20a4b21c ]

smb3_zero_range() emulates FALLOC_FL_ZERO_RANGE by invalidating the
page cache over the target range with truncate_pagecache_range() and
then issuing FSCTL_SET_ZERO_DATA to the server.

Dirty data was only flushed conditionally, when the range reached or
extended EOF.  For a purely interior zero range that does not reach
EOF, no flush happened, so a dirty folio overlapping the range could
be written back to the server after the FSCTL and refill the range
that was just zeroed with stale data.

Fix this by unconditionally flushing and waiting for dirty data in the
range before invalidating the page cache and issuing
FSCTL_SET_ZERO_DATA, exactly as was done for smb3_punch_hole() in
commit d7d2adcd022b ("smb/client: flush dirty data before punching a
hole"); the two paths are structurally identical here.

This is observed as generic/363 randomly reading stale data where a
zeroed range is expected against Windows Server.

Fixes: 91d1dfae4649 ("cifs: Fix FALLOC_FL_ZERO_RANGE to preflush buffered part of target region")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Adapted to the branch's i_size_read() size handling instead of netfs_read_sizes(), and dropped the now-unused remote_size and ictx variables after removing the conditional flush. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1a205f20e55c5..14ccca3f209db 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3486,8 +3486,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *cfile = file->private_data;
-	struct netfs_inode *ictx = netfs_inode(inode);
-	unsigned long long i_size, new_size, remote_size;
+	unsigned long long i_size, new_size;
 	long rc;
 	unsigned int xid;
 
@@ -3506,14 +3505,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	filemap_invalidate_lock(inode->i_mapping);
 
 	i_size = i_size_read(inode);
-	remote_size = ictx->remote_i_size;
-	if (offset + len >= remote_size && offset < i_size) {
-		unsigned long long top = umin(offset + len, i_size);
 
-		rc = filemap_write_and_wait_range(inode->i_mapping, offset, top - 1);
-		if (rc < 0)
-			goto zero_range_exit;
-	}
+	rc = filemap_write_and_wait_range(inode->i_mapping, offset,
+					  offset + len - 1);
+	if (rc < 0)
+		goto zero_range_exit;
 
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
-- 
2.53.0



