Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015859;
	b=rgpm8GusFhqrd3fCedO8UpcpWeSQ1tOc2ywcyJK8WZ87nAxwililxKSuXhVFB5GNDc7A
	 XbSiwGvWSNyo+CuTPJjUFAkw7PL7cSaUYg3H17NZ/m7ciM7MI7p5sUwIc8GzCWBcfvFSK
	 Y3mDyNA+HQhKwg8QrklblwyKijrik5TTK4f1517k57fxOdeVcPIYkIRhAW20aMwFZonn1
	 OCahoqEqXg41rK1QeLsJleEWU4QiDXYQeduzM/0J4fTpzrfgr1g4NonJAHCuaTD4lumzH
	 +AuHolgO9RsCgI9m39/EbHZyLk2ttv/+cvCXsdfUbmzknlM4tH2xj2RRsZe18U3ISBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m6AM6N0PKdKD5qWD5l3JP4/fWqgBLedysQJRzaXpuN4=;
	b=hTGjEfA7HYtHZpJlCKGtR0OEYFVcoVhjQYPmBZcL4LArvWPBxDGHiJ8bw5DX5+vDSe4v
	 nBzudjq3caCHFL0U3coJcylTmTTSK98Ql0IMGJ6lIti5l5F4Hawfz2rn8Y+ABM1ZrEf3q
	 CD/J8sGQgDINZrXNxf8A6zZBRYE4FKAT10zXI3U7tOPcIDu50/M8Ne/i5ImsrzDZIYGV4
	 +Em4675bFRwXSyFpPsw6H9p2u1ZsFgbjMRkggB+imYq932Zn4+Xu1yrqtgqSq0wywLrg/
	 TdKxQNxX32NcrmjsK1E5wWxhMKA8uoUc2NQm+wsiMsUX6L/4Kvg76JQiPu/Gf96AYJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yio+2ovz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC1760A3816;
	Wed, 18 Nov 2026 15:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yio+2ovz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7209C1F000C7;
	Wed, 18 Nov 2026 15:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015859;
	bh=m6AM6N0PKdKD5qWD5l3JP4/fWqgBLedysQJRzaXpuN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yio+2ovzaL6MOXFahKgl91zgsrM3jSnXZjrprxXr7u+ANze7g2MCb75z8+jqI9buH
	 Z7X+5z3ujeMX7a0t63b8ZhW5YKKrL7Rpt+PIAFIalxQ3Zt0VAUk5loBlP4pyKidxZu
	 FBcYdXau0OBcGJ1QAUrQqdVPtnvOFZIH3HOUAZYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0322/2651] selftests: net: csum: filter packets by source address and port
Date: Wed, 18 Nov 2026 15:26:02 +0100
Message-ID: <20261118150259.463077357@linuxfoundation.org>
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

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 8342c68435dd34b1ecd65b02fff9745cadab2616 ]

Add source address and port verification in recv_verify_packet_* and
recv_udp: non-matching packets are skipped.

The receiver reads from PF_PACKET and UDP sockets to verify incoming
packets to test hardware checksum offload. It did not validate the
packet source address or source port.

During tests expecting an invalid checksum (-E) or zero checksum (-Z),
background packets can fail the test.

For -Z, build_packet_udp chooses a specific source port that causes
the checksum to sum to zero. When running in receive-only mode (-R),
call build_packet in do_rx to compute the expected source port so
that source port filtering can be applied to -Z as well.

Also
- add an inter-packet delay to avoid drops from bursts.
- remove a comment that is no longer correct.

Fixes: 91a7de85600d ("selftests/net: add csum offload test")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260908155537.813889-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib/csum.c | 55 +++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/lib/csum.c b/tools/testing/selftests/net/lib/csum.c
index e28884ce3ab39..ad960e07e31bd 100644
--- a/tools/testing/selftests/net/lib/csum.c
+++ b/tools/testing/selftests/net/lib/csum.c
@@ -2,8 +2,7 @@
 
 /* Test hardware checksum offload: Rx + Tx, IPv4 + IPv6, TCP + UDP.
  *
- * The test runs on two machines to exercise the NIC. For this reason it
- * is not integrated in kselftests.
+ * The test runs on two machines to exercise the NIC.
  *
  *     CMD=$((./csum -[46] -[tu] -S $SADDR -D $DADDR -[RT] -r 1 $EXTRA_ARGS))
  *
@@ -236,7 +235,8 @@ static void *build_packet_udp(void *_uh)
 		uh->source = 0;
 		uh->source = checksum(uh, IPPROTO_UDP, sizeof(*uh) + cfg_payload_len);
 
-		fprintf(stderr, "tx: changing sport: %hu -> %hu\n",
+		fprintf(stderr, "%s: changing sport: %hu -> %hu\n",
+			cfg_do_tx ? "tx" : "rx",
 			cfg_port_src, ntohs(uh->source));
 		cfg_port_src = ntohs(uh->source);
 	}
@@ -249,7 +249,8 @@ static void *build_packet_udp(void *_uh)
 	if (cfg_bad_csum)
 		uh->check = ~uh->check;
 
-	fprintf(stderr, "tx: sending checksum: 0x%x\n", uh->check);
+	if (cfg_do_tx)
+		fprintf(stderr, "tx: sending checksum: 0x%x\n", uh->check);
 	return uh + 1;
 }
 
@@ -571,15 +572,36 @@ static int recv_prepare_packet(void)
 static int recv_udp(int fd)
 {
 	static char buf[MAX_PAYLOAD_LEN];
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
 	int ret, count = 0;
 
 	while (1) {
-		ret = recv(fd, buf, sizeof(buf), MSG_DONTWAIT);
+		addrlen = sizeof(addr);
+		ret = recvfrom(fd, buf, sizeof(buf), MSG_DONTWAIT,
+			       (struct sockaddr *)&addr, &addrlen);
 		if (ret == -1 && errno == EAGAIN)
 			break;
 		if (ret == -1)
 			error(1, errno, "recv r");
 
+		if (cfg_family == PF_INET) {
+			struct sockaddr_in *sin = (void *)&addr;
+
+			if (sin->sin_addr.s_addr != cfg_saddr4.sin_addr.s_addr)
+				continue;
+			if (sin->sin_port != htons(cfg_port_src))
+				continue;
+		} else {
+			struct sockaddr_in6 *sin6 = (void *)&addr;
+
+			if (memcmp(&sin6->sin6_addr, &cfg_saddr6.sin6_addr,
+				   sizeof(sin6->sin6_addr)))
+				continue;
+			if (sin6->sin6_port != htons(cfg_port_src))
+				continue;
+		}
+
 		fprintf(stderr, "rx: udp: len=%u\n", ret);
 		count++;
 	}
@@ -620,6 +642,9 @@ static int recv_verify_packet_tcp(void *th, int len)
 	if (len < sizeof(*tcph) || tcph->dest != htons(cfg_port_dst))
 		return -1;
 
+	if (tcph->source != htons(cfg_port_src))
+		return -1;
+
 	return recv_verify_csum(th, len, ntohs(tcph->source), tcph->check);
 }
 
@@ -647,6 +672,9 @@ static int recv_verify_packet_udp(void *th, int len)
 		return recv_verify_packet_udp_encap(udph + 1,
 						    len - sizeof(*udph));
 
+	if (udph->source != htons(cfg_port_src))
+		return -1;
+
 	return recv_verify_csum(th, len, ntohs(udph->source), udph->check);
 }
 
@@ -659,6 +687,9 @@ static int recv_verify_packet_ipv4(void *nh, int len)
 	if (len < sizeof(*iph) || iph->protocol != proto)
 		return -1;
 
+	if (iph->saddr != cfg_saddr4.sin_addr.s_addr)
+		return -1;
+
 	ip_len = ntohs(iph->tot_len);
 	if (ip_len > len || ip_len < sizeof(*iph))
 		return -1;
@@ -680,6 +711,9 @@ static int recv_verify_packet_ipv6(void *nh, int len)
 	if (len < sizeof(*ip6h) || ip6h->nexthdr != proto)
 		return -1;
 
+	if (memcmp(&ip6h->saddr, &cfg_saddr6.sin6_addr, sizeof(ip6h->saddr)))
+		return -1;
+
 	payload_len = ntohs(ip6h->payload_len);
 	if (payload_len > len - sizeof(*ip6h))
 		return -1;
@@ -940,6 +974,9 @@ static void do_tx(void)
 			cfg_payload_len = rand() % MAX_PAYLOAD_LEN;
 			buf = build_packet(_buf, sizeof(_buf), &len);
 		}
+
+		/* avoid bursting */
+		usleep(20);
 	}
 
 	if (close(fd))
@@ -952,6 +989,14 @@ static void do_rx(int fdp, int fdr)
 	long tleft, tstop;
 	struct pollfd pfd;
 
+	if (!cfg_do_tx && cfg_zero_sum) {
+		static char _buf[MAX_HEADER_LEN + MAX_PAYLOAD_LEN];
+		int len;
+
+		/* calculate source port that causes csum to add up to zero */
+		build_packet(_buf, sizeof(_buf), &len);
+	}
+
 	tstop = gettimeofday_ms() + cfg_timeout_ms;
 	tleft = cfg_timeout_ms;
 
-- 
2.53.0



