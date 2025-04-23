Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDB228137E;
	Wed, 23 Apr 2025 14:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419713; cv=none; b=dXMR79BbeFsCy4pcqQFnxexdTieg7r/UZaMhO+mnx4Z8wIQMYJHyywunoBQbTYIGs4eXuSDOXBC46RQqufTTIuRbwNv3xjk/8Lhrtkt8Q9pnmeJibHp35iX4Y74F5KGXNnPyMlGpwxAQU0i45c4VoPNTsT2OAEPm920r8YRbHfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419713; c=relaxed/simple;
	bh=nfm+nNuEnT+SPlg4tgrH0ZHHoz82MF1b4M+En0vLRHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3Ey8pH1EpA6/6odJjk5DwYtscmjP8pWmGJjDNhMTeq+qteisdzduF0O3OZeLv+i6USSmxcS3QcWQbMrobGCHUDNNXj2xemI1f2MPah9ndLLcT1pJWwNF7Xmu3zv+YgaTH+r6K03QRTUtoqjeAPfQfp9Yg4OBJZuA+8R+28AimA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKneAJjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKneAJjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66B5C4CEE2;
	Wed, 23 Apr 2025 14:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419713;
	bh=nfm+nNuEnT+SPlg4tgrH0ZHHoz82MF1b4M+En0vLRHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aKneAJjD7IDEyLrsKObKCD1Kc/pKPh0GgeMukuFWm7Q7D2AUIu7Y+ICSfiB4Ywpdw
	 Vs/+cRr///eWXF3ztc0dDEqPLeoGkAKQF9KHiknSownaDyfUpDhiz/Q0VdDFV4om7o
	 uRnWKmCj+daCSsalqQmvC+6pX2JpbB0b94adElU8=
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
Subject: [PATCH 6.14 014/241] ovl: remove unused forward declaration
Date: Wed, 23 Apr 2025 16:41:18 +0200
Message-ID: <20250423142621.102765045@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 0021e20250202..be86d2ed71d65 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -540,8 +540,6 @@ int ovl_set_metacopy_xattr(struct ovl_fs *ofs, struct dentry *d,
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



