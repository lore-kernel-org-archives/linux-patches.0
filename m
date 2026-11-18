Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044673;
	b=XlkuF8t1YKiQC0qH/B0c2efhzIl/jIV6xUur4PPVujAe0aYxANKAzgF+pXEUKjsrilG/
	 XCtN3PCwLlyflI37uEiy7vo/vmRseKqmQmRTKqXA3kHANZYakEujo4jKLaeBKKUKOZVJ0
	 6Xff7LXouBGz8Z54w/1hPeBEC0bIH5c9BCxxL2xZ9Waihr28nTobbJtmuYtescC1Tb+2S
	 CidN7gJ3ykcUQDyDPFFEEeUufI0gwoyRHzdhmmOK5dnTNVGaN7vY0wRqAQ+pCl5kkwKU5
	 Y31rqzoqUKG3X77KEj7a0/SbB3tP/jMJ7jRwHagTUOVIQtYlZcnsRQt3q1+06SyevmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLFSIVwWpMqlQM/G5rE40HjoSvFebhoMAwRBYCsFQwc=;
	b=Lck6YjNf6f3Xa65Gzrdow0fGd/LKfRtYY+v4k3rapC3qp4fZlZbZGLr0CqnFmCsUvf6b
	 iX1rBy03zyJGEtzDqQcD7zpZMGQUXmAnCLKgcq9FGO8w83jVg2zp57CMCB0OMZk4n9tyc
	 GVpJyCCeboyJiZT2qL8igKtwSeKwu1DK+5uLp2P/TSKO9OO8z+mdY+ciODi209/9eh9fq
	 gXQpVXSsOm9WYaKu8vXjPdoYgaKFmWkvZtKokA60OyuSsGEoXRCoZPJPG1w1eFyXA/6xW
	 J+5ti6RGMtPAd2hNC29JYoKVYFAXj6MDpHZTm/fThCy1cx9BC8bL7oWIgVhgmr34eCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqPQfaCG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B84E606A31C;
	Wed, 18 Nov 2026 23:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eqPQfaCG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BB41F000C4;
	Wed, 18 Nov 2026 23:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044673;
	bh=eLFSIVwWpMqlQM/G5rE40HjoSvFebhoMAwRBYCsFQwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqPQfaCG8qIZp8KE6TEywoTpsNe4UV1Xasdaf7QTc8nmvnnEeHLo1kaU87ST53drS
	 ohOLr2tcSqedXO9LywalK3LYT+Lvex6C6wvtbbk5U8UVDbhdaz1Yg5E/A6PfB1P9qF
	 yxLksmtvb/JgE6kTq1tSA7S+aTa89o/49TxWISdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 0651/2857] ovl: skip copy up of empty security.capability
Date: Wed, 18 Nov 2026 15:28:05 +0100
Message-ID: <20261118150225.000611316@linuxfoundation.org>
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
[ backport: context: no blank line before the ovl_getxattr_value() call;
  depends on e6b9117076fb ("ovl: fortify ovl_copy_xattr() against
  underlying layer modifications") ]

 fs/overlayfs/copy_up.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -47,6 +47,15 @@ static bool ovl_must_copy_xattr(const ch
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
@@ -98,6 +107,10 @@ int ovl_copy_xattr(struct super_block *s
 		}
 		size = ovl_getxattr_value(oldpath, name, &value, &value_size);
 		if (size < 0) {
+			if (!strcmp(name, XATTR_NAME_CAPS) && ovl_no_fscap(size)) {
+				error = 0;
+				continue;
+			}
 			error = size;
 			break;
 		}
@@ -929,9 +942,9 @@ static int ovl_copy_up_meta_inode_data(s
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
 


