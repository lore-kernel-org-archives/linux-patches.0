Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C76D1CC89D;
	Wed,  6 Nov 2024 13:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899195; cv=none; b=jrcwbhDa6mundLiMpZUbnRjSG3IU6WIClWKEo5SQFHa8GlBfhNJ4iY3FXUc+R0KreoQ6ztJJKJ71w0G3ENgWC7ZM6gsAtN8IiWt6fdj4hPsNGbKYsNazRrVzXEiFSpmidNfLZcc/YxU67+qjcQBneXGWg6+AlioV10qbhcP8uHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899195; c=relaxed/simple;
	bh=rtr7xawq0ICASJDmFa4U8xqzwd89N0A4B0iDL8x2mnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EtQ09gxfBTn5A4Nblh58bC7JygkU0s7VT29JfRcjyspKFe0U05bM2EhE007tK5iYfsL6Nt9bFYpbkMXm3Tsi+cJtd6q3fqE2bNTQRkqhDHGYLsD2RwqGKgcOSrNp5iPl2LyEZdg4CFxqH7wvkXEohsy0lADLjjVcam115vCFdO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bcwaJIrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bcwaJIrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E995CC4CED3;
	Wed,  6 Nov 2024 13:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899195;
	bh=rtr7xawq0ICASJDmFa4U8xqzwd89N0A4B0iDL8x2mnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcwaJIrDLrWepsCMokbNGttgglFZNIYlNwlZm34riwOkf/lYC7DGGPAr0zLX18394
	 hEsz5/qcqTcMblCYCrCm/1CXYQv0wgZpNZ9dK/bU6wNBHeqjn93DVez7i+2Vy+9DtS
	 0zXiRf0ML9M4/YOtkIxy2MAlPJLuwYbWKjv3v+CY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	syzbot+c2ada45c23d98d646118@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 31/73] fs/ntfs3: Fix warning possible deadlock in ntfs_set_state
Date: Wed,  6 Nov 2024 13:05:35 +0100
Message-ID: <20241106120300.893773005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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
index b4c09b99edd1d..7b46926e920c6 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -328,7 +328,7 @@ struct mft_inode {
 
 /* Nested class for ntfs_inode::ni_lock. */
 enum ntfs_inode_mutex_lock_class {
-	NTFS_INODE_MUTEX_DIRTY,
+	NTFS_INODE_MUTEX_DIRTY = 1,
 	NTFS_INODE_MUTEX_SECURITY,
 	NTFS_INODE_MUTEX_OBJID,
 	NTFS_INODE_MUTEX_REPARSE,
-- 
2.43.0



