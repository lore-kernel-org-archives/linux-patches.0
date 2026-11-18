Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044172;
	b=TAoNoRiyqBP1BMQXjNrR76v5RA/sMpIzUCkRA4ajF75Obj3zvCYijE8SGfvMj0E4jK+0
	 MlIdVfbQTOS6tc71/d6+otZGi2o6sx5NhZYGeNAJV8voWmcNWm8FC3BQja86hGZYiKRIi
	 hh7P/OhjzxcuDCJpcbi+e9vOVoPEZD1CQung3IybheZqmENJRYRppyD5mGBmLtSrTOQgv
	 qKD3KRUPtmkXYqzVMO6jZVLmeoRyapOvq7Sv5WzVHUvlck1+DoXsFNUI5QZPW7C6XhGJL
	 Btl1Z53Qhl0nhRymIaCQQXSto59+ylr1ci0io1JPuBvDchcl2OtSxVZd/K23uE6AprA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qkLuD2IDo1ytrw6OxAXVj0f/KGuIRzWvNVEa69aGLzs=;
	b=mclQ1qYNE6nbTvbhrz8oC2Xq9J8OUW8CngkJYmyjzGVyu/ma64EoVuCEgKUy5tmYy6Kt
	 IwtQ0pzBVctPaJPAV94xtiSbSaiJzBze3X6JIFWxLqDiBNEcwF57n27siEypmFmDjO4+D
	 fOnQlAOh8HkphDDozHu7o5e6Skc7aNkGtojIPSbm60DFBaZ9XZiZsiXaNoPJoRopGf9z6
	 eqU+xaPljNlZcW67ilfhTYsepi/32WuKrdwH3qaLklhFjUqRdpq0lwfJFI54V1NsPB3an
	 zJbAxDO2eQ/zqmYPKEKsfxuNB4cOsoriBnbK1ipTjTef9yFDq/pVmd5N4rP0o0x8BOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lkmennk7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F609606A320;
	Wed, 18 Nov 2026 23:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lkmennk7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1381F000C4;
	Wed, 18 Nov 2026 23:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044172;
	bh=qkLuD2IDo1ytrw6OxAXVj0f/KGuIRzWvNVEa69aGLzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lkmennk7R/ZwAL68A0SP0aDt6Db63vS5WZNUwyzSRMeetC/iK55mzovN9RdYFmp4y
	 sQd242u30PqXCuQTETgpG5JvAfEsErQmBuFpI2ldw4+EnB7/MStcqrpcaAftiQFB5t
	 79fzq4kmEwMsKxZ0q7PfSyhueAOkeTEVEOEhakB4=
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
Subject: [PATCH 6.1 0474/2857] smb: client: flush dirty data before zeroing a range
Date: Wed, 18 Nov 2026 15:25:08 +0100
Message-ID: <20261118150218.511838264@linuxfoundation.org>
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
[ sashal: Kept this tree's direct i_size_read() size handling instead of netfs_read_sizes(), and dropped the now-unused ictx and remote_size declarations after removing the conditional flush. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index db3924bb21d6d..b9039f917c545 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3515,8 +3515,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *cfile = file->private_data;
-	struct netfs_inode *ictx = netfs_inode(inode);
-	unsigned long long i_size, new_size, remote_size;
+	unsigned long long i_size, new_size;
 	long rc;
 	unsigned int xid;
 	__le64 eof;
@@ -3530,14 +3529,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
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



