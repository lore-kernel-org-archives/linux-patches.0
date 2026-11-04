Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831599;
	b=n66CeKcy9hyjpz/SRoseLFycvmVSri/eMho+WOE/3xizOY/Vqa7fCQlNVgEy2Gf8OnWK
	 b6a8tnjDG7Y+qL0SED0xrZxCXJx58m79K0RdWsb6RjmdgfuPiGvLFGWBkoU7qNgNuv59c
	 jUM+F/JPW2ygCOWubaI1207mhJzqHQ1H2dZfE9X+XT3cb4jhAkzGjT4awPqwU73IhexAg
	 jEQr9//yoZ41ipFn4q379C7dxb8Tw1AeUV2Xl/atESWIWUkWqwJqNq6muPOqFXLG+UXDa
	 L5zfyXdLOpKZjbgSYqB9SRApfjESZ8JghUtmlQFkJkClzaW9Q8Nco7OvB3X+9tjaA0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=72YjejlMuWhG+qYz0isEl3D+zIA0bqmAEGQhjycr1iw=;
	b=0GtnuQtGtoogDENfoefkY441sz5EU8DRfu9rGQMyTTzM6dHv33oruRhnFPiFyzZg/FpS
	 gqoypBwur+6qsfU75kLwNFvOT7TKFyZinQ0TkyltTzmf9cdz/l5IVrlCAJL/+kNTBVLGT
	 qdQeX/5dph3i6SogjrGZCajdt1wAKrYl1W8AMenRe5DouErluq/Wy0FTv5qVVZ9X9wa2/
	 f45H/XrJgVenMg0QHvvyvzKUZdPSOruXH8qo4sK8jqpKFWZ3JRCKza2iHUoDjpnmtlxuY
	 cYkFg08AZQIT2l+2mFilnEBz2dpFdANlS+3dM3bjB0DZuOOXFyXyEMTFRye0jfLiBXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yruzcGJd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF24606AB3C;
	Wed,  4 Nov 2026 22:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yruzcGJd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08E131F00919;
	Wed,  4 Nov 2026 22:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831599;
	bh=72YjejlMuWhG+qYz0isEl3D+zIA0bqmAEGQhjycr1iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yruzcGJdmJWfi5OGBev4M74p8hMLsNbRHCDzKQI9oE7yg0sG72GOPnyhJmHyUcEu7
	 ibKLA3p2N8bAGIgEhgom+o4mOlQMHs3CG6LQLxK0KB/Pg0/tbEK7o+6MgnSJ4qD0S/
	 kYfPfn4BAiqPFHfsJ+4HXcbq0mC52HjjTJNLkrwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0763/1005] ovl: use the pinned upper dir in ovl_fix_origin()
Date: Wed,  4 Nov 2026 16:08:16 -0500
Message-ID: <20261104211104.792166264@linuxfoundation.org>
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

commit 4f61ff2ebfb3d2967b83b6a4d456242244d5a61f upstream.

Renames made directly on the upper filesystem during a lookup crash the
kernel.

A dentry that is passed to vfs_setxattr() must be pinned.
ovl_fix_origin() passes upper->d_parent to ovl_set_impure() without a
reference, and the lookup holds no lock of the upper directory. A
rename on the upper filesystem changes d_parent, and only the child
pins the new parent, so a second rename and an rmdir free it.

With delays in ovl_fix_origin() and ovl_set_impure(), renaming the upper
directory twice and removing the intermediate parent during the lookup
of a merge directory without an origin xattr gave a KASAN
use-after-free in vfs_setxattr().

Fix this by passing the upper dentry that the overlay parent holds.

Fixes: 9678e6303057 ("ovl: fix inconsistent d_ino for legacy merge dir")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: add helper ovl_set_impure_dir()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/namei.c     |    6 ++++--
 fs/overlayfs/overlayfs.h |    6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -936,8 +936,10 @@ static int ovl_fix_origin(struct ovl_fs
 		goto out;
 
 	err = ovl_set_origin_fh(ofs, fh, upper);
-	if (!err)
-		err = ovl_set_impure(dentry->d_parent, upper->d_parent);
+	if (!err) {
+		/* upper->d_parent is not stable, use the overlay parent */
+		err = ovl_set_impure_dir(dentry->d_parent);
+	}
 
 	ovl_drop_write(dentry);
 out:
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -559,6 +559,12 @@ int ovl_check_setxattr(struct ovl_fs *of
 		       enum ovl_xattr ox, const void *value, size_t size,
 		       int xerr);
 int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
+
+static inline int ovl_set_impure_dir(struct dentry *dentry)
+{
+	return ovl_set_impure(dentry, ovl_dentry_upper(dentry));
+}
+
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
 bool ovl_is_inuse(struct dentry *dentry);


