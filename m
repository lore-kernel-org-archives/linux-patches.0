Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021B41DE3B8;
	Wed,  6 Nov 2024 12:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895191; cv=none; b=djbOghiALbdiDhySJKqQk+9XUy78oepf53jefgRxS1a+kmrlYblwpwgaNlP0/86OEFHmbIp8Nzn7LzCnkuSoBX+xUFR80yXlkLFu+rNnPzW0bBhuXyqukJY1C3blOdUAnGo+6xlo1In9vONEMV7aJppzbWUjYi5HOVFazj7JNAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895191; c=relaxed/simple;
	bh=mriAJ9Ou/EoDUeUkiuIjQyX36qnSF4BJH/m7h/gxPkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pW66FR5HE5P7rZkVpTMuy04VmmzBpb7ct8S2+sFgHdlsjqeA+NoEhOhwavORw7GV4Egcnp3g4IoSKT4IGeP6CUexf9Fg5WpZzwfDEgbzMyvFernYRFUPWWPZdvPAoN4eQ61vWGZ5NBkmb/2daIoT3F74wwaGD9CgBnZ6lz7CVVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mkhvfzsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mkhvfzsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6677C4CECD;
	Wed,  6 Nov 2024 12:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895190;
	bh=mriAJ9Ou/EoDUeUkiuIjQyX36qnSF4BJH/m7h/gxPkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MkhvfzsnP7b/0TpUAqfs9l/eIXOtBQ4hqTk6XAAOZqLZvKnRSFUyzzxBTRR4K/Vik
	 tN0NMxTOOE9oaIKSTsYGYCi2wa6ELpOp7l5Uw1SPfGaG8mRWWBKgNIE94PlX8G38Vj
	 3gBpuJJGyVTKwNR0fbpN91w9Uk0DOgyRxNpp+7AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/350] f2fs: remove unneeded check condition in __f2fs_setxattr()
Date: Wed,  6 Nov 2024 13:00:25 +0100
Message-ID: <20241106120323.298512856@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 00af34ba8561e..5b8ce9c7a5dc2 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -732,7 +732,7 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	if (index == F2FS_XATTR_INDEX_ENCRYPTION &&
 			!strcmp(name, F2FS_XATTR_NAME_ENCRYPTION_CONTEXT))
 		f2fs_set_encrypted_inode(inode);
-	if (!error && S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode))
 		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_CP);
 
 same:
-- 
2.43.0



