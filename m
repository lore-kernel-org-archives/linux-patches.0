Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F92C2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0547BC433EF;
	Tue, 18 Apr 2023 12:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821301;
	bh=B6hTYp9WM+dRwzj5L5Ake9t1Q1Gp4dRHWBGCID7B4Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otJ3zaoo9n+XBkBo5WcNvF/MQbnu9d8k6HDRb8Ca7UKFbmKLTAxlTDscPhSoFwOLz
	 Qo65K73q+3kqiT1zNZh73izpicCqEwnJgYHWLBm+8JNa4ENQ+8CX+ZeDwnaJmr79/P
	 0CCTV//NpP7kTvtI+g4rm0pbYwghgUax5BLXPFIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/124] ipv4: shrink netns_ipv4 with sysctl conversions
Date: Tue, 18 Apr 2023 14:21:34 +0200
Message-Id: <20230418120312.591112824@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4b6bbf17d4e1939afa72821879fc033d725e9491 ]

These sysctls that can fit in one byte instead of one int
are converted to save space and thus reduce cache line misses.

 - icmp_echo_ignore_all, icmp_echo_ignore_broadcasts,
 - icmp_ignore_bogus_error_responses, icmp_errors_use_inbound_ifaddr
 - tcp_ecn, tcp_ecn_fallback
 - ip_default_ttl, ip_no_pmtu_disc, ip_fwd_use_pmtu
 - ip_nonlocal_bind, ip_autobind_reuse
 - ip_dynaddr, ip_early_demux, raw_l3mdev_accept
 - nexthop_compat_mode, fwmark_reflect

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: dc5110c2d959 ("tcp: restrict net.ipv4.tcp_app_win")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/ipv4.h   | 32 +++++++++----------
 net/ipv4/sysctl_net_ipv4.c | 64 +++++++++++++++++++-------------------
 2 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 75484f425e558..92e3d8fe954ab 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -84,36 +84,36 @@ struct netns_ipv4 {
 	struct xt_table		*nat_table;
 #endif
 
-	int sysctl_icmp_echo_ignore_all;
-	int sysctl_icmp_echo_ignore_broadcasts;
-	int sysctl_icmp_ignore_bogus_error_responses;
+	u8 sysctl_icmp_echo_ignore_all;
+	u8 sysctl_icmp_echo_ignore_broadcasts;
+	u8 sysctl_icmp_ignore_bogus_error_responses;
+	u8 sysctl_icmp_errors_use_inbound_ifaddr;
 	int sysctl_icmp_ratelimit;
 	int sysctl_icmp_ratemask;
-	int sysctl_icmp_errors_use_inbound_ifaddr;
 
 	struct local_ports ip_local_ports;
 
-	int sysctl_tcp_ecn;
-	int sysctl_tcp_ecn_fallback;
+	u8 sysctl_tcp_ecn;
+	u8 sysctl_tcp_ecn_fallback;
 
-	int sysctl_ip_default_ttl;
-	int sysctl_ip_no_pmtu_disc;
-	int sysctl_ip_fwd_use_pmtu;
+	u8 sysctl_ip_default_ttl;
+	u8 sysctl_ip_no_pmtu_disc;
+	u8 sysctl_ip_fwd_use_pmtu;
 	int sysctl_ip_fwd_update_priority;
-	int sysctl_ip_nonlocal_bind;
-	int sysctl_ip_autobind_reuse;
+	u8 sysctl_ip_nonlocal_bind;
+	u8 sysctl_ip_autobind_reuse;
 	/* Shall we try to damage output packets if routing dev changes? */
-	int sysctl_ip_dynaddr;
-	int sysctl_ip_early_demux;
+	u8 sysctl_ip_dynaddr;
+	u8 sysctl_ip_early_demux;
 #ifdef CONFIG_NET_L3_MASTER_DEV
-	int sysctl_raw_l3mdev_accept;
+	u8 sysctl_raw_l3mdev_accept;
 #endif
 	int sysctl_tcp_early_demux;
 	int sysctl_udp_early_demux;
 
-	int sysctl_nexthop_compat_mode;
+	u8 sysctl_nexthop_compat_mode;
 
-	int sysctl_fwmark_reflect;
+	u8 sysctl_fwmark_reflect;
 	int sysctl_tcp_fwmark_accept;
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	int sysctl_tcp_l3mdev_accept;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 439970e02ac65..cb587bdd683a6 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -540,30 +540,30 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "icmp_echo_ignore_all",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_all,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_echo_ignore_broadcasts",
 		.data		= &init_net.ipv4.sysctl_icmp_echo_ignore_broadcasts,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_ignore_bogus_error_responses",
 		.data		= &init_net.ipv4.sysctl_icmp_ignore_bogus_error_responses,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_errors_use_inbound_ifaddr",
 		.data		= &init_net.ipv4.sysctl_icmp_errors_use_inbound_ifaddr,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "icmp_ratelimit",
@@ -590,9 +590,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "raw_l3mdev_accept",
 		.data		= &init_net.ipv4.sysctl_raw_l3mdev_accept,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
@@ -600,30 +600,30 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_ecn",
 		.data		= &init_net.ipv4.sysctl_tcp_ecn,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_ecn_fallback",
 		.data		= &init_net.ipv4.sysctl_tcp_ecn_fallback,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_dynaddr",
 		.data		= &init_net.ipv4.sysctl_ip_dynaddr,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_early_demux",
 		.data		= &init_net.ipv4.sysctl_ip_early_demux,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname       = "udp_early_demux",
@@ -642,18 +642,18 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname       = "nexthop_compat_mode",
 		.data           = &init_net.ipv4.sysctl_nexthop_compat_mode,
-		.maxlen         = sizeof(int),
+		.maxlen         = sizeof(u8),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec_minmax,
+		.proc_handler   = proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "ip_default_ttl",
 		.data		= &init_net.ipv4.sysctl_ip_default_ttl,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= &ip_ttl_min,
 		.extra2		= &ip_ttl_max,
 	},
@@ -674,16 +674,16 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "ip_no_pmtu_disc",
 		.data		= &init_net.ipv4.sysctl_ip_no_pmtu_disc,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_forward_use_pmtu",
 		.data		= &init_net.ipv4.sysctl_ip_fwd_use_pmtu,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_forward_update_priority",
@@ -697,25 +697,25 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "ip_nonlocal_bind",
 		.data		= &init_net.ipv4.sysctl_ip_nonlocal_bind,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "ip_autobind_reuse",
 		.data		= &init_net.ipv4.sysctl_ip_autobind_reuse,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = SYSCTL_ONE,
 	},
 	{
 		.procname	= "fwmark_reflect",
 		.data		= &init_net.ipv4.sysctl_fwmark_reflect,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_fwmark_accept",
-- 
2.39.2



