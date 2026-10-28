Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213659;
	b=YjVoOjX8MyBBzx600Xl7pT+ueFWpQZ5FXkmuQ2HgEaN1/e7/en2kv0MZr3WzkADK05gN
	 xhevQXyte9+QJ98OHPdj7t/JdphOKnstR14d0Hikrb4F+CIOSlkYjW4XuHEUfLq5gESXr
	 Xj+FBCY2z4tz5nqesgNv9U9L950axa0fKwGR3/regXpDISGCmQGjJUbpFr+8due1lzQ0X
	 HJFjQSSOwOSbhZ8+jEEK+rVMEObVR4q4Za9tVXVlW1W/8GCZ4HZJTIJdt5sRHbgmPTHuN
	 +O43GggRFRtKxAY/dBBoOKivxBpV2kvQUDN7PhuehQ5/GZMba9qCzJF4YQd4/KtIT3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ARP64Dp5tT8T1v0JAfsffKWIY9Hob/ZzgTQQ0UdPnE=;
	b=MzdvWQLtSLLVoeHjXfJUzZU5pn+xzvwItokKl/B6u0Z0MJ0Erpg+7f90d1y1IIJEtKYg
	 7FGlJnO+QtulgsGsks2tfOg3YWF/ANen7g9f/sUBbizcE6TnIvTfVReHMrN09DrgcfhWu
	 VtY1BcYUKyUEdn7YYVVTo+0CYWChvPEkwAmGYCqYHCWi5tSlrtrPFIayEREUBhQ+STRjr
	 RgEsNxXVdKgTgl303mem+nalVo4dZzpKQVEj5ajj/hqyWZamB4GQdd3R4VSbi+SR97cL7
	 CbhU16rzWDglpZFNiYepRQ1mIvi0XA5spmkc4xPnJpY5wUWVqOvEGxBhj/SsMqV/Cjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5621ptY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B85606A31F;
	Wed, 28 Oct 2026 18:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z5621ptY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE931F01825;
	Wed, 28 Oct 2026 18:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213659;
	bh=9ARP64Dp5tT8T1v0JAfsffKWIY9Hob/ZzgTQQ0UdPnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z5621ptYPErscKwRmHvPHeoLOSnT8vgWaiIrmVZ+6FhcJKGYLEa/5nvB42dD8sbBm
	 R9fw4hOFF3aowojVEoswKFOvC0mBF4oZnZfWh33Fjx4rkt/vm3AgoUPpNy8EG7vyNX
	 MrREHeEoTbUBqE9piuZEyPvWmAJtrLzdcHemBQ6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0585/1887] net/sched: act_mirred: use the backlog for mirred ingress
Date: Wed, 28 Oct 2026 17:44:41 +0100
Message-ID: <20261028170512.735330240@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 52f671db18823089a02f07efc04efdb2272ddc17 ]

The test Davide added in commit ca22da2fbd69 ("act_mirred: use the backlog
for nested calls to mirred ingress") hangs our testing VMs every 10 or so
runs, with the familiar tcp_v4_rcv -> tcp_v4_rcv deadlock reported by
lockdep.

The problem as previously described by Davide (see Link) is that
if we reverse flow of traffic with the redirect (egress -> ingress)
we may reach the same socket which generated the packet. And we may
still be holding its socket lock. The common solution to such deadlocks
is to put the packet in the Rx backlog, rather than run the Rx path
inline. Do that for all egress -> ingress reversals, not just once
we started to nest mirred calls.

In the past there was a concern that the backlog indirection will
lead to loss of error reporting / less accurate stats. But the current
workaround does not seem to address the issue.

Fixes: 53592b364001 ("net/sched: act_mirred: Implement ingress actions")
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Suggested-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/netdev/33dc43f587ec1388ba456b4915c75f02a8aae226.1663945716.git.dcaratti@redhat.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_mirred.c                             | 14 +++++---------
 .../testing/selftests/net/forwarding/tc_actions.sh |  3 ---
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index bbc34987bd09b..896bffd50aa8b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -205,18 +205,14 @@ static int tcf_mirred_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
-static bool is_mirred_nested(void)
-{
-	return unlikely(__this_cpu_read(mirred_nest_level) > 1);
-}
-
-static int tcf_mirred_forward(bool want_ingress, struct sk_buff *skb)
+static int
+tcf_mirred_forward(bool at_ingress, bool want_ingress, struct sk_buff *skb)
 {
 	int err;
 
 	if (!want_ingress)
 		err = tcf_dev_queue_xmit(skb, dev_queue_xmit);
-	else if (is_mirred_nested())
+	else if (!at_ingress)
 		err = netif_rx(skb);
 	else
 		err = netif_receive_skb(skb);
@@ -312,7 +308,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 
 		/* let's the caller reinsert the packet, if possible */
 		if (use_reinsert) {
-			err = tcf_mirred_forward(want_ingress, skb);
+			err = tcf_mirred_forward(at_ingress, want_ingress, skb);
 			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
 			__this_cpu_dec(mirred_nest_level);
@@ -320,7 +316,7 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 		}
 	}
 
-	err = tcf_mirred_forward(want_ingress, skb2);
+	err = tcf_mirred_forward(at_ingress, want_ingress, skb2);
 	if (err)
 		tcf_action_inc_overlimit_qstats(&m->common);
 	__this_cpu_dec(mirred_nest_level);
diff --git a/tools/testing/selftests/net/forwarding/tc_actions.sh b/tools/testing/selftests/net/forwarding/tc_actions.sh
index b0f5e55d2d0b2..5896296365022 100755
--- a/tools/testing/selftests/net/forwarding/tc_actions.sh
+++ b/tools/testing/selftests/net/forwarding/tc_actions.sh
@@ -235,9 +235,6 @@ mirred_egress_to_ingress_tcp_test()
 	check_err $? "didn't mirred redirect ICMP"
 	tc_check_packets "dev $h1 ingress" 102 10
 	check_err $? "didn't drop mirred ICMP"
-	local overlimits=$(tc_rule_stats_get ${h1} 101 egress .overlimits)
-	test ${overlimits} = 10
-	check_err $? "wrong overlimits, expected 10 got ${overlimits}"
 
 	tc filter del dev $h1 egress protocol ip pref 100 handle 100 flower
 	tc filter del dev $h1 egress protocol ip pref 101 handle 101 flower
-- 
2.53.0



