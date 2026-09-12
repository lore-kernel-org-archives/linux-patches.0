Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5476A3AC17;
	Sat, 12 Sep 2026 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226047; cv=none; b=IeuHZFHy//3X9No3fQy61q4De4Mh3QSskVKRdWhs2WxPHkLsYJSdaYtMcwIDtuPvbov/JkSYfpYcNaEUO9I015THigMNFke+2u7J4rfZS5ZtB9zhgxd9o089AflQABDQhPDc28ojROLIIRX+VpFbLPEet7TUZFEpcjBphNGTYVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226047; c=relaxed/simple;
	bh=5awplvxYgtvyZOnNRY/lixwEJBf0qOxieJm0Sxfy7ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blsPFM+frzIwpa1lIWThPuu78NrNocz3+rlgUbprz1xRsnyU5T9kHPSF4fPttZuo7IaRS26Ox5SMeNamp2l7B6cBKolMz+XmvrkV04/DmcC3BLGOizQdS9K+zvAas1QB4lwLWYC0vyKuYqVuogf5BYNMH0yTnmiGYJjz+o2t8Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Om/AAZ9B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Om/AAZ9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400EA1F00893;
	Sat, 12 Sep 2026 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226046;
	bh=C/DyN8tehzDmEDmjIOJ96/8HtNqvSV3DKDl0klht7MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Om/AAZ9BPmwosV6+6omkTXx87XieCik9I+OL2EGTnI0F9Yiww+BiROaO8mPOwIF3y
	 vcvfEbpCiQGTfZ3Sxho4j52rCsJTcYxsxvQj3rMH4QgqOZVbToUgEN5PWq00aIkOe9
	 umvpKl2tdanKXRI22UaYGJ+4IDImby2jjrYk0R4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1279/1424] fuse: use FUSE_ROOT_ID in fuse_get_root_inode()
Date: Sat, 12 Sep 2026 09:01:51 +0200
Message-ID: <20260912065635.918522215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 253e52437119719eb87293ef6852e13bb5ad0960 ]

...when calling fuse_iget().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 928f659a3e36 ("fuse: check for NULL root inode in fuse_fill_super_submount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index ac7603f2352df..84cfb5fcbc154 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -990,7 +990,7 @@ static struct inode *fuse_get_root_inode(struct super_block *sb, unsigned mode)
 	attr.mode = mode;
 	attr.ino = FUSE_ROOT_ID;
 	attr.nlink = 1;
-	return fuse_iget(sb, 1, 0, &attr, 0, 0);
+	return fuse_iget(sb, FUSE_ROOT_ID, 0, &attr, 0, 0);
 }
 
 struct fuse_inode_handle {
-- 
2.53.0



