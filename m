Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617739;
	b=qlnjjU1IreRJ0M7ca+upTvVQWjfxtHb/Qmz5uSLNr1f8M7kWNDv4pmPlaaHXmEFiuFD2
	 BYU9L7WSFUgtic1mRqs6h0kcsVOBbU4kmgBeU4GwTw3odf37Rh2qDgewHHZhOI4LzJkeF
	 Aj3urK4h/dQ5GLkCfsc98RoUfAJQ6c5sEjqDjyYvnJMVEDAiADCObNtksWY8zUtbFEuFC
	 MfvwOZfDp8y6j4pp2S+RDMkwx9WRTbclGK3ae42K8AptrUktYGTlJZB7ucKhRqRgE5e0n
	 ohuwuPWlcaHG1lcVSqJk6M36PiblEBnMYAjBbjPI5CZ34Li+8zoCNxRVwvaWwckXV+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oxQRfjfEhmuIxWCfZ6KK0wq4i2jsMV1AFCulGvJO8wE=;
	b=J5/zCn205RtDiZzfAou1U5aRMtrD764eTwFjqi+NEF+pwPPaxHypFLSdSnRlX/5J5U3q
	 Wo3YGTrAcHBeXpw0eRxg+ZnWZ38Q2byyPSoYmOrXZTLU9Qp/RN5PeXkj3NycGTHb/ZkWR
	 n77gMC8ky+8ue0QZqlpm5ozxOC+QUqcgMSMnL9ic6LkUmN9emcM9VAk2xQWlwcuGbGDHG
	 YSdq8GwEmlHOvD1dtSf3IcWtx7nC7iBazp+VZhW7zZTex68xKlYXeUh82ZGYD+qTmm3ta
	 2zSFqsLxGovj8PTvN1MApvo2waNGIS8PhYjUPTUW1B5Oq2Sg/+/nZqNUCQmvgdGqafg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nQQY/skP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9F2606A323;
	Wed, 25 Nov 2026 14:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nQQY/skP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1BB1F000CF;
	Wed, 25 Nov 2026 14:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617739;
	bh=oxQRfjfEhmuIxWCfZ6KK0wq4i2jsMV1AFCulGvJO8wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nQQY/skPl33BkXvbeudboH2o/YRrrau7KMKtelMLhzKufUg6+2iCOxL7q5PMrzs1M
	 CwzqkgiSEKKxn1ux+bwK+yJDH73humWtoDSbgBIod6hJ2rS13/cSrn9k14Wvyyj0I7
	 yPn5tfJQxRWuHdhX/Nd6wkOqQvRCcnTRxe4nJZzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfu Xie <yuanfuxie@stu.pku.edu.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0058/1005] 9p: do not store the create fid on special files
Date: Wed, 25 Nov 2026 15:23:16 +0100
Message-ID: <20261125143823.100509386@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1431549b1f4d8..d9156b2509aca 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -328,16 +328,24 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
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



