Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044907;
	b=vEFv7w5sSLnC2Rk8dvo4cCxUFCoXc1gTsoBQUw/53df89T/WAR6P8fH0G0UW8YhBDKrA
	 84WNEc1XXD/qwHD8Tp83KT+5WGIJQqXQxtJdOv3slJENGueR4gtop08hLxxPaZKIXL/AI
	 aQabUV9s/uR0PC8hjKiPr5PKdMM8Vc5jeCrrQS01NSpiVrCqfrbnAMBlslpdkzFUf3SIe
	 4VYL/ncqAM8YSxgvy7G5QllgJeVmPhsqE4cUGXgIs2COPA5yE08xH+FJOjiRc5xjYBPU5
	 m8A3NFsnhEovo1FBP5wvKj48XM0sWyZrowMWpTGjVrXO/a88FhZ510fhGEpQRjJ/Ykw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Euzo4TNn+9fWGhMEcP0y8B4Zm7JK4Xe0Z8dMauKmN6I=;
	b=XbO1bq18xwRTaJOB29KY+szwoXI6doyKx/ATt3Nn5YgeiWgvHu0lGwbDK3yVbIGE1Vku
	 yZBlFK14RiTU+lZLzxr0gh5kf9qSIFMlCXTveJJGoBzOnOR4gXWLYyrQrvuNemfNOSuZe
	 P7GdKiVwQVCE62sFcXtyqaxyG2eVpYoPFGgErfnKUrPgcnxse+NLYG3F1dnba08aAhpHN
	 nP6/4J5MFkRYtz1hgCreA4d+LiWiqoyKsKAMlCGEVrvqOxt1QA+bUtPBhfla0GNqXhVA1
	 K158oIpMj9a26DcbqQq5EwWpD1VIHDcoXvBDQwas5jDQn1T1QwadO6dIqEaGt7C0pUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHNkp48Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A14606A337;
	Wed, 18 Nov 2026 23:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHNkp48Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746D11F000C4;
	Wed, 18 Nov 2026 23:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044907;
	bh=Euzo4TNn+9fWGhMEcP0y8B4Zm7JK4Xe0Z8dMauKmN6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHNkp48Q92QB3sYX4x8xMVCxiD6qAPRU8DwxGpq4ldcSbXfwfE0d5cYQhEEL2cOXn
	 W4AcrwuPMP1cHV3ZwGaXjuBlto94SaIODf6l2suzuNDQ9ga8EXSl7L/eaoknDSsWlI
	 peB65VKtVgZEHCBDEVLzI3bJSyaJ7QvvptT/6rF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0684/2857] ovl: check that the parents of volatile/dirty are dirs
Date: Wed, 18 Nov 2026 15:28:38 +0100
Message-ID: <20261118150226.186835270@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/super.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 51eec4a8e82b2..e8e7e1c59d95d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1333,16 +1333,23 @@ static int ovl_check_rename_whiteout(struct ovl_fs *ofs)
 
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
-		child = ovl_create_real(ofs, parent->d_inode, child,
-					OVL_CATTR(mode));
+	if (!IS_ERR(child)) {
+		if (!child->d_inode) {
+			child = ovl_create_real(ofs, parent->d_inode, child,
+						OVL_CATTR(is_dir ? S_IFDIR :
+								   S_IFREG));
+		} else if (is_dir && !d_can_lookup(child)) {
+			dput(child);
+			child = ERR_PTR(-ENOTDIR);
+		}
+	}
 	inode_unlock(parent->d_inode);
 	dput(parent);
 
@@ -1363,7 +1370,7 @@ static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}
-- 
2.53.0



