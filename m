Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022497;
	b=iElqONaWlo2sCXheRf25L9gVyB1ScFMguGcbSUJLqFRB+My8K5l1XXfV1I7aFkhQSuiu
	 e0bCZsNXIe7tQdbVcZb/Y91jaRpURFAlw+QQglP1qiVIwGA+5PGDVXQoKwQyjNW7Gmji9
	 rCVv6OHXClo+ix7VCcIdpACbGMOZsxcqZ56buGBtWkvGvpo24u9xYbrj3ebUpdxqgxxt7
	 CVfzvgBsRNl70DAq+UoygSbRthnKu0jgxqCbuL8Gxp629aOfIxg9H0UZy9/RYdDJdYV/N
	 jGB5W/2e0sdHs2z6Enrz1ABRf4DsAnDBtuGvA5l1h5gh2el8OYFyM6O0i6iTevtBbYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=559F1aVwP4Am9Fuyu9IX2hlxv2Wlcwuw7FPND+Mu6U8=;
	b=Bs2+k+Y6TCAfO3V//S+n63agF42vUm7l39hfwjQfkA22mS+anr3bb5s8EjM73626vhYf
	 5g6xJugziCbHdL4cmwHkRwmPYOaEOSxOgCQifAk2ajgtnIgeDfUk29kVcsjGQJHdZzdbu
	 DVKNQaaL5VpZEDCfe0vF5K68Xk6v/GWlD2icTWTBzcBq3T51tBhoGFToxYNMGUgztojTu
	 BnaZ7NiYD+CqloOo8zbUHqAyF1pP0VtjrtPIbChP8TryGepmC2Ugyh6OAcDc/KG9pMtDR
	 jmwgA8aGSRfuJt4wWzM0B+LdhNxBGxA5izz9TEaNun2fU7zrrus3iNlmFs6gHE0v4eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="eEl/5l9W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3140606A325;
	Wed, 18 Nov 2026 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEl/5l9W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7821F000C4;
	Wed, 18 Nov 2026 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022497;
	bh=559F1aVwP4Am9Fuyu9IX2hlxv2Wlcwuw7FPND+Mu6U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEl/5l9WmwANX2ACKeuB9bjV+uqcZDCcy389IMQuTQrzmJOua+DJM78IS26yRYuZ8
	 t6xucIrx9svm9FecY8b7/K/QefArSbF4RNnaNgEPd/74cL4qpGcUK0w4i4O7R4/JKH
	 xZmBGXCeUu/ntKgRDzbZHMdJU9LSO5lK4E5Fog50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Edvard Conrad <edvard@tuta.io>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0033/2151] ovl: inherit FMODE_NONOTIFY when opening directory realfiles
Date: Wed, 18 Nov 2026 15:29:28 +0100
Message-ID: <20261118150122.863315018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/open.c                |  1 +
 fs/overlayfs/overlayfs.h |  9 ++++++++-
 fs/overlayfs/readdir.c   |  3 ++-
 fs/overlayfs/util.c      | 11 ++++++++++-
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 3d64372ecc675..3d5ff8f58d5c9 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -1143,6 +1143,7 @@ struct file *dentry_open_nonotify(const struct path *path, int flags,
 	}
 	return f;
 }
+EXPORT_SYMBOL_GPL(dentry_open_nonotify);
 
 /**
  * dentry_create - Create and open a file
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6268db46483e7..7bd69773f33c9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -524,7 +524,14 @@ void ovl_dir_modified(struct dentry *dentry, bool impurity);
 u64 ovl_inode_version_get(struct inode *inode);
 bool ovl_is_whiteout(struct dentry *dentry);
 bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path);
-struct file *ovl_path_open(const struct path *path, int flags);
+struct file *ovl_path_open_realfile(const struct file *user_file,
+				    const struct path *path, int flags);
+
+static inline struct file *ovl_path_open(const struct path *path, int flags)
+{
+	return ovl_path_open_realfile(NULL, path, flags);
+}
+
 int ovl_copy_up_start(struct dentry *dentry, int flags);
 void ovl_copy_up_end(struct dentry *dentry);
 bool ovl_already_copied_up(struct dentry *dentry, int flags);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 7fa4fecf15360..3c8fe45b06f12 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -960,7 +960,8 @@ static struct file *ovl_dir_open_realfile(const struct file *file,
 					  const struct path *realpath)
 {
 	with_ovl_creds(file_inode(file)->i_sb)
-		return ovl_path_open(realpath, O_RDONLY | (file->f_flags & O_LARGEFILE));
+		return ovl_path_open_realfile(file, realpath,
+					      O_RDONLY | (file->f_flags & O_LARGEFILE));
 }
 
 /*
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 19f4fe7b98f29..f75e8009fb15f 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -659,7 +659,8 @@ bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path)
 		ovl_path_check_xwhiteout_xattr(ofs, path);
 }
 
-struct file *ovl_path_open(const struct path *path, int flags)
+struct file *ovl_path_open_realfile(const struct file *user_file,
+				    const struct path *path, int flags)
 {
 	struct inode *inode = d_inode(path->dentry);
 	struct mnt_idmap *real_idmap = mnt_idmap(path->mnt);
@@ -687,6 +688,14 @@ struct file *ovl_path_open(const struct path *path, int flags)
 	if (inode_owner_or_capable(real_idmap, inode))
 		flags |= O_NOATIME;
 
+	/*
+	 * Directory opens use dentry_open() here, not backing_file_open().
+	 * Inherit FMODE_NONOTIFY from a fanotify permission fd so a listener
+	 * that also watches the real filesystem does not deadlock.
+	 */
+	if (user_file && FMODE_FSNOTIFY_NONE(user_file->f_mode))
+		return dentry_open_nonotify(path, flags, current_cred());
+
 	return dentry_open(path, flags, current_cred());
 }
 
-- 
2.53.0



