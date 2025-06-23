Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E822F24;
	Mon, 23 Jun 2025 13:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685562; cv=none; b=iZdmhLgjngkc+l0HRJeeuK4h1IOxtMWMK8kRCcuJF0fZslruH5T8z4w2qsqdN79n7lxtm0k5cwA2lK7/7xTQf/OMhYVNCjaSSO12Ij8ol308PaVBb/fMdr78kugwluIUUpKMr93RFA+K4GIcip/XZKQDl947Pdp6kEPdm0iP2fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685562; c=relaxed/simple;
	bh=QFIl+5UnxmRvruGu9fGBQ3pBnXwuMMh6W8wOt5Ztpf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI3iEoxJ8VVuuDHjbGN5sMdulM+fzxQiKGayxjhP6Sp8AZkKaPcXdwnfVu8LXxYtHHJF7RhMNUIK6u9V6zgQTtMi4iDtrfnmCdgaOGPfy3cR3TTIcqy43rrTuCUHQ49suvk00i+yhYCGsZLcZxt8LlUgT1gJ4DLcI2ey0DbclRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJHiNtEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJHiNtEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACF1C4CEEA;
	Mon, 23 Jun 2025 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685562;
	bh=QFIl+5UnxmRvruGu9fGBQ3pBnXwuMMh6W8wOt5Ztpf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJHiNtEqlIZfxoIsQPgfpdQzHdjjd3bqs9qlcN5h9/3yGzXyEDqndojgfQ5+Cl+Kh
	 XDir3UwTnrS09UIHl+TSgKuRGMeqvJFvqb/AQV4uEwCLAlfSDPawpkmqjaqnNkkMje
	 xBqwwh//TYJofX3XU08R91ruc+RxuAxfJruVCRMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/355] f2fs: fix to correct check conditions in f2fs_cross_rename
Date: Mon, 23 Jun 2025 15:04:20 +0200
Message-ID: <20250623130628.596218404@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 9883494c45a13dc88d27dde4f988c04823b42a2f ]

Should be "old_dir" here.

Fixes: 5c57132eaf52 ("f2fs: support project quota")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 1e3e525be68bf..a5ebebc15b08e 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1123,7 +1123,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if ((is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(new_dir)->i_projid,
 			F2FS_I(old_inode)->i_projid)) ||
-	    (is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
+	    (is_inode_flag_set(old_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(old_dir)->i_projid,
 			F2FS_I(new_inode)->i_projid)))
 		return -EXDEV;
-- 
2.39.5



