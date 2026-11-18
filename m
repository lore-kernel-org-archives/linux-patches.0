Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031188;
	b=x799Mc7kbbJjnOuzpBeJ5PdhhL+v5gOhLFNQFtKj319L7sPH7xMQK8+QkCUq2hW7lV2g
	 UYWFYvxfZFGWGVhS3NHWsisLOEgP2YR0dK97/ZtD9/IcsfeGvdB0xavt1YsDziNPhy7Fq
	 Wpm20psVwEXQ+Blf1ABcby7AvRHMn9jZs7Hv74Dd89cvTeyqf+ie44gYDlE63BJGj6UHp
	 V/nudCcLtHZiU7NBILIo1IIKq1TpOCxHEnpmzYaB27hfozeOwRUTb+rBGe4VALv+R2ACy
	 wBMoL+Rplvvqyj79r/9y5Vx+ITxTej6ug0fabKdI/j3aQiOsQSlTVq0OAH3xWzpfwvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b0P7r60wl8nzHqjQEBQUh9NpByJGQkhgukPVH533yko=;
	b=qF94qATL4/OJH2BIyucLosC/Bs6jW+J78pJHsmf/Oa8SJDQ2WpoOIckaZ9//dk08iu+Q
	 0FJm59IT1UpV639bUcWw/xXFKb3KcPHNshSJRe61IezcbMT1OrnVXlzFaa8ASeoXi3csY
	 sxH+bmJcGwTP5iDubDEnEMIzLi60M7QEsMhz7QP7X8BjKuqUVxFPfCauxY6aFxYjO1aQX
	 tZyPK0GuU3IIpR+OqOqvg5m4iWa1sr7gOIhI1De20prlh7CME6oa/GEv2OCQjca4Bm12V
	 79uuA0Deef9KgOYLxbHeB4HL6HyG3KOmpxZi4EO59jnJiZyuNiGjROmRLKHEEILgbew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IPF/XIDO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0184B606A320;
	Wed, 18 Nov 2026 19:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IPF/XIDO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD851F000CB;
	Wed, 18 Nov 2026 19:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031187;
	bh=b0P7r60wl8nzHqjQEBQUh9NpByJGQkhgukPVH533yko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IPF/XIDOxjuqgcyGrYzJ3Kj3g+6sy2BMynzEr8kbhI8xx+bQIzTkr8hMzPOQsy0HV
	 epmVucDwzUXKETtIH6scpM0JyHUe3Y8JFo0vUDzIwfteSe8MGA1L4/aEp0DQ+O5NYw
	 K4kbx4kSXcq6Ti9ZLEcBLk9KveHm+NaL3pevIudQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c388db0347b7fc88fa7a@syzkaller.appspotmail.com,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0928/1756] nilfs2: fix link count underflow when removing corrupted directory
Date: Wed, 18 Nov 2026 15:50:55 +0100
Message-ID: <20261118150046.898996722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e02fae6757f12..1e56f52a22376 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -341,10 +341,16 @@ static int nilfs_rmdir(struct inode *dir, struct dentry *dentry)
 
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



