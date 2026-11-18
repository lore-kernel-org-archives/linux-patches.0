Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044765;
	b=vqyBTRWw0jJaculo5U6G0qlPD3A51dwVQNZn32yhXkY9h6ccVCVjdBzK+/m0M3WIx3e4
	 rL/lGbakzR8xKW2+9ciBdnTwmtzs7scaR8w51lnRX41U595IqiJXtKSWa8ZzyRWcXUTnN
	 CNcgEyp0ZEwuck0L280VBZr2pp/deZtEVj6LCsh8UiIdVNHsDyaJkurIsEWByoXJMtaZv
	 dqdmFb6LKoM/MSkDoV3D4UCna2rB7pAA1U4yuXROr8sNR4nqrbxU22Ao2CZPB7kjKA9Ay
	 bEEcP+YOqseLoqCljKdbjV1dg9EzKLaYIUgSaV6ljqGX0g77TludyTqWfiLN6jox2zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AWSaxojDb5z9C77BwHgEiM+PkRUKiQW2rTPnMAkrNY4=;
	b=W1aK4m73azo/Wxm8dsN4m0x6rBdl9EINxagjG91xDFMXHErvH9HPHluOxVY6+l2OPwuI
	 NUoUx/kw+YZyIx5Wds2m5OYj6K/XqkhsKQYn0Euab2eSTBRSU+J3+2gCLSBnzKQGIHo2e
	 5eLP00/i6S/v6Haa8du5GYmTGNjOnFR8fK6gCggX3RBbU/PTp5VPvw9KA6HMy+g96HawN
	 O//cZE76NKM70SVlRPKLFTLFGp64eEYupckPx+f8LptygdsukO0QZVZfp1x3DLBe8yflI
	 TrS+BKpJm+rEyYG2qt0q7NCpPcO+SS3BvpH57WGI1HPlzrEm/2FJkijtFmroBvyWMug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxtKTzoG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7E560A6F6D;
	Wed, 18 Nov 2026 23:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxtKTzoG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD891F000C4;
	Wed, 18 Nov 2026 23:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044765;
	bh=AWSaxojDb5z9C77BwHgEiM+PkRUKiQW2rTPnMAkrNY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxtKTzoGI8O3IyAXdzOQcYtmIoWjU+STsDsmoEEKT911RBQuaK7hUlYBCfKpAjrI6
	 VOjQgl0InpKAoxMp4p+Q2p5AXrkLKIGQm54mhoC9jcXbQlFpqYzGY0kx7Fpm5Z1N4M
	 XH8DiNEZv6Qlqdwj8mG458G7NoJBaHcSl7j+A/tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0677/2857] ovl: use the pinned upper dir in ovl_fix_origin()
Date: Wed, 18 Nov 2026 15:28:31 +0100
Message-ID: <20261118150225.938620932@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/namei.c     | 6 ++++--
 fs/overlayfs/overlayfs.h | 6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index cb8ca730c0ecf..cf805c99cfb9f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -819,8 +819,10 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 		return err;
 
 	err = ovl_set_origin(ofs, lower, upper);
-	if (!err)
-		err = ovl_set_impure(dentry->d_parent, upper->d_parent);
+	if (!err) {
+		/* upper->d_parent is not stable, use the overlay parent */
+		err = ovl_set_impure_dir(dentry->d_parent);
+	}
 
 	ovl_drop_write(dentry);
 	return err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index eb92e628afdd1..18d8cd614ef20 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -427,6 +427,12 @@ int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
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
-- 
2.53.0



