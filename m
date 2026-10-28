Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214215;
	b=vffb7Wtu0M1axZZFp9CNKMvhpXF53cA8IM0WtLjjVX0GC/Ed7vTNri9Z540R/lCK/Tzl
	 q62yAFkceYJwwSshGzZm9tJXaLg8TCqyukZGqkfPgAZiWrc4WIEeVka1gR+HhUPtajvmM
	 W4RgW/TnG/ixQM1B4qkXxFx0JuaMYHUHdTf/MCgCx91RrAPQEhHHK+peRKQ/svyd15+o7
	 I2AaD89PjaaTIP6/1hR8g49cxRB/MrL/XzTP9V90ni1tSC2jNKCrV9ej/g1twX1ALv6W1
	 bam302pZFUX908xIpNh2PgSExwAAtWC0c8W43+bDiqV56y5agoIyzoge0QAUvdn9oVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JnqbBimhoQiFHThi8M15zz5SNoa8WNW7LZcBXiJypM0=;
	b=X8JyBnpEjNvr2Awbq8uwmu0IRRdA9ZlUbx7YEoW8Jjv0ZNVb1rVflMasXbAQE3lCSUUp
	 uBBeeOprrqi5AtnDS6vjULcaMbyyBZwJOzxb3iNTfnzlRr6n0zB/UCdwwqm/FOGsHoYM3
	 CXvrYbAyVz7yv0/qcwoX+LeTRyFt8c1Y2Eqriwc3Wbhk6qdNVK31NjF3A01G2tkDtQGIH
	 ze6Vbum/Ud28Xhmk4e97Tz6IkWVMvsLfgXdSL1GC1f9JKOcsto5zqk60Zf2yTOk6Smm0g
	 X6HeWgtzcQvXO13gf1VBVVC0fOT7dTmNxDyH/BG0+gi0OSVoqmKHuEYWndSOaIxj6xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAm8OQL9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8404860A2616;
	Wed, 28 Oct 2026 19:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAm8OQL9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86F11F013C0;
	Wed, 28 Oct 2026 19:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214215;
	bh=JnqbBimhoQiFHThi8M15zz5SNoa8WNW7LZcBXiJypM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAm8OQL9gTy0vubJh3LswKxQ5W+gW0jgzxwhr0V8uwAr65XYsUO8J25eLaQ3ZfCze
	 llBHF/w/rt1aG1bOhETWx/iAROFpUcJ7ECrkTZla5DrUNdWRRcVG6CNa3RpHsoIGE8
	 WKWDkobUgYrRSDPjT1HOxadQ7cAygMJPkNd47UyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5b667f9a1fee4ba3775a@syzkaller.appspotmail.com,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0763/1887] fs/9p: fix NULL pointer dereference on mkdir
Date: Wed, 28 Oct 2026 17:47:39 +0100
Message-ID: <20261028170516.805711210@linuxfoundation.org>
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

From: Christian Schoenebeck <linux_oss@crudebyte.com>

[ Upstream commit 3f61ac7c65bdb26accb52f9db66313597e759821 ]

When a 9p tree was mounted with option 'posixacl', parent directory had a
default ACL set for its subdirectories, e.g.:

  setfacl -m default:group:simpsons:rwx parentdir

then creating a subdirectory crashed 9p client, as v9fs_fid_add() call in
function v9fs_vfs_mkdir_dotl() sets the passed 'fid' pointer to NULL
(since dafbe689736) even though the subsequent v9fs_set_create_acl() call
expects a valid non-NULL 'fid' pointer:

  [   37.273191] BUG: kernel NULL pointer dereference, address: 0000000000000000
  ...
  [   37.322338] Call Trace:
  [   37.323043]  <TASK>
  [   37.323621] ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434)
  [   37.324448] ? page_fault_oops (arch/x86/mm/fault.c:714)
  [   37.325532] ? search_module_extables (kernel/module/main.c:3733)
  [   37.326742] ? p9_client_walk (net/9p/client.c:1165) 9pnet
  [   37.328006] ? search_bpf_extables (kernel/bpf/core.c:804)
  [   37.329142] ? exc_page_fault (./arch/x86/include/asm/paravirt.h:686 arch/x86/mm/fault.c:1488 arch/x86/mm/fault.c:1538)
  [   37.330196] ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:574)
  [   37.331330] ? p9_client_walk (net/9p/client.c:1165) 9pnet
  [   37.332562] ? v9fs_fid_xattr_get (fs/9p/xattr.c:30) 9p
  [   37.333824] v9fs_fid_xattr_set (fs/9p/fid.h:23 fs/9p/xattr.c:121) 9p
  [   37.335077] v9fs_set_acl (fs/9p/acl.c:276) 9p
  [   37.336112] v9fs_set_create_acl (fs/9p/acl.c:307) 9p
  [   37.337326] v9fs_vfs_mkdir_dotl (fs/9p/vfs_inode_dotl.c:411) 9p
  [   37.338590] vfs_mkdir (fs/namei.c:4313)
  [   37.339535] do_mkdirat (fs/namei.c:4336)
  [   37.340465] __x64_sys_mkdir (fs/namei.c:4354)
  [   37.341455] do_syscall_64 (arch/x86/entry/common.c:52 arch/x86/entry/common.c:83)
  [   37.342447] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Fix this by simply swapping the sequence of these two calls in
v9fs_vfs_mkdir_dotl(), i.e. calling v9fs_set_create_acl() before
v9fs_fid_add().

Fixes: dafbe689736f ("9p fid refcount: cleanup p9_fid_put calls")
Reported-by: syzbot+5b667f9a1fee4ba3775a@syzkaller.appspotmail.com
Signed-off-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Message-ID: <E1tsiI6-002iMG-Kh@kylie.crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_inode_dotl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index e15ad46833e05..7c261b354379a 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -424,8 +424,8 @@ static int v9fs_vfs_mkdir_dotl(struct user_namespace *mnt_userns,
 				 err);
 			goto error;
 		}
-		v9fs_fid_add(dentry, &fid);
 		v9fs_set_create_acl(inode, fid, dacl, pacl);
+		v9fs_fid_add(dentry, &fid);
 		d_instantiate(dentry, inode);
 		err = 0;
 	} else {
-- 
2.53.0



