Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023757;
	b=OJ6JIDSQ18xBIKN/vEN2qelAWSse2ZoQDhCcUyQCUs4y7PIdx5QpQa97e0Bw0RRm9Z6J
	 mJYPWYDzn3sB/k76vzGmnWSbEDhn2ih9lxz08rnKlxywwNe+VdpXMY+C7yYuzDS+8fi/+
	 M/tSaoQqnjWbmknHX7efh+fxcnl+V0CgJeGi401A0P424j+vxQPJDrmlAudxUn9LWSWVM
	 gwlAArTMGLHkfa+XCci4DlICe7yAMrfJghWtS0XFu3blMlDr+8zo0d98T6XBHP7CTPgqb
	 QWGqyuEbHxJHHbPgTYUhbbX8FtQulOMcWHaHKggIz2h7LmF25c9DEK57GeEbL2Eb6vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023757;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=raR/gUETW11yEsDzC/LY7JnkM2YHZOFbwabXfScZC+0=;
	b=MeMNiXvsU+89aIMj2hKxZUU1c5jNlREI0tiuG1WTuAlZauKHWP8aXc0w6fEuIw6kXCb0
	 1dYC08ZQS5ATipmddkiU5J4W89e8R0D7z7NutUOvE24BkQO1yGZ+6cR1oD489T8/Om/YC
	 kLON/nJ0NOhA6UHybC+0ufPoxSJnnPfr8Ri4Biq0YrIWkQ59/GWt5OXchT6OO++RGIHtl
	 PVwnk3PKuwnZP9t79D7Rd5gCdF7Wjf9hrFuSuVeL4C3mk0WhsLLTjASrjudtlGNbuqvxw
	 IO6ETRcGTmj4FPZaLFxCEc+1un18ykTSVrsxm86/+ay55+38NkjXMVZawcLZ+ruLPqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DXBP/rXW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AD0606A330;
	Wed, 18 Nov 2026 17:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DXBP/rXW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4631F000C4;
	Wed, 18 Nov 2026 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023756;
	bh=raR/gUETW11yEsDzC/LY7JnkM2YHZOFbwabXfScZC+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXBP/rXWBrN/1AS8OTtY4ovR3J085roKrisyp30/Ro+PMc5DUvuVQ6+qMEQJCCkM1
	 glpIMBuQIpLymoy4Tq/d9o8SsSLJBb8JN0p4LhqCdIpWYcTs062mi8fv5By9/FBCe5
	 OtW3vFaSZ4q+LJLIjRvcVRIUB1M/5DWOHUjIut1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0484/2151] kernfs: dont hold kernfs_rwsem across notification delivery
Date: Wed, 18 Nov 2026 15:36:59 +0100
Message-ID: <20261118150139.680379551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9adf36e6364b7..63c4beeed93fe 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -911,9 +911,12 @@ static loff_t kernfs_fop_llseek(struct file *file, loff_t offset, int whence)
 
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
@@ -929,14 +932,20 @@ static void kernfs_notify_workfn(struct work_struct *work)
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
@@ -948,15 +957,14 @@ static void kernfs_notify_workfn(struct work_struct *work)
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
 
@@ -969,7 +977,6 @@ static void kernfs_notify_workfn(struct work_struct *work)
 		iput(inode);
 	}
 
-	up_read(&root->kernfs_rwsem);
 	up_read(&root->kernfs_supers_rwsem);
 	kernfs_put(kn);
 	goto repeat;
-- 
2.53.0



