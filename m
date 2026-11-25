Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619658;
	b=kR8k0B7hyJbtyjWNNJh2Uz9GtcpBYFwFJkRD7raRTYkYo1GmlpFOAOHfG8kWoFwDq8/s
	 ySsZ4YDVxLw+af/xXAxCfW1+WPEhd4zS2qbMru/O6rIkgC+efacHEjwspa17Fr4oQsA+M
	 12rv/lMXziiIwYQ2iznwpOmIv+iVhkm2pPMDwxDu6Nm0iz6HPBbDdh1oKfPd4GhMV+lUt
	 Zr5RM40iH0AOVBC6nP/9rlb68ur5GCFxlHsrB7HSHkmO07F/ZMTe8e+W41aWydDQW7bD7
	 g99of6AvrrL5/61okbJ18F78gT2Zct9y+wsF0e88Bx5iStbDW3iRgyt70Xw08bHlpWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+QnW2t9PpIGk0/afcjJBIis7UImz7+oncjR9eqMF7po=;
	b=l9lrbt4SdmWXTxhwf4dzxbHbvJ7BphAuvjsYxt4gRnuN5XAj2r/i2tkGbo2WxxPsPEol
	 HgPGp8FYqBI4U9SnuMEbk+8/NmpH/5janPxLMOQ/vZ3YIAacjA51COweLbsW7ka8H1yF4
	 O2Grq9BMo/4QFMYgahtD4+b/xh2lZGVDqmMteKVXEGl7JjGrd0TBIEfXLfsC60Fz8GTaV
	 hO4nBa2bE51GrTeh0Ey/5hdCfmzJRDO8W0B2tvgABoQlrcYL3EMd/5cGjGESe+j6B4mhd
	 Yzu21J0CAefeF6yNRJrYQu0PwkNyo+lICypcNWfGXaFiI2ryhRskzZF7kf8YrDnS4ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwtbiqPi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75DE606A329;
	Wed, 25 Nov 2026 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwtbiqPi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3861F000CF;
	Wed, 25 Nov 2026 15:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619658;
	bh=+QnW2t9PpIGk0/afcjJBIis7UImz7+oncjR9eqMF7po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwtbiqPij0i+nWSQU3O5bPKxyMeuvRwxNJFjXHeighS4A2gj/VkbaYoFGAvfC/6Mh
	 oHZTId3IvbNqAQTtEhazQ/tPRWAqno4wn9bc4K9Le3UAhH784scNCehByc7ylronZF
	 TWwOtvpVSE2AXaBzXfVbSCNGu/ZeARvahYDM0sMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1269fe6cc2016008124e@syzkaller.appspotmail.com,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Naman Gulati <namangulati@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0668/1005] net: wait for in-flight device unregistrations before netns dismantle
Date: Wed, 25 Nov 2026 15:33:26 +0100
Message-ID: <20261125143837.398963993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

commit c164a431a646983275d0076ff5b0e4c326fbc10b upstream.

A device can be unregistered by a context other than the cleanup_net()
of its own netns, for instance a veth whose peer in another netns is
deleted. If references on it are still held, it stays in
netdev_wait_allrefs_any(), which rebroadcasts NETDEV_UNREGISTER every
second.

Meanwhile its netns can be dismantled: default_device_exit_batch()
only takes care of devices still listed in the netns, then pernet exit
handlers free their state, and finally struct net is freed while the
device still points to it.

The rebroadcasts then run notifiers against torn down pernet state, or
freed memory. Three instances were reported so far:

 - netdev_genl_netdevice_event(): net->genl_sock is NULL [1]
 - nh_netdev_event(): net->nexthop.devhash is NULL [2]
 - nf_tables netdevice notifiers: use-after-free of the nftables
   pernet storage [3]

but any notifier using dev_net(dev) is affected, as is
netdev_wait_allrefs_any() itself (__rtnl_net_lock(dev_net(dev)) with
CONFIG_DEBUG_NET_SMALL_RTNL=y).

This was prevented by rtnl_lock_unregistering() until I removed it
in commit 8a4fc54b07d7 ("net: get rid of rtnl_lock_unregistering()"),
considering only the loopback dependency, and missing the notifiers one.

Restore a per-netns counter of devices sitting in netdev_run_todo(),
and make default_device_exit_batch() wait for it to reach zero, after
it has unregistered all devices of the dying netns(es). At this point
no new unregistration can be started for these netns.

Unlike the old barrier, this only waits for devices of the netns being
dismantled and runs after their own devices are gone.

Tested on a KASAN kernel with a debug-only hack holding a reference
on a veth device for 5 seconds after its unregistration: a nexthop
on the veth in netns X, delete its peer from init_net, then delete X.
Without this patch, the nexthop_flush_dev() null-ptr-deref from [2]
triggers. With it, no splat; netns churn and dismantle of a netns
whose own device is held still work.

[1] https://lore.kernel.org/netdev/6adf9f64.6200f071.51519.0ed1.GAE@google.com/
[2] https://lore.kernel.org/netdev/20261105114707.3030737-1-bsdhenrymartin@gmail.com/
[3] https://lore.kernel.org/netdev/20261105114817.3033625-1-bsdhenrymartin@gmail.com/

Fixes: 8a4fc54b07d7 ("net: get rid of rtnl_lock_unregistering()")
Cc: stable@vger.kernel.org
Reported-by: syzbot+1269fe6cc2016008124e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6adf9f64.6200f071.51519.0ed1.GAE@google.com/
Reported-by: Henry Martin <bsdhenrymartin@gmail.com>
Closes: https://lore.kernel.org/netdev/20261105114707.3030737-1-bsdhenrymartin@gmail.com/
Closes: https://lore.kernel.org/netdev/20261105114817.3033625-1-bsdhenrymartin@gmail.com/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Naman Gulati <namangulati@google.com>
Link: https://patch.msgid.link/20261105144543.1624238-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/net_namespace.h |    1 +
 net/core/dev.c              |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -69,6 +69,7 @@ struct net {
 	spinlock_t		rules_mod_lock;
 
 	unsigned int		dev_base_seq;	/* protected by rtnl_mutex */
+	atomic_t		dev_unreg_pending; /* devices in netdev_run_todo() */
 	u32			ifindex;
 
 	spinlock_t		nsid_lock;
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11007,6 +11007,14 @@ atomic_t dev_unreg_count = ATOMIC_INIT(0
 static void net_set_todo(struct net_device *dev)
 {
 	list_add_tail(&dev->todo_list, &net_todo_list);
+	atomic_inc(&dev_net(dev)->dev_unreg_pending);
+}
+
+/* Paired with net_set_todo(). @net must not be used after this call. */
+static void net_unreg_done(struct net *net)
+{
+	if (atomic_dec_and_test(&net->dev_unreg_pending))
+		wake_up(&netdev_unregistering_wq);
 }
 
 static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
@@ -11890,6 +11898,7 @@ void netdev_run_todo(void)
 		if (unlikely(dev->reg_state != NETREG_UNREGISTERING)) {
 			netdev_WARN(dev, "run_todo but not unregistering\n");
 			list_del(&dev->todo_list);
+			net_unreg_done(dev_net(dev));
 			continue;
 		}
 
@@ -11906,8 +11915,11 @@ void netdev_run_todo(void)
 
 	cnt = 0;
 	while (!list_empty(&list)) {
+		struct net *net;
+
 		dev = netdev_wait_allrefs_any(&list);
 		list_del(&dev->todo_list);
+		net = dev_net(dev);
 
 		/* paranoia */
 		BUG_ON(netdev_refcnt_read(dev) != 1);
@@ -11928,6 +11940,8 @@ void netdev_run_todo(void)
 
 		/* Free network device */
 		kobject_put(&dev->dev.kobj);
+
+		net_unreg_done(net);
 	}
 	if (cnt && atomic_sub_and_test(cnt, &dev_unreg_count))
 		wake_up(&netdev_unregistering_wq);
@@ -13372,6 +13386,17 @@ static void __net_exit default_device_ex
 	}
 }
 
+static bool __net_exit netns_dev_unreg_pending(const struct list_head *net_list)
+{
+	struct net *net;
+
+	list_for_each_entry(net, net_list, exit_list) {
+		if (atomic_read(&net->dev_unreg_pending))
+			return true;
+	}
+	return false;
+}
+
 static void __net_exit default_device_exit_batch(struct list_head *net_list)
 {
 	/* At exit all network devices most be removed from a network
@@ -13413,6 +13438,16 @@ static void __net_exit default_device_ex
 	unregister_netdevice_many(&dev_kill_list);
 	rtnl_unlock();
 
+	/* Devices of these netns unregistered from another context
+	 * (e.g. a veth whose peer was deleted) can still be waiting
+	 * in netdev_run_todo() for their last references, while
+	 * NETDEV_UNREGISTER is rebroadcast for them. Wait for them
+	 * before pernet exit handlers tear down the state used by
+	 * netdevice notifiers, and before the netns is freed.
+	 * No new unregistration can start: all devices are unlisted.
+	 */
+	wait_event(netdev_unregistering_wq, !netns_dev_unreg_pending(net_list));
+
 	rtnl_net_flush_workqueue();
 }
 


