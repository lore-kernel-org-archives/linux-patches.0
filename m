Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061843;
	b=0wfcdbWkt50RkhhUYlGJNaCnN6eMEFH31+rLX4/DAeCuCJybNJ07y4ci3/b7138IJ0Xr
	 jXB3DxIZ/iQSB/s8Vsj3RMpXze9EeV86YNEOJ3fFc3HqwTy9BjGGNYahUQ39EKD4iTeW5
	 DOKVw/Da0GuUZYpHbKRmH5rOIjIIkjMT5ZmBEh4a4bDuoKW3CrNY3nBkYsEbZoP/52+2A
	 D6XoGdSaSiS9arzh6gij+jcZ7oES2N80/CgPz5yeyqp72eiX46aX4guo5ec7hd7BYB1Iu
	 4xfIWot197Qu2u5Ayh4zeXVmmCVG6jlIhw9P5vJlwD1DSkqfjozMPed8s+ULxX7n6LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lO9hmD8vhm56NJYqsCXTMcBkSFgvMdfmZjgunJBA0Xk=;
	b=CbIEl3XlxHAHlrHjlGKImtRhWKYyyAz5hDii/JuB0wgR6LWotmC5fKJdd8FQU5NX4N9M
	 sJJhHw/3KnW/qKrTsdmV38ALWZbis98gOwn3Hu5BOAG2xZrFS/I8pJz8ZaJUfETf1l7bV
	 4ceorLXKj0VF27h7iRritj9NMyC6wIGezlnWADgJ5GmUk+SlAqbTMCwJgod+3NS6nWlPw
	 Y8wIwHA9QRYX5hFp8TrxRfg1W7F1VJ5Kd2YrK5sFC13IuXKamXkFaDR7cXeS0JHKFsTEf
	 1OGKurvJwGCRIIvDBBOxBumgzewAs0d1tkt6HwlXgzLjD/UVN/tRlMNnQ4i6XvdR8Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ByvV8/p3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CE7606A32C;
	Sat,  7 Nov 2026 14:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ByvV8/p3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C296F1F0089F;
	Sat,  7 Nov 2026 14:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061843;
	bh=lO9hmD8vhm56NJYqsCXTMcBkSFgvMdfmZjgunJBA0Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ByvV8/p3eptFiEAAOhG+DjMtsI6f0v2G1BFR3ovwbXfRwyPfoU8lGfr6WBetxwbpQ
	 ifqbv7RipIWNJWJfdi6zATSObxPEHsv9BpHD7WXiq4zrl8G+XA0o57niRRxNy+n9Eu
	 SaGB9IummR/yYBWjD8vJbgDfsgcbNjOFZpxnMTMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0861/1536] ovl: check that the parents of volatile/dirty are dirs
Date: Sat,  7 Nov 2026 08:47:57 -0500
Message-ID: <20261107135021.732904859@linuxfoundation.org>
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
index bd0c548cf1eeb..b0cf671b4200d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -594,16 +594,23 @@ static int ovl_check_rename_whiteout(struct ovl_fs *ofs)
 
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
 
@@ -624,7 +631,7 @@ static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}
-- 
2.53.0



