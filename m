Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D437F281375;
	Wed, 23 Apr 2025 14:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419697; cv=none; b=t1urjFJWvUrOWuUeNluKXH0ctPYli3wsv+mxPIMlxvR7tb+YtTj3GBho7XmhdZifm7//m5R5SJtFfMdDneGQp4J3lZ0IZtTrvR+BJjMrSbWygnbHxy2aVU3l7fcX97tUWk0PwkHqdWnU78hE2bYZF3zhXNWu7CcUSplOP4PAjrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419697; c=relaxed/simple;
	bh=fhhBOYAMPuiZMjjrF5oe/ltfxgZ8RV96mlrm43RqO8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+1QESTRRN4yccKfndK5Z11Xa+RYZZpu6jNOtIzQLGMwbKai6S8DTL+pCYIbl4tr3TCqIdZZj1NtujLDLqMMQ3d6n8GrgzTPM2QrBjIkT8Z9LtVQcFzGT1P90DMpoDTqV0zLSFhF0saHcL0pG4cpWCc8NMJ1roEXmtyR3rNuxhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJUVN3Vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJUVN3Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE6EC4CEE3;
	Wed, 23 Apr 2025 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419697;
	bh=fhhBOYAMPuiZMjjrF5oe/ltfxgZ8RV96mlrm43RqO8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJUVN3VmkOGyNw1YCMRFMR0WT+STr+PDzeW323k6lN9nsWhRIjnh708D1c+dHlBJw
	 XVKThq3Bo/YAHEHS74YzoyXg6LyJiKAT4F9hwacWQr01B5+Pgn5sE2APYq1lMt6CkZ
	 alt3pSqfKVpMyqQf5aG0imUSzKW116o/aEwbXmAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Alexander Larsson <alexl@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/223] ovl: remove unused forward declaration
Date: Wed, 23 Apr 2025 16:41:30 +0200
Message-ID: <20250423142617.860217477@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Giuseppe Scrivano <gscrivan@redhat.com>

[ Upstream commit a6eb9a4a69cc360b930dad9dc8513f8fd9b3577f ]

The ovl_get_verity_xattr() function was never added, only its declaration.

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
Fixes: 184996e92e86 ("ovl: Validate verity xattr when resolving lowerdata")
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Alexander Larsson <alexl@redhat.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/overlayfs.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 844874b4a91a9..500a9634ad533 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -547,8 +547,6 @@ int ovl_set_metacopy_xattr(struct ovl_fs *ofs, struct dentry *d,
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int padding);
 int ovl_ensure_verity_loaded(struct path *path);
-int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
-			 u8 *digest_buf, int *buf_length);
 int ovl_validate_verity(struct ovl_fs *ofs,
 			struct path *metapath,
 			struct path *datapath);
-- 
2.39.5



