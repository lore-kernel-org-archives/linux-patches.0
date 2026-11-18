Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035232;
	b=SQTXvVm69TRMYU0b60S2juzF+7vOVdtmmu/crG7lJzJbEDr6VnykpZkcsTKZv6NVmCE9
	 HKHyjhzy/15RTj4HS2Cv149oZuVvgXBvq8xFs4yoc4CXySXnNzyQchMthAUxfUkvhP6Eq
	 VIl/dfKSWc0qZqCvxiKHSTP+pGZsIt+XLj/6yy4QHEztUyTPHXy/MqQdQsbrCpnFC/cJ8
	 i3job6j6dWkKF5DWp4SwR3hGgvQDwxnPpEoc2YVmHvISNUtjc6STu5s9kCA5fe9Uq40iE
	 cmTQqFPShNFN5kfYv34CJWV2BAlzvF/0Ycdw5/pVCqL4JRyfiKXddB1SrOsruw1l/sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kBknCfaXG7ze9xzx/+D2J+aWrK8SS/DckSIhRfflnXs=;
	b=qFBhSchYSW9awc16DUGd/pcXYrbXjwUD91B9uRT/uarl88Lj/u2gN3nMfiOuevnxN2sw
	 +ec6gCZSCi8br50fpaGqyj5VkQDcjJJSCJlmAj+SBGMFWJdZRxfT2tgw5C14Bxyue2aC6
	 N6v3mS4qH4ME3R9BY5PFSGhQgbA9vFwkB8p4Uzyn9an+yeJ/tSSdxxvjwuP6pZSCQndsR
	 mKoGiFeEnxd/kve23RP1RImd6r6OcZ+ArLPBH4Jrna+uxi0IW1jqyaiBWtP9ui7Q0bODt
	 vUCn4qXSBDNon84k3o7rxz3JgFgfPKT+vWx/a4hauviBNQ6J32rt/DygceVeB40nLVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GtKfjuxz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9138860A260E;
	Wed, 18 Nov 2026 20:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GtKfjuxz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACE31F000C9;
	Wed, 18 Nov 2026 20:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035232;
	bh=kBknCfaXG7ze9xzx/+D2J+aWrK8SS/DckSIhRfflnXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GtKfjuxzAWcqwjc5uenQs1EB36h6AyGLgn3A55dy0veKrJ/T2J568T2gF3aXdNkDm
	 9sqJqBW6No/5eup7JMp3j6W1P17DUoHWhLZbXsg7VQcqskkbQYF9VfO8SDgRVLPV1h
	 Y2QRa+odTiUnbf82XwanV9b4IEQVYzRB78Dzd2wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.6 0653/3318] ovl: skip copy up of empty security.capability
Date: Wed, 18 Nov 2026 15:21:15 +0100
Message-ID: <20261118150337.616401576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -76,6 +76,15 @@ static int ovl_copy_acl(struct ovl_fs *o
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
@@ -135,6 +144,10 @@ int ovl_copy_xattr(struct super_block *s
 
 		size = ovl_getxattr_value(oldpath, name, &value, &value_size);
 		if (size < 0) {
+			if (!strcmp(name, XATTR_NAME_CAPS) && ovl_no_fscap(size)) {
+				error = 0;
+				continue;
+			}
 			error = size;
 			break;
 		}
@@ -1005,9 +1018,9 @@ static int ovl_copy_up_meta_inode_data(s
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
 


