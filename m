Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044720;
	b=aN6LmDg5Ss8yMrFU8JndqL9SiZGBSZ+FMjW7i45V8QZxslLYjXTnKB8XcPQ93ZxyvqyZ
	 RWZGNOh6Eivegbca61IW3tvgv7z5iWWsSe9u9ZVV+GEq0ORuvEeNf+SATAHqvb1EqmqcJ
	 0Uyda8LpJr0ODyiMEPbZDWIo12AsIVIu+u1NpCfmcY8XZ+cr73eS7ITgU7TjIwu2L32vH
	 rzwl7c8TFUZg7et1i+9k7YW8Pq1v2H3Fh+dnqh31I7fSjFQTHNTtPFHuiOz4LWByPdyTn
	 8ie+5A4zn/5eToZU9nqmFU37D/w+2C8JJJsdd2Pa1bLWCltgkPO4IqaaxYeTdkmlmEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1HFgl8bWP6pw05Bge5THHfp7cN2Tl/Z8bbkxxNLNyzg=;
	b=n5ps8UKVenphu0/ZjtkD2eyny+G6Kqu8vN24Tu4sGj5/haLUdA0PkMpxZrJCldSihgAY
	 dIRhX6VuJJnAaSb0lhtclZpHrC7Y4uMzGJwcj4YDS/pP2/K9B2KiYtwbHzw5FGqI9i4gE
	 +FFDykCFLr5V+qRo5u5SXguUm+wqfqJ3V2rd99DGVcBonu8Ad9rmvFzf1DC3yms8WhJKd
	 VxEOD4fN8FbiFPt8YHZIKN/uFSOKNkQEe69L1NZcRXCH+wFdPkumWCAW7cDLdFeccM/3X
	 CwE3t9G7urILaT11ole5HD+K/pYoV6uPXT+cCqyh/KTj/RZtabeDRdZQUoNEj76XHew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4JqB0HU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8516C606A320;
	Wed, 18 Nov 2026 23:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4JqB0HU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE28B1F000C4;
	Wed, 18 Nov 2026 23:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044720;
	bh=1HFgl8bWP6pw05Bge5THHfp7cN2Tl/Z8bbkxxNLNyzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4JqB0HUxo0/MIJ8WhcnTAEUIS2Gcyi/7jrU2s2WVHCMtRYB7G8OwgbXEBDt0W4JC
	 3bCoIWklwXBI303uuJV0g/l96PaYXoPzj2cUivtTZO9/EJAOFMqa8NCBU4cVk0luH6
	 mTI1KBOrvLUjkOWppKA1OC+fJO0sO0bpzWiZ2QLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0666/2857] ovl: take a snapshot of the name for copy up
Date: Wed, 18 Nov 2026 15:28:20 +0100
Message-ID: <20261118150225.535234322@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

commit 65bf000962a33ec9d2488e4e1797b6cf630abcbb upstream.

The copy up of a directory reads a freed dentry name when a lookup
moves the directory at the same time.

A pointer to the name of a dentry is only valid while something stops
a move of the dentry. ovl_do_copy_up() keeps a plain copy of
c->dentry->d_name in c->destname, and ovl_copy_up_start() only keeps
ovl_rename() away. When a lookup finds the same directory under another
name after a change to the lower layer, d_splice_alias() moves the
dentry and frees its external name.

With a delay in ovl_do_copy_up(), a chmod of a lower-only directory with
a 60 byte name raced with a rename of that directory in the lower layer
and a stat of the new name, and KASAN reported a use-after-free in
lookup_noperm_common().

Fix this by using take_dentry_name_snapshot() for c->destname.

Fixes: 829c28be9bb9 ("ovl: use d_splice_alias() in place of d_add() in lookup")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[backport: destname is set in ovl_copy_up_one(), take the snapshot in
 the non-index branch of ovl_do_copy_up() instead]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0f0c02121936e..a873bf4bac814 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -804,6 +804,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 {
 	int err;
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
+	struct name_snapshot name;
 	bool to_index = false;
 
 	/*
@@ -832,13 +833,23 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		/* Disconnected dentry must be copied up to index dir */
 		return -EIO;
 	} else {
+		/*
+		 * ovl_copy_up_start() keeps ovl_rename() away from c->dentry,
+		 * because ovl_rename() calls ovl_copy_up() on source and target
+		 * dentry.  It does not stop d_splice_alias() from moving a
+		 * directory that a lookup found under another name after a
+		 * change to the lower layer.  That move frees an external name,
+		 * so take a snapshot.
+		 */
+		take_dentry_name_snapshot(&name, c->dentry);
+		c->destname = name.name;
 		/*
 		 * Mark parent "impure" because it may now contain non-pure
 		 * upper
 		 */
 		err = ovl_set_impure(c->parent, c->destdir);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
@@ -870,6 +881,8 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 out:
 	if (to_index)
 		kfree(c->destname.name);
+	else
+		release_dentry_name_snapshot(&name);
 	return err;
 }
 
@@ -1005,7 +1018,6 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (parent) {
 		ovl_path_upper(parent, &parentpath);
 		ctx.destdir = parentpath.dentry;
-		ctx.destname = dentry->d_name;
 
 		err = vfs_getattr(&parentpath, &ctx.pstat,
 				  STATX_ATIME | STATX_MTIME,
-- 
2.53.0



