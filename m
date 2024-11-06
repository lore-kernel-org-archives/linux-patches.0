Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216E41EC019;
	Wed,  6 Nov 2024 13:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898113; cv=none; b=XXLuFUGKOsvhpHETWWri86wmGetsj2cKzd1ROJcpmgvMCsbozoNQs4zUxTRCO4lcHIYSnEO0L0PD8oDbJxS3GKRpPWauEbTqZCeusFUHxEcLOY8Ad0TcDjrUCLlJQ/XsPya/9CTqsU/3WBgNLTpxL0NNGuwb2FPshL21NYQvMlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898113; c=relaxed/simple;
	bh=PpNHx5zBQzoe+5M6L3ilFynU5ll2tVArESJz9OmmRYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8vHDCUvr7neRvcQ/4oNT/Ma7MHMgh0aC86MM2dqQIp6o/ohQenthrE82rdbd6aq3CmXYFpJgdQqgpQ4EWMA8FPuYfWa5svxOLVE1MiXf1KYxSOAQVlv42fIcw9M/EIDeB0XMGOVyiRh2453KCzh7XSoIQfmAQQKXjwgtpxkeKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wltu103t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wltu103t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E75C4CECD;
	Wed,  6 Nov 2024 13:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898113;
	bh=PpNHx5zBQzoe+5M6L3ilFynU5ll2tVArESJz9OmmRYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wltu103tYg/gDDH+QnDwp4iY3n1Bkc+pulVMKmAChRvjYBN8RmSs5uoc6FKZevhJV
	 fu52JDUKCoqbXX3XrSwLEqa88m+fzmU8di9SSJs7BKT9JBBX3CcDDdg2/0/rbdm8nC
	 BbhaIPiyQIHYZ+vUZY4oid4p6ZtfSiSNJ/quBXFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 128/462] f2fs: remove unneeded check condition in __f2fs_setxattr()
Date: Wed,  6 Nov 2024 13:00:21 +0100
Message-ID: <20241106120334.670633702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit bc3994ffa4cf23f55171943c713366132c3ff45d ]

It has checked return value of write_all_xattrs(), remove unneeded
following check condition.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: aaf8c0b9ae04 ("f2fs: reduce expensive checkpoint trigger frequency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 1e0fc35887f5d..731f97c7d4023 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -737,7 +737,7 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	if (index == F2FS_XATTR_INDEX_ENCRYPTION &&
 			!strcmp(name, F2FS_XATTR_NAME_ENCRYPTION_CONTEXT))
 		f2fs_set_encrypted_inode(inode);
-	if (!error && S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode))
 		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_CP);
 
 same:
-- 
2.43.0



