Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831871;
	b=xM9qPzCMCAddqRel+5B5KsLgU/CLFG2kt9LsUd785dFS7klCwaSMfX2xwnGBvoncVMCZ
	 CFpZgLaCcA2IolnOx4RUsAzwWTKmj4iOdjPQjeEKKERjX14BrGknokH6VwQ7XyrqAcyFv
	 zIPA9uI2q1HHKXtozmwRfIkHJxvChLQ3DT72O88lkOAF8+eh/5EafhKGLEMHFnNaFSnSc
	 0UD8H/za1sb215rZyDy3FvGbakCDK/ZH0mKtE/zzyPrIN2X/Dp8xqwfBETiFxGoUWMTuK
	 b9BXBrzt5F7mL7XW11eSGluqgGumT2jBplh+NSTxta2zGPqWn5OQKn7z6/lUiKHfZBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EWefh4luHNv4F2M7D+0Dx+rs6ih7yDoQDR0P5LSl2qw=;
	b=Ob5cjRLHwFmtileaybTgd1D8Q1uIhHKs2XyBBEDq3SNZshhyugRGa5cJLqilwZubNblm
	 at9fjywrqdIFDINnU0Hb8m91UisEjAb1K6bJ413N/z0yoDanRYiiaB35ZtWq+AMrzpJNQ
	 KB9hgi3H4/TsQIs6gUM4FUt/28MZLnRSpbd6NhlYjg8g+1ap2xAbYZP3LI4hpd2INTl7y
	 bshzYvMRzjsUc9fpjrPTx4sxK6x7CXWprxGkOn+FAbR7ifRZBLssk6mPwU6Ax20XdtjOe
	 BYGCZ7elYj99BOygIoIlLpHaouYSVv/tTo7yGF1ILbWZeqY9B7ANW8kSz8vl3T4Duvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Lb8k/pz5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CF6606A326;
	Wed,  4 Nov 2026 22:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lb8k/pz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5941F000C1;
	Wed,  4 Nov 2026 22:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831870;
	bh=EWefh4luHNv4F2M7D+0Dx+rs6ih7yDoQDR0P5LSl2qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lb8k/pz580dsSvqt5k5aA5KnzLUlYGzt9Ng2Jh7t/Vgdxur0O5gHnqz9OI+e6MChK
	 QOvcoEqeCaoixxfOubw7XYFdSyQQmUNbBObmOH6D4ADnpn1E+t8+bArTb6bCM3g5bz
	 2JfRBbus2F1JCYbU8/efPfvE9MC8XcdYpwByTWBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0966/1005] ovl: check that the parents of volatile/dirty are dirs
Date: Wed,  4 Nov 2026 16:11:39 -0500
Message-ID: <20261104211110.130708753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

commit e34d2ef818e4c7676d8d8e1bf43e6a1ed39efb2a upstream.

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
[backport: no ovl_start_creating_upper(), check the child of
 ovl_lookup_upper() in ovl_lookup_or_create() instead]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -624,15 +624,23 @@ cleanup_temp:
 
 static struct dentry *ovl_lookup_or_create(struct ovl_fs *ofs,
 					   struct dentry *parent,
-					   const char *name, umode_t mode)
+					   const char *name, bool is_dir)
 {
 	size_t len = strlen(name);
 	struct dentry *child;
 
 	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
 	child = ovl_lookup_upper(ofs, name, parent, len);
-	if (!IS_ERR(child) && !child->d_inode)
-		child = ovl_create_real(ofs, parent, child, OVL_CATTR(mode));
+	if (!IS_ERR(child)) {
+		if (!child->d_inode) {
+			child = ovl_create_real(ofs, parent, child,
+						OVL_CATTR(is_dir ? S_IFDIR :
+								   S_IFREG));
+		} else if (is_dir && !d_can_lookup(child)) {
+			dput(child);
+			child = ERR_PTR(-ENOTDIR);
+		}
+	}
 	inode_unlock(parent->d_inode);
 	dput(parent);
 
@@ -653,7 +661,7 @@ static int ovl_create_volatile_dirty(str
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}


