Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053002;
	b=TDM+XgqJKnT4VP1kLl+cC1tJWCx5UCtMnS1FJ92D6oAoaaEiOXV/WVyMta/gQ0rj22oD
	 ZAgCq1cMu+AQElamDm2pY50+sbafjsL3sVhY+Dh+0lMoezaYklee8rnTOrST9zqVQx6I5
	 XjDnR1IgMXr933wALOoHpRBxn5rkAjZMwDGTEkXh5JOMYDRvSlet7E6WlqLHQ5SAcErq+
	 uzLiF5XVZ3z8mFu3ubYaDkdFQxJxTDsWnTXWTwo9ixIz9tCjZJpfGXe0vev5JzCJ8Dgef
	 8vPdpLTACeio0XwpQr/X3DeUWytDx0ehWmn4JlwHVPRqsWWaeBXZ6ESREdZkLxg5vLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=de/kW9+7TvGg7DDhje89AMRrVaTjqwDqmGMxe8u4j9Y=;
	b=5JT5E+d0ltu1WCP2LvYxor45Tq5uFARpvtWsOdZzgOheiP5kMDmdduP1/gCQraxUC/Nr
	 i4relm1expOL8zZMqg1cXwrJ/uf6qt0BZlhh5Arax+Ha0WJlSufx5xFVBkirVjejhWBBw
	 GyqwHuL0OcTeLfkQOcdhYUyPpL6lvjgnJRauS29MuVBAivLyhCpnvpvaJUbmjAS9pf2Cz
	 CI3cB3/FXYISSk8gatqJyq+ig7IBTakQk16cKUKcJO812Ztz/zMNgwF3AU2W9mj6CG3ca
	 ITZSOhjdOpj/kqHh7kgL31uitPv2PEHmQmeOV8sk/GKIv7K43CLhbpUx3hcIdbIqtCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AKBfittY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282BE606A32C;
	Thu, 19 Nov 2026 01:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AKBfittY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8541F000C4;
	Thu, 19 Nov 2026 01:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053001;
	bh=de/kW9+7TvGg7DDhje89AMRrVaTjqwDqmGMxe8u4j9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKBfittYXgFBO39MCUZxQB9R46WSZWnpaszrO5xzvsf0NHhWJmuVmYxl5sQZm0ZCM
	 qODhBjc84YNHIkWUn8iLcvmLkFXQCCgHa18pCbcbrUZzE39ETCYv3fiUVRwjDQjwol
	 5ljrVasSHCiI2LGwab1r3M1DJjZA/Cuf8dKR08Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0763/2214] ovl: take a snapshot of the name for copy up
Date: Wed, 18 Nov 2026 15:40:39 +0100
Message-ID: <20261118150042.237149612@linuxfoundation.org>
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

[ Upstream commit 65bf000962a33ec9d2488e4e1797b6cf630abcbb ]

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
[ sashal: adapted name snapshot handling to copy-up code with earlier destname initialization and no file-handle cleanup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index dadca83b41a69..24b4e41e939dc 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -791,6 +791,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 {
 	int err;
 	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
+	struct name_snapshot name;
 	bool to_index = false;
 
 	/*
@@ -819,13 +820,23 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
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
@@ -857,6 +868,8 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 out:
 	if (to_index)
 		kfree(c->destname.name);
+	else
+		release_dentry_name_snapshot(&name);
 	return err;
 }
 
@@ -982,7 +995,6 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (parent) {
 		ovl_path_upper(parent, &parentpath);
 		ctx.destdir = parentpath.dentry;
-		ctx.destname = dentry->d_name;
 
 		err = vfs_getattr(&parentpath, &ctx.pstat,
 				  STATX_ATIME | STATX_MTIME,
-- 
2.53.0



