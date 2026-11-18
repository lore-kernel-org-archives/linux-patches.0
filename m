Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061445;
	b=ol+WOszpMgCBd9KSITk5ECwwwUPP+dn1QxgCNgrMCFQmmf2heAfEkLdApK5E+BKFCOML
	 ZQ1TNoe1COm1qHN/S8PA3anBYYGKO6spaiVur1Cgblp3k43eGK5HvUH4ZJjQw2j0/IuLB
	 PGxfpRUIbwdCfERAaSxSIv+aR6IA/JkllNIN1xjv4PRr0HMso3/fHP0qMB8T7hxWbLqOW
	 SNWuP2yz5/UMbsBJp0FMxyG2/uQ/uioaheusOmpXpWLXGH/CXg7kI/huXErV9fu8SGlSQ
	 t3KLrcnyc+f3Unkj6GmrJIuUdPkiOXHmi7c67M476lZoeukI8mJXrbP49j6Er9aXhpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bx18Yh23bhVxIsNGe+N9BuVXbJf3d2lQqo/mVVrRPGY=;
	b=n+uiq+Ug0r0I/jkQ1eMk6jXYL8VucBlnJjC1Ds4U7NmMbI3u7/uNjSaGUr3M2svMj1sC
	 zVDnCf85ji5xB9IVebe2VU596Y76WIG41UapkYlCaN1sWMTazLWc+OgeIFo5z8//pkiA1
	 vICe1Gyc1DDYxLb5wTD7fbZocvI6Uwc6YJxAs1muwwiQY/g9Dt4cliRYEXl1SrENzH3ch
	 XaDU02KkGI+tAd6LNDx5SD60MgIng5TnP8A6tIP9CKl7oV2EUi/6OwwuhRiIkHryY1Rrq
	 ieymSEcn3L6L9hZfes1XRL8jWo0NJyp4vCnBHPyzZ9g8G2HENSnFZjbJtj0WsnSQ2Fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uv2LhMbf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C073D606A32A;
	Thu, 19 Nov 2026 04:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uv2LhMbf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6BA1F000C4;
	Thu, 19 Nov 2026 04:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061445;
	bh=bx18Yh23bhVxIsNGe+N9BuVXbJf3d2lQqo/mVVrRPGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uv2LhMbfRGVdgvbH0WNu5CY0EXXuf6y/QGE6dyhBxxzQ+YHDNtjTULN5/eQ0oG2F2
	 EnSFNklEJLpbdYZSfGOMTMmeDxvhC8pmOohC0KmCedfTjcZX4HJoN3YJDzWgidUKfE
	 jPZShcBLnhqbbo5lgPxwAgzSe4bWQGMS51e97NoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1514/1848] nilfs2: fix link count underflow when removing corrupted directory
Date: Wed, 18 Nov 2026 15:59:12 +0100
Message-ID: <20261118150022.677130157@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 814f5a53b4724798795b15690ff3d1c1d9ac1eb6 ]

When removing an empty directory with a corrupted link count (e.g.,
i_nlink is 1 due to filesystem corruption), nilfs_rmdir() calls
drop_nlink() via nilfs_do_unlink() and then calls drop_nlink() again
on the directory inode.  This second call causes an underflow of
i_nlink, triggering a kernel WARNING in drop_nlink().

Fix this issue by using clear_nlink() instead of drop_nlink() to
finalize the link count reset for the target directory in nilfs_rmdir().
Additionally, log a warning message when i_nlink is not 2 before
removing an empty directory to notify about the link count inconsistency.

Reported-by: syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c388db0347b7fc88fa7a
Fixes: d25006523d0b ("nilfs2: pathname operations")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/namei.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 380af65e9ea16..31f18da800650 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -339,10 +339,16 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 
 	err = -ENOTEMPTY;
 	if (nilfs_empty_dir(inode)) {
+		if (unlikely(inode->i_nlink != 2))
+			nilfs_warn(dir->i_sb,
+				"inconsistent empty directory link count %u (ino=%llu)",
+				inode->i_nlink,
+				(unsigned long long)inode->i_ino);
+
 		err = nilfs_do_unlink(dir, dentry);
 		if (!err) {
 			inode->i_size = 0;
-			drop_nlink(inode);
+			clear_nlink(inode);
 			nilfs_mark_inode_dirty(inode);
 			drop_nlink(dir);
 			nilfs_mark_inode_dirty(dir);
-- 
2.53.0



