Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035691;
	b=Vnk/mX4cL5HZMprRhRLUOYIaxZzNEyRdkvpm9o0Mx7bnDq8h/3krlN53eqauBt5aYfpo
	 1MAE+mFxvjtDyMbBN7ntjwgtY3BjN2dAl00WvF+R14BSE4kiJ6XidhF2P0oJsSBico0Mw
	 XkjhQrzGNgB3eYobohW2Uh01GlQxG/beMBRhB4w7+j/BWMmFVMn9OU1CkyDIsCBbXYAx7
	 s63sDWmdl2BvBfzYwwGAwtuGxb1jGrTFGulb0ZMT4FPoHL89A7p60zd0JsKi/BHys5CpE
	 TVBYDTgq4obtI4hGxS5YMtorXvhSPSnqY7QeFnvAlY36OY6cKCONIIxDweiDG3o7Bww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8f5i/aAr3lH18T6FObPbg6GE81s6V2OfdcjPSSE2QW0=;
	b=quN4MsRdWyAazs/2hA6fGCaJbt8ggpmhAqQ9WR1oyEYq/ABVpRYqypoNpeihXXdbXNkG
	 sjTEUE25Ug1cTInaGt/1wSHPFGaaqy0uqN2SHWb3Kzwt/35pCT2sfrtcOMf9hjg5RnFgY
	 1o/XY1E9/TggseXP/IIdZjr/aVc7WJFVegJC2e0i3CM/lLUPxJ3hrJDKkw/BRwA6E3U1e
	 iDGXtyvy95pnwiWD36MvvZNTVTk+4JgE8BiOsNwWcOQzclidxJnvYfwV7Tlo6nMY+dsJG
	 JXNjh35v4mAfBAKBq5gb5FEmIv+IHrku1+pVpdpL0+xamunLyrOH/pjx8BSLBZk8Elw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdpaYEPH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD87260A2603;
	Wed, 18 Nov 2026 21:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdpaYEPH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A0F1F000C5;
	Wed, 18 Nov 2026 21:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035691;
	bh=8f5i/aAr3lH18T6FObPbg6GE81s6V2OfdcjPSSE2QW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdpaYEPHso1yiZiaJ2Kac1gL9FyagofjMzCkb3kFZm631+hf/7pyanEcOLtMnn+eU
	 LN81wCDL955ixd1v3lsbmAcY+ZD7kj/yDyoyE5Lat059sVfdm3neYCREOWWdxMPjP9
	 qIfBgRDyykLHINO6WItwuI1AO6WIINUsbuLycPBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.6 0743/3318] ovl: use the pinned upper dir in ovl_fix_origin()
Date: Wed, 18 Nov 2026 15:22:45 +0100
Message-ID: <20261118150340.897197713@linuxfoundation.org>
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
[ backport: context: ovl_fix_origin() calls ovl_set_origin() ]

 fs/overlayfs/namei.c     |    6 ++++--
 fs/overlayfs/overlayfs.h |    6 ++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -883,8 +883,10 @@ static int ovl_fix_origin(struct ovl_fs
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
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -492,6 +492,12 @@ int ovl_check_setxattr(struct ovl_fs *of
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


