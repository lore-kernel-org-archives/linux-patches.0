Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061438;
	b=KeebI0JmTvN+Fp1gNhthmSC70vr/sOP0Qm67AnCpfInFPY9Sf3QfNdLuQp94Ohcc1e4y
	 BXjN2tsotIvWZdxC9QGyLIo0kddyDymvOTWDnZl43b8d28XVqIt9vXRYc5Hw0EZM0CuHi
	 +Wh+uSzQgZ5WWIVCmaeEVHIVbfVhcNyTeKzLDdL+zmvc4nYztbPCK9RgPDVVhkOcaoeu4
	 AEUF3Y3PvUtD7Ou/CXcRmZoThOVOnf2oCd/RbelYyNDatbmv4GO5qQpfTH0/kyYV2+aJz
	 6K6/QIowYeeyjnn/nLIJ4/f7XzAgVC7lPceAgWmVE4OC2B0GXHVor0Ex52rcq6WylZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P7ba1KeOB8AQWLG4U3iSc+YO6sX02ACMWavNXVboQ30=;
	b=V/e30dQiKLlxwdBzX8B4PJTJ2lwkZWZMuuDEN9gxxtqYJhtHnHoJvT9dQNG87FX3RikO
	 VFU0dC5rDFlzfzuTgl72U5M8Q6WUroQm18WTS8BfPLZ6yS7gF+bCiHBoTFeJBVzV0Aoi8
	 OFagvFHSlfa8pqVlYuUm6NIvAW4VIRrudZRTBqI+ZKU5X8Wbel8PyPYIfKy2sYmT6S27f
	 TihPBL4jCHYnYinih4jI8aaklWnfFmr4EcsPTyv2b2jNl9XLlrSTaqUT0DlNxX3yrdAaf
	 1i2hfzpuDn2hH7Py4Kl1a3cZM3+UveXcFZe+T39tfYNkBJM0om2f2ADmAmRikHPueGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoyCYobP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EA1606A326;
	Sat,  7 Nov 2026 14:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoyCYobP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9751F0089F;
	Sat,  7 Nov 2026 14:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061437;
	bh=P7ba1KeOB8AQWLG4U3iSc+YO6sX02ACMWavNXVboQ30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoyCYobPDfvBL0rpL+EsbyBH8cAe+tMVkPxJ6SVBHrL45NZ4iYi2DxvD6n5waYYzJ
	 0h/GVYssCjjIZZiF1w16LUQX1I7veKdqWXkO3ooz2+HXN9xIXhS+RO0i+dWZk0AV2a
	 +vn9svWdHu7iTcISE3UblMB1IXx9nHPc1LFXUlyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0547/1536] namespace: check a recursive bind mount for mount namespace loops
Date: Sat,  7 Nov 2026 08:42:43 -0500
Message-ID: <20261107135012.976029150@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit c640a01a78e42302879006ed7b7d5a9a943ba815 ]

do_loopback() refuses to bind mount the file of a mount namespace that
is as old as the caller's or older because a mount namespace that holds
a mount of its own file, or of an ancestor's, would cause a cycle. But
it only checks the dentry the bind mount starts from. With MS_REC
everything below it is copied and do_loopback() passes
CL_COPY_MNT_NS_FILE so mount namespace files below the source are
copied.

That's fine for a source in the caller's own mount namespace. Every
mount namespace file in there passed the same check when it was
bind-mounted. It isn't fine for a source in another mount namespace.
may_copy_tree() accepts a bind mount of any nsfs or pidfs file no matter
what mount namespace it lives in so that /proc/<pid>/ns/<ns> and pidfds
can be bind mounted. If we create a bind-mount stack of mount namespaces
file descriptors the kernel will copy them irrespective of their
ancestoral relationship to the mount namespace in question:

  151 146 0:7 net:[4026531833] /tmp/nrc/y rw - nsfs nsfs rw
  152 151 0:7 mnt:[4026532293] /tmp/nrc/y rw - nsfs nsfs rw

Mount 152 is a mount of the mount namespace file of mount namespace
4026532293 inside mount namespace 4026532293. That namespace and every
mount in it are leaked... All it takes is a process in an older mount
namespace that stacks the file and repeating it leaks without limit:

  after control: Shmem:               380 kB
  child: mount(/proc/self/fd/6, MS_BIND|MS_REC): ok
  after cycle: Shmem:             65916 kB

do_move_mount() runs check_for_nsfs_mounts() over a detached tree for
exactly that reason. Do the same for the copy before it is grafted.

Fixes: e149ed2b805f ("take the targets of /proc/*/ns/* symlinks to separate fs")
Fixes: ef4144ac2dec ("pidfs: allow bind-mounts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-4-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: Uses lock_mount() with separate parent and mp, so the call is graft_tree(mnt, parent, mp), and adds a forward declaration of check_for_nsfs_mounts() ahead of its use. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 036d56df28289..ebdc223c142e0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2805,6 +2805,8 @@ static int do_change_type(struct path *path, int ms_flags)
 	return err;
 }
 
+static bool check_for_nsfs_mounts(struct mount *subtree);
+
 static struct mount *__do_loopback(struct path *old_path, int recurse)
 {
 	struct mount *mnt = ERR_PTR(-EINVAL), *old = real_mount(old_path->mnt);
@@ -2872,7 +2874,11 @@ static int do_loopback(struct path *path, const char *old_name,
 		goto out2;
 	}
 
-	err = graft_tree(mnt, parent, mp);
+	/* the copy may carry mount namespace files from below the source */
+	if (recurse && !check_for_nsfs_mounts(mnt))
+		err = -EINVAL;
+	else
+		err = graft_tree(mnt, parent, mp);
 	if (err) {
 		lock_mount_hash();
 		umount_tree(mnt, UMOUNT_SYNC);
-- 
2.53.0



