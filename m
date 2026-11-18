Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047414;
	b=QXPitr3yaQ/b29A2yTUoh63DEw54YIIXftMxSCU28Pv0yrCDD3Lk32FSmu32IFHV+hiO
	 k29tWDlqHr1rGVKuUDk9fey7ktW4XDr116Yg/xN5fZ+Pg0C8JAH8sQR9r18VGhxKdRBlH
	 bbhvTSTMm6Y9WYRW3uMIoDBfsKxWGIh8jNNcF4Mi0sBoC+StSixE+4/buhQFuyV8NSqHd
	 r/D0UjviTKUQqys/h8dk7fK6EJItW5w7t+3+SxZICBZbLgSRWcoRnqZVisixHoKixeZbe
	 sxcDiMTM3yAeyMVuJoEnTtSrMoE+PXklrrJ4GM4EVcFBU541JvShJ45zBvpBV4Sl8+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOgdNYBFDrRZHIWtSiUhERRGo68p2I5Ps3fgkqu9I00=;
	b=Hgb4v4dkR8vAtrKhITsa/Yduw3wbyBOvbT8/Cwy96Pg9AafyGfQIrrUpWcMtUIeS4ZUX
	 GlBM1UaeD7xeq8mq9A2g6Dgf+OyT5H3Lnh03cQWwUC160vAzuCXdPzJetWSEx17YkIO+M
	 1AmOLLuNvZLOKfW46x0lhUMRUCaTIxOyhsRQoWMzMLpGVhbJ2TL+lCMi+ta+FR77nNmP5
	 ugwMQv0GFbMBRbw9nS7dtVMLHCR5BbEDJLz8W39+foIYbfky+MtD0ewTJmnURbwSLgfDO
	 x/aq31T2zQkYLRMklzzTHrgSJQMgxVWAQMRW8vfCRaB43j59dvb7if2WdtPHE7Wr7bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q6WkclbI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E793606A31C;
	Thu, 19 Nov 2026 00:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q6WkclbI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7321F000C4;
	Thu, 19 Nov 2026 00:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047413;
	bh=vOgdNYBFDrRZHIWtSiUhERRGo68p2I5Ps3fgkqu9I00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6WkclbIMYiSUzUHRGHmnwpTapsXyzz8umgA1jVwv005rdy8LRVKEpQRAR9c3kF1+
	 Ek0fcN5dL1Bcdc5fPN+/ZyNwhxKOt1uv2EEoqiJOw8Jl/9scYRY0L0qnxNuCxubPLW
	 zDRNpYDDKNe0M7wWtTvu+y4M1ABkAzSPQIgMEzpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Edvard Conrad <edvard@tuta.io>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1629/2857] ovl: inherit FMODE_NONOTIFY when opening directory realfiles
Date: Wed, 18 Nov 2026 15:44:23 +0100
Message-ID: <20261118150259.996440949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
[ sashal: passed __FMODE_NONOTIFY through ovl_path_open() flags instead of using dentry_open_nonotify() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 10 +++++++++-
 fs/overlayfs/util.c    |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index cd7a81b6da8be..ff3d30a9b3344 100644
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
index 6922d8d705cb3..08ec15773121e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -519,7 +519,7 @@ struct file *ovl_path_open(const struct path *path, int flags)
 	struct user_namespace *real_mnt_userns = mnt_user_ns(path->mnt);
 	int err, acc_mode;
 
-	if (flags & ~(O_ACCMODE | O_LARGEFILE))
+	if (flags & ~(O_ACCMODE | O_LARGEFILE | __FMODE_NONOTIFY))
 		BUG();
 
 	switch (flags & O_ACCMODE) {
-- 
2.53.0



