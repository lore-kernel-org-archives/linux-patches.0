Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831548;
	b=x3s5Vx5NE7nbupXSKxmUUoz1ZaBYdKVjIynQI5so1+mI1JfrLiQaQLz7QcmSC4WtJsHB
	 oAZOSw/TwgllbRZGhQsFF1gc4ddhtRPboqrTLds5OVrDLr4JEBTAKydQ3KWFfYG5+HYMe
	 hGx6a8Vg28lvKEJUqYq+45xzlIlF6Z3zbn2DN94Ku8shsbP0wdkT1Q04yeP73wqPTOfr+
	 LlCQswlOuz5OFTGp6ReoAAGF0ZGuq8sVJ8o025pj6zKnHW/UWXEBPkF/e/oL0KSzbkO/O
	 lf2ItUdXMrUQQ65JxCkmL4nILRWkk6cevFCOG5P5alQh1RMA2OkM9hC7lpKF1NNfZkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IkAFR7STfNIJPKjkASftk05R8m8vd1fCi3m83M3HXu0=;
	b=QBQt7OLRD3wSUqVMnt1Hd45hfa7XXfgtn4gaUP5pUJsGp1Q9MnEI+b/OPEcnNs2ljMOO
	 fR0LxrW099Ouu/D6TcV8drmSIdlqkutdQ9WUh7UqmMoNRhsDOwq1buetTSZARwA2GBEv+
	 gNRasW2FrlH5BLSfJ51et96BycuJ9N9tYwUpkrWMNt8ykGtx69f6+gYsGoKDbh3srjf/e
	 mUz7bv5tzIjvB3ldGDGZMgq3zLZC8TbqzzuV5IVknYx9kONN5swLOgB9EAlBmQCD8cs9X
	 xBJ6EvTsvClxrq/lwDG9Bf7Op6SrH+lezdG9z+/2L1xQD6Sz+8sJLw3OB7YwZOVGhEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSoFEZCl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F333606A85E;
	Wed,  4 Nov 2026 22:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSoFEZCl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE4C1F00919;
	Wed,  4 Nov 2026 22:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831548;
	bh=IkAFR7STfNIJPKjkASftk05R8m8vd1fCi3m83M3HXu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSoFEZCly92CttzxcWuddgiK5JPyla4Ob+CS4G+qXeb/LclnX/i99JqaLhnHTrA8r
	 tcporiANa94B7hgm/q+rYaLpqVzhbsahfHqcUqqJ7Amza/hjxglUSlGUOB3DArTV5b
	 vuvWPtZlltO6BZhoIztjBvVeG0qXMifZFLWjQXrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.18 0772/1005] ovl: skip copy up of empty security.capability
Date: Wed,  4 Nov 2026 16:08:25 -0500
Message-ID: <20261104211105.007764106@linuxfoundation.org>
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
 


