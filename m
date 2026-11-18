Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021600;
	b=WaVBlP3yaqImQKITsfqAXr0bEe5iDCe/1P8LRfxldaNCFDjUxCRzYNwiceFLCU2edTVD
	 znwPg9ZF6ahaAP2ahZpCcL0yjeXXt0DfVrdxLBC/93jLkkLJUc6CRJuQC69wA5BMfEv+Q
	 g8qP1aejGk52odytT/ZZNKOwJIRnB8+/diKIZPW9boexk067ARdcMKi/pgQV4/ZFlR1b0
	 JpaW5gFNq+vGjlim7n6aXXKErhfYX3r+t0B95Gm5KaKpYQscykG/wAZiD1e4g00lPmFpY
	 NYQSZEj+PeBIJ2LBDXwD0c7hQefVTkR3AwWLykQ7k+tWQScz+4TvAtDdSQrxL+BTMgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wzi3aYcLLxvglXQ3jPfbsycPl/dSfgNGMLohzEbIA6o=;
	b=5ZZgdAOUjbfh+LDSM6PkhbKpN+KI+bUpL6VRQ4Hbx3Ts3o+riGsldlLFctKN2ekrfqdT
	 Cly8h9Bu7GqElerSrc5/fU7QW2svhsrNco1KFCO7Qvk/4cNAkQzHnxow04OyBXKiGQCR2
	 dD/01swHeZIXhWBFXIMdIvAXSSEB7RTfVtmSUxO2ohDSNvcW9brLVmhnJ0lNH7+Wbb1oG
	 tRcT7cjaXPQLNWWuawy7GD6Jifnfla9SDMVOiP0eD75rU/grLsxYkQHzcNFq9/rTG0Lx9
	 0p1FCtgIVtV5VATEjOO7kKgHp2tXaOZ/K0M6SjUOk0Kaz+r3wX4CGcN05RXnskmzT+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSIjrlPJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681E9606A333;
	Wed, 18 Nov 2026 17:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSIjrlPJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1831F000C5;
	Wed, 18 Nov 2026 17:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021600;
	bh=wzi3aYcLLxvglXQ3jPfbsycPl/dSfgNGMLohzEbIA6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSIjrlPJAj1mPJtHFiHfPGDnUwL4sd23uQiHM0p85MTut52c/ZCYcJ3lc5sU+JW3M
	 CR1VylfbGR+oSnFlJCUFMgJ0rKN505BoRF+ezOfJvPsRJ0jCIcBzpmJYfuYCrbOLwH
	 4vz7fMcQ/uDYOthwVMZNbOBDzvWK8uKAyhTmv2ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	=?UTF-8?q?Alexis=20Lothor=C3=A9=20 ?= <alexis.lothore@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2324/2651] selftests/bpf: Time tc_edt from its first packet with data
Date: Wed, 18 Nov 2026 15:59:24 +0100
Message-ID: <20261118150408.825125189@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiliang Yuan <odys.yuan@gmail.com>

[ Upstream commit b116ac6087541d3d98031e786adbe9c733cd6df3 ]

tc_edt sends 1MB over a TCP connection that a BPF program shapes with
EDT, and checks that the rate it measures is within 2% of the target
rate. The transfer takes about 200ms, so the margin is about 4ms.

The measurement starts before send_recv_data(), which first creates the
sender thread and accepts the connection. On a KASAN kernel, x86_64 VM
with 32 vCPUs, that takes 0.7ms when idle and up to 4.7ms with all
CPUs busy, while the BPF program spreads the data over 200.08ms in the
median. The test also fails without test_progs -j where everything runs
slower, e.g. on s390x and with ASAN in BPF CI.

Have the BPF program note when the first packet with data goes out, and
start the measurement there.

tc_edt run 100 times on the same VM, idle and with 32 busy loops in the
background, before and after this patch:

                 before                after
  idle           0 of 100 failed       0 of 100 failed
  busy loops     3 of 100 failed       0 of 100 failed

Fixes: b0f82e7ab6fb ("selftests/bpf: integrate test_tc_edt into test_progs")
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Link: https://patch.msgid.link/20261019-selftests-bpf-tc-edt-serial-v2-1-41c3813e7916@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/test_tc_edt.c  | 13 ++++++++++---
 tools/testing/selftests/bpf/progs/test_tc_edt.c     | 13 ++++++++++---
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_tc_edt.c b/tools/testing/selftests/bpf/prog_tests/test_tc_edt.c
index 462512fb191f1..1391978a3e309 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_tc_edt.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_tc_edt.c
@@ -90,7 +90,7 @@ static void cleanup(void)
 	remove_netns(SERVER_NS);
 }
 
-static void run_test(void)
+static void run_test(struct test_tc_edt *skel)
 {
 	int server_fd, client_fd, err;
 	double rate_mbps, rate_error;
@@ -113,12 +113,19 @@ static void run_test(void)
 	if (!ASSERT_OK_FD(client_fd, "connect client"))
 		return;
 
-	ts_start = get_time_ns();
 	err = send_recv_data(server_fd, client_fd, TX_BYTES_COUNT);
 	ts_end = get_time_ns();
 	close_netns(nstoken);
 	ASSERT_OK(err, "send_recv_data");
 
+	/*
+	 * Start from the first packet with data rather than before
+	 * send_recv_data(), which also sets up the sender.
+	 */
+	ts_start = skel->bss->tx_start_ns;
+	if (!ASSERT_GT(ts_start, 0, "tx_start_ns"))
+		return;
+
 	rate_mbps = TX_BYTES_COUNT / ((ts_end - ts_start) / 1000.0);
 	rate_error =
 		fabs((rate_mbps - TARGET_RATE_MBPS) * 100.0 / TARGET_RATE_MBPS);
@@ -138,7 +145,7 @@ void test_tc_edt(void)
 	if (!ASSERT_OK(setup(skel), "global setup"))
 		return;
 
-	run_test();
+	run_test(skel);
 
 	cleanup();
 	test_tc_edt__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/test_tc_edt.c b/tools/testing/selftests/bpf/progs/test_tc_edt.c
index 4f6f03122d61d..69f4b16acbef6 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_edt.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_edt.c
@@ -24,6 +24,7 @@ struct {
 } flow_map SEC(".maps");
 
 __uint64_t target_rate;
+__uint64_t tx_start_ns;
 
 static inline int throttle_flow(struct __sk_buff *skb)
 {
@@ -62,7 +63,8 @@ static inline int throttle_flow(struct __sk_buff *skb)
 	return TC_ACT_OK;
 }
 
-static inline int handle_tcp(struct __sk_buff *skb, struct tcphdr *tcp)
+static inline int handle_tcp(struct __sk_buff *skb, struct tcphdr *tcp,
+			     uint32_t hdr_len)
 {
 	void *data_end = (void *)(long)skb->data_end;
 
@@ -70,8 +72,12 @@ static inline int handle_tcp(struct __sk_buff *skb, struct tcphdr *tcp)
 	if ((void *)(tcp + 1) > data_end)
 		return TC_ACT_SHOT;
 
-	if (tcp->source == bpf_htons(9000))
+	if (tcp->source == bpf_htons(9000)) {
+		/* Note when the first packet with data goes out */
+		if (!tx_start_ns && skb->len > hdr_len + tcp->doff * 4)
+			tx_start_ns = bpf_ktime_get_ns();
 		return throttle_flow(skb);
+	}
 
 	return TC_ACT_OK;
 }
@@ -94,7 +100,8 @@ static inline int handle_ipv4(struct __sk_buff *skb)
 		return TC_ACT_SHOT;
 
 	if (iph->protocol == IPPROTO_TCP)
-		return handle_tcp(skb, (struct tcphdr *)(((void *)iph) + ihl));
+		return handle_tcp(skb, (struct tcphdr *)(((void *)iph) + ihl),
+				  sizeof(struct ethhdr) + ihl);
 
 	return TC_ACT_OK;
 }
-- 
2.53.0



