Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286B3158D9C;
	Mon, 29 Jan 2024 17:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548148; cv=none; b=R0Nxk3d544JfNuhbnhFreWE9GsVbQ4IUNAelr8P9OcByWFtEsbNppG4M6lAaQmSP756VQKZT+R+v8OLfOb1EvRmMv/U6Vzn+7xSbHP6qAAnwgLQHa/256I4/b72tDAHKdW99cK37lB1StPQtnQnaHNg2JqqFJtyANea1vdssoJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548148; c=relaxed/simple;
	bh=9Vm/M11261Vp0lVlmffKd83uBy3s1s1iQc3QRNrn6tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKTmLj1PmPtlW+ducPcG8S4GDN3HNuY5BRM5Z8FF8cjRVSJ71Ilf7qhxjjxNrJZTFegUD9YNlpW5alDL57uMHrfrzPQXistgkwsrDP2MzqKvNzOBDqMfuQL/zoYnokn6VTk8Hc3G+pe/2b4mlMGO/97yWoE1X7Ayxhv7w8+2mRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uy7SvUHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uy7SvUHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4182C43394;
	Mon, 29 Jan 2024 17:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548148;
	bh=9Vm/M11261Vp0lVlmffKd83uBy3s1s1iQc3QRNrn6tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uy7SvUHNmAIDgl/Xr4ax3kGVBBdRA9KP3qvrLksPmDf4RrOCbTQt2tZ8wJ4cVj445
	 YiCkK32peJxmwCpbpekYCCYo5Vgr1V8dAQMz/Ueejk8eU/tCQVyguEfT8sImmO85Cc
	 IPHPBHGmPE+jNGr8OPdxq5oWtolKQttuA2oZ9bkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 184/346] selftests: fill in some missing configs for net
Date: Mon, 29 Jan 2024 09:03:35 -0800
Message-ID: <20240129170021.808286495@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 04fe7c5029cbdbcdb28917f09a958d939a8f19f7 ]

We are missing a lot of config options from net selftests,
it seems:

tun/tap:     CONFIG_TUN, CONFIG_MACVLAN, CONFIG_MACVTAP
fib_tests:   CONFIG_NET_SCH_FQ_CODEL
l2tp:        CONFIG_L2TP, CONFIG_L2TP_V3, CONFIG_L2TP_IP, CONFIG_L2TP_ETH
sctp-vrf:    CONFIG_INET_DIAG
txtimestamp: CONFIG_NET_CLS_U32
vxlan_mdb:   CONFIG_BRIDGE_VLAN_FILTERING
gre_gso:     CONFIG_NET_IPGRE_DEMUX, CONFIG_IP_GRE, CONFIG_IPV6_GRE
srv6_end_dt*_l3vpn:   CONFIG_IPV6_SEG6_LWTUNNEL
ip_local_port_range:  CONFIG_MPTCP
fib_test:    CONFIG_NET_CLS_BASIC
rtnetlink:   CONFIG_MACSEC, CONFIG_NET_SCH_HTB, CONFIG_XFRM_INTERFACE
             CONFIG_NET_IPGRE, CONFIG_BONDING
fib_nexthops: CONFIG_MPLS, CONFIG_MPLS_ROUTING
vxlan_mdb:   CONFIG_NET_ACT_GACT
tls:         CONFIG_TLS, CONFIG_CRYPTO_CHACHA20POLY1305
psample:     CONFIG_PSAMPLE
fcnal:       CONFIG_TCP_MD5SIG

Try to add them in a semi-alphabetical order.

Fixes: 62199e3f1658 ("selftests: net: Add VXLAN MDB test")
Fixes: c12e0d5f267d ("self-tests: introduce self-tests for RPS default mask")
Fixes: 122db5e3634b ("selftests/net: add MPTCP coverage for IP_LOCAL_PORT_RANGE")
Link: https://lore.kernel.org/r/20240122203528.672004-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 8da562a9ae87..19ff75051660 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -1,5 +1,6 @@
 CONFIG_USER_NS=y
 CONFIG_NET_NS=y
+CONFIG_BONDING=m
 CONFIG_BPF_SYSCALL=y
 CONFIG_TEST_BPF=m
 CONFIG_NUMA=y
@@ -14,9 +15,13 @@ CONFIG_VETH=y
 CONFIG_NET_IPVTI=y
 CONFIG_IPV6_VTI=y
 CONFIG_DUMMY=y
+CONFIG_BRIDGE_VLAN_FILTERING=y
 CONFIG_BRIDGE=y
+CONFIG_CRYPTO_CHACHA20POLY1305=m
 CONFIG_VLAN_8021Q=y
 CONFIG_IFB=y
+CONFIG_INET_DIAG=y
+CONFIG_IP_GRE=m
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NF_CONNTRACK=m
@@ -25,15 +30,36 @@ CONFIG_IP6_NF_IPTABLES=m
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP6_NF_NAT=m
 CONFIG_IP_NF_NAT=m
+CONFIG_IPV6_GRE=m
+CONFIG_IPV6_SEG6_LWTUNNEL=y
+CONFIG_L2TP_ETH=m
+CONFIG_L2TP_IP=m
+CONFIG_L2TP=m
+CONFIG_L2TP_V3=y
+CONFIG_MACSEC=m
+CONFIG_MACVLAN=y
+CONFIG_MACVTAP=y
+CONFIG_MPLS=y
+CONFIG_MPTCP=y
 CONFIG_NF_TABLES=m
 CONFIG_NF_TABLES_IPV6=y
 CONFIG_NF_TABLES_IPV4=y
 CONFIG_NFT_NAT=m
+CONFIG_NET_ACT_GACT=m
+CONFIG_NET_CLS_BASIC=m
+CONFIG_NET_CLS_U32=m
+CONFIG_NET_IPGRE_DEMUX=m
+CONFIG_NET_IPGRE=m
+CONFIG_NET_SCH_FQ_CODEL=m
+CONFIG_NET_SCH_HTB=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_NETEM=y
+CONFIG_PSAMPLE=m
+CONFIG_TCP_MD5SIG=y
 CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_KALLSYMS=y
+CONFIG_TLS=m
 CONFIG_TRACEPOINTS=y
 CONFIG_NET_DROP_MONITOR=m
 CONFIG_NETDEVSIM=m
@@ -48,7 +74,9 @@ CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
 CONFIG_CRYPTO_SM4_GENERIC=y
 CONFIG_AMT=m
+CONFIG_TUN=y
 CONFIG_VXLAN=m
 CONFIG_IP_SCTP=m
 CONFIG_NETFILTER_XT_MATCH_POLICY=m
 CONFIG_CRYPTO_ARIA=y
+CONFIG_XFRM_INTERFACE=m
-- 
2.43.0



