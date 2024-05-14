Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933B012DDBD;
	Tue, 14 May 2024 11:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686848; cv=none; b=enKsUk601dHYvUM/iVoqkoVKBjwsu7lx+vjqZhkyT7281ZsbVJvMKZxPBia6WZWpTCUD0RppzsJOv0XOeGZYfCQrlWMKWhT0YPSQcHAt5zy4DKwyfke/XNiEzL7HvNcYfS2UA8T9EwAxfY4uwuDgLysXfCPr4IVgkfNkU69M39c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686848; c=relaxed/simple;
	bh=ftu920eVvPWpkMU8Ycupri02R3JZg1Wmi0oRkuhrmOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1raYf9HJM8IFramV/fuz9Fxa/7415N5uQ0wexCoWL4ZGp9Pp8OvQGcdgB2cAMXlvUqsI0ehGC8gWryC2oZUqVfKonlf097arjcI1vk0q95GYHBoBesHi36H0jy89zopX9Wrp0JNU7nPKMZds0h48tTH75dm3R8/j+veyELc13M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viPFj82h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viPFj82h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1F0C32781;
	Tue, 14 May 2024 11:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686848;
	bh=ftu920eVvPWpkMU8Ycupri02R3JZg1Wmi0oRkuhrmOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=viPFj82hhRypfC/0veMJOQxqCD9KQvqDujUjmkfQwfxpurcbsCFPIF6wxii9kj6q7
	 mCf8RHGZ9jdXEaAQtgx+pHWGjqOhiOBXE1kuSXyqORROSNRzuairjCXmcLOK6l0j27
	 EY9Q/n1IDNld78DJt/F1/2re1Q0vNOh6nVu9Q080=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 42/63] fs/9p: drop inodes immediately on non-.L too
Date: Tue, 14 May 2024 12:20:03 +0200
Message-ID: <20240514100949.605026569@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index eeab9953af896..b47c5dea23424 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -346,6 +346,7 @@ static const struct super_operations v9fs_super_ops = {
 	.alloc_inode = v9fs_alloc_inode,
 	.destroy_inode = v9fs_destroy_inode,
 	.statfs = simple_statfs,
+	.drop_inode = v9fs_drop_inode,
 	.evict_inode = v9fs_evict_inode,
 	.show_options = v9fs_show_options,
 	.umount_begin = v9fs_umount_begin,
-- 
2.43.0



