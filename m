Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034874;
	b=2dw+Wps40sF1M+acL3vBZGYlLmCwbUIGpt+gb/rhsQZMUvZXmoVpg+gdMqYqyXZD3ofE
	 Dgmhjqov/ZWxacSedXwtNEFK3cjrzLtsThHa2MBHMRGmFPKHzKAN4+iNggMy9Q2aw5rOu
	 scvS0JZ2a23S3GoUUQ40MgpliEqICqpBMMS7QrNmUdt+XGHmHvv0thg8dB2A1gQm+mwbM
	 q9Q95MpeCqIEK+kuQim2BSQr0KL1g6PHNDCdJ8tROUM+rrBShUDa4T6Eit2enPMvvLw9z
	 21kUgc/yzqKxMo8cnkdHCDNJrqP0vXCuK9WsefOXoLBVC6v7KVLD+wSAHCNGVPgQZ/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cuNPi3k2IJTDO84Z5OJU3eNm97V/qjq8E1g6gkCbTQc=;
	b=l5TJP7zZuPyPNZRXiwTA52g23mf8xmTzlazLSbDE7xNlUh52yOvrHEF+TbIFPBlhda6D
	 mQJzGxJeIc+9qqmIiz3jW0xAP6kdXNERjW+ugeO+XY44jxIjfVX/xZsNaCn2r7pV61Cm1
	 RjqkBR1vDuYnS7Y8L2dJYaryzP4hsT1o6LfAK8VaMcZzRaUDNe1NhcJLeiJuIfL1IOlhy
	 mAeixZZ0R4IcUkKzFOn+pYIg4PnjtdehrbbmcGOcVn0RV4+jWTQZOUcV27yVhJdYiViZr
	 S0RnSr6FON8/KGEeaKl8Sl1dyt8HXGFYsi+16OCQZVKY+suQlvL1itdnohcDx6H9mXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJp3L2xj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC631606A31C;
	Wed, 18 Nov 2026 20:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jJp3L2xj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81771F000C4;
	Wed, 18 Nov 2026 20:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034874;
	bh=cuNPi3k2IJTDO84Z5OJU3eNm97V/qjq8E1g6gkCbTQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jJp3L2xjPJNdFI3S9P4kEzB1pD/guv3+N3tmJNRP46UR7vbXP/Xh4dxwb+MwEXcEZ
	 ++KbsleuJiTmTM1akFMce9Aw1qDftsl8aSBhI8WZVS1LHUOpo8XsBmll1MrwkClslp
	 4LGdL3ngTFV42/jwMLtPdslze+y6C0bjscuTzB58=
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
Subject: [PATCH 6.6 0523/3318] smb: client: flush dirty data before zeroing a range
Date: Wed, 18 Nov 2026 15:19:05 +0100
Message-ID: <20261118150332.876068661@linuxfoundation.org>
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
[ sashal: Dropped the now-unused ictx and remote_size declarations and replaced the size-reading context, since this tree lacks the netfs_read_sizes() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 968643f4ecdd4..256b8ddbc2b2f 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3262,8 +3262,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *cfile = file->private_data;
-	struct netfs_inode *ictx = netfs_inode(inode);
-	unsigned long long i_size, new_size, remote_size;
+	unsigned long long i_size, new_size;
 	long rc;
 	unsigned int xid;
 
@@ -3284,14 +3283,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
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



