Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061617;
	b=lBlxCZlaR3tAzsR3B6s1clRBMjmxRvHPcy5y9kTR1JDtvkkwzY1+DiiJYwjiW/hX+a7A
	 imMFEAwCAvtFJJaIl4Jr/YimpgBRGH3ihWX5D9TIsySwVuqut/HHSzvDBfrTW7H9w+thJ
	 lMGeJVV9t/fuWVDf8N5lEllYdwH5xQzx5QM3bEtRRmD2yptYoU+csX3nxR1VGMZZ4eMiO
	 8SOqqyj/Zs5xf4LMgjpTBQHt3WcLLMYTEGBADNKxHRNQ5KKXh8hWRP0k3TmKPivJisOCR
	 slvgmYE0szASn+LP62Pyzjl8MY9pOpwmGh0bLfkeq39fAJKF0F9PYw0gGPwSjf7aakw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z7NJ7RTt047sOp+LcdAByZk/MxdCyD8cX3rtdCVZ5iY=;
	b=UyvVs2fSz0XTMQXCwvmglNUvOfmktTsymr8lCHb1ZaCjWfPrqYi/DUQRWfnYvOA91l5n
	 ppRcrdbkJIcwVR2b/kihx4M0HQLLdy/HNQSyraRqIELvMzJ9l8Uc3uYLW6pcTvrALKh+0
	 aGKheUA7oVfm5OHvwivAAXzcTsT/lTkkBk8KfHKXsqae/3qhhvvZfits/OwEjubwlEadF
	 bjDX0NS31tWH7QjrNuldhea2c3NWyedfXAjzZNOb1G7pY75bIafkiGwSG9DlQrA6QG3PX
	 gJsT2aNoBvestPI1cNTC5G3DtU6gJ5BEbKqsQ3Dj+1D1WnKPx12ObuqlD5fiEz4fagQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EoGbhYDl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E45606A326;
	Sat,  7 Nov 2026 14:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EoGbhYDl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2091F0089F;
	Sat,  7 Nov 2026 14:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061617;
	bh=Z7NJ7RTt047sOp+LcdAByZk/MxdCyD8cX3rtdCVZ5iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EoGbhYDly7WOiW6Cm3bx1yNuuRnw8SH6dx3sc0elS5g2GRC85SGr6b2RqYwXtMvqO
	 ZFmLuPDlu17/O1T3/2NqemUA02wUt+4fM8WbqPBnMnGl/eLCn+xrFhprAPVTCIpKsg
	 T0Au70tTxBvr8tG+59cTLdBO6iGtU6pDv8ATGxm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 0686/1536] ovl: skip copy up of empty security.capability
Date: Sat,  7 Nov 2026 08:45:02 -0500
Message-ID: <20261107135016.757481474@linuxfoundation.org>
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

From: Amir Goldstein <amir73il@gmail.com>

commit 50912a1715b8a7c614b654011a0db750e372b43e upstream.

ovl_copy_xattr() gives up if it can't read an attribute that
listxattr() has named.  An empty security.capability, which anybody has
been able to store on any file for a long time, is such a case: it is
listed, and getxattr() has nothing to return for it.  A file in a lower
layer that carries one can't be copied up: it can't be written to,
renamed or have its mode changed.

There is nothing to copy if there are no data.  Go on with the next
one.

Fixes: 8db6c34f1dbc ("Introduce v3 namespaced file capabilities")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: treat -EINVAL as no capability too, and do the same in
 ovl_copy_up_meta_inode_data()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/copy_up.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -75,6 +75,15 @@ static int ovl_copy_acl(struct ovl_fs *o
 static ssize_t ovl_getxattr_value(const struct path *path, char *name,
 				  char **value, ssize_t *value_size);
 
+/*
+ * Any user can store an empty security.capability, which fails to read with
+ * -EINVAL.  It grants no capability, so treat it as none, like no xattr.
+ */
+static bool ovl_no_fscap(ssize_t err)
+{
+	return err == -ENODATA || err == -EOPNOTSUPP || err == -EINVAL;
+}
+
 int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct dentry *new)
 {
 	struct dentry *old = oldpath->dentry;
@@ -134,6 +143,10 @@ int ovl_copy_xattr(struct super_block *s
 
 		size = ovl_getxattr_value(oldpath, name, &value, &value_size);
 		if (size < 0) {
+			if (!strcmp(name, XATTR_NAME_CAPS) && ovl_no_fscap(size)) {
+				error = 0;
+				continue;
+			}
 			error = size;
 			break;
 		}
@@ -1115,9 +1128,9 @@ static int ovl_copy_up_meta_inode_data(s
 	if (c->stat.size) {
 		err = cap_size = ovl_getxattr_value(&upperpath, XATTR_NAME_CAPS,
 						    &capability, &cap_size);
-		if (cap_size == -ENODATA || cap_size == -EOPNOTSUPP)
+		if (ovl_no_fscap(cap_size))
 			cap_size = 0;
-		if (cap_size < 0)
+		else if (cap_size < 0)
 			goto out;
 	}
 


