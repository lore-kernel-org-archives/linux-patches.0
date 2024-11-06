Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D59B1DE3B5;
	Wed,  6 Nov 2024 12:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897450; cv=none; b=WLHtpbMWoZ7/YB2L4LtWOPZflOu3iGsuipyyzRjsF9BsMGPN09MltpRiFl0LVX3guFJnpDo4lXD+wDpGgCjtIo4ykEOjnYicDjsFPHc4qzly8sEANHv5HKLFjscvebwAoG4RXelWG5DwXjQIo0COje2QO/3nR6dORxgULMVYA8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897450; c=relaxed/simple;
	bh=YLAZ416mAebthCPIolGLvYWrXc9mhQzz0QG6cE5YONw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1Om1GhDdgW46lP2fNLS90+KQb2liMASMzxOLrDPmpxXfWOhU+Ik5nWA0lirlE6zu/75Y1p51hEYkHqHonh7OWgC8UZ5a9vlVfW6L/ZHwWqamyrLt37dWaeUjpxnvGrSKdck5uENnei2xyZ5ALNxFaoz4aPadwCqi7LR9yf+Fdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSJGxd42; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSJGxd42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C1CC4CECD;
	Wed,  6 Nov 2024 12:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897450;
	bh=YLAZ416mAebthCPIolGLvYWrXc9mhQzz0QG6cE5YONw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSJGxd42Gh08GETUigXmEFxvwLHHHGJ3YTk/cWrYg9OYXQCXicNlX4HbfsQJdW7IA
	 Cq/VNjtBh2rnVz8dm2bDKYXLTV0jcWEcr2LDM/j0ksc1wrJudh1ZX/0FcLHsgxeSss
	 WpIL2PC9NuEhy+nX0TfNEcjk6uPVuv3KpSG8zXyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	syzbot+c2ada45c23d98d646118@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/151] fs/ntfs3: Fix warning possible deadlock in ntfs_set_state
Date: Wed,  6 Nov 2024 13:04:05 +0100
Message-ID: <20241106120310.406556585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 5b2db723455a89dc96743d34d8bdaa23a402db2f ]

Use non-zero subkey to skip analyzer warnings.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Reported-by: syzbot+c2ada45c23d98d646118@syzkaller.appspotmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/ntfs_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 28788cf6ba407..cfe9d3bf07f91 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -334,7 +334,7 @@ struct mft_inode {
 
 /* Nested class for ntfs_inode::ni_lock. */
 enum ntfs_inode_mutex_lock_class {
-	NTFS_INODE_MUTEX_DIRTY,
+	NTFS_INODE_MUTEX_DIRTY = 1,
 	NTFS_INODE_MUTEX_SECURITY,
 	NTFS_INODE_MUTEX_OBJID,
 	NTFS_INODE_MUTEX_REPARSE,
-- 
2.43.0



