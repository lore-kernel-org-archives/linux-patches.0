Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023297;
	b=UJ23RTIoiGoyANbrzfbJj2Difi4r9yQxrcPk534O/WNQWK8OysYOaeEKnPLZ4m1fSV6W
	 V2xb669dEOpIOCtjmFpZVILVhOHIqq1kJpFQFXoI/lkV4JFQ+zxZttt5jrR/zUaVLfsPb
	 KG4lHYCPsPecpx41+t9VFFo8Ow8p9fqJDio+q5BvneK721eT05+gwZgMGkbsLPPxtvihV
	 HvmYJMVfCmEVWZ6dVHfu2/1nnQ04ivxbdGSAEKWR/IA5E9Hx8QqTk63rhEivUq2IZq3nM
	 ds700CBkZF9LC3BIJUh6tmCJQHKeb4v9ZxeUkg93TGQvjIL2dbMOCEEn1HmHtxm4xJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wf1gS98QOU8iMsDa5fJ/u9TuPlTSA+NDfusAQFGfCuw=;
	b=JdzljQJecGUv5CtywQ8mFHCaajseCIHHJuMm7B8CcgpE2H1kdynUQjKL3t/HHiXoLiga
	 K7W/yAXbf/yb4n1ALhMOJDyGB4HQhvx/8cqqsEHCOdXSURTR7VtlQme0fsgJMcqfFdn5L
	 wO7YGWlrE6xwWSNyuIW264q10rdXRaYFQ7gRh4dWaSjqIhLkQAQP5jZcifwzB/tmjqVis
	 3NP/BSkmdW5L6X6O3Zwgos7nyF9jYt+8V1ekYsKDRwhIZb9lEgp4MtKQFqoyx/AizVmI0
	 zJtMsMO0W/FQeCdun+jeQiNo8I3z+tQ86+jsnbCeEd31QrPV3E6W3Rsbr3rFsveP+uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z51+Xl+p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB40606A32A;
	Wed, 18 Nov 2026 17:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z51+Xl+p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24711F000C4;
	Wed, 18 Nov 2026 17:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023297;
	bh=wf1gS98QOU8iMsDa5fJ/u9TuPlTSA+NDfusAQFGfCuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z51+Xl+p8OAxupgmb6nyj7AX9u5/DwT0M4I409oCh+zIVrVyhO1ogdxho2Q5eX16q
	 SR7JCXXUXAgX/KnyfAi/6khOZ+ZNRw4RQzrcuo0us6H9q04HzVV4e0XsuaC5QE8snD
	 hOZBmTyRXgV0sxP6EWC0pumH6CWDuhhfAGpqa6qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0319/2151] selftests: net: csum: filter packets by source address and port
Date: Wed, 18 Nov 2026 15:34:14 +0100
Message-ID: <20261118150133.581691170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



