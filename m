Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7557139D1E;
	Tue, 14 May 2024 11:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687079; cv=none; b=EyStn3RcwsoPSiOAvht7zuKuHb/koXXoQnGTbMvKFm56MO2UsI/VR0oVsmDkoyZCzBcH9irxWF4baLEYsTJqlt3YnCqnbXjtkWcTMh3jDdMnZMvxukKXvZ5nvl2ttG5yTJUxHgIRjCHcSw4vYA9lPzH4CzhdBtNuRiUoDt1AyJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687079; c=relaxed/simple;
	bh=NjG8vUh1sliE7/8lfAG/GsjLLxMuBoYZbC5V9KI2lRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FX+/D/WkKrVvSK+L/ZiWcaHmj17CFQWqvM0jHsjO6UwWnG4JCVyzUZ81uCqziLzwlU1798oJX6hPJxTfRfPce3yD/fzHQRZiz0GDYiov3/EJZymdI5UBfLsqm1QkvPQ6QyjNCsqEZJfxqqE2pt8p01cSSUXUwMDCz4ogr8PMA+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H3cmtcHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H3cmtcHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3398FC2BD10;
	Tue, 14 May 2024 11:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687079;
	bh=NjG8vUh1sliE7/8lfAG/GsjLLxMuBoYZbC5V9KI2lRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3cmtcHmkainbckf061z+p+c16REhZ5fNK1n5jzu9ht7Ep+F4PdyStPSvkCMfBn+Q
	 /jQUpIhiy16AQD1FT1vAPzuDdYRU+gS8ZNcDwc3PpiR52qS0oOsCt5XNgDEIfszHL0
	 zvbRzv1z/Ed7a2xLopy+zU+4OSFEak9/5RcWLffA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 57/84] fs/9p: drop inodes immediately on non-.L too
Date: Tue, 14 May 2024 12:20:08 +0200
Message-ID: <20240514100953.831282040@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 74df32be4c6a5..46e58fdf9ba54 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -335,6 +335,7 @@ static const struct super_operations v9fs_super_ops = {
 	.alloc_inode = v9fs_alloc_inode,
 	.free_inode = v9fs_free_inode,
 	.statfs = simple_statfs,
+	.drop_inode = v9fs_drop_inode,
 	.evict_inode = v9fs_evict_inode,
 	.show_options = v9fs_show_options,
 	.umount_begin = v9fs_umount_begin,
-- 
2.43.0



