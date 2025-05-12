Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1E0D528
	for <patches@lists.linux.dev>; Mon, 12 May 2025 02:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747016063; cv=none; b=k+nydmGJiEyU9/Sdwy5+Q6GA/3FxsvsjuB9lcvdTRdJI5UblFD7IziZjCGEm192oZLBwL1MNd2gP40agMeBMchD1W+VeDCX+4bxBEM/aDhQTfmxD2uoPHWJumHM0GM9YR12o8MdA3IIDpxh+TrJU2MXpcn9Q0GdY+O9t+BxBT5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747016063; c=relaxed/simple;
	bh=pnxU2CEJKSdncR1tk3EpHMB0Cwdhj1DDOuUob/OYeMQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GWwE72H5mCYtxtoyB5y4R9odzHDBhCgEsoDMkIuLRl+u2D99USKqEqP9h6vKGXQyuRc+Uo3u+VT+F2Fv/MP/1aRuf44NfHaJbSA61OCk8ZXb+hJeP2itJrKHsSqxTuiulX2bq6ng9GdD68WJzOvcY4dvfdj5+/kDZzXE/uaWcKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54C2BXPJ012129;
	Sun, 11 May 2025 19:14:00 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 46j233h3yk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Sun, 11 May 2025 19:14:00 -0700 (PDT)
Received: from ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Sun, 11 May 2025 19:13:59 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Sun, 11 May 2025 19:13:56 -0700
From: <jianqi.ren.cn@windriver.com>
To: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <jianqi.ren.cn@windriver.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <shuah@kernel.org>, <shmulik.ladkani@gmail.com>,
        <netdev@vger.kernel.org>, <dcaratti@redhat.com>
Subject: [PATCH 6.1.y] net/sched: act_mirred: use the backlog for mirred ingress
Date: Mon, 12 May 2025 10:13:55 +0800
Message-ID: <20250512021355.3327681-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=EojSrTcA c=1 sm=1 tr=0 ts=68215968 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=A7XncKjpAAAA:8 a=J1Y8HTJGAAAA:8 a=t7CeM3EgAAAA:8
 a=--JntEdgB-XHV1fWJyUA:9 a=R9rPLQDAdC6-Ub70kJmZ:22 a=y1Q9-5lHfBjTkpIzbSAN:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDAyMSBTYWx0ZWRfXzDyHjivNP+jo 3KQKYOQIER5TsAjwSYU3Yq3+iXEAnyTsWiY4Y5zh/4ImoT3uPxwSeK/FfE1EFQMqB/WU5AJl/XT tluMA4Kllhjyeenso1UU40nZ7lpqnYNjsXZ5WzSVMrqAPQrQN7KeSfWe1+kCcGVFWvy68axNWk6
 V+GkPeMtZGymZTREHCUjTpepfOrnjHT8PP1d9n6Ha9KD8PAtFnK6ZB5+mFm4Hwfq+6qebu0/T9v v5W16v6Rv67vSQ9lpr9MauKSAGagzRHS43BS8EkVzncpR7zMj3EBFYA+ysLU/gqI1BasO3wZqun qGo4eBui/fonHYW1DHm/rms1Yb71VYEW3v593QdpwSphY0yAdQmiY4cHvYu38GElpzNNeHSVWeS
 NJLIMBZZCJJPiGOccPuUL5IyNjQpIIp/Lk71kl8oivj/tiZU1ghE+vdc+e7p5DdNn5y8fIP5
X-Proofpoint-GUID: dardaHlfkVJzYoR8YHIW5l_o7Ab7dOUM
X-Proofpoint-ORIG-GUID: dardaHlfkVJzYoR8YHIW5l_o7Ab7dOUM
X-Sensitive_Customer_Information: Yes
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-11_10,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 adultscore=0
 impostorscore=0 clxscore=1011 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.21.0-2504070000
 definitions=main-2505120021

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
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 net/sched/act_mirred.c                             | 14 +++++---------
 .../testing/selftests/net/forwarding/tc_actions.sh |  3 ---
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index bbc34987bd09..896bffd50aa8 100644
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
index b0f5e55d2d0b..589629636502 100755
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
2.34.1

