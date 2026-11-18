Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029272;
	b=kPQang8kKYvmFYpIWdiYuQeh7+VMko3kue8hhfTVe2CeqWUbb1EtSuXVbZ71hkHA97q3
	 O7S/oTW84VrL02bSU1HaLzDSNYFnGfyEY/7Q3no/nFlibWYDKR9TcxCqeHDve5nVccckR
	 othjGnfJQ5UJH46b+CU/hNDR0eo2E6M8riOQisqV5kIytIC8grRWlL8oSk/xTDM3BbBj6
	 o4si38PH/34+EhYUtQ0+A52zxtuMePr9etzPs7IZAZ2JahE4mL91fpI+OuYW5QG1iK/V2
	 Ofp/V3FhOzPc7IdgCgdpDqAwX1UnohNnKor35nyAaKCMhGHnbOyqn4C5QiIoXp9Zapg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029272;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mbNr/HTyTpWhguPuM7r4hz6gwJMdciCZXmLfzWZ9BL4=;
	b=DNcH2XMKoAUAszjSJZouFYupMLlOG9E1oIu0m9joGpVCUNUsZvvvDKkRhHmMSHd8nMem
	 v+OAAE0oAluIDt+jVW6P/McPqDtTbdK2vYLTGyvyDCGMzWmj93r5N/SJOdxqBbrJloFPX
	 j0OIL8xJ0Asvq9+ffBWcq1jkqVR782j0Y334b43WmElpHivnwBNW7jF26o0MfaogKoSU1
	 DGRI0YPSaWlBISFnYnqHmKatU70Whu9dc+hs4kUBH09pHxh32HnqPiyy807Lmd2adC6vZ
	 BimGVgJuounrp1zs28VyxXe02x/fNrkaAWNEz0SizpYgtALOW/OV9qlbcAtJmCoR3qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsoHJfGl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB36F606A31C;
	Wed, 18 Nov 2026 19:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GsoHJfGl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447CF1F000C4;
	Wed, 18 Nov 2026 19:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029271;
	bh=mbNr/HTyTpWhguPuM7r4hz6gwJMdciCZXmLfzWZ9BL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsoHJfGlqJfPQ4B4b9pW1CaEyeuFzgzfhrBOzGlxWmioxWC9QY6bZA1qTZH/CxD20
	 UYzirxdmfLAkDSDV33FHt1DR2N3FOhEJZbS7kCXMztD7iwMBs32q8Dgk6vH+DhLQKl
	 ovPWya5gq9vezuFTmiRaaKMAFm5fpH8DQCbNYIGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0291/1756] selftests: net: csum: filter packets by source address and port
Date: Wed, 18 Nov 2026 15:40:18 +0100
Message-ID: <20261118150019.967658196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 27437590eeb53..26c642c1f7fd3 100644
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



