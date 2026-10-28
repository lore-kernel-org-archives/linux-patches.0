Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213668;
	b=eBZeI/B4+3ych8DYgiA196vx9KDC2S8Y/kMOOSbsZh1fh4kP39OpianwwfTBWXmtAtie
	 Z/2diOGUWLZyGJLYQzrZq+O66XyGeUv+Iof/ccRZqIgi6iKR7eE5JZtUVLmc3UFje89ui
	 Qcqd/a8lscAH6SPjJ4Mgzk577WsCaYEfEiSVoYMEZXI0CYHqEjEuukxdC3xIBywWfHCA/
	 OqB+/R00QLkg/t/MknDcpSXQOeflZo1KUCwSaEBMRUWTIv/Gc3f6es7PTpxlAiiKWBm15
	 osoc/5usqfmVbPxARGATwDiKL65kCJFqPgYWPpkY6W+HLYaeut9dRL6+A6qa50nXmkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=90tSSDn8usPlStyeMF+HpoObE8DDwRerPdDyMprSJOA=;
	b=eglJcWJqWYZcXQ6/9JZr8dSkFUJdgu8yO9XExrpGPJKKhjDmW7r62ffCNliMkGW3EVnb
	 wwp6onBL26lg6wG6qBAF4HntAeWjdkVEQrwNFIt8EGDZ9WZYDHO6hS0xsY3YKbC9j8p39
	 IEyeagsM1YPytXcMjJ2x1OafEiEoJ//BgN3XzxZpHhSILWo9GgMDRY0Q4FsltPLEp6hRb
	 U6f6bONBxaEJBUFR8AGca3WXNH8hi5bdFvPTSpv8kkC5UkdJ/33rF9SIViKw3eNl9X9Xo
	 RX4uNYDvy6CjTxBq6780RnF1GLHk1/8Tx5K2J05C3INYLXPg4zcQFImbPwDPQQWFhSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JuS6v5ST;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1828B606A31D;
	Wed, 28 Oct 2026 18:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JuS6v5ST
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665BA1F01825;
	Wed, 28 Oct 2026 18:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213667;
	bh=90tSSDn8usPlStyeMF+HpoObE8DDwRerPdDyMprSJOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JuS6v5STpAMeu0ILGZON8EMPEzUB7F0l6Jk4AGCC3wx9rUx/zGmPNbK0xu929WMwp
	 1++1upiiQOPu2kPg9x1CWBV4oJWUrMQNCY21HV1rzluJncWKxIVUx6jN3Agf8UsgiT
	 WAnlYDgRJVH6Y3dZsEINFVVBG/NdsHCHVPmEOYQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0588/1887] f2fs: introduce f2fs_is_readonly() for readability
Date: Wed, 28 Oct 2026 17:44:44 +0100
Message-ID: <20261028170512.802024074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit ed8ac22b6b75804743f1dae6563d75f85cfd1483 ]

Introduce f2fs_is_readonly() and use it to simplify code.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 9f0c4a46be1f ("f2fs: fix to truncate meta inode pages forcely")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h  | 5 +++++
 fs/f2fs/super.c | 5 ++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 971d45979ce40..f72c28700ab7e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4596,6 +4596,11 @@ static inline void f2fs_handle_page_eio(struct f2fs_sb_info *sbi, pgoff_t ofs,
 	}
 }
 
+static inline bool f2fs_is_readonly(struct f2fs_sb_info *sbi)
+{
+	return f2fs_sb_has_readonly(sbi) || f2fs_readonly(sbi->sb);
+}
+
 #define EFSBADCRC	EBADMSG		/* Bad CRC detected */
 #define EFSCORRUPTED	EUCLEAN		/* Filesystem is corrupted */
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a86200f7d9101..375daa37b3795 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1400,8 +1400,7 @@ static int parse_options(struct super_block *sb, char *options, bool is_remount)
 		return -EINVAL;
 	}
 
-	if ((f2fs_sb_has_readonly(sbi) || f2fs_readonly(sbi->sb)) &&
-		test_opt(sbi, FLUSH_MERGE)) {
+	if (f2fs_is_readonly(sbi) && test_opt(sbi, FLUSH_MERGE)) {
 		f2fs_err(sbi, "FLUSH_MERGE not compatible with readonly mode");
 		return -EINVAL;
 	}
@@ -2144,7 +2143,7 @@ static void default_options(struct f2fs_sb_info *sbi, bool remount)
 	set_opt(sbi, MERGE_CHECKPOINT);
 	F2FS_OPTION(sbi).unusable_cap = 0;
 	sbi->sb->s_flags |= SB_LAZYTIME;
-	if (!f2fs_sb_has_readonly(sbi) && !f2fs_readonly(sbi->sb))
+	if (!f2fs_is_readonly(sbi))
 		set_opt(sbi, FLUSH_MERGE);
 	if (f2fs_sb_has_blkzoned(sbi))
 		F2FS_OPTION(sbi).fs_mode = FS_MODE_LFS;
-- 
2.53.0



