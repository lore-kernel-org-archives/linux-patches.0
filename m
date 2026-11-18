Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033442;
	b=rmTsqNw0pia7mFL8G+n6k/61x34pXmqXSsvjz4OJLhf47uRAaIvqkmuT2E56a5ds084z
	 ROzrmB//XGbrB60hce2w9Uz5X95w5djBebLf7uqyyUY4Jex3MnFD/J+bax5+biIM2HTKu
	 vmBKehXyxkDZq7yZcwyzLqoX8M436gz+8eZj8kN18SJ0U4f9QSvmvc04pb7VQWIupYXFh
	 e9lA3nNc3WYK2cI4D7EmhHhlfDBpNIUxZUSpdmhLZtN3RD4ak0X3HFfAZ25KlrQ82kwp7
	 +4g7dmpsk5liMHKB/Ce2UkkXCA9g9OBWriO94H0Jv3WjRzUIi51Oh3AITfAM/DTM1Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dVWKi9UhLYOTDkWxmJqsBCtcpylEYxUGWxcb2nLUrLw=;
	b=qRQYuoOzYuLYZSG372ru+029f6qEdFplhGsMwAycXep7i9yW5xqA9SMjIFRiz334wUVx
	 ABtQMPB1pMB7IprPVT2oNAyc9qFAkE8WbDmYnUFafbAVjYgTcaJ7UZb6rTAlzpwx2IjDx
	 dtVQGr+FpdajtfqDeGsxdO1VYnKaMiQLhS/8VlHpeynrSrOSqanrSPIuHmbtn8geDjD61
	 x+aY06RA7czY87vR1v20PJuEUAOgmTnDIlJ5vQ3cRRAlAWkEbysy7AGOkYt6w0rbvslZp
	 TZcfULcxJS76cQwSRPIg6N7PcxhI74zMILVKD5NerlCk/M+VBmduH8wxxyeMPoiPz8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XDlusmES;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCE7606A31C;
	Wed, 18 Nov 2026 20:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XDlusmES
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAE91F000C4;
	Wed, 18 Nov 2026 20:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033442;
	bh=dVWKi9UhLYOTDkWxmJqsBCtcpylEYxUGWxcb2nLUrLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDlusmESW4nZEirYAydw2PO3TJe2Mff9r1F2UQfFCcJNyUmWZGj0xaxVyK/MYYCaK
	 5YJ1kcI+srXq+7UQC+4qZDTj0DFRIIAP0Me8gk221eC6SOyxB6As2fpDyFd4AFTNFf
	 k9DVUL10WPLFewGTqVY0PkVJcj0kN5UFQsteBbM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com,
	Yao Kai <yaokai34@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6 0017/3318] ext4: validate readdir offset before accessing dirent
Date: Wed, 18 Nov 2026 15:10:39 +0100
Message-ID: <20261118150314.218751775@linuxfoundation.org>
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

From: Yao Kai <yaokai34@huawei.com>

commit bc4b7b0414c33b2c8898eb04386df0d21a13dad8 upstream.

A corrupted directory can trigger the following KASAN report when
ext4_readdir() resumes from an invalid position:

  BUG: KASAN: use-after-free in __ext4_check_dir_entry+0x5ef/0x820
  Read of size 2 at addr ffff88810a646000 by task repro_linear/509

  Call Trace:
   <TASK>
   dump_stack_lvl+0x53/0x70
   print_report+0xd0/0x630
   kasan_report+0xce/0x100
   __ext4_check_dir_entry+0x5ef/0x820
   ext4_readdir+0xcde/0x2b70
   iterate_dir+0x1a1/0x520
   __x64_sys_getdents64+0x12b/0x220
   do_syscall_64+0xf9/0x540
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

KASAN reports use-after-free because the out-of-bounds access lands in an
adjacent freed page. The directory buffer itself is still referenced.

ext4_dir_llseek() invalidates the directory cookie so that ext4_readdir()
rescans directory entries from the start of the block. The rescan checks
only the lower bound of rec_len before advancing. A corrupted rec_len can
therefore place the offset where the block has insufficient space for a
complete directory entry. The rescan itself may dereference that truncated
entry, or the main loop may pass it to __ext4_check_dir_entry(). The latter
reads de->rec_len before validating the range. For example:

  block offset  0                           4092  4096
                |---- de1.rec_len = 4092 -----|----|
                                               de2.inode
                                                    | de2.rec_len
                                                    ^ OOB, reported as UAF

de2 starts at offset 4092 in this 4 KiB block. Its four-byte inode fits in
the block, but its rec_len starts at offset 4096 and crosses the boundary.

The minimum safe length is inode-dependent. Encrypted and casefolded
directory entries need eight additional hash bytes, while a valid metadata
checksum tail is only 12 bytes.

Cache the metadata checksum feature state and derive the minimum directory
entry length from the on-disk format. Use it to bound both the rescan and
the offset passed to the main loop. Report an offset in a truncated block
tail and skip the remainder of the block, while continuing to accept an
offset exactly at the block boundary.

Reported-by: syzbot+5322c5c260eb44d209ed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5322c5c260eb44d209ed
Fixes: ac27a0ec112a ("[PATCH] ext4: initial copy of files from ext3")
Signed-off-by: Yao Kai <yaokai34@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260706041313.708346-1-yaokai34@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/dir.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -136,6 +136,7 @@ static int ext4_readdir(struct file *fil
 	struct super_block *sb = inode->i_sb;
 	struct buffer_head *bh = NULL;
 	struct fscrypt_str fstr = FSTR_INIT(NULL, 0);
+	bool has_csum = ext4_has_metadata_csum(sb);
 
 	err = fscrypt_prepare_readdir(inode);
 	if (err)
@@ -147,7 +148,7 @@ static int ext4_readdir(struct file *fil
 			return err;
 
 		/* Can we just clear INDEX flag to ignore htree information? */
-		if (!ext4_has_metadata_csum(sb)) {
+		if (!has_csum) {
 			/*
 			 * We don't set the inode dirty flag since it's not
 			 * critical that it gets flushed back to the disk.
@@ -233,7 +234,10 @@ static int ext4_readdir(struct file *fil
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
 		if (!inode_eq_iversion(inode, file->f_version)) {
-			for (i = 0; i < sb->s_blocksize && i < offset; ) {
+			for (i = 0;
+			     i <= sb->s_blocksize -
+				  ext4_dir_rec_len(1, has_csum ? NULL : inode) &&
+			     i < offset;) {
 				de = (struct ext4_dir_entry_2 *)
 					(bh->b_data + i);
 				/* It's too expensive to do a full
@@ -255,6 +259,17 @@ static int ext4_readdir(struct file *fil
 			file->f_version = inode_query_iversion(inode);
 		}
 
+		if (unlikely(offset < sb->s_blocksize &&
+			     offset > sb->s_blocksize -
+			     ext4_dir_rec_len(1, has_csum ? NULL : inode))) {
+			EXT4_ERROR_FILE(file, bh->b_blocknr,
+					"bad entry in directory: %s - offset=%u, size=%lu",
+					"directory entry too close to block end",
+					offset, sb->s_blocksize);
+			ctx->pos = round_up(ctx->pos, sb->s_blocksize);
+			goto next_block;
+		}
+
 		while (ctx->pos < inode->i_size
 		       && offset < sb->s_blocksize) {
 			de = (struct ext4_dir_entry_2 *) (bh->b_data + offset);
@@ -310,6 +325,7 @@ static int ext4_readdir(struct file *fil
 			ctx->pos += ext4_rec_len_from_disk(de->rec_len,
 						sb->s_blocksize);
 		}
+next_block:
 		if ((ctx->pos < inode->i_size) && !dir_relax_shared(inode))
 			goto done;
 		brelse(bh);


