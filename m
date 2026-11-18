Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034890;
	b=s3qXZvEgJKlIEZGC9qNRx88yX4QxlR08CZZXI5rEtpdn/O7nDEQQz1HA2lgZ/AjZY1zl
	 s+gwrcbsf+DQTPsuRAiGcc9g9IWARUSfOxsgHU+AdG2TuwN4KyjzkCp3ajI7o17r/trtW
	 8o9pBIZFGFMXVG0Xh0tpFfYL5Ev6xQg+WP0u4qC7CZh9mFcK5NpJbX96HZXKxpkm2vMtv
	 OFPLg3JILgzZDgP7BlBWSIvyu45+F07nQHxdGVJMdIIMvA8envWfTC2inVN6YZt0I/S0+
	 K3WGlPB7N9WTRzyLXXSY46pYfJJQDyGt54WRioPar+4tMCWzc2FHywhkQ6euHnLNgiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OHEP8W4vrsZynFPS3kkFSRR6aiiklBzf7p1JifPdxiM=;
	b=A2bkO4rDWJGFx8vKPq4TLff8HM6KnEDCwd8Q45gIX1liNR58UCU9iBul8OmQksX6a/BZ
	 OtzK3HmvpMpeayjxkcOXo4heshSOWKlK6PGdsPvqFdLPUueRrpOT86cvMgzREev7gtgdK
	 5i0BOvL3OsdygFdEnsOiaJmqjq+Hydgq+eacAjClsKxTSit/hm0ht46RxyQjVhDTnO5jY
	 HlaaEeExynE8hbyr9UahTdF33FosJM5Opp4wvP+SlgDXvf2JyR1fhFGv37Y5b3DprYjbH
	 XqJ9g9bgxc82HZOAg5czBokaMvFZsivEXqKgjW1e/+gE+sdQ15v2Yx9RlDdbvEeclHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SS1vMMFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6410606A31C;
	Wed, 18 Nov 2026 20:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SS1vMMFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8671F000C4;
	Wed, 18 Nov 2026 20:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034890;
	bh=OHEP8W4vrsZynFPS3kkFSRR6aiiklBzf7p1JifPdxiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SS1vMMFKw+wdc/lJLWfuwRtJEx8hgIbMvIDPjpHMvWY+iN9mBPbI4WFKSRRu5gd/b
	 iJWvUh0OC/xanNXT5ypXmfIVlgOXRhfZmGS3xUWRrkI3DQ2eXRRoItLKcS3duAGxB8
	 S2fQy36ol/g7R7VLxjhFFF23G21rHG2MrjdPyG8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0529/3318] namespace: check a recursive bind mount for mount namespace loops
Date: Wed, 18 Nov 2026 15:19:11 +0100
Message-ID: <20261118150333.080897673@linuxfoundation.org>
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
[ sashal: Adapted the graft call to the older graft_tree(mnt, parent, mp) signature and added a forward declaration for check_for_nsfs_mounts(), which is defined later in this file. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 0d5f71d56b12e..449c52d0611df 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2654,6 +2654,8 @@ static struct mount *__do_loopback(struct path *old_path, int recurse)
 	return mnt;
 }
 
+static bool check_for_nsfs_mounts(struct mount *subtree);
+
 /*
  * do loopback mount.
  */
@@ -2690,7 +2692,11 @@ static int do_loopback(struct path *path, const char *old_name,
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



