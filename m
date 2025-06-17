Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FB62264B7;
	Tue, 17 Jun 2025 16:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176430; cv=none; b=nYNRmdw+t4TVVOWCqA38iS6mmdS2QbrxiX11D3/fTfpBwPn6dciqgkh4vR3Z5oVVI8diSX5TTpV1e1FadS5HYmGsNjS1DzCKaHqKrlFUApK83bkNn3xhITFdmG5XAtfJyu8nigX/7DT3N2xQoAZMK34gVu/k9WVo/jiwFpJMpQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176430; c=relaxed/simple;
	bh=4f9A4/qg81d9IkXARo9uIiFY5Kbhe5VfPRCHdurHzcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ux3hOijhw6Qvg1FrrTzXtxxnNtaJipGne96Il6yqU8gAocYazfIQr5+ydK7LeezOvOiirayViP4o5x6O+TIkazKPMWwsnOi4P5d+quXyhugUR2LW+7PLN/3VY8p7u6DaEOdT41E6cV7kjBcTj8VZX7iBW9LbzkNlcnD3lG8cn4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5nqtNcd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5nqtNcd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3567C4CEF0;
	Tue, 17 Jun 2025 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176430;
	bh=4f9A4/qg81d9IkXARo9uIiFY5Kbhe5VfPRCHdurHzcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5nqtNcd6NAbk4H68LbROuNc+GL+gaHMakLv7hka7dXwpe2uNzLE2vhnYg9qlnaqy
	 Xj5olnZM0QdnM1vjNLtYKSAkK4LCzlAvvitXvWnGPeq3LiSfAj5zH4foNAoEVGJ+2f
	 JtxO62xqecGhbpuODRUEWTIyhS1x3xIJbh4q6++M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/512] f2fs: fix to correct check conditions in f2fs_cross_rename
Date: Tue, 17 Jun 2025 17:23:03 +0200
Message-ID: <20250617152428.424856322@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f8407a645303b..6f70f377f1211 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1099,7 +1099,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
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



