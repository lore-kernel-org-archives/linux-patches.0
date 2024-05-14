Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629E77F7C7;
	Tue, 14 May 2024 11:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686436; cv=none; b=Mlhlh66WkYjomMXhBk0NGNA9rJhSX51WHBaNw/TfsyGBVZhOtv9nFP6mUd5Yhto1zbJRoCvELbIMBtZyxQEFWzb3PWxIR404po0RnK7GwZ34d2uFdatNvUBHGq31MRg4bhM0JSkXArocXOfteG+6l2SCYPSdZ7DehYS0Xl+fiG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686436; c=relaxed/simple;
	bh=p9VBWqKTHECSS+ruI02h2QurQ+hV8RO0f+Vc/neGVhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKIFr+NKJcVaOUSXXQVjZwbgZTDCJVDJlE6QmrKL+B/qxFRmLGVz1ZiGYc6c/1r2WVnXnQ279oiIWoMbfVZS3PpaM4oxxvI9k500JqMDkpwcQFIXLGPhmkAQqWWQg0rU0aSO7AzQJ0FUjPGvkAoeAHxdLsYDSJbGIyeFVE7dHKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvDbSuH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvDbSuH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2E4C2BD10;
	Tue, 14 May 2024 11:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686436;
	bh=p9VBWqKTHECSS+ruI02h2QurQ+hV8RO0f+Vc/neGVhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvDbSuH1T+WebAH0NVhcZ1ItHIFvHguhkyRsRAcZBuxbkdlw+SY7+A+r9afEacZiT
	 SMY5+AGG48Krgy0jrkT4ca4fEafQMphcfT8cwawwCUnMAVR/TymD8q4MJoIxHiUigm
	 jH7ltgBb3x09IoaMj0ekNCSJxTEJ5d78RRIAfnI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/236] fs/9p: drop inodes immediately on non-.L too
Date: Tue, 14 May 2024 12:18:19 +0200
Message-ID: <20240514101025.570871213@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2d9ee073d12c3..7c35347f1d9be 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -342,6 +342,7 @@ static const struct super_operations v9fs_super_ops = {
 	.alloc_inode = v9fs_alloc_inode,
 	.free_inode = v9fs_free_inode,
 	.statfs = simple_statfs,
+	.drop_inode = v9fs_drop_inode,
 	.evict_inode = v9fs_evict_inode,
 	.show_options = v9fs_show_options,
 	.umount_begin = v9fs_umount_begin,
-- 
2.43.0



