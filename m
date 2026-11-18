Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043994;
	b=rF6g5fW0miiRehYE5hXP8aTh9W1sK03bBT51Ly1x8X1ZqWGghiHxv4Zm8O6avZvJbuIG
	 J2bv+XaloS5cbhhbwKYyCFZjDm1zXdT080sc7sND7zMt2Ng7VrdWb/qaPn3KBo39+31+1
	 tyweWRpkyGbva7njzboJFWvABXnWEpuy5p8qA64a9idSA7C/HwvP7cSMESM8FnLOTFTtB
	 qJuRJbJvTF2WZsG6YbYUZWh0nbg5hGSQ/NgKrCg0rOCu5hoEyA/+K0fIl4PxA312J/Ycr
	 U0Uj8Hzp1fYbXvycL40DpOObW/z2BF/ZaoPxdBXBOF2eSJlEym2PmJe28I4sSRzRjjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HjQm8OBWBmCRPnVt9OUZ3RLbIzTeRiPeV4O7/WtX6KY=;
	b=ssIo7Wo/bkf/0Q1m1BvrDqT/pdskFj2YgJ7eX/ayhBiv0il9p7jNlh3juKOFMn5YTvdK
	 WTnrKi+gzgPb92/g42QZNmhZFl7J8NB073ee/PG6m1qtQbPPmHcEmzoDjhglyD5fC6z5f
	 4VnilT1r095Q91G3zLvtKziZTTutIfYkbIzMWB3ukfTNxi45QYFxBPMxrTN8zz2TcjdNL
	 KhE4QsPi8OHnzKPGue+KpAIz3PIhPBCxYGAh5HVXRfna2SHxvWvy5D8SyxaGFh9mRW+ng
	 Ll7E0dYelc83gk3B1MSdvxTGr+f2D51tBnLxWfW/BRh+fRkmm8i3HHflT3l2lSxjTzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGKRyn8j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB48606A32A;
	Wed, 18 Nov 2026 23:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dGKRyn8j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D331F000C5;
	Wed, 18 Nov 2026 23:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043994;
	bh=HjQm8OBWBmCRPnVt9OUZ3RLbIzTeRiPeV4O7/WtX6KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGKRyn8j1xz0QY4/f57RM+2yHzwQy+LtPVENVYvAUNdhfKrlGNwHKR8uP/PH4qXXY
	 +CElQxphZtqT9oA3anvoBAEevrjh4GsLHqnilQYhw0w5OenLNaUU51PAtxCsVYQUU2
	 F2+CVtEyug5+mNBWggMAWIFXPdokJhTQTnjgKQpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b16e3d085833cbf3e25@syzkaller.appspotmail.com,
	Vasileios Almpanis <vasilisalmpanis@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0407/2857] configfs: unhash the dentry before dropping the item in rmdir
Date: Wed, 18 Nov 2026 15:24:01 +0100
Message-ID: <20261118150216.042940244@linuxfoundation.org>
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

From: Vasileios Almpanis <vasilisalmpanis@gmail.com>

[ Upstream commit f06c2d26d1999d37e93299db0ecead04ca7d0b9f ]

configfs_get_config_item() treats a hashed dentry as proof that
sd->s_element is a live config_item.  configfs_rmdir() breaks that:
simple_rmdir() leaves the dentry hashed, the last reference to the item is
dropped right after, and the dentry is only unhashed by d_delete() once
->rmdir() has returned.  configfs_symlink() resolves its target holding no
lock on it, so get_target() can land in that window:

  BUG: KASAN: slab-use-after-free in config_item_get+0x26/0x90
   get_target fs/configfs/symlink.c:128 [inline]
   configfs_symlink+0x4ab/0x1030 fs/configfs/symlink.c:185

Unhash in configfs_remove_dir(), while the item is still guaranteed to be
there.  A reference obtained just before that stays harmless, as
create_link() rechecks CONFIGFS_USET_DROPPING, already set by
configfs_detach_prep().  Both configfs_unregister_subsystem() paths
d_drop() after detaching, so this only makes rmdir match them.

Reported-by: syzbot+6b16e3d085833cbf3e25@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6b16e3d085833cbf3e25
Fixes: 7063fbf22611 ("[PATCH] configfs: User-driven configuration filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Vasileios Almpanis <vasilisalmpanis@gmail.com>
Tested-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260730093435.195441-3-vasilisalmpanis@gmail.com
Signed-off-by: Breno Leitao <leitao@debian.org>
[ sashal: Moved the d_drop() after simple_rmdir() into the older remove_dir() helper, since this tree splits it from configfs_remove_dir(), and omitted the pr_warn branch that doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 69762a33dff6b..5006437bed662 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -395,8 +395,17 @@ static void remove_dir(struct dentry * d)
 
 	configfs_remove_dirent(d);
 
-	if (d_really_is_positive(d))
-		simple_rmdir(d_inode(parent),d);
+	if (d_really_is_positive(d)) {
+		if (!simple_rmdir(d_inode(parent), d))
+			/*
+			 * configfs_get_config_item() takes a hashed dentry as
+			 * proof that ->s_element is still alive.  Our caller
+			 * is about to drop the last reference to the item and
+			 * the VFS will not unhash until after we return, so
+			 * unhash it here.
+			 */
+			d_drop(d);
+	}
 
 	pr_debug(" o %pd removing done (%d)\n", d, d_count(d));
 
-- 
2.53.0



