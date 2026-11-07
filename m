Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065612;
	b=5MBhXPsxJ6YgMolQ8WraSR0AN4A9NqnU0nJdeo1KRGtMTQGdhhkBUNjUnIvgb7MZMpDL
	 3/xlNFkdxlg0ZrwsjHbIhiYkP0fc9B+bOH7XdLemZeijSlMmptb+v0G90Y9MFaXmbxVA+
	 d7AcW6qbMK03muO/EjJrIPuGBBEt5TF0Aiejw3u6YfOsdCDeYaF0TCo8/LJ0qXcEQKEI8
	 qlUs5wxS7rt7JVbxsq+QBpd+XPmw7NJ+xowxjBuzwFGx7ug+oG0uYKNjd00oYb2wza0HV
	 +rentQ/ENHVs//4xwEee8r9F2+fwCYMdXGlze6+VXzHkFYfeFHehZEkRQJzyAmVovew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JyU4u5XDyaBfNGjB/Uds2Lyqc4aeh0r6Ry2+AlNFrnc=;
	b=Qc7KcXhMr9tYUujR+k9fwl1o7OP1+MVNdvFdeZW/rDJFlAxMxrSazt4lpEHZrdoNXG5T
	 hVBckdAdMSlIzmf9NwQ5NWM1TkoEZyY9MG1gFQtByxOPsYYTxmF4Kd7gT4RiHnQM657pC
	 jKp5sqfHJDSdKUz2Yv9Zoq1OOkBPqD4AEWQe8I8guPYa2/EgkEgSIjT3zCFWGYA7l1VPH
	 dZMsrF8AYP1ktSMQjXtb3Dkey6tDWFLGlX+z0HUGalJb3j4y2XccQJN+DTwZbIkbBpwQ/
	 6/9kmcKCoV0JW0im3xprblewrIRdNO6Wdyjiq4g6oREVuV+RiQEZx2fOi9Y14FFeZuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTDM5RzH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B41606A330;
	Sat,  7 Nov 2026 15:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BTDM5RzH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F451F008A1;
	Sat,  7 Nov 2026 15:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065611;
	bh=JyU4u5XDyaBfNGjB/Uds2Lyqc4aeh0r6Ry2+AlNFrnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BTDM5RzH+Wiuoys3AdVEaYDXiIn6LWpvyX2n0ZLdMjx5HKHhXzaWjjPJLk7Mcn8iP
	 /Vtwq7TM1upYcza1lFR8PkDsVktUGv43M9xg1N8ULbIVdfgTv3EGUaFedDOxw+fTXO
	 2etDznS5idhg7Pau895hm+Dc/VnK0xUWNSQCmwfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <yi1.lai@intel.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1252/1257] ns: dont add init_ipc_ns and init_net without namespace support
Date: Sat,  7 Nov 2026 08:59:08 -0500
Message-ID: <20261107135013.893836210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 82f1c815aaef1905c5c6c386c8a0d74f6ff70a54 ]

When CONFIG_IPC_NS or CONFIG_NET_NS are turned off we still add the
initial ipc and network namespace to the namespace trees. ipc_ns_init()
calls ns_tree_add(&init_ipc_ns) whenever CONFIG_SYSVIPC is set and
setup_net() calls ns_tree_add_raw() on init_net whenever CONFIG_NET is
set.

But without CONFIG_IPC_NS and CONFIG_NET_NS these aren't namespaces
userspace can do anything with. They don't have proc_ns_operations so
there's no /proc/<pid>/ns/{ipc,net} for them, nsfs_fh_to_dentry()
refuses them with -EOPNOTSUPP, and since ns->ops is NULL
__ns_tree_add_raw() doesn't add them to the owner list of init_user_ns
either. So they end up half registered. That's also not how we treat
any of the other namespace types. Without CONFIG_UTS_NS, CONFIG_PID_NS,
CONFIG_TIME_NS or CONFIG_USER_NS the initial namespace is never added
to the tree.

listns() walks the unified tree and calls is_current_namespace() for
every namespace it finds via may_list_ns(). But is_current_namespace()
only knows about CLONE_NEWIPC and CLONE_NEWNET if CONFIG_IPC_NS and
CONFIG_NET_NS are set. Otherwise we end up in the default case and its
VFS_WARN_ON_ONCE(). Any unprivileged caller can trigger that with a
plain listns() call:

  WARNING: CPU: 0 PID: 526 at fs/nsfs.c:508 is_current_namespace+0x12f/0x440
  Call Trace:
   legitimize_ns+0x25f/0x4c0
   do_listns+0x185/0x5c0
   __do_sys_listns+0x13b/0x300

Instead of teaching is_current_namespace() about namespaces that can't
be opened, only add the initial namespaces to the tree if their
namespace type is enabled. Move the registration of init_ipc_ns into
ipc/namespace.c which is only built with CONFIG_IPC_NS. That also fixes
CONFIG_SYSVIPC=n, CONFIG_POSIX_MQUEUE=y, CONFIG_IPC_NS=y where
ipc/shm.c isn't built and init_ipc_ns was never added at all. For the
network namespace only call ns_tree_add_raw() if CONFIG_NET_NS is set.
Without CONFIG_NET_NS cleanup_net() isn't built and init_net is never
removed so there's nothing to balance.

Fixes: 74b24a582e1f ("ipc: support ns lookup")
Fixes: 195f7422298d ("net: support ns lookup")
Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202610260917.6248e316-lkp@intel.com
Cc: stable@vger.kernel.org # v6.18+
Link: https://patch.msgid.link/20261030-work-nsfs-init_ns_tree-v1-1-7ec0adb47c54@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/namespace.c          | 7 +++++++
 ipc/shm.c                | 2 --
 net/core/net_namespace.c | 4 +++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index 75aa7b4693484..b54d23fd83d70 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -255,3 +255,10 @@ const struct proc_ns_operations ipcns_operations = {
 	.install	= ipcns_install,
 	.owner		= ipcns_owner,
 };
+
+static int __init ipc_ns_tree_init(void)
+{
+	ns_tree_add(&init_ipc_ns);
+	return 0;
+}
+pure_initcall(ipc_ns_tree_init);
diff --git a/ipc/shm.c b/ipc/shm.c
index 6862f681373f1..83ac223352ba5 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -45,7 +45,6 @@
 #include <linux/mount.h>
 #include <linux/ipc_namespace.h>
 #include <linux/rhashtable.h>
-#include <linux/nstree.h>
 
 #include <linux/uaccess.h>
 
@@ -149,7 +148,6 @@ void shm_exit_ns(struct ipc_namespace *ns)
 static int __init ipc_ns_init(void)
 {
 	shm_init_ns(&init_ipc_ns);
-	ns_tree_add(&init_ipc_ns);
 	return 0;
 }
 
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index da5f881fbd3b9..52c2bd44778a8 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -447,7 +447,9 @@ static __net_init int setup_net(struct net *net)
 	down_write(&net_rwsem);
 	list_add_tail_rcu(&net->list, &net_namespace_list);
 	up_write(&net_rwsem);
-	ns_tree_add_raw(net);
+	/* Without CONFIG_NET_NS init_net isn't exposed as a namespace. */
+	if (IS_ENABLED(CONFIG_NET_NS))
+		ns_tree_add_raw(net);
 out:
 	return error;
 
-- 
2.53.0



