Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026546;
	b=4hlt9GFexhXjY8jiLdxk3onLfmqudl1WJSxX8d3vjpH9bnxLmodZanAsaUVLE1GQq/r2
	 gk7PhgGdmRTO5W4sngT2yXHWzBeg/v0XDhWKMdkkpnjTlvcY4CkDAucVMP9Bmw6BwPOTP
	 rty17pss5VjviiwMExRO62sA4MkZAOcPSbrsv+Zvr2OT2IKUiskGHrkD7LHBHFB1O3hBd
	 6GdmcfLVE0CSC5+SeYN6fTOzhA9GwKjb4gbvmpyU1etUTWrxMVCU/mGtqpL7qbMGQk9Z5
	 rzecTShgap6oZeizAKYHBcv0/y5gAwFyInugfzBpygxGtuuL2799GZNSuiSs7Y7Nnlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c/C7PweZ3BciPr5zQ5wlURSvPx6a0Fu5hSfvl1oN+CA=;
	b=g6M/xmfrAqS9M12DPXoRTFWQ0z2j5SCf88XqKE4uTCB/LttWU5pYRY9kk4W3lHkEy3IU
	 ZZ6/cF/6NdFLnr8fkFHYkDOzZVjLltL8LvRJqCsBcPIK4EV8QMA/GCuH/Sph+7Qdz8es0
	 Zcn9eBQuj0bNg2mEHDMFyFL1qPbP3sgQ6SBYl/eUCNgTb9KcVepHx4WZnuYU+jp1zMip4
	 O4NQj1QnLM5DaR6jOwjGuYZo0/usf03qy+cJ5j2gCTi4iOSLnYOcf4FQCDw1phM8xJ94c
	 aArKfJQOKteBCIF7SVtwr9smBHRtPnWeCbB6XmOggADeze0W7XQI2mcyvrlYU1QQHxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ardw0ppO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FFF606A31C;
	Wed, 18 Nov 2026 18:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ardw0ppO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7D71F000C4;
	Wed, 18 Nov 2026 18:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026546;
	bh=c/C7PweZ3BciPr5zQ5wlURSvPx6a0Fu5hSfvl1oN+CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ardw0ppOLZRUYeYE88xMJQZJ99jhrh6VF6gFW2igBwQplRFBRKmVYlaTBvzw8M5S3
	 +gQQkuMnsgN+pRrgnCrwA27fsf0okZZP60KxDiU+tDShglKJjIUsz4tFlniWaWYk4T
	 dpXEji70j5VIzBsR7JNdN3tZk6Uxyx5/6swNOF1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+03aaa576f1daa1c1f2f0@syzkaller.appspotmail.com,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1475/2151] ocfs2: validate chunk and block counts of the local quota file
Date: Wed, 18 Nov 2026 15:53:30 +0100
Message-ID: <20261118150215.614539852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit b10ef5d2c2083ea4c40e963c10a73a154793c5d4 ]

ocfs2_local_read_info() trusts dqi_chunks and dqi_blocks from the local
quota file header.  If dqi_blocks is too small,
ocfs2_extend_local_quota_file() computes a bogus chunk length, extends the
file, and maps logical block dqi_blocks, which is already in the inode's
metadata cache (the header or a chunk header read at mount).  sb_getblk()
returns that cached buffer and ocfs2_set_new_buffer_uptodate() hits
BUG_ON(ocfs2_buffer_cached()):

  kernel BUG at fs/ocfs2/uptodate.c:509!
  ocfs2_extend_local_quota_file+0x45c/0x1100
  ocfs2_create_local_dquot+0x8ac/0xb50
  ocfs2_acquire_dquot+0x614/0xae0
  ocfs2_get_init_inode+0xe9/0x1b0
  ocfs2_mkdir+0x174/0x430

ocfs2_local_quota_add_chunk() has the same exposure.

Reject a header whose counts don't fit the chunk layout or exceed i_size.

Reproduced with a crafted image (dqi_blocks = 1, chunk 0 dqc_free = 0);
syzbot has no reproducer for this report.

Link: https://lore.kernel.org/20260920140710.43938-1-ngocthang2710.1999@gmail.com
Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+03aaa576f1daa1c1f2f0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=03aaa576f1daa1c1f2f0
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/quota_local.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/ocfs2/quota_local.c b/fs/ocfs2/quota_local.c
index a52bf3895ae25..6bb549863c9c7 100644
--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -245,6 +245,25 @@ static void ocfs2_release_local_quota_bitmaps(struct list_head *head)
 	}
 }
 
+/* Check that the on-disk chunk and block counts match the file layout */
+static int ocfs2_check_local_quota_info(struct inode *inode,
+					unsigned int chunks,
+					unsigned int blocks)
+{
+	u64 chunk_len = ol_chunk_blocks(inode->i_sb) + 1;
+	u64 min_blocks = chunks ? 1 + chunk_len * (chunks - 1) + 1 : 1;
+	u64 max_blocks = 1 + chunk_len * chunks;
+
+	if (blocks >= min_blocks && blocks <= max_blocks &&
+	    blocks <= i_size_read(inode) >> inode->i_sb->s_blocksize_bits)
+		return 0;
+
+	return ocfs2_error(inode->i_sb,
+			   "Quota file %llu has bad info: %u chunks, %u blocks\n",
+			   (unsigned long long)OCFS2_I(inode)->ip_blkno,
+			   chunks, blocks);
+}
+
 /* Load quota bitmaps into memory */
 static int ocfs2_load_local_quota_bitmaps(struct inode *inode,
 			struct ocfs2_local_disk_dqinfo *ldinfo,
@@ -733,6 +752,11 @@ static int ocfs2_local_read_info(struct super_block *sb, int type)
 	oinfo->dqi_blocks = le32_to_cpu(ldinfo->dqi_blocks);
 	oinfo->dqi_libh = bh;
 
+	status = ocfs2_check_local_quota_info(lqinode, oinfo->dqi_chunks,
+					      oinfo->dqi_blocks);
+	if (status < 0)
+		goto out_err;
+
 	/* We crashed when using local quota file? */
 	if (!(oinfo->dqi_flags & OLQF_CLEAN)) {
 		rec = OCFS2_SB(sb)->quota_rec;
-- 
2.53.0



