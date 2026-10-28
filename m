Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216358;
	b=0mvqcsc96kYy0cXUwXJPj6zrdDq6hLVHBuUUllSY537cpHtvtbT8gEbEetKPP3KlgmS9
	 x4jz/sQaQhWSz1G0gA5DXdCSrZn3L9720uSXikher4K9ABrwmNAJg4XkREMyrj29iPabY
	 UIFlHnccYyai2vekCJI7tqlMTkfRmvRCqs7vsVUmIA9BK2wGGmMtelPWjSA/zfujKyGJm
	 W3tlSzM5W4NfTrHbVmzRwg8yIcrTXs0iRV04SxXP8p8z168Nd0RBBR370p1zA5DFZBRjJ
	 qWk8L106+2XuhSD4oQq3BHck2MOB2EgiCbLitgbqyNQIuXM/8e7ySTmy0GcbIBzMg5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I7qUI1QfzJcV/rKyNQxiwk485vaBzPBqz7+kxjjkH6o=;
	b=OV/J/s8lfACd+AP623ufkUc08rythqnejiqtNCGbsQFndUy8FX/cZpCXlwLKzDu7wRwa
	 zN8DyM+Gs8GUQ10MJVhy+wF7JpM3ELk695T4+FXuu5rjYKnZSXITKV9OBSVU2VVEEup5T
	 HqqVcQpeiIlNq/kU0FgLNAyN4KuomYCzL+NmZlLY5N454uG/POudL9JjNkeI4eKbm0XPN
	 VyQukwKwtIZpNqbB0vuO/PV0aVvhUp6XXzsF7nOta8SX+HrqTP0ofTAU/jeFt2qycprRo
	 Qs3Lv7s4tcZcIIzZql6y2N4SOz6Hy0a6lBBjku5a0YKrtc6nH/YyCL9CbSiy9yUi4nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hdR4AtUA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5D8606A31A;
	Wed, 28 Oct 2026 19:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hdR4AtUA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AAA1F01825;
	Wed, 28 Oct 2026 19:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216358;
	bh=I7qUI1QfzJcV/rKyNQxiwk485vaBzPBqz7+kxjjkH6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdR4AtUADIYhpMZx1XjWZXtIM/pFnc2aV+mXdq9ve3Ofgx1tTwhHtf2YJ9l6Dpu6e
	 tMDXg7jmcFt+JPfO5D3gvF9E7RVFbAcrMTdhgwwTUoMZmM9td87Z+dqrNSLoSOuB3X
	 XxzYdxIklsxdAGGtpOPjcXS6ywT7NQR39uGwdwQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1530/1887] fuse: check for NULL root inode in fuse_fill_super_submount
Date: Wed, 28 Oct 2026 18:00:26 +0100
Message-ID: <20261028170534.281382815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit 928f659a3e3650978a5b4829cc982324f72b474b ]

fuse_iget() can return NULL when its inode allocation fails, but
fuse_fill_super_submount() passed the result straight to get_fuse_inode()
and decremented fi->nlookup without checking it:

        root = fuse_iget(sb, parent_fi->nodeid, ...);
        fi = get_fuse_inode(root);
        fi->nlookup--;

Inside fuse_iget() the inode allocation can fail and return NULL.  The
submount root takes the iget5_locked() path, whose alloc_inode() can fail
under memory pressure (the auto-submount branch can fail the same way in
new_inode() or fuse_alloc_submount_lookup()):

        inode = iget5_locked(sb, nodeid, fuse_inode_eq, fuse_inode_set,
                             &nodeid);
        if (!inode)
                return NULL;

A NULL root makes get_fuse_inode() a container_of() on NULL and the
nlookup decrement a write to a bogus address, oopsing the mount.  With
CONFIG_KASAN the following null pointer dereference is reported when the
root inode allocation of an auto-submount fails (e.g. under memory
pressure):

==================================================================
BUG: KASAN: null-ptr-deref in fuse_get_tree_submount+0x656/0x8b0
Read of size 8 at addr 00000000000002b0 by task ls/942
CPU: 0 PID: 942 Comm: ls Tainted: G W 6.6 #15
Call Trace:
 <TASK>
 fuse_get_tree_submount+0x656/0x8b0
 vfs_get_tree+0x48/0x140
 fc_mount+0x13/0x50
 fuse_dentry_automount+0x7a/0xb0
 __traverse_mounts+0xca/0x330
 step_into+0x339/0xac0
 path_lookupat+0xc5/0x2f0
 filename_lookup+0x163/0x2a0
 vfs_statx+0xd5/0x200
 do_statx+0x83/0xd0
 __x64_sys_statx+0xa0/0xc0
 do_syscall_64+0x37/0x90
 entry_SYSCALL_64_after_hwframe+0x78/0xe2
 </TASK>
==================================================================

Return -ENOMEM instead; the caller tears down the partially built
superblock on error, matching the other error returns in this
function.

Fixes: 1866d779d5d2 ("fuse: Allow fuse_fill_super_common() for submounts")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 332cc885b815e..269699abdbfc7 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1537,6 +1537,8 @@ static int fuse_fill_super_submount(struct super_block *sb,
 
 	fuse_fill_attr_from_inode(&root_attr, parent_fi);
 	root = fuse_iget(sb, parent_fi->nodeid, 0, &root_attr, 0, 0);
+	if (!root)
+		return -ENOMEM;
 	/*
 	 * This inode is just a duplicate, so it is not looked up and
 	 * its nlookup should not be incremented.  fuse_iget() does
-- 
2.53.0



