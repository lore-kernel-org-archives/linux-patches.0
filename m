Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059994;
	b=BUnPBSVEfnOy6+j7c+CLBRpBU/VP1368M8km0nOBkspSo0cGMi5ZqcvbGI3CMOkqSsXi
	 w9oMXxsN1NrU1AuPsY5NWKCnQwN8f+UpaB2g/tC2O2zKwXWrr2lqHuSGfFqvsDtKzUYn1
	 5rTItfX/qVeoOOnfoCNPENW/FSMZcUMYhzoEAmhyzLmgfbhQ4t3jk48aFGIrnrcNMpHCP
	 5qfFWxVNPDQmXPS1dTF+5gLIQ6PTLCFw0xj6IrUCtTSLas1o24egzaRwr50R7Ix5JpjV+
	 AWqITwLxPqmgf2b0k30+ndLcfR3BTZcakWq6cZ5n2rLR2Mm5ML38HswXnkfgKPkvfsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nBywqN1rja6qGvybprP8tVbViqbUAVjuYPaVFzaVebk=;
	b=e7FITOHy+EDBockfaAijecIvObbmcFgCdkidwksXZ8Hh7jyHV7c/KMZh1ch7v4KItdbN
	 szLwnSq3c0WWnVALUlCCHnVZyWDR0/OFVwy9ejMZHY0xL5FR3bFJVr5FC27pSJv7R0x7M
	 UPkjITClE9YJuvnXo4e//SF7Nzy+qeefb7FTocFXsBVtaUUKv4PNG2dKCEft48IAmQnvm
	 8QcBnWeSKJJvUHs5aeFMtfqLyt/rxwdiEPDnx4F65751SuhObQeNv0BkjcFOBtPQo8yH1
	 IuSzChOR6JFcc1T0LD7CbqfMshy98wjlgu0x9JMoUcNaod0oTK2+CpnblcAm3SDw2OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UoTeEPDZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4646D606A325;
	Thu, 19 Nov 2026 03:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UoTeEPDZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8351F000C5;
	Thu, 19 Nov 2026 03:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059993;
	bh=nBywqN1rja6qGvybprP8tVbViqbUAVjuYPaVFzaVebk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UoTeEPDZbaxrD28kQS2yaMvowxp2wucrncjgedRfKqW0wSYjTaSdR7Ez36LoMBtVR
	 Rrm4x8NfBhrM8jqF4Qxxri4M1xrXq+ZXWjVLqStrNVSr0Bsjy7y4E/72cVM2KrSMgm
	 MQ3J9vWl2IccitLD5NWmSY9N/l8JDYt2o8kIGCUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Edvard Conrad <edvard@tuta.io>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1040/1848] ovl: inherit FMODE_NONOTIFY when opening directory realfiles
Date: Wed, 18 Nov 2026 15:51:18 +0100
Message-ID: <20261118150000.883125919@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: passed __FMODE_NONOTIFY through ovl_path_open() flags instead of calling dentry_open_nonotify() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 10 +++++++++-
 fs/overlayfs/util.c    |  2 +-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index abfe17068b7d6..e3ff8828b5a8c 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -845,9 +845,17 @@ static struct file *ovl_dir_open_realfile(const struct file *file,
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
index 26f29a3e5ada0..4146ab82dcda6 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -485,7 +485,7 @@ struct file *ovl_path_open(struct path *path, int flags)
 	struct inode *inode = d_inode(path->dentry);
 	int err, acc_mode;
 
-	if (flags & ~(O_ACCMODE | O_LARGEFILE))
+	if (flags & ~(O_ACCMODE | O_LARGEFILE | __FMODE_NONOTIFY))
 		BUG();
 
 	switch (flags & O_ACCMODE) {
-- 
2.53.0



