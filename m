Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623376;
	b=NvP8/nW6zv1acFpMkkQ7DxzMGtPOmBOebq0Y45lFm3jmQ8xDwfTa8MEKoID82WXnw9SL
	 0aqc9jbFamOW5mxppKHWQrmLbkbO7oUOEvSlYnLzj6A9qsd17Uu9WUEO/OtQRnio9cYuA
	 4Zdf2Kug05ZjpUBeuPe3StPxp/QdQyjtBHw2O0pMAl59fjPp/HA2PQddxaS+64vB3udGf
	 w0x9ptPukaTl2kjwtyu17502/HXz38qPqYUxXpO1zv8ScsFd/NJpGj47C8yQwrTWGrRhK
	 Nu8nU01Exqnu+/soAi3cjiZf9qVSSK8eXRYPtr3zXMgZMIwqNIFNQtVBSKM1TSwNCmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9JNnpxJqiAMm8+VtUnzOlJUKeKxnpgT+4QtPh0RKNiE=;
	b=H0iVFXENoaW2sH3DJaMdYlSJRYOlZnFznBhGDMxHscTUdrLei+f2k2kMhQB5wXl2r54t
	 W64SLnJGjpx7R/kAYQnE8UfBN9DLE5hUa/UqXbXKiAQy9u5b11Iqo7e9+TsYnXux/DHyP
	 A//EtwqKykJQ1kmOLy7MULNRKyA9Nj8fWqKolv11jq02KDqWL8yB0aPdSjgoxguye0dX5
	 pQybs4iYWz7aJGHtalNkjS/auIKPGzIK6emA4zT7vzvi/GD5B4hPAmeFLk72hdkn3xwHS
	 /4U14ffOBVVfEmWeckpY9ICrLYe93WxnaFcNl8ie4XiNdmTz0AtPBKgAlbneO6Ci4BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="loJ/tCy8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6CD606A31E;
	Wed, 25 Nov 2026 16:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loJ/tCy8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CF11F000C6;
	Wed, 25 Nov 2026 16:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623376;
	bh=9JNnpxJqiAMm8+VtUnzOlJUKeKxnpgT+4QtPh0RKNiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=loJ/tCy8vI7v26ZzeTCR26LjcuS/XBzyI9AWo8TmOv0kCk3YqwrzjY2b8SRHbvwpH
	 6fwqVNuHDZS820hapmxhF9hdcTWiYO1RrxV8VvEyy8efOavK1HO6CRR58W9j4wnOTa
	 3Q1dfxoKVuON+h8n9gy17MjOMDY/YbjtuiyE4ing=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 832/990] ovl: reject different lower idmaps on the same fs
Date: Wed, 25 Nov 2026 15:36:39 +0100
Message-ID: <20261125143841.524141034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 720f40c05b2785406121da0151543751204f2953 upstream.

Overayfs mounted with index=on or nfs_export=on require file handle
support from backing filesystems.

Overlay file handles identify a backing filesystem, but not the lower
mount used to decode it. If lower layers share a superblock and use
different idmaps, a handle can decode through the wrong layer.

Record the first idmap on a private lower clone for each backing
filesystem. Fail if another clone has a different idmap. Comparing
the private clones prevents mount_setattr() from changing the checked
state. Distinct idmap objects are treated as ambiguous.

Fixes: bc70682a497c ("ovl: support idmapped layers")
Suggested-by: Christian Brauner <brauner@kernel.org>
Link: Link: https://lore.kernel.org/all/20260925-server-hager-riskieren-06116eded213@brauner/
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/ovl_entry.h |    2 ++
 fs/overlayfs/super.c     |   23 +++++++++++++++++++++++
 2 files changed, 25 insertions(+)

--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -24,6 +24,8 @@ struct ovl_config {
 struct ovl_sb {
 	struct super_block *sb;
 	dev_t pseudo_dev;
+	/* Idmap of the first lower layer on this fs */
+	const struct mnt_idmap *lower_idmap;
 	/* Unusable (conflicting) uuid */
 	bool bad_uuid;
 	/* Used as a lower layer (but maybe also as upper) */
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1125,6 +1125,29 @@ static int ovl_get_layers(struct super_b
 		}
 
 		/*
+		 * Lower file handles identify the lower fs, but not the layer,
+		 * so with different idmaps on the same lower fs, index and
+		 * nfs_export may decode a file handle through a layer with the
+		 * wrong idmap.  Following copy up origin without index is only
+		 * used for st_ino, which does not depend on the idmap.
+		 */
+		if (i < nr_merged_lower &&
+		    (ofs->config.index || ofs->config.nfs_export)) {
+			const struct mnt_idmap *idmap = mnt_idmap(mnt);
+			struct ovl_sb *fs = &ofs->fs[fsid];
+
+			if (!fs->lower_idmap) {
+				fs->lower_idmap = idmap;
+			} else if (fs->lower_idmap != idmap) {
+				pr_err("lower layer '%pd2' conflicts with idmap of another lower layer on the same fs, mount with '-o index=off,nfs_export=off' to override.\n",
+				       l->path.dentry);
+				iput(trap);
+				kern_unmount(mnt);
+				return -EINVAL;
+			}
+		}
+
+		/*
 		 * Make lower layers R/O.  That way fchmod/fchown on lower file
 		 * will fail instead of modifying lower fs.
 		 */


