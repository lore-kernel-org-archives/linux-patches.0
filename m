Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044194;
	b=F9wmpZjI/uTn6oCuBJAQus0RLnwpqoiYo15Jx95R3IH30XqvhWyg3CRR83+xV/OYT8xT
	 UItNIk4HnZ1ofzF6Hjb0LBl5XhWiVsPRrMn3DM19/Ln0klOe9OzTkzQlqXHdLnTycXeOG
	 5M/5g/RTe/1kzkps4JSR9nRS66HdcedzVatWjqU/8hR7spZrC2LSlZGPd9c/Hscug1j2/
	 90XDEfM1cnPyMQIWMVc1xom+NYnG8MqvYZRwIFRLAEcQEean5hGfzdsoIPwpbqlJPSd2D
	 xpiFRZT2sx4L8e56jVbA+v3IcfnHKx5R67RgT8mouNtRAtjwW108sHScedJWvpMyYKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PSGv6lnSyFJSRwGrmNFjuH9HflThaT+e4utx+fWz6Rc=;
	b=Gl4GNrAu1zS9tWYZ57jLWvdkv1nqnHAwJaqo/H9nXetnn5CShQIxHkVeAdIU97rKKCEa
	 /byoWgChuezNqcT1zdVObrnAt97Ty6iPn2X1KR8bszF8oQfgkANOo+BYjoqdrVhNIYLPA
	 nUQA8YV8A2vBIlPyIhInZS5PEG5Igv1xwMENco0kFjDzL90MFIyZnJgQ2wsWRGN+xboGH
	 eHyuerzgm9uI4EAo6a94lELiWXW831xjCQA74Er7dHTU5rtzxPWyK3c4hZN3rB6hMLoBe
	 NUky2YUMYrBl2A0Am2kMkk2iQItdqq5Lkzy5zLrBfKGWAPKzX1jDDVsTreQBBjlSEsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hc3ssslA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC52D606A325;
	Wed, 18 Nov 2026 23:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hc3ssslA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3885C1F000C4;
	Wed, 18 Nov 2026 23:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044194;
	bh=PSGv6lnSyFJSRwGrmNFjuH9HflThaT+e4utx+fWz6Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hc3ssslAsxwDD5X+wZrbYKUFIG1tHfXMbmWYJkPbRuTx+VlLkphoLG7xRRuFmTUcm
	 tY/C8oYM19+K/L/T1bSSNvuTD2V0UZA1R9FPqW6XoVnLV11mZMqFP/Cg+f9NaF/dkq
	 3AWxrheVxRkRHsgotphuodNDPhOsCtg/k3oYXAGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0482/2857] namespace: never expire a locked mount
Date: Wed, 18 Nov 2026 15:25:16 +0100
Message-ID: <20261118150218.794755556@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit f78ddcc872248c7aa1d7e904928441a0be4c6d5d ]

Locked mounts are special. They protect the underlying files and
directories from being revealed. do_umount() refuses to unmount locked
mounts but shrink_submounts() doesn't.

A shrinkable mount can become locked once the owner of a user namespace
puts it beneath a locked mount with MOVE_MOUNT_BENEATH. The locked
property now moves to the mount at the bottom making it possible to
unmount the top mount.

So umount() of an unlocked ancestor now expires the bottom mount first
and the covered directory is revealed:

  move_mount(c -> x/hidden, MOVE_MOUNT_BENEATH) = 0
  the cover after the lock moved:  umount2(x/hidden) = 0
  the holder of the lock:          umount2(x/hidden) = EINVAL
  the root of the copy, busy:      umount2(x) = EBUSY
  reads x/hidden/secret: "covered-by-root"

So leave a locked mount alone as it dies together with its parent. A
plain umount() of an unlocked mount with a locked one below it is EBUSY
from now on. It's the same for any other locked child. A lazy umount
still takes the whole tree.

mark_mounts_for_expiry() never sees a locked mount. lock_mnt_tree()
leaves a mount on an expiry list alone and nothing else puts a locked
one on such a list. Add an assert for this.

Fixes: 5ff9d8a65ce8 ("vfs: Lock in place mounts from more privileged users")
Fixes: c62a4766937e ("move_mount: transfer MNT_LOCKED")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-8-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Used WARN_ON_ONCE instead of the missing VFS_WARN_ON_ONCE for the new assertion, and placed it at the loop top since the is_mounted() check it followed is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f534ebc90c9cf..cb3b702de4447 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3221,6 +3221,8 @@ void mark_mounts_for_expiry(struct list_head *mounts)
 	 *   cleared by mntput())
 	 */
 	list_for_each_entry_safe(mnt, next, mounts, mnt_expire) {
+		/* lock_mnt_tree() leaves expirable mounts alone */
+		WARN_ON_ONCE(IS_MNT_LOCKED(mnt));
 		if (!xchg(&mnt->mnt_expiry_mark, 1) ||
 			propagate_mount_busy(mnt, 1))
 			continue;
@@ -3249,7 +3251,8 @@ EXPORT_SYMBOL_GPL(mark_mounts_for_expiry);
  */
 static bool shrink_submount(struct mount *mnt)
 {
-	if (propagate_mount_busy(mnt, 1))
+	/* not the kernel's to remove either */
+	if (IS_MNT_LOCKED(mnt) || propagate_mount_busy(mnt, 1))
 		return false;
 	touch_mnt_namespace(mnt->mnt_ns);
 	umount_tree(mnt, UMOUNT_PROPAGATE|UMOUNT_SYNC);
-- 
2.53.0



