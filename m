Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044479;
	b=EwzZz7RFh4G5AmhHFStJHRjqyY/R85/fNtCM4EX2dHWBPFVfFZcn1RcbHT5ymaXXm0t1
	 6SzeEosg9jYXozhOW42oWS7y1zsES74jXMAvqaOEKU/ClDiUtxyddDrZzWBKtOuBrgcMS
	 hfFdPzdY5NSxXh7u7WJdLCDox/v1rxM1cGye7wkxvl0L+rY+HCTb3hVU3LMxaWHSYbcRX
	 vhb3jTs7TUo8aoHSbZ8AO5fVzymkAKtAiOHJgfARyD7JDKFtH1utq+Y4e5Qo1Gw5kvAR7
	 I/oagtrP4xc+nhrJ58FqMod3C3fs89ITdGapkggR86wEOsCAEPYiJVXf1+uFdLbekGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QINbLgUF8nqi9FexY69sPMYvvxzyBBlnPIvAg3pqTsc=;
	b=23l87A4UPTHweK35RoIw3TaoCigeY2CVemTrRkT9gzlwxADtHSyBkUbh3XCPiFldLd7K
	 9yAkPi6X1eGclEaONnMn8Jht7AuBtz7wzPA2hrX2LxEg8KM04jQIE621ay9xMnq7sSTTc
	 3vPhu1kdQWabhnfY3arqGPxYJWW9GCgy4hNT24Hbo3EciEAPAY9LTtmrQPME6oJHNRA6T
	 paFVDwHCuw6dldegDxen2ZTjGm63EIhw/hsdMmKZfqR5saO1ah0srviOhWTJ1n6UBklGN
	 KictP6sZf4FfnMqIrErBRRFALOYTOuUuVy7F3kqw/cdEJHBa9aPAlibNFg4LYwAY4dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZMELtor;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E8F606A32C;
	Wed, 18 Nov 2026 23:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZMELtor
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4AC11F000C4;
	Wed, 18 Nov 2026 23:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044479;
	bh=QINbLgUF8nqi9FexY69sPMYvvxzyBBlnPIvAg3pqTsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZMELtor2NfAv0cDBGQ7KGwAPvfjIZ359PTlksYO1+RKOgMPkrl3vVznERwfFSgyT
	 4zJ/sQAxQXXIuQlsa/N0u2uUxDeGDyLA/NbJII98J0HtAQGBJcjLPNyh5YSaGmUyFf
	 Nr8mgIq+vjlh4KYvpkt4y0+QUGqOe+NQVd02uiQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongjun Gwon <d3bugee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0583/2857] ksmbd: serialize directory emptiness checks with readdir
Date: Wed, 18 Nov 2026 15:26:57 +0100
Message-ID: <20261118150222.473738843@linuxfoundation.org>
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

From: Yongjun Gwon <d3bugee@gmail.com>

[ Upstream commit 7220980b2423d06a0604516129bfa4cec8a697ae ]

SMB2 QUERY_DIRECTORY holds fp->readdir_lock while it calls iterate_dir()
on fp->filp. An SMB2 SET_INFO request with FILE_DISPOSITION_INFORMATION
can resolve the same FileId and call ksmbd_vfs_empty_dir() on the same
filp without that lock.

iterate_dir()'s inode read lock permits concurrent readers and does not
serialize per-file iterator state. ext4 stores its dx readdir cursor and
fname RB tree in file->private_data. Concurrent reset or refill can
therefore free a fname node while the other worker still traverses it or
retains its RB-tree link, resulting in use-after-free accesses.

An authenticated SMB client with list and delete rights on a directory in
a writable KSMBD share backed by ext4 can trigger this when the directory
takes the dx readdir path. The client overlaps an SMB2 QUERY_DIRECTORY
request with an SMB2 SET_INFO request carrying FILE_DISPOSITION_INFORMATION
on one live FileId.

In one x86_64 SMP KASAN multi-shot guest using ksmbd-for-next at
171df27077fb, the unmodified kernel reported a cross-worker use-after-free
before a panic. The first report's access and free stacks show the two
request paths directly (trimmed):

  BUG: KASAN: slab-use-after-free in ext4_htree_store_dirent+0x488/0x550
  Read of size 8 by task kworker/2:0/29
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   ext4_htree_store_dirent+0x488/0x550
   htree_dirblock_to_tree+0x535/0x990
   ext4_htree_fill_tree+0x319/0xba0
   ext4_readdir+0x175a/0x2f40
   iterate_dir+0x1b6/0x630
   smb2_query_dir+0x1003/0x1cc0

  Freed by task 279:
   free_rb_tree_fname+0x67/0xc0
   ext4_readdir+0x13a9/0x2f40
   iterate_dir+0x1b6/0x630
   ksmbd_vfs_empty_dir+0xa2/0x100
   smb2_set_info+0x2ffa/0x45d0

Take fp->readdir_lock across the entire emptiness check. This places both
iterators over that handle's filp in the same lock domain while
preserving the disposition status handling. The exact code change
completed a warning-free x86_64 KASAN bzImage build. Tracing three request
pairs showed that the two iterate_dir() calls no longer overlapped and the
expected statuses were preserved. A further 1,600 reproducer iterations
completed with expected statuses and no KASAN report, Oops, or panic.

The reproducer and complete guest configuration are available privately
to maintainers on request.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Yongjun Gwon <d3bugee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: omitted the ksmbd_stream_fd() exclusion from the directory condition ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8d2f5e4e9ae3b..1157acc74caf2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6085,6 +6085,7 @@ static int set_file_disposition_info(struct ksmbd_work *work,
 				     struct smb2_file_disposition_info *file_info)
 {
 	struct inode *inode;
+	int err;
 
 	if (!(fp->daccess & FILE_DELETE_LE)) {
 		pr_err("no right to delete : 0x%x\n", fp->daccess);
@@ -6093,9 +6094,13 @@ static int set_file_disposition_info(struct ksmbd_work *work,
 
 	inode = file_inode(fp->filp);
 	if (file_info->DeletePending) {
-		if (S_ISDIR(inode->i_mode) &&
-		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
-			return -EBUSY;
+		if (S_ISDIR(inode->i_mode)) {
+			mutex_lock(&fp->readdir_lock);
+			err = ksmbd_vfs_empty_dir(fp);
+			mutex_unlock(&fp->readdir_lock);
+			if (err == -ENOTEMPTY)
+				return -EBUSY;
+		}
 		smb_break_all_levII_oplock(work, fp, 0);
 		ksmbd_set_inode_pending_delete(fp);
 	} else {
-- 
2.53.0



