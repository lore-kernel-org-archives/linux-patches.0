Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213731;
	b=GFlFcQ2Li++0SlwpSocrEnLfSiWvto17nEtR/mRlC+RuapevFf6LGIPjXJP2AGuM80fJ
	 Vd5KtE+5nzkE1JzFHRhNVa/KTT9zGDvB1yec70HVtmE+DCz3KJOy9Dknk/UEQxbgo2xud
	 0osFktxmUYAY94ShOdkqmvIjQTRZDN7Nyt5KFxmdXpAxD/b6bjXwunozahPR/NhBl0bNO
	 QxhIQOxxrkFxU5XE5jOmSpN86/vjtluvrTSZuUNlkJUk5olNPXK/vHS+A+Etr8DSmLMUU
	 8C/VjyD9ryngiJOdbgssVGcXloUaRecLXZ+K398KHxlQgxbou8a95XqCwwp0VbrrJLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EDzg6pqkmggfHZSiIZkFzGF0JpZWk9FRsw1FxGcrmbc=;
	b=nMbt+wMUfSZob1Eofhl4lfHe8SdpXcSvyF8vf6jSJ1rSeE2ra/2nayYCsotqSS7z9Xo1
	 m2pzvJMjemzp8aeb85DzdM24LVQ/+CKzARrqRiB74Lkj0SE3f2z19NkE0OQNnEfYI0Rol
	 ZgJisxEF2Dqy3r450Kr4XhCfOWEuowR+bTzDGk7q9JZGQtTHEpBnpV8KvhK8daOjhFcsx
	 c18Xb9K930ZDC1s81a82qHqlL/qLRowlZ7FF5WSmVEmlSKzoaKtTjTKxABmItt1vuIyy1
	 toFUhlF+l0bwm4CR7dlHu5qyJbXOumzJzX90olBfrwTrfkatZfOqg/cwJR3ekxjJqIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kqbH6d/T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F10606A31F;
	Wed, 28 Oct 2026 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqbH6d/T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348C61F01825;
	Wed, 28 Oct 2026 18:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213730;
	bh=EDzg6pqkmggfHZSiIZkFzGF0JpZWk9FRsw1FxGcrmbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqbH6d/TpsOH8HcEZP6oaEXAbNzLU9/AuGHef5oNho1/hsPqHylOfKmI7aU9jXHRC
	 biR/WMWeDiB2NONj62ZO7doBwIYhEYgbVfcZjlbAosp8DSi0JZwxDbX3tqMwfRfxZ+
	 U+dFuoLFVN5+5Xx8uNnPnFJLACG4LJekTukTNuDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0608/1887] selinux: avoid dereference of garbage after mount failure
Date: Wed, 28 Oct 2026 17:45:04 +0100
Message-ID: <20261028170513.250246445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

[ Upstream commit 37801a36b4d68892ce807264f784d818f8d0d39b ]

In case kern_mount() fails and returns an error pointer return in the
error branch instead of continuing and dereferencing the error pointer.

While on it drop the never read static variable selinuxfs_mount.

Cc: stable@vger.kernel.org
Fixes: 0619f0f5e36f ("selinux: wrap selinuxfs state")
Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/selinuxfs.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index f74fdabaa541b..8fd1428a60e18 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -2211,7 +2211,6 @@ static struct file_system_type sel_fs_type = {
 	.kill_sb	= sel_kill_sb,
 };
 
-static struct vfsmount *selinuxfs_mount __ro_after_init;
 struct path selinux_null __ro_after_init;
 
 static int __init init_sel_fs(void)
@@ -2233,18 +2232,21 @@ static int __init init_sel_fs(void)
 		return err;
 	}
 
-	selinux_null.mnt = selinuxfs_mount = kern_mount(&sel_fs_type);
-	if (IS_ERR(selinuxfs_mount)) {
+	selinux_null.mnt = kern_mount(&sel_fs_type);
+	if (IS_ERR(selinux_null.mnt)) {
 		pr_err("selinuxfs:  could not mount!\n");
-		err = PTR_ERR(selinuxfs_mount);
-		selinuxfs_mount = NULL;
+		err = PTR_ERR(selinux_null.mnt);
+		selinux_null.mnt = NULL;
+		return err;
 	}
+
 	selinux_null.dentry = d_hash_and_lookup(selinux_null.mnt->mnt_root,
 						&null_name);
 	if (IS_ERR(selinux_null.dentry)) {
 		pr_err("selinuxfs:  could not lookup null!\n");
 		err = PTR_ERR(selinux_null.dentry);
 		selinux_null.dentry = NULL;
+		return err;
 	}
 
 	return err;
@@ -2257,7 +2259,7 @@ void exit_sel_fs(void)
 {
 	sysfs_remove_mount_point(fs_kobj, "selinux");
 	dput(selinux_null.dentry);
-	kern_unmount(selinuxfs_mount);
+	kern_unmount(selinux_null.mnt);
 	unregister_filesystem(&sel_fs_type);
 }
 #endif
-- 
2.53.0



