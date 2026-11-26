Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705449;
	b=i6VTgEGZmWFELZrykxYLA6qQJDDuRxRFCQAdxIW9rSxYKU9g02SYLjjelZfhh8X3qQLk
	 xn434Do6D0yqMsb91dqHs9IVPvCppi2Kit9y50E9zH66i3lio1avSwl7wkf+y/1TBQycP
	 KfTX/evsk8huzmXX0LdwBPCl6WivvnGca0js5qw3YaD5Dv6UBxbUPy7z52ClqXRIOOAsz
	 1txlcYfFsuwuQuw6ZBRV4o92v2PEAjhytrEfa/VEQQhu1lJPgoJgcV7rIolTjvVIq9kzI
	 3SGzE8i9d4JmIxn6IVaUaA76hztEwufmzGUIQbVQ1GNps9QpSzfEqDArjg/1Lq/I+zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O7rTs7exTVEoyNAn+p1BZsa7iHfG7IhkhJt8MCy+9Ng=;
	b=L/wyQ3HXc38TH/eYmaCtCdxXfv1sF2H8q9JdenIXV5lvtSLYLGMSbJXyKX0qA6k6+uDE
	 1DQqAWldBHumPL30dE/QBaXbc/sG45nmvepjnbHHAKMoiYgfwtooftq1lpeYLsyo4ZWhH
	 WhUQm4PbYIiM3uRJcftXwiHHfe5ecH77tlTKh8+Po+u4CcO5kcTLZFbBQ7yyLy2waBTwg
	 aznhMW4EpFNm0tBU+EVYD4qEBz+hXopqbmIlJzYSxN0ee/2vBbkUVPuZ/lc0tUHYboC6S
	 qhYdg3o4ytsh01NOvOnXHw8bRFSHHlbq9uEUYw5hqMNX5iyEcN8C0HedlATRilx6uhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AeFqhuiK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A7A606A31C;
	Thu, 26 Nov 2026 15:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AeFqhuiK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707BA1F000E1;
	Thu, 26 Nov 2026 15:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705448;
	bh=O7rTs7exTVEoyNAn+p1BZsa7iHfG7IhkhJt8MCy+9Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AeFqhuiKPomzVEe2AgI1VA4UGxbWV3cqMaamG5aioGz0nk5WgLGWpoe40mta51PB1
	 H36wkEHKSJyr4L3NnJkvAxFBgG6GQl9+lHuOs8WM0BD4D3NHAn8/EjAFkwSMSf5P8W
	 YFGsqQDBv7b3a1Kyrg8FK1Ku8K6511CvjYkPF6xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	shaos <shawnq1@163.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 201/319] net/sched: sch_teql: reject qdiscs from another network namespace
Date: Thu, 26 Nov 2026 15:39:29 +0100
Message-ID: <20261126144011.282013111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -172,6 +172,8 @@ static int teql_qdisc_init(struct Qdisc
 	struct teql_master *m = (struct teql_master *)sch->ops;
 	struct teql_sched_data *q = qdisc_priv(sch);
 
+	skb_queue_head_init(&q->q);
+
 	if (dev->hard_header_len > m->dev->hard_header_len)
 		return -EINVAL;
 
@@ -183,9 +185,12 @@ static int teql_qdisc_init(struct Qdisc
 		return -EOPNOTSUPP;
 	}
 
-	q->m = m;
+	if (dev_net(dev) != dev_net(m->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "teql master is in a different network namespace");
+		return -EOPNOTSUPP;
+	}
 
-	skb_queue_head_init(&q->q);
+	q->m = m;
 
 	if (m->slaves) {
 		if (m->dev->flags & IFF_UP) {


