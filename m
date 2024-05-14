Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5A73D0D1;
	Tue, 14 May 2024 11:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687750; cv=none; b=WeuG3ssjA5pdiSgR8BfwzDlJzG+C4qi25Xiex5op+rWVhPYtZToK/8iVxfC+GubTQLnAOWfWMBBHE7kzP3bYYTq28yBdxSXiO3o9v91gONJlRWADN8b6aEUuen1KI3wJyQWKVtr2Qy1HE9T351+hYHBPsD5MFRdYpa1XZlNgBL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687750; c=relaxed/simple;
	bh=uvZBZRA9ixNaUBSr+HItJUyHht7vRBmRBHAVzRMFZyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slR3H728hhJeu/8JvQQa1nemUvfCrAy0146PMqQUhay+UED9yY+tpPiRtVXRjJaD+alL1W5yWqEvzYCgR0VWLG4Ux2CJKvijBJ3qHuhtIBAAIpqSNwDlItEQg0+RhIpuoodeyjQVbvcTMcfPOTqIJ0LrKX/6VKKAxojobnzFrdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw3CvUKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw3CvUKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38568C2BD10;
	Tue, 14 May 2024 11:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687749;
	bh=uvZBZRA9ixNaUBSr+HItJUyHht7vRBmRBHAVzRMFZyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw3CvUKRmjRltHI3fcc/s+h7hLlMhPMiuiF5ux+Lg8PTam5nsd460T0gTQ4cqR9uP
	 1HBMgbrh5nOIc9gR2QbWR3I7uw/saA9/LUIf1A9h0sFZdgxs5LkN30L7wo764OAd/S
	 EeY/qIb15VQQcjy/tz7IvyyRk+e+fa0VPeaubLO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joakim Sindholt <opensource@zhasha.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/168] fs/9p: drop inodes immediately on non-.L too
Date: Tue, 14 May 2024 12:19:50 +0200
Message-ID: <20240514101010.163232778@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7449f7fd47d22..51ac2653984a7 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -340,6 +340,7 @@ static const struct super_operations v9fs_super_ops = {
 	.alloc_inode = v9fs_alloc_inode,
 	.free_inode = v9fs_free_inode,
 	.statfs = simple_statfs,
+	.drop_inode = v9fs_drop_inode,
 	.evict_inode = v9fs_evict_inode,
 	.show_options = v9fs_show_options,
 	.umount_begin = v9fs_umount_begin,
-- 
2.43.0



