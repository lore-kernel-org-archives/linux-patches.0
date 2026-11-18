Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054323;
	b=dyURxrpj2IagtU6QswDkaNS+xLoU9ClEC5VqJWFPU7Z+udxBtDam4yaimHdFMUDcqUzq
	 RsPKvYCAPPRBBOChcAfvB7Gpf6saoS4kenLqJUGEr2Gr1yu1Nr+qt0IDlRguvq4VfzaYU
	 4k9dt7TFgahOyXilvlT8boLXVpDgGHrFDT1h72YBMe0VrPSBdZQt5U4vsTlzax/p9Egsz
	 /TFx8IgRbVQaysaGIFXTD1eFAbXycLMyplMHiY5158EPzfOPbBv7EuwsLeF/4KmVHpZt5
	 6ajDGu5+ZW5nrboivXCqWishgwHmXpHaGwLyKDNFclZh8opV1soltAHnXEvA9aGtoRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SY4/XtzwqPRCGZmlmvjbipkzKszV3EY32d2FTu1d1GY=;
	b=hSLXvrzVLMew0mYOJQuSgy3vkt4mQHIc4xtSw36gY+3LQhaLkJWmZWx/78Mw711PTQ4u
	 DlH/ViWomTOUmzd1LmBN39ssEdmMgg5aggvJUL/LWSwAL8d/HZaYxn0xSwDzUwTHhKa2R
	 7BQTPXB3azxabP7dxoTL8M9ebEjgGFtpIgk+YiZVkCqEoITQkOuHtCB/LqyYf9kxQaSh+
	 Wf8mDllWHOmqjp26hOvqcGC7T8rcl6fkJmQ+p9um99yWtfzk2oZJVlBEEk4jUhKwsGRZf
	 Lo6/rlHwifJEHaMzgokeij+Z1JLWDOLliBiu+uAEa2hmly4ycDmHWsccHmhXwb3AINQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eo/eA9i0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AFE606A31C;
	Thu, 19 Nov 2026 02:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eo/eA9i0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3681F000C4;
	Thu, 19 Nov 2026 02:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054323;
	bh=SY4/XtzwqPRCGZmlmvjbipkzKszV3EY32d2FTu1d1GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eo/eA9i00Bvza3wxq/errFduYNGdeQDbhPL6P13BLlFVs5INoAExKvPZNBGHy4uV0
	 gZJozQGQb1+vlCCwRHasVVWfxqPy3AhZhqnKh+mveggqpBXFs+KvZWOOGhiBkdqhiC
	 6Yxrkohggepe6CUiXu7hSJWwHpnIhBUYV8bEopTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Edvard Conrad <edvard@tuta.io>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1233/2214] ovl: inherit FMODE_NONOTIFY when opening directory realfiles
Date: Wed, 18 Nov 2026 15:48:29 +0100
Message-ID: <20261118150101.069586615@linuxfoundation.org>
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
[ sashal: passed __FMODE_NONOTIFY through the existing ovl_path_open() instead of calling dentry_open_nonotify() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 10 +++++++++-
 fs/overlayfs/util.c    |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 896bc521bcdc3..eef6c5d1b1f8b 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -850,9 +850,17 @@ static struct file *ovl_dir_open_realfile(const struct file *file,
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
index 06c26f061e675..4aac752a118b1 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -502,7 +502,7 @@ struct file *ovl_path_open(struct path *path, int flags)
 	struct inode *inode = d_inode(path->dentry);
 	int err, acc_mode;
 
-	if (flags & ~(O_ACCMODE | O_LARGEFILE))
+	if (flags & ~(O_ACCMODE | O_LARGEFILE | __FMODE_NONOTIFY))
 		BUG();
 
 	switch (flags & O_ACCMODE) {
-- 
2.53.0



