Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044670;
	b=n/sjcsEDiO6Dj8Jo6dYrfnXUJ1jHmRYPR7323KUS0hLUuyAQ10J/fnybTQM4e44eh0kG
	 iz83z18xyTYLqMm+w0eI2NWSxCiIv8HajzDfT5+1fCOIDNsL7DN5Z25CQrH2I12NqVlbR
	 IthYYZRChSOovAKbWVWaCVpl9TUe+k4g3BmitUmIiDazOcs+EGzZrAZlPjn0LTR78xWoc
	 KI8vqSQtXIbu6JAqaAu3AsNkTfYf88+QYWKk2UkJuDN0jNbt6+2v5YW8Xtw+UggBPX/OS
	 KUOTuPPO5i3KIpRtN2JwosXU9YCEBzFU2r7R4JHQHzhR998qlBYWfs+lY/1jlalhmJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AhO9A/UzOftV373os/0/rqJ15XQHDXel2oroaEt78BE=;
	b=RPE+B8cwZZlig6j660mRtdIfsk7oK/OHOU5HVRbvwHaCcXbp95oyU2qz/oK8013fc9vB
	 rroiMQmAgW4gbydORUFPAoZ88I0KbAyb38et2BXc3MsNKrtt/s8rkpD8WN3g500roRme1
	 Ir457HTtOb38Gevz5FwEChHmIhcWRwJO8M1Sbtqhrrw922LoXzQwBp5JtGg6nSE/ZukQv
	 8Z28ojxksv7wbffDFzAxWduX4zyTBiglrKNvqrN4SCyvtjy7L0OOBZUc5mjaNLXEXtgjT
	 +pUZzfi59VTqCHyrb4dWTVD8iq4szyqjyLX8MmAAf5qYGZzURYMAheQ7ZhAXTJHEM9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmmnej5e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D207606A32A;
	Wed, 18 Nov 2026 23:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmmnej5e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA1C1F000C4;
	Wed, 18 Nov 2026 23:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044670;
	bh=AhO9A/UzOftV373os/0/rqJ15XQHDXel2oroaEt78BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmmnej5eKJ8wWHOsQ7MgEYfsCQ0/pLnk1tLk1Kz02AJQFhZDUnbPOACj6oQ2uecMC
	 l5lPaV3W6bQCiJ4FnpJO0sXsJkO/ZHidVMEI+2chhTz1bdzj1KGNqS1wBCuWTV3jMG
	 8xaOhvHKTJnCDdH+UCcvSNWJAG+Ot4R0rJv8nWIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 0650/2857] ovl: fortify ovl_copy_xattr() against underlying layer modifications
Date: Wed, 18 Nov 2026 15:28:04 +0100
Message-ID: <20261118150224.959864006@linuxfoundation.org>
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

commit e6b9117076fb4c0ff4a670efa9c876d9a50d79ab upstream.

Adapt ovl_getxattr_value() to be used from ovl_copy_xattr(), by
allowing to pass it a pre-allocated buffer, which can be resized
and by handling the ENODATA/EOPNOTSUPP return codes in the caller.

This replaces the retry loop in ovl_copy_xattr() with a single retry
after resizing the buffer. If the value changed again by then, the
underlying layer was modified, so return -EIO instead of retrying.

As a side effect, ovl_copy_up_meta_inode_data() now returns -EIO instead
of -ERANGE in this case of underlying xattr size changes.

Reported-by: Fahad Alharbi <fahad@codepure.com>
Tested-by: Fahad Alharbi <fahad@codepure.com>
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Link: https://lore.kernel.org/linux-fsdevel/CAJfpegsVoUyqy0dYkTvBGRZvgdv_nmzmCw_uF+LP-Vq3EhEkSg@mail.gmail.com/
Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
[ backport: context: ovl_must_copy_xattr() instead of ovl_copy_acl(), no
  blank line before the retry: label and no OVL_VERIFIED_DIGEST;
  depends on 755b5c5c9277 ("ovl: do not copy up an xattr value that was
  never read") ]

 fs/overlayfs/copy_up.c |   68 +++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 36 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -44,6 +44,9 @@ static bool ovl_must_copy_xattr(const ch
 	       !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN);
 }
 
+static ssize_t ovl_getxattr_value(const struct path *path, char *name,
+				  char **value, ssize_t *value_size);
+
 int ovl_copy_xattr(struct super_block *sb, const struct path *oldpath, struct dentry *new)
 {
 	struct dentry *old = oldpath->dentry;
@@ -93,34 +96,12 @@ int ovl_copy_xattr(struct super_block *s
 			error = 0;
 			continue; /* Discard */
 		}
-retry:
-		size = ovl_do_getxattr(oldpath, name, value, value_size);
-		if (size == -ERANGE) {
-			size = ovl_do_getxattr(oldpath, name, NULL, 0);
-			/* Nothing was read into value, so it must not be used */
-			if (size >= 0 && size <= value_size)
-				size = -EIO;
-		}
-
+		size = ovl_getxattr_value(oldpath, name, &value, &value_size);
 		if (size < 0) {
 			error = size;
 			break;
 		}
 
-		if (size > value_size) {
-			void *new;
-
-			new = kvmalloc(size, GFP_KERNEL);
-			if (!new) {
-				error = -ENOMEM;
-				break;
-			}
-			kvfree(value);
-			value = new;
-			value_size = size;
-			goto retry;
-		}
-
 		error = ovl_do_setxattr(OVL_FS(sb), new, name, value, size, 0);
 		if (error) {
 			if (error != -EOPNOTSUPP || ovl_must_copy_xattr(name))
@@ -896,26 +877,39 @@ static bool ovl_need_meta_copy_up(struct
 	return true;
 }
 
-static ssize_t ovl_getxattr_value(const struct path *path, char *name, char **value)
+static ssize_t ovl_getxattr_value(const struct path *path, char *name,
+				  char **value, ssize_t *value_size)
 {
 	ssize_t res;
 	char *buf;
 
-	res = ovl_do_getxattr(path, name, NULL, 0);
-	if (res == -ENODATA || res == -EOPNOTSUPP)
-		res = 0;
+	res = ovl_do_getxattr(path, name, *value, *value_size);
+	if (res == -ERANGE) {
+		res = ovl_do_getxattr(path, name, NULL, 0);
+		/* Xattr changed underneath us? */
+		if (res >= 0 && res <= *value_size)
+			return -EIO;
+	}
 
-	if (res > 0) {
-		buf = kzalloc(res, GFP_KERNEL);
+	if (res > *value_size) {
+		buf = kvmalloc(res, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;
 
 		res = ovl_do_getxattr(path, name, buf, res);
-		if (res < 0)
-			kfree(buf);
-		else
-			*value = buf;
+		if (res < 0) {
+			kvfree(buf);
+			/* Xattr changed underneath us? */
+			if (res == -ERANGE)
+				return -EIO;
+			return res;
+		}
+
+		kvfree(*value);
+		*value = buf;
+		*value_size = res;
 	}
+
 	return res;
 }
 
@@ -926,7 +920,7 @@ static int ovl_copy_up_meta_inode_data(s
 	struct path upperpath;
 	int err;
 	char *capability = NULL;
-	ssize_t cap_size;
+	ssize_t cap_size = 0;
 
 	ovl_path_upper(c->dentry, &upperpath);
 	if (WARN_ON(upperpath.dentry == NULL))
@@ -934,7 +928,9 @@ static int ovl_copy_up_meta_inode_data(s
 
 	if (c->stat.size) {
 		err = cap_size = ovl_getxattr_value(&upperpath, XATTR_NAME_CAPS,
-						    &capability);
+						    &capability, &cap_size);
+		if (cap_size == -ENODATA || cap_size == -EOPNOTSUPP)
+			cap_size = 0;
 		if (cap_size < 0)
 			goto out;
 	}
@@ -961,7 +957,7 @@ static int ovl_copy_up_meta_inode_data(s
 
 	ovl_set_upperdata(d_inode(c->dentry));
 out_free:
-	kfree(capability);
+	kvfree(capability);
 out:
 	return err;
 }


