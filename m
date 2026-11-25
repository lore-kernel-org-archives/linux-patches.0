Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623045;
	b=ew3cQhya3OZ9ce2H/Dz17a8b5pV6N8wCQH+BcuBasLRFuqwMKVqT+kuyn3TMUEbQTB97
	 VDPU1Mn7e4zHhINE7ZD6hlg2kKtgvJ/rOUHsNBD6ED1kUvU7Fwc/HzMo7euA7ImpHh6cF
	 eymOK4OP70hyPlaJ5Ke1f5sGnm7f54tlSauO6Aqh0QUMyA0oDMDrLreIKp4v7ywz6o+zg
	 kvOE3QR6JXTlmKSnRgPxaIh/d4K/7kVI9qeQvYHF3Mp3k0YXpcxa38Eg/rn6ht8rswy6/
	 zs7vsCrxoq1h2mbZi4uArx+4jCHiklYNX2avAK/76nx3g4i2n1CZw6/YTnsQQt+RTpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3OGvGEgz5kzEBikwfLOc7TKceV7v+UMZu0wBnHogW0c=;
	b=ud1zo2+F7vnhBTeBDDFe6fvSPcvLo3MR/okAZyMWuqEE7ECBnQ6DxWGhm6RK8az/7i22
	 LOzzMhlKYTHA3OBQyps31wsQ1uCiLraEALZHFffV7QCsa/nmjP4cclPlnBw5drZ25M8a1
	 DkDAPq1P+5iUr4Yey8Ao38/kdzGERv3xeiK+BYSaX0E3R6hUy9rO0Xvog5+/Dt6TjqX+U
	 oNhwUIuHdXVjLLlQ5MUuY/n2shS6RcUuTPVq2JkH/LKttl3eVgWa7uBXwrsf7zAXkzk61
	 a5iiRy7XQZfrcGCkID1TgsUthYQcAcrvhvmzOuxKz1gWmFnPESbRL9dlu0B+8poc/cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YImYIS/I";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C101606A333;
	Wed, 25 Nov 2026 16:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YImYIS/I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA35B1F000C0;
	Wed, 25 Nov 2026 16:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623045;
	bh=3OGvGEgz5kzEBikwfLOc7TKceV7v+UMZu0wBnHogW0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YImYIS/IuI6DvEIGHz3PEIvjbwomHJRZFJzjKtFjb8FkDCAHT83ngRBVQ6ewLE5ve
	 XY8WwqtVKBf2Y60Dlqsc1VJzd8izmfZqVaWeKLz7coXNcOpU9Ij1/QjIhgSrSJbs/1
	 iJNEH5WRkdfB1MfH1spw28R/u4O6oiX1lR+uoXIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 730/990] net/sched: sch_teql: reject qdiscs from another network namespace
Date: Wed, 25 Nov 2026 15:34:57 +0100
Message-ID: <20261125143839.169590017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

commit 1ae84bdd736f8fab30180159996e1d193f8029ff upstream.

Reported by shaos <shawnq1@163.com> with a reproducer, which was
reproduced and verified in our test environment.

The issue:
The teql master devices are created once in the initial network
namespace and their Qdisc_ops are global. teql_qdisc_init() takes the
teql_master embedded in the registered sch->ops and uses it without
checking whether the new qdisc's device lives in the same network
namespace as the master. A qdisc created in another netns can therefore
attach to the init-net master and change its MTU and flags.

The Fix:
Reject a teql qdisc whose device is not in the master's network
namespace with -EOPNOTSUPP and an extack message; same-netns teql still
works.

Initialize the private skb queue before any validation so every
constructor failure path, including qdisc_create_dflt(), which resets the
qdisc before destroying it, sees an initialized empty queue.

Conditions to recreate the bug:
CONFIG_NET_SCH_TEQL=y, CONFIG_DUMMY=y, CONFIG_USER_NS=y, CONFIG_NET_NS=y.
As an unprivileged UID, unshare a user and network namespace, create a
dummy device, set its MTU to 60000, and add a root teql0 qdisc:

  unshare -Urn
  ip link add dummy0 type dummy
  ip link set dummy0 mtu 60000
  tc qdisc add dev dummy0 root teql0

The init-net teql0 device changes from MTU 1500 to 60000. A pfifo control
on the same device leaves the MTU unchanged, and a direct MTU change on
init-net teql0 is denied. The namespace needs CAP_NET_ADMIN; no init-net
privilege is required. With the fix the attach fails with
"Operation not supported" and the init-net MTU stays 1500.

Fixes: 7316ae88c43d ("net_sched: make traffic control network namespace aware")
Reported-by: shaos <shawnq1@163.com>
Link: https://lore.kernel.org/netdev/20261022144830.67948-1-shawnq1@163.com/
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/SER-NSBD.v1.r2.20261031160050-3%40mojatatu.com
Link: https://lore.kernel.org/netdev/179366641863.488856.17368571591466000274@kernel.org/
Cc: stable@vger.kernel.org
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/SER-NSBD.v3.r0.20261103064310-3@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_teql.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -198,6 +198,8 @@ static int teql_qdisc_init(struct Qdisc
 	struct Qdisc *first;
 	unsigned long flags;
 
+	skb_queue_head_init(&q->q);
+
 	if (dev->hard_header_len > m->dev->hard_header_len)
 		return -EINVAL;
 
@@ -209,9 +211,12 @@ static int teql_qdisc_init(struct Qdisc
 		return -EOPNOTSUPP;
 	}
 
-	q->m = m;
+	if (dev_net(dev) != dev_net(m->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "teql master is in a different network namespace");
+		return -EOPNOTSUPP;
+	}
 
-	skb_queue_head_init(&q->q);
+	q->m = m;
 
 	raw_spin_lock_irqsave(&m->slaves_lock, flags);
 	first = rcu_dereference_protected(m->slaves, lockdep_is_held(&m->slaves_lock));


