Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620971;
	b=j5kFxwW3uVUYzoYu55ecqlooOnnaqPkkiBvlDeWq7mlmqUnF+hlCgh4PWYBDsBFSA1eI
	 AdiGkLjH99aFIRBQDoVUHv+qo2MhAwkRp+j93DlW1UxykrgJxgjbqqCeqYl6hbql+i8eu
	 4rDm3jW5wOV0MIFG3glp/gM354UYwDt0mwK+qQoRKO2vv6Pa/7mfvWxC+B4oHnMY4ITOb
	 ewQgYh2XN8rNQu0nBPk1QvXlgs8u/gzz8H3RVQs97F2olBSqmDdqIsVZWPGO26MS4fkNj
	 vFkLfjXQqXofw+tS+rr3WWuaQvoSi28nRXGTG5tweb8mozCFCIoT3GA4NmVbZN7Y1gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AY+zZKbqEqmbfQzBMEk3zz4htjVImKx0a2STKHeMsGk=;
	b=mHA9UV6NkSbP7s9JQLbWB0lyAeyUfmimw3iCm9EPuLpfUUH6oL08UNNJHE+89qmQt2oc
	 eDNOeosOFjdYA1EyPxMWEWJoOSvODYtSW+Ty6ESdjCFkutQYfFLK6xP1BcgeLpCrWfNFI
	 leiomlxLPAmoC8r5Ccsm7/5hHonwqYUPxlJRLV6SoXYfKObeWVCbA1g1zCuR7spUvkr+f
	 CexPQgOeSTxm3WHankLrcW0JdO+UiamQnSkdy0fecQnDuJXwdny94QknhuS0V/9KpepV6
	 K+1xjDS1QLTYi23GM53W6ki/SAa4/7zAqUfZOWWzg25AlLEixk0yOu9OpUxqQ6qWSvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQX14Nyx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C15A606A6AD;
	Wed, 25 Nov 2026 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQX14Nyx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ECB1F000D0;
	Wed, 25 Nov 2026 15:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620970;
	bh=AY+zZKbqEqmbfQzBMEk3zz4htjVImKx0a2STKHeMsGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQX14NyxSCTLAbeKVi8FnjqsutKdtk7NjBPP4p09pkQqy/ZEtm5AALKih/3oviS/v
	 bV8ZUsELg9olOK9nyB2Qfz6euRpLrMVpWrT0qgomXW+F9SfkheeCvhztVKEMTK5SxG
	 lKBsd9C1aJ5UP3lgrgMtzJl1ZdADQ58M9s5LedPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/990] 9p: do not store the create fid on special files
Date: Wed, 25 Nov 2026 15:24:08 +0100
Message-ID: <20261125143823.985098628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>

[ Upstream commit 56894cadf21c34abbba7f74b8f5d78dabf69dd39 ]

v9fs_vfs_atomic_open_dotl() always stores the create fid in
file->private_data after finish_open().  FIFO and device inodes
already have type-specific file_operations that own that field.
Overwriting it with the fid makes later read/write/close treat the
p9_fid as a pipe_inode_info, which corrupts the fid and can use it
after it has been clunked.  The non-dotl atomic_open path does not
assign the fid this way.

Only attach the fid for regular files and directories.  Special
files do not need the create fid; leave it for the existing
p9_fid_put() on the out path so it is clunked before return.

KASAN report, linux-stable 4982d3552a3b:

BUG: KASAN: slab-use-after-free in anon_pipe_prefill_and_lock+0x376/0x3f0
Read of size 4 at addr ffff88800ab30538 by task repro/1

Call Trace:
 <TASK>
 anon_pipe_prefill_and_lock+0x376/0x3f0
 anon_pipe_write+0x127/0x1600
 fifo_pipe_write+0x24/0x300
 vfs_write+0x659/0xd00
 ksys_write+0x10f/0x200
 do_syscall_64+0xdd/0x4a0
 </TASK>

Fixes: 30d904947459 ("kill struct opendata")
Signed-off-by: Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>
Message-ID: <92377346-29E9-46D3-96F5-AABA8A64CD57@stu.pku.edu.cn>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode_dotl.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index f154b7a45d4f9..4240b3588c537 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -329,16 +329,24 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	err = finish_open(file, dentry, generic_file_open);
 	if (err)
 		goto out;
-	file->private_data = ofid;
+	/*
+	 * Special files have type-specific fops that own
+	 * file->private_data.  The create fid is unused
+	 * there: leave it for p9_fid_put() on the out
+	 * path so it is clunked before we return.
+	 */
+	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)) {
+		file->private_data = ofid;
 #ifdef CONFIG_9P_FSCACHE
-	if (v9ses->cache & CACHE_FSCACHE) {
-		struct v9fs_inode *v9inode = V9FS_I(inode);
-		fscache_use_cookie(v9fs_inode_cookie(v9inode),
-				   file->f_mode & FMODE_WRITE);
-	}
+		if (v9ses->cache & CACHE_FSCACHE) {
+			struct v9fs_inode *v9inode = V9FS_I(inode);
+			fscache_use_cookie(v9fs_inode_cookie(v9inode),
+					   file->f_mode & FMODE_WRITE);
+		}
 #endif
-	v9fs_fid_add_modes(ofid, v9ses->flags, v9ses->cache, flags);
-	v9fs_open_fid_add(inode, &ofid);
+		v9fs_fid_add_modes(ofid, v9ses->flags, v9ses->cache, flags);
+		v9fs_open_fid_add(inode, &ofid);
+	}
 	file->f_mode |= FMODE_CREATED;
 out:
 	p9_fid_put(dfid);
-- 
2.53.0



