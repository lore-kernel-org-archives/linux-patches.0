Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016533;
	b=Clc7aTsxbrrPPR2/xzYHOZJnR9LzKj8tgFm2s5iiJ3zGqzNE1fOqctshx+RrcY1aUckC
	 WiOPi8Qg3RPREvQ2GcrFiQzUbuuzck0h8ufZge23Xk2GVyIjz1UALqabKcXbYIYMChrOM
	 bnzEeGlKNjLAYza+08YMPux18bmMWJE4euVc3iqcy6U1nbH01gq16pFDWwTwp8w/3E+zV
	 sgTLTbpUY2IQQOA6QlFMy9+2pjfd73rEa+zmfObWT6aemm/kdTJJXuY6lMJYxtVtjJdeB
	 SNnIUMUqBKFHR7hwWYyWGm+oU+KSt71a9MQ4L47F9sKy7lZ4mO5VvGllvluzbXezwew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xn7y2G+VWKNuco9CRkf5yIj461tpUsXGY5W4KQRsj/E=;
	b=VfFv136/KVpxbQUHLQlhipT+S9HZbGtf//kQzCgyi9kvWYrI9I3P3vI5+ROtzwanWZqf
	 6Pw55lRkoVwWB9ZzMlfqxQKSabDv3re7vmlMJlLZEuFmOew0QMsKEsIKO9jmpMUwwWwQq
	 VZl5Kcdx4OVi5PRr6Gc3QGpTM1cI0yWG634Hrgd3FLgh/t+6tiOSjUS0RVZzlP4yOSPdT
	 NRc6f1S5GhSh0E5IaUflXVVOzhUaDesxyEyIYaF+XUq58mmOhqWJX5fgj55PeVD7UdIUx
	 wKKvzVIwklj1Qu2DBbA70kT2qSu7Kiz/vyfvlJE82+HSvHkOAvXJkF+aQXNzGSIacwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qhXCq5w9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AFF606A334;
	Wed, 18 Nov 2026 15:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qhXCq5w9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8FB1F000C4;
	Wed, 18 Nov 2026 15:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016533;
	bh=Xn7y2G+VWKNuco9CRkf5yIj461tpUsXGY5W4KQRsj/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qhXCq5w9p6hPkItvXKnHFXyWc9iEEr1KmI/A7hPdGFArmgxkoNrhnUMSdY733fpO1
	 hFec6uvC6u2koDpOmnnLOfCToQ5cR+d3BRtQsW/a6t5Y/cX86XdUqayTMQ+oFCnkVJ
	 fu7gwazxT372t102NujGKzwBFiKJrXiecBJmF5O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0519/2651] kernfs: dont hold kernfs_rwsem across notification delivery
Date: Wed, 18 Nov 2026 15:29:19 +0100
Message-ID: <20261118150306.434968786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit 23985e2b1f31623468244a2149b2388cda4925eb ]

Recently at Meta we noticed that on multi-tenant systems, a workload
under extreme memory pressure negatively impacts unrelated workloads and
system daemons like below [1] and fb-oomd [2]. Mainly we observed that
system daemons were stuck on kernfs_rwsem in cgroup-related interfaces
for long periods of time.

On further inspection, we found that the workload under pressure had
registered inotify watches on its memory.events and was continuously
receiving limit-hitting notifications. The cgroup notification is done in
kernfs_notify_workfn(), which holds kernfs_supers_rwsem and kernfs_rwsem
and calls fsnotify(), which allocates the event with
kmalloc(GFP_KERNEL_ACCOUNT|__GFP_RETRY_MAYFAIL) charged to the watching
cgroup, which is already under memory pressure. So the notify worker
ended up in memory reclaim of a cgroup already under pressure, and itself
kept triggering the limit notifications.

This notification path takes the locks in read mode, but a waiting writer
blocks all future readers. That is exactly what is happening in the Meta
fleet, and it leaves daemons that are critical to the reliability of the
system stuck for long periods of time.

Commit 400188ae361a ("kernfs: Acquire kernfs_rwsem in
kernfs_notify_workfn().") added kernfs_rwsem just to safely read
kernfs_node::name.  Let's sample the name once before the loop and drop
the lock.  kernfs_supers_rwsem still covers the list, and the removal
paths take that one for reading too, so a stalled worker can still hold
a removal up once a mount or unmount is queued behind it.

Two things change for a watcher.  A name longer than NAME_MAX now gives
an event with no name, where before it gave one with the full name;
fsnotify() takes the name as optional, so the event still arrives.  And
the name and the parent are no longer sampled under one lock, so a rename
between the two would name a file against the directory it moved to.
That cannot happen today: kernfs_notify() rejects anything that is not a
file, and no caller of kernfs_rename_ns() renames one.

[1] https://github.com/facebookincubator/below
[2] https://github.com/facebookincubator/oomd

Fixes: 400188ae361a ("kernfs: Acquire kernfs_rwsem in kernfs_notify_workfn().")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20260910045406.485295-1-shakeel.butt@linux.dev
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/file.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 8e0e90c933720..7e3800526b1e9 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -904,9 +904,12 @@ static loff_t kernfs_fop_llseek(struct file *file, loff_t offset, int whence)
 
 static void kernfs_notify_workfn(struct work_struct *work)
 {
-	struct kernfs_node *kn;
+	char name_buf[NAME_MAX + 1];
 	struct kernfs_super_info *info;
+	struct kernfs_node *kn;
 	struct kernfs_root *root;
+	struct qstr name;
+	bool have_name;
 repeat:
 	/* pop one off the notify_list */
 	spin_lock_irq(&kernfs_notify_lock);
@@ -922,14 +925,20 @@ static void kernfs_notify_workfn(struct work_struct *work)
 	root = kernfs_root(kn);
 	/* kick fsnotify */
 
+	/*
+	 * Sample the name once so kernfs_rwsem need not be held across the
+	 * loop.  A name that does not fit is reported without one; fsnotify()
+	 * takes the name as optional, so a watcher loses the name and not the
+	 * event.
+	 */
+	have_name = kernfs_name(kn, name_buf, sizeof(name_buf)) >= 0;
+	name = QSTR(name_buf);
+
 	down_read(&root->kernfs_supers_rwsem);
-	down_read(&root->kernfs_rwsem);
-	list_for_each_entry(info, &kernfs_root(kn)->supers, node) {
+	list_for_each_entry(info, &root->supers, node) {
 		struct kernfs_node *parent;
 		struct inode *p_inode = NULL;
-		const char *kn_name;
 		struct inode *inode;
-		struct qstr name;
 
 		/*
 		 * We want fsnotify_modify() on @kn but as the
@@ -941,15 +950,14 @@ static void kernfs_notify_workfn(struct work_struct *work)
 		if (!inode)
 			continue;
 
-		kn_name = kernfs_rcu_name(kn);
-		name = QSTR(kn_name);
 		parent = kernfs_get_parent(kn);
 		if (parent) {
 			p_inode = ilookup(info->sb, kernfs_ino(parent));
 			if (p_inode) {
 				fsnotify(FS_MODIFY | FS_EVENT_ON_CHILD,
 					 inode, FSNOTIFY_EVENT_INODE,
-					 p_inode, &name, inode, 0);
+					 p_inode, have_name ? &name : NULL,
+					 inode, 0);
 				iput(p_inode);
 			}
 
@@ -962,7 +970,6 @@ static void kernfs_notify_workfn(struct work_struct *work)
 		iput(inode);
 	}
 
-	up_read(&root->kernfs_rwsem);
 	up_read(&root->kernfs_supers_rwsem);
 	kernfs_put(kn);
 	goto repeat;
-- 
2.53.0



