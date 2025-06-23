Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57A91E480;
	Mon, 23 Jun 2025 13:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686001; cv=none; b=DaUBSiSfxQP3M+BV8Es/lR308Cm5pVwRRHcmzcbu/WnjYRGrvpsBn1FRpv1yQ4yJG4K1Ma3/HAZIxk8QkSGbtcGOnWscSMYVrQJeE/qM9X0pCsl9Ru7RfTDNlOB9rU3quhKQRAVoaio4u4BiFHj+IrVnkU8I8EeFAaXQPPlXfM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686001; c=relaxed/simple;
	bh=quGE162zx85C6FEqVPLljDzXSorWtbU6qBuLgCxH4ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXZTBJ0JxvtVZyc817kO49MhnO5RDG7dV9KyJP8wRNubwIXG0HMJ6oMJCikVInVuHr5YvaQpefvrHTZLEkuFOpdCGyrR8vK1kbR8vpl5YesNfVrRR50EKmbKf0xkNdRm9zHFq4Kpo6opUh3x0YLWeYJ2MvhER2ox4NwYkB+w9Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VeIYdaxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VeIYdaxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69330C4CEEA;
	Mon, 23 Jun 2025 13:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686001;
	bh=quGE162zx85C6FEqVPLljDzXSorWtbU6qBuLgCxH4ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VeIYdaxK1BC18IWddnLgG7dsYvgGZtUITSPmb/rEWLgfvzQp4KRO0+REYFzLPBbmI
	 z3VL6Fd5r+C6Y8oWaS4N9jEXTnRP+sz+mIVTKZKEOYPm2I92Hm9qbmHQXLaNyIZy/F
	 oOhNW3eoTdu3ve2AZSQAH8xYwQsynN10VkcV1I1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/411] f2fs: fix to correct check conditions in f2fs_cross_rename
Date: Mon, 23 Jun 2025 15:03:38 +0200
Message-ID: <20250623130635.227882285@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 364731547f696..ecdcde93ade4c 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1076,7 +1076,7 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
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



