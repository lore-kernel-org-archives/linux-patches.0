Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061607;
	b=4B2H4UTD6nYsaVPZrPVyibe37sbl/KOoCvKlL8alzQhTudGTGd1w21vQNBPzmd9gULKT
	 A0R/BeSBIqQbkXdk0POidQYHyaZHuYBblEWbiuKurCMwuOOl1tJGBLbmDnF6hT3lnBUYH
	 sR5HGpvqrqIt05bi6+sRRrI7It4ddvAWpXA7YoNMhwyC1an/1CCFl3VOLmpbSRG8E0VOS
	 lUjEfztcE0qU8rk69L/oXbkt/eYOVy3SjsHT5xfuDPZuIb1LYvsMoi4kjgPgCBHO//C/J
	 v5fQX5eZvwEjHYNcPzvcY7ROd2GPfDfgZGgCKmalm0Mo1tZ5y8VLIwaJTK7RnC6e+zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EgT5t2RiGAZ0OGTde2pB7FZ9McKD+bR34iv5UGPIGoI=;
	b=HjjMXVShFPLASuMfutF9ZPLCqAjqDfikvivPRcoWd/s/Vb0VtgGexV0uSWsjHZq4njnC
	 bsHDD5yJzzVhxMFDrKy/8CJuBAnJ857cZexPLfeP6szOlAYAncrJlze5Q3L4HLYCgB35G
	 bMsW8OEGlmUI86AIsddo9qZ3ml9czDNic7EvCXAOeV9rSTw7TcUibnwRQ1FJYVd6ZKizh
	 7Lf52CajlHLnIgvFSxM/9AbsZsjSxP2OXsXat5azdAJnEgyPWpihs4fLOidTggoWNOx8P
	 Tzd7A/9fi23e7W5V38W9UDixr3W8U+cYP5reKMuYBXjm1J2azj8hk6pgH5Denam8DxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywexLTnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6176E606A32D;
	Sat,  7 Nov 2026 14:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywexLTnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3CA1F0089F;
	Sat,  7 Nov 2026 14:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061607;
	bh=EgT5t2RiGAZ0OGTde2pB7FZ9McKD+bR34iv5UGPIGoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywexLTnNXJhAgFddiic+0BgLNYPZv2owmkAqsAcT5qD/601atX58MViIIsUOhW7bg
	 e0XGisBJzb3QhFa+KcnFt7EW9TqJlH8fbHLrhc3ndDWGjy6aJTOw21flUjyoJxMW99
	 xzVSkbvTH2dckwG/EQaLKGkARsfdvk/iGDjzN7fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 0679/1536] ovl: use the pinned upper dir in ovl_fix_origin()
Date: Sat,  7 Nov 2026 08:44:55 -0500
Message-ID: <20261107135016.555525387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -910,8 +910,10 @@ static int ovl_fix_origin(struct ovl_fs
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
@@ -539,6 +539,12 @@ int ovl_check_setxattr(struct ovl_fs *of
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


