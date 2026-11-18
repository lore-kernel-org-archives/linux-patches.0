Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028648;
	b=DlSrDteLE6x2f6iHU7hdAMrqbFaqoIIgU1NSZIYDJQ6zl5stVfvZZCG40n9yKtVesBtt
	 Imgp2Nmo7W8NwhmMMAHVqqDWezKzdo6jxTHinefCZUgh31ynWipktRZKOja2ItegVTdmx
	 WHuYok67twX9xxI6ZjptRAjMLaXXUUI1/cIuL/EVKVtGigDz/V9ClNfOcX4oJxHWIBhZ3
	 Mi6ufpd5rLjty4rp5QqParnljS3+vzMrvQ/kjId842DfPQqWu2AkWs5NfKeBhV7Eh53TP
	 qtV/NR4KiAxs/4IANAa+D+zSToXyam+XVY8II8sCpSzLmb9wOQp8HsUWn9FBTIgbz4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VMFsoPbDD29HGfeHcQSac6SOo0+ZZtzS4AnCIcEHYrU=;
	b=c3O6xj47gS+9zw0tIGnG4WxzxI+Oa2cDRaNs5h8jdeZJ1peB9oKrffj76A6fUDP2CH1a
	 ebrl9zeMjEQe928FmoRUy76dxVyw9i0h5/ebb3r+14F4AU6fG/3piDR0oiwCzGWOHRqKG
	 3msxKESLDHAKfaRrInsATIiVeBssj0zkbO5VywxizTM/8HH7RnTzt+34tKSrA8a9ysB11
	 srobLEqv9mGam2KwpkydLKE3B5MsWO/UEq7OJ3NNEML0BI0d04WqFkKiqtDdA5+xOdnhz
	 YfN+OXtQcA8OoYPnivvPpt3043IpnL9G6XW/RRdKKYnyHJZkaDOps4XuuJ0Bg7O8F+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pPuDYjme;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC966606A335;
	Wed, 18 Nov 2026 19:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pPuDYjme
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D2F1F000C5;
	Wed, 18 Nov 2026 19:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028648;
	bh=VMFsoPbDD29HGfeHcQSac6SOo0+ZZtzS4AnCIcEHYrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pPuDYjme44VJClllgso0dzTv2UEJ4mvF2RHW2ZLHTJWxdk9X5O3Kz6MmRLwyAMmd0
	 oHkVdSPkECY2EGvxnaOQNdC7LHm/78sHdhHIgZv0BdjW4JlOpDVKNXYgGHokO87Pmg
	 Y/LYYVbR+Iw6sGLGtjPpVQqzeGRqvttiuAkAy5XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Edvard Conrad <edvard@tuta.io>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0027/1756] ovl: inherit FMODE_NONOTIFY when opening directory realfiles
Date: Wed, 18 Nov 2026 15:35:54 +0100
Message-ID: <20261118150008.962551007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced dentry_open_nonotify() with dentry_open() using __FMODE_NONOTIFY. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 10 +++++++++-
 fs/overlayfs/util.c    |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 5d912f887aac7..843c3d5168f4e 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -869,9 +869,17 @@ static struct file *ovl_dir_open_realfile(const struct file *file,
 {
 	struct file *res;
 	const struct cred *old_cred;
+	int flags = O_RDONLY | (file->f_flags & O_LARGEFILE);
+
+	/*
+	 * Inherit FMODE_NONOTIFY from a fanotify permission fd so a listener
+	 * that also watches the real filesystem does not deadlock.
+	 */
+	if (FMODE_FSNOTIFY_NONE(file->f_mode))
+		flags |= __FMODE_NONOTIFY;
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
-	res = ovl_path_open(realpath, O_RDONLY | (file->f_flags & O_LARGEFILE));
+	res = ovl_path_open(realpath, flags);
 	revert_creds(old_cred);
 
 	return res;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 723672073b1e3..4c0881f0b75e0 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -652,7 +652,7 @@ struct file *ovl_path_open(const struct path *path, int flags)
 	struct mnt_idmap *real_idmap = mnt_idmap(path->mnt);
 	int err, acc_mode;
 
-	if (flags & ~(O_ACCMODE | O_LARGEFILE))
+	if (flags & ~(O_ACCMODE | O_LARGEFILE | __FMODE_NONOTIFY))
 		BUG();
 
 	switch (flags & O_ACCMODE) {
-- 
2.53.0



