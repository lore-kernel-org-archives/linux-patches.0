Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053021;
	b=2djrV5iUsUS1bMzRt/HXNcz0UsFolGGgXsridlnjkk7uRkf+sUKfnbda74YttlMFWnHK
	 Ucv0kIes1YuG4Hkxyo5x3EwQdUdXe8FFmgN5Mu/od3/z65EahCgEOGqocekmBBdgj4BLd
	 sLkDO/AS0C0whnNKMdrtixqhki9j41VWXQKkOjS7QT9oQw6qozQ09jT7sjmKHoM8FBhSf
	 iNe6xNsvYbtF3miftpD2TxgiuazgqAzM+33q+56vnZzcEfnj2H5AIS5lGuNwUfIUayYy/
	 bgMEesBSX0gG19WKPob1Hi/x+AgnJfoIxcgOJVhWUhe4zIgKOLpf/Z+smR8xUz+UzeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wa2KYrwbBj4yAtWxt3fPMqH91+2p79+Nz6kY7Jt6lQs=;
	b=yCcR8mYWBL74Mty1PdQ64darfFh8khKva/Qv8+LLQHzXIgECY32ohgKJ371QaOTSSJBq
	 ed4Z9mBpM7Zxk3R6LLtxKjw5iV+zBa/sAZZeE7jVamR5WExycqmu+Cdb8dpFIE9lAeK27
	 vtF9OewaQRDjTddabnwjfLFamWOjVZK5dj9NzGJmFXT9KTwbgAthsei1RhHcPpj/RPKxl
	 x/eJcpTHHUv1mMCFTCE4fjIO2kL8FoPXMVhXH+VvpSKWDT1+iSh0yomTFcbNSPooQh5X8
	 9ZGwZsSvwsh1NgbYYP7gvINvZmRMi4d67cIBOJ5i64NsPeN4NsvSpwr9Vb6dAgwpxxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lZP57U37;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65358606A31C;
	Thu, 19 Nov 2026 01:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lZP57U37
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B265C1F000C4;
	Thu, 19 Nov 2026 01:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053021;
	bh=Wa2KYrwbBj4yAtWxt3fPMqH91+2p79+Nz6kY7Jt6lQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZP57U371hh+Ts4nFZb/nrJ7XFIFNIRHXtTDzMe8M5vOd5r8FI1lpznQDFi95TWs1
	 uYxQPf+kaYt0TNSZbjvE8HWmksO/W1OB12boOo9FYcOg6aIvJ0Hf6wwvjaSQSGQ8oO
	 CfwPXa7dtxsDt+R+nBpW8Vs7TPT7z3EHX4HtARp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0770/2214] ovl: check that the parents of volatile/dirty are dirs
Date: Wed, 18 Nov 2026 15:40:46 +0100
Message-ID: <20261118150042.478143600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit e34d2ef818e4c7676d8d8e1bf43e6a1ed39efb2a ]

An unprivileged user crashes the kernel by mounting overlayfs with the
volatile option.

A dentry that serves as the parent of a lookup must be a directory.
ovl_create_volatile_dirty() walks work/incompat/volatile/dirty by name,
and ovl_lookup_or_create() returns an existing entry whatever its type.
A file or a symlink that another task creates during the mount becomes
the parent of the next lookup, which calls a NULL ->lookup.

An unprivileged user mounted overlayfs with "volatile" in a user
namespace while a second process created a symlink named work/incompat,
and the mount task oopsed on a NULL ->lookup call.

Fix this by returning -ENOTDIR from ovl_lookup_or_create() when the
caller asked for a directory and the existing entry is a non-dir.

Fixes: c86243b090bc ("ovl: provide a mount option "volatile"")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: Adapted newer creation helpers to lookup_one_len() with explicit inode locking and dput() cleanup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 2ad1f8652ce61..6e97ef29ebd8c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1321,16 +1321,23 @@ static int ovl_check_rename_whiteout(struct ovl_fs *ofs)
 
 static struct dentry *ovl_lookup_or_create(struct ovl_fs *ofs,
 					   struct dentry *parent,
-					   const char *name, umode_t mode)
+					   const char *name, bool is_dir)
 {
 	size_t len = strlen(name);
 	struct dentry *child;
 
 	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
 	child = lookup_one_len(name, parent, len);
-	if (!IS_ERR(child) && !child->d_inode)
-		child = ovl_create_real(ofs, parent->d_inode, child,
-					OVL_CATTR(mode));
+	if (!IS_ERR(child)) {
+		if (!child->d_inode) {
+			child = ovl_create_real(ofs, parent->d_inode, child,
+						OVL_CATTR(is_dir ? S_IFDIR :
+								   S_IFREG));
+		} else if (is_dir && !d_can_lookup(child)) {
+			dput(child);
+			child = ERR_PTR(-ENOTDIR);
+		}
+	}
 	inode_unlock(parent->d_inode);
 	dput(parent);
 
@@ -1351,7 +1358,7 @@ static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}
-- 
2.53.0



