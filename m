Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038937;
	b=dW05E0CJnvvtUC/qBBVZOZlUpsl8m5O6DgeENGCDyh4Vr+XvMB4Ou+rgw0E+s7Y7qlbU
	 C9aD99SUjGTnX3bEN2LMHeztudRT2zmd35tBtJ7tAjNqZQCwOHgXQOYu0XZJ66/VzkWKx
	 r5Hfl4ZrZk0tTOSxEePSXQGuJ6jvZNf7bBNVnONO3wBbMgj1yw1XrSJjNxDRLRxBjwxTS
	 opmhyUVx2g8GMEgMlLHfgDkYEcKjvIMyt7q3jajQto/ex2xt0UCu9bbTCCkVqcbpxTMxI
	 2Jzj4nqajmtSU4/iZO0BLxFvFVfJn21vL2G/HmIjnen7IpJrrKm3erOqUNCvK3Kneuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0rGY87WSMeqIniZ0chh7w7v0+4/IebEfkiT7jX49kSY=;
	b=zIFn0HXP0iEf3+v84iibxgzHLSgs3reGy90qdeyZzLZlAluAA7a94E8s02Af6ZaIX3nV
	 Xul7gEbcUjqmdOAEZMTyBP5Ifas+sq87qyexQiNTRuGcVhh8xhAS+KMrcjW+Q92JtM9uf
	 N7XGiHAlH6JeUNC2O3EvbNnG21QJnA79vHDxXUsLHwUbPDna1Rn8LiKkwbI7fuJVRlCEB
	 Udn+LI1tOmCPvGcZ+wqgEAw0+3o/fNQe10UO+gHxFybVS2qOCM/Zn56KlBoyXy3hxdQaE
	 pPC2dMuv0lGPHkMeIse90nesi+WfcsBMo5PXrEqivmXHzx4YHzqCVVzZ0eC3agOtofg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9OBaYTU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BA3606A325;
	Wed, 18 Nov 2026 21:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9OBaYTU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074571F000C4;
	Wed, 18 Nov 2026 21:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038937;
	bh=0rGY87WSMeqIniZ0chh7w7v0+4/IebEfkiT7jX49kSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9OBaYTUcEZypsYrOe1HSyqcbXHiE3yqoD8IXsT8E2yVWgzxoWa+mUb1PPCMMtx9O
	 2lTtyMARlYr2HD0+SXJnjQ5q+/sjOT90apjfK1VL5dA+rfATbJHIocOZUjN+7UHPbQ
	 836BEK0U7oOC9Pb1imVLdyba+EgxijghiDqGpeKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Edvard Conrad <edvard@tuta.io>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1880/3318] ovl: inherit FMODE_NONOTIFY when opening directory realfiles
Date: Wed, 18 Nov 2026 15:41:42 +0100
Message-ID: <20261118150418.385215108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 323899b4ed233d5b6e2fc160c16fbf39cf0317da ]

When fanotify hands a listener an fd for a permission event on an
overlay directory, ovl_dir_open_realfile() opens the real directory via
dentry_open(), not backing_file_open(), so the lower open could still
raise FS_OPEN_PERM and deadlock a listener that also marks the backing
filesystem.

Export dentry_open_nonotify() and call it from ovl_path_open_realfile()
when the overlay user file must not generate events.  Ordinary
ovl_path_open() callers are unchanged.

Reported-by: Christian Brauner (Amutable) <brauner@kernel.org>
Closes: https://lore.kernel.org/all/20261030-welpen-anbinden-nullen-b2432cee1d10@brauner/
Fixes: 130fdbc3d1f99 ("ovl: pass correct flags for opening real directory")
Cc: stable@vger.kernel.org
Tested-by: Edvard Conrad <edvard@tuta.io>
Link: https://lore.kernel.org/ltp/P5Iny41--F-9@tuta.io/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: Replaced dentry_open_nonotify() with __FMODE_NONOTIFY flags passed through the existing ovl_path_open() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 10 +++++++++-
 fs/overlayfs/util.c    |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 9252e20bdab8b..ed79c2ad3593e 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -855,9 +855,17 @@ static struct file *ovl_dir_open_realfile(const struct file *file,
 {
 	struct file *res;
 	const struct cred *old_cred;
+	int flags = O_RDONLY | (file->f_flags & O_LARGEFILE);
+
+	/*
+	 * Inherit FMODE_NONOTIFY from a fanotify permission fd so a listener
+	 * that also watches the real filesystem does not deadlock.
+	 */
+	if (file->f_mode & FMODE_NONOTIFY)
+		flags |= __FMODE_NONOTIFY;
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
-	res = ovl_path_open(realpath, O_RDONLY | (file->f_flags & O_LARGEFILE));
+	res = ovl_path_open(realpath, flags);
 	revert_creds(old_cred);
 
 	return res;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0da1cd01d01cf..0a40a4950e9f6 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -586,7 +586,7 @@ struct file *ovl_path_open(const struct path *path, int flags)
 	struct mnt_idmap *real_idmap = mnt_idmap(path->mnt);
 	int err, acc_mode;
 
-	if (flags & ~(O_ACCMODE | O_LARGEFILE))
+	if (flags & ~(O_ACCMODE | O_LARGEFILE | __FMODE_NONOTIFY))
 		BUG();
 
 	switch (flags & O_ACCMODE) {
-- 
2.53.0



