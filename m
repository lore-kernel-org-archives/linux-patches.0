Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772B81DDA15;
	Wed,  6 Nov 2024 12:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896191; cv=none; b=Fg+ZUu+aDxh/iPR2Mcy1WyKLVTIIYa4jr6rWiw8+vzO/XwOf/FNSOzrmEDycGmp74iCx681hmD37FkuUwMrbBjlpDYhNPGaI8f2rQ/E5vWEiOFD6uuvIQ3m1963CvfAU5Yzxv0QzNVlXZ3teZ4fqGTDHcfWnFBkxAGEz7iSxy1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896191; c=relaxed/simple;
	bh=mlV/gI+JzS4zpk3G/4KeJoj+tJKol6dpAIdygOoLvnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wgdw4XmZFQY3JMdZtLxexA1Ylnp3wxYJQDrEXPiXcGa2SIxP7bgrvjXhjC2ZhF1ALmSKEHqxXWVsgYVBAXNkllawOqzau5V6ELzqBkifZm8UBIiZ7KewOldj84C3cKJ02xxSAldLMoIzAf7FPS/tkygW0EEmpT7ZRlqg+YHe0SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSNUojXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSNUojXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00390C4CECD;
	Wed,  6 Nov 2024 12:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896191;
	bh=mlV/gI+JzS4zpk3G/4KeJoj+tJKol6dpAIdygOoLvnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSNUojXLQRxG6CCXUi/AXh+4L7NUHvAan7HGmxJvYLQnTC/ywlKYogeFPBLuUFKpN
	 +/NPFQZpB3VqxKYvMqBVP+V+M7BnNFVUYKWl5RUWEChQSAz8u4QCYSps48CdpoUVLU
	 UawLlL+flCzHSADwuIjyRwB1h841cLNGCIAVb/6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	syzbot+c2ada45c23d98d646118@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 084/245] fs/ntfs3: Fix warning possible deadlock in ntfs_set_state
Date: Wed,  6 Nov 2024 13:02:17 +0100
Message-ID: <20241106120321.274958682@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index e5255a251929a..79047cd546117 100644
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



