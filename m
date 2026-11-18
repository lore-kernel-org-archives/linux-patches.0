Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016393;
	b=Q2ywQ1znzbZBTcujyKGWq/0xyb/HFe80rJJMGmy02w9Jn2pSWE0pWuQ3GJw6H9RV9tIy
	 UOYGxv2XA8pc51qtQrBIhukMukpiWBqQoLZTtF1J824J/eV/GQCUf5VqgUpYlEigH20/R
	 Irs8F2WxeleXKPFQsHD9hHXRj9YUWq4amqr8Zgt9QhQXCSoFZ7ov+li9t7ETpm2MOQzEQ
	 D8OCRV0nd/C62OhbPUFr4N/Wgv3+wLUqmWMkUPfh+ZhPRd7UlkF6+nriU6Ty2b4W/cYdC
	 xjNJZFccksFmFqlUsd9T8C9viSiAQV+/ZaRIzHaoWWegZgBlUiiOVWMQxDewWfJX43A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wg4MVHTu1C+mQcbMRS9CwCrETNHBxjLTlhgjDdRfmtE=;
	b=0E8sehs5Uk7Wn/CO4UWp5U2Ke7YZX09Pq/DR5nD1V3FOAKzKULEG3BLr2vs0Jz4O0qos
	 xS1SDVCIFy9WhZiRb4Wmt63+8L7d7JDda3qPmdJ6UapTAhV/seUssPFSNRvTXklacFTL7
	 ExJAxEE2khnf+S0zb4Aivvlx/+F4aTwb63Gn3mCCH7KjgEbtygb2YHWwFhINsSreAwK6U
	 5f18dj/Sy2We/k9XV8TWfpwHVZKMujPHzWg7vT0yTCV1qXr0V2u/F32FmA2AoQBcHw6Rm
	 kmXvwbvzyQuyDejGaQKMnHGAIfAQ9IQ1RJE+UXqWFLEeTd/0BBMqoTAZrQRbliS1npQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sw3zZLZn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739C560A2614;
	Wed, 18 Nov 2026 15:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sw3zZLZn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39F71F000C4;
	Wed, 18 Nov 2026 15:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016393;
	bh=Wg4MVHTu1C+mQcbMRS9CwCrETNHBxjLTlhgjDdRfmtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sw3zZLZnFYF/7VM2LtO4I/TL62+6Q5pjKX1Z+oCOG6Bsm6OosocHkXmXzD/T5Nceu
	 5R6ZoBWb4ici4izlM2bHbkLCb7SKAWDUq/xJsdHggCl9VvD9ZO1q0Imv+dSEU7sy4V
	 3MmjKXmV3CrnuFx/qnAiGlFZErdsHkN8cla+x8+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0511/2651] selftests/bpf: Wait for links to come up in lwt_ip_encap
Date: Wed, 18 Nov 2026 15:29:11 +0100
Message-ID: <20261118150306.149360947@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 71b75648d1a21c0a6379741d00f41086ec95f14a ]

lwt_ip_encap creates three fresh netns with veth pairs across them and
then immediately pings over IPv6. The peer ends of the first veth pair
end up with the same ifindex in their respective netns, so linkwatch
does not treat the carrier-on as urgent and may deliver NETDEV_CHANGE up
to one second later. Until that happens addrconf considers the link not
ready: no ff00::/8 multicast route and no link-local address are
installed, and the neighbour solicitation for the next hop is dropped
as a no-route packet. The NS retransmit a second later succeeds, but
ping -W1 has already given up:

  check_ping_ok:FAIL:ip netns exec ns-lwt-ip-encap-1-... ping -6 -c 1 -W1 -I veth1 fb04::1 > /dev/null unexpected error: 256 (errno 2)
  lwt_ip_encap:FAIL:ping OK unexpected error: -1 (errno 2)
  #226/1   lwt_ip_encap_ipv4/egress:FAIL

This reproduces reliably when the test is run standalone on an idle
system where setup completes well within a second. The original shell
script had a "sleep 1 # reduce flakiness" after setup which was lost in
the conversion to test_progs.

Instead of sleeping, poll SIOCGIFFLAGS for IFF_RUNNING on all veths at
the end of setup_network() so traffic is only sent once every link is
operationally up.

Fixes: f5e288943e2c ("selftests/bpf: Move test_lwt_ip_encap to test_progs")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://patch.msgid.link/20260916232407.764886-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/lwt_ip_encap.c   | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c b/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
index 39e8a3b8b6afb..5c5560d45c5b4 100644
--- a/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
+++ b/tools/testing/selftests/bpf/prog_tests/lwt_ip_encap.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#include <net/if.h>
 #include <netinet/in.h>
+#include <sys/ioctl.h>
 
 #include "network_helpers.h"
 #include "test_progs.h"
@@ -141,6 +143,54 @@ static int set_bottom_addr(const char *ns1, const char *ns2, const char *ns3)
 	return 1;
 }
 
+/*
+ * A veth whose peer sits in another netns with the same ifindex gets its
+ * carrier-on handled as a non-urgent linkwatch event, i.e. up to 1s late.
+ * Until then IPv6 considers the link not ready (no ff00::/8 route, no
+ * link-local address) and silently drops neighbour solicitations, so wait
+ * for all links to be operationally up (IFF_RUNNING) before sending traffic.
+ */
+static int wait_for_oper_up(const char *ns, const char *dev)
+{
+	struct nstoken *nstoken;
+	struct ifreq ifr = {};
+	int i, fd, ret = -1;
+
+	nstoken = open_netns(ns);
+	if (!ASSERT_OK_PTR(nstoken, "open ns"))
+		return -1;
+
+	fd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (!ASSERT_OK_FD(fd, "socket"))
+		goto out;
+
+	strncpy(ifr.ifr_name, dev, IFNAMSIZ - 1);
+	for (i = 0; i < 50; i++) {
+		if (!ASSERT_OK(ioctl(fd, SIOCGIFFLAGS, &ifr), "SIOCGIFFLAGS"))
+			break;
+		if (ifr.ifr_flags & IFF_RUNNING) {
+			ret = 0;
+			break;
+		}
+		usleep(100000);
+	}
+	close(fd);
+out:
+	ASSERT_OK(ret, dev);
+	close_netns(nstoken);
+	return ret;
+}
+
+static int wait_for_links(const char *ns1, const char *ns2, const char *ns3)
+{
+	if (wait_for_oper_up(ns1, "veth1") || wait_for_oper_up(ns1, "veth5") ||
+	    wait_for_oper_up(ns2, "veth2") || wait_for_oper_up(ns2, "veth3") ||
+	    wait_for_oper_up(ns2, "veth6") || wait_for_oper_up(ns2, "veth7") ||
+	    wait_for_oper_up(ns3, "veth4") || wait_for_oper_up(ns3, "veth8"))
+		return -1;
+	return 0;
+}
+
 static int configure_vrf(const char *ns1, const char *ns2)
 {
 	if (!ns1 || !ns2)
@@ -304,6 +354,9 @@ static int setup_network(char *ns1, char *ns2, char *ns3, const char *vrf)
 	if (!ASSERT_OK(configure_ns3(ns3), "configure ns3 routes"))
 		goto fail;
 
+	if (!ASSERT_OK(wait_for_links(ns1, ns2, ns3), "wait for links"))
+		goto fail;
+
 	/* Link bottom route to the GRE tunnels */
 	SYS(fail, "ip -n %s route add %s/32 dev veth5 via %s %s",
 	    ns1, IP4_ADDR_GRE, IP4_ADDR_6, vrf);
-- 
2.53.0



