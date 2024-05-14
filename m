Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF57C126F33;
	Tue, 14 May 2024 11:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685489; cv=none; b=TVZYY59yzMC9lb4Lr3VbdTjU5CdvzvGeNYIxSimFLqsJuG5ypMDswy5SP4a326TZX91dKVxwn10Cpe6UhEArrDUbJHT4CIzQV9L+zooEDhO7cU4TOxcizN7UU6+rikN0+bG6VqqwSqPXmGEcWnnuE21jlXB7lKAFXYGIVCM1lUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685489; c=relaxed/simple;
	bh=+MeuTgadmIvwwhqewNKSvXWBMfqlSKdXiH+FsQthy04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuYJzpbdolUY3OJnPfJZ6zTDG9rISuY6ou+2wznWdzLyZCO2zTT9sjtXVh9zkbFS3Pxubb42X8/xojb+XJoNMBbqSRbQOpd5c3lIjUQe0xpWO5ELyjkhD9ry/kde4xQ8HH6dXEK5YY47LlEKtuSD5zpbiuDU0FOtWKRpNqvOBkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKzqgmMJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKzqgmMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD80C2BD10;
	Tue, 14 May 2024 11:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685489;
	bh=+MeuTgadmIvwwhqewNKSvXWBMfqlSKdXiH+FsQthy04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKzqgmMJPRtWDisSl2RqmrEQImi7RZnt/5VD2QrS9qhJNzYCrp1zzTwy2ncHsANuU
	 BRaAtSwqAEuxbvb9qsiSqpggm6vDY6yLjYoQ9/tyg03MM15OxOZMloTsB20VKO4iQQ
	 5m3vk2vJ0Sk5LJ401alQaE30dWPjNffKCdUfum0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/301] fs/9p: drop inodes immediately on non-.L too
Date: Tue, 14 May 2024 12:17:17 +0200
Message-ID: <20240514101038.524163927@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joakim Sindholt <opensource@zhasha.com>

[ Upstream commit 7fd524b9bd1be210fe79035800f4bd78a41b349f ]

Signed-off-by: Joakim Sindholt <opensource@zhasha.com>
Signed-off-by: Eric Van Hensbergen <ericvh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/9p/vfs_super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 73db55c050bf1..958efc8423334 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -320,6 +320,7 @@ static const struct super_operations v9fs_super_ops = {
 	.alloc_inode = v9fs_alloc_inode,
 	.free_inode = v9fs_free_inode,
 	.statfs = simple_statfs,
+	.drop_inode = v9fs_drop_inode,
 	.evict_inode = v9fs_evict_inode,
 	.show_options = v9fs_show_options,
 	.umount_begin = v9fs_umount_begin,
-- 
2.43.0



