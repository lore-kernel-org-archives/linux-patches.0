Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059828;
	b=GCDQ26NO4CJoZS3EGJ1puQ0VjxQnAgJYaedF+6/yNWdI3d1Wf0USsLXhviSU/qpPa/l8
	 Bp5KEV1fk5bpR4CaWAZKNa84YMgo54DXJu9KKFKPCH0+sDEYr2ltDaQ/cl8FjerllmbsF
	 9fABEhBx+jjWsGnEoKkLFXYzn5pO/AE+zW5DQOgoFs9dAc56AgxcBHO35np2rleZ7SHkF
	 h6aRU8ZFcsSEPR88r5gXpMt62Xv7e+dlQWEXzVtxjQz7keUa34PtNu6uuDBj/ELGpOrNy
	 WqPV33OSe+U21Puv4YMG1sMhKJNVfuEov/EjrhCQQOi1mLEfSgPYMKsxZINY3o+K42Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sr3fhYnu+DPAJfHmSSmQavEaKF21wOhZJSzlgwxQImY=;
	b=u1h4Cp5hnOExh8cN4jvqCi9Kxrb4PlzDbvCZlWx/tQ30zuDTPVtwOcMU1B+dSHMJ8seX
	 OWoKVhw+rBeHZ8BIea6N+AGp1zn8UdwsgYtfXfCrikzNqfQnDOz5BYFrHSwAdVn4L+s7G
	 +WKtmU1WTZM1H5PR8nz2oMOhvhudVRbtyk0dr0x8ENz2kHuHSWplpel+VTs21ZLfDO1Kx
	 +GupAs6afmcFLercRuTqQxYRoKzv947JaL8MjHVeFvoG/PKkPNjXIPzjLd5JO1RV3TI2p
	 qMxID6nXkx7Ne0LNdusNOtPCJnF8rvnLZvehgaTWJ9sAOHlKcL9RensRqM6zKbaeOeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1OUsON+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FE0606A320;
	Thu, 19 Nov 2026 03:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1OUsON+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3856B1F000C4;
	Thu, 19 Nov 2026 03:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059827;
	bh=sr3fhYnu+DPAJfHmSSmQavEaKF21wOhZJSzlgwxQImY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1OUsON+SsVfo8VIxh4UcrID1U32yKo/Fn4PNHCR1+VSzTsG9dbr/gDXWC/fJINTlJ
	 A1g+uBcfp0w6nw2SXtU3A4uxN/GB++yTLSIFgouqmn/kYUWX0gCD9+DI6zoe4Tsblt
	 vidhbr0dqbuw/gG5BvkpDr/R2XY7YlcR3v1FKr1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0974/1848] f2fs: release a removed xattr node in roll-forward recovery
Date: Wed, 18 Nov 2026 15:50:12 +0100
Message-ID: <20261118145957.731258173@linuxfoundation.org>
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

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit f5924de8867c09206ba631b9faed63862ec00a10 ]

When xattrs shrink enough to fit in the inline xattr area,
write_all_xattrs() truncates the xattr node and clears i_xattr_nid. If
the file is then fsynced without a checkpoint, only the inode block is
written, with i_xattr_nid of 0.

Roll-forward recovery starts from the checkpointed inode, whose
i_xattr_nid still points to the old xattr node.
f2fs_recover_inline_xattr() copies only the inline xattr area, and
f2fs_update_inode() writes the old i_xattr_nid back. So the inode keeps
the stale xattr node:

 - The node block is never released, and fsck reports "nonzero bytes in
   xattr space after end of list".
 - If the inline xattr list ends exactly at the end of the inline area,
   its terminator is read from the stale node, and the removed xattrs
   come back after recovery.

When the fsynced inode has no xattr node but the checkpointed one has,
release the old xattr node as truncate_node() does: check its block
address, invalidate the block and drop its node cache, which may still
be dirty.

Fixes: 28cdce0459cc ("f2fs: recover inline xattr data in roll-forward process")
Cc: stable@vger.kernel.org
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ sashal: adapted F2FS cache operations to the existing page-based APIs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 1dddb65e249ad..fc1f0d3bf6ed7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2635,6 +2635,44 @@ int f2fs_recover_inline_xattr(struct inode *inode, struct page *page)
 	f2fs_wait_on_page_writeback(ipage, NODE, true, true);
 	memcpy(dst_addr, src_addr, inline_size);
 update_inode:
+	/*
+	 * The xattr node of the checkpoint was removed before fsync, e.g. the
+	 * xattrs became small enough to fit inline. Release it as well, or
+	 * the inode keeps pointing to the stale xattrs.
+	 */
+	if (!ri->i_xattr_nid && F2FS_I(inode)->i_xattr_nid) {
+		struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+		struct node_info ni;
+		int err;
+
+		err = f2fs_get_node_info(sbi, F2FS_I(inode)->i_xattr_nid,
+								&ni);
+		if (err) {
+			f2fs_put_page(ipage, 1);
+			return err;
+		}
+
+		if (ni.blk_addr != NEW_ADDR &&
+		    !f2fs_is_valid_blkaddr(sbi, ni.blk_addr,
+					   DATA_GENERIC_ENHANCE)) {
+			f2fs_err(sbi,
+				"nat entry is corrupted, run fsck to fix it, ino:%u, nid:%u, blkaddr:%u",
+				ni.ino, ni.nid, ni.blk_addr);
+			set_sbi_flag(sbi, SBI_NEED_FSCK);
+			f2fs_put_page(ipage, 1);
+			return -EFSCORRUPTED;
+		}
+
+		f2fs_invalidate_blocks(sbi, ni.blk_addr);
+		dec_valid_node_count(sbi, inode, false);
+		set_node_addr(sbi, &ni, NULL_ADDR, false);
+		/* drop the cached xattr node, which may be dirty */
+		truncate_inode_pages_range(NODE_MAPPING(sbi),
+				F2FS_BLK_TO_BYTES((loff_t)ni.nid),
+				F2FS_BLK_TO_BYTES((loff_t)ni.nid + 1) - 1);
+		f2fs_i_xnid_write(inode, 0);
+	}
+
 	f2fs_update_inode(inode, ipage);
 	f2fs_put_page(ipage, 1);
 	return 0;
-- 
2.53.0



