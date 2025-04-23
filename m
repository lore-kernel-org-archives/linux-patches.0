Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FFB269B07;
	Wed, 23 Apr 2025 15:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421947; cv=none; b=ZtRax4B3tBUtkKvLiCGXFYIA0i6dlwXQJ0pcQIOtUqhH5E2eZKxHekENTB6u8bghi37yXaj77XdC3ZweXe39do2+tq6IrXoHjgVedxJtX7tFHETfb8IAKe51USlebLwmjgc0fvl/a4x5c68v7fxWWeSfXDKRZ51IsavAcz2Womg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421947; c=relaxed/simple;
	bh=eWgLSW+21k6c0gdBkvCBr22pm6ePWey5Sk/nujmkD5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcVjnEZoCQpuRxEvTLvE+lbQ7/ocEnYlrN49E9keaxA4rNtDOCGfVom+i5LbNMDjRlGow9Uib4v9DahlHXdLY9zSSg+R22bApKfIvLbh6X1MfripNH/UzJ+Qyu9ZolaUd7OVAjY4gd65+Kkrn2MqLENiWXk/40GysEF5WAm70qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQ0SmjnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQ0SmjnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029DCC4CEE2;
	Wed, 23 Apr 2025 15:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421947;
	bh=eWgLSW+21k6c0gdBkvCBr22pm6ePWey5Sk/nujmkD5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQ0SmjnLvTZd7Xie6DC0/kjdvelLInERw7c54uAG9SkNHjSPYVJNG36V2uyOO23Bg
	 wvSD7DFVhKEI8y/zRae04oPbvFjz8tzgPkdHp2XPvizMXzfmp261rZGzGHCn5df4Ax
	 /SeFKR+TYSPzjAdy1dSak/bVbA4kICpZATcsr50E=
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
Subject: [PATCH 6.6 250/393] ovl: remove unused forward declaration
Date: Wed, 23 Apr 2025 16:42:26 +0200
Message-ID: <20250423142653.700219083@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 981967e507b3e..23b5c5f9c7823 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -506,8 +506,6 @@ int ovl_set_metacopy_xattr(struct ovl_fs *ofs, struct dentry *d,
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



