Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033257;
	b=og8xXY9GbGgqE3gHcYT0zD/qmrYfzsRbNtOF934ybGKlQjn8poVEvJ0KPFCvoWPYvArG
	 uUxAd0tNEZTSQt+7jw1FbvRbi6vnoH4NKJK3lU5YFq8B2ng/TgySpLEZxzgUumfQkVH0e
	 lxZghZhD0jyL7ueO31WpwpTj0MUbtU8r5uCjQBAGDR9HSRKq8FVT5s+nl+nSt0nf/nJMQ
	 Uqha+cMLoyCI9oQq1tSK+XHHMyizTImE8rkbU17fl+cUx+NGaOxC/4rLb7VoiyxKR/rbj
	 rxuQvIVBGdXCNt9ssMp1Uz6Zra+osahpzWO7PVOBe0aNT8NR6bJjUUxjNCa/CWXnUEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033257;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w9ekWmDMPAqGeg/q2DLQoHuiPlLK+PJ3BFnBiH6sc5w=;
	b=w2EsI7/eF5bT0AbqiC8S7CgyRO6iFyRoqVaeDBl+nF6m2pRK9+vUiwHCXNyuxi5BAO3m
	 WPiAUwgcVWnncybQVLbJ+j62+/JxHaaGrcxk7GZ8HCW/gki1X1UUL6/HsL2V+mptUHkd9
	 tF9YFFXiBFwNo3qsiVanZc2SjxhAS0UJZocwCx7MT18/iI0+PQdKp/oGrmGZTVBA/PcAS
	 nTxt4NDSFvbRmDKvXLHzBhzs6YeSVnJX/J+oDJ3sTInBoD4hGIspeLaBh0oTv502Blyuc
	 0GJy6KwHAzr0Z2slmDg+bkzHUVDWrgAdWygKONg9i20++nCgMlL3Xn8JHYNeKl+Noqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNZrjne2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D43E606A31C;
	Wed, 18 Nov 2026 20:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNZrjne2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A3D1F000C4;
	Wed, 18 Nov 2026 20:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033257;
	bh=w9ekWmDMPAqGeg/q2DLQoHuiPlLK+PJ3BFnBiH6sc5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNZrjne2I03SLRNJOSZJJA6ysJa8DP1ZrMLdc7f0siHkvfW6IJtzPlPDu7Hyuh2Yu
	 cxUF9Lp5uB4rsPAq0/GcFaORDSgWLG6y6EpZLpSFyAmUtt216R2cM5yO66m7HZWA/Q
	 0Y5C2v/17ryRgQznR/F0AkQVdEbIvN/vPuFDPrAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sun Jian <sun.jian.kdev@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1705/1756] selftests/bpf: cover short IPv4/IPv6 inputs with adjust_room
Date: Wed, 18 Nov 2026 16:03:52 +0100
Message-ID: <20261118150117.517945441@linuxfoundation.org>
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

From: Sun Jian <sun.jian.kdev@gmail.com>

[ Upstream commit f1cc94665df907a85589ddb5fe74d7768ff61533 ]

Add a selftest covering ETH_HLEN-sized IPv4/IPv6 EtherType inputs for
bpf_prog_test_run_skb().

Reuse a single zero-initialized struct ethhdr eth_hlen and set
eth_hlen.h_proto from the per-test h_proto field.

Also add a dedicated tc_adjust_room program and route the short
IPv4/IPv6 cases to it, so the selftest actually exercises the
bpf_skb_adjust_room() path from the report.

Signed-off-by: Sun Jian <sun.jian.kdev@gmail.com>
Link: https://lore.kernel.org/r/20260408034623.180320-3-sun.jian.kdev@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 695e1408eb90 ("net: use eth_type_trans_careful() in __dev_forward_skb2()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/empty_skb.c      | 40 +++++++++++++++++--
 tools/testing/selftests/bpf/progs/empty_skb.c |  7 ++++
 2 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/empty_skb.c b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
index 438583e1f2d12..c9fcb70cbafbc 100644
--- a/tools/testing/selftests/bpf/prog_tests/empty_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/empty_skb.c
@@ -10,8 +10,8 @@ void test_empty_skb(void)
 	struct empty_skb *bpf_obj = NULL;
 	struct nstoken *tok = NULL;
 	struct bpf_program *prog;
+	struct ethhdr eth_hlen;
 	char eth_hlen_pp[15];
-	char eth_hlen[14];
 	int veth_ifindex;
 	int ipip_ifindex;
 	int err;
@@ -25,7 +25,9 @@ void test_empty_skb(void)
 		int err;
 		int ret;
 		int lwt_egress_ret; /* expected retval at lwt/egress */
+		__be16 h_proto;
 		bool success_on_tc;
+		bool adjust_room;
 	} tests[] = {
 		/* Empty packets are always rejected. */
 
@@ -46,6 +48,28 @@ void test_empty_skb(void)
 			.err = -EINVAL,
 		},
 
+		/* ETH_HLEN-sized packets with IPv4/IPv6 EtherType but
+		 * no L3 header are rejected.
+		 */
+		{
+			.msg = "veth short IPv4 ingress packet",
+			.data_in = &eth_hlen,
+			.data_size_in = sizeof(eth_hlen),
+			.ifindex = &veth_ifindex,
+			.err = -EINVAL,
+			.h_proto = htons(ETH_P_IP),
+			.adjust_room = true,
+		},
+		{
+			.msg = "veth short IPv6 ingress packet",
+			.data_in = &eth_hlen,
+			.data_size_in = sizeof(eth_hlen),
+			.ifindex = &veth_ifindex,
+			.err = -EINVAL,
+			.h_proto = htons(ETH_P_IPV6),
+			.adjust_room = true,
+		},
+
 		/* ETH_HLEN-sized packets:
 		 * - can not be redirected at LWT_XMIT
 		 * - can be redirected at TC to non-tunneling dest
@@ -54,7 +78,7 @@ void test_empty_skb(void)
 		{
 			/* __bpf_redirect_common */
 			.msg = "veth ETH_HLEN packet ingress",
-			.data_in = eth_hlen,
+			.data_in = &eth_hlen,
 			.data_size_in = sizeof(eth_hlen),
 			.ifindex = &veth_ifindex,
 			.ret = -ERANGE,
@@ -68,7 +92,7 @@ void test_empty_skb(void)
 			 * tc: skb->len=14 <= skb_network_offset=14
 			 */
 			.msg = "ipip ETH_HLEN packet ingress",
-			.data_in = eth_hlen,
+			.data_in = &eth_hlen,
 			.data_size_in = sizeof(eth_hlen),
 			.ifindex = &ipip_ifindex,
 			.ret = -ERANGE,
@@ -108,17 +132,27 @@ void test_empty_skb(void)
 	SYS(out, "ip addr add 192.168.1.1/16 dev ipip0");
 	ipip_ifindex = if_nametoindex("ipip0");
 
+	memset(eth_hlen_pp, 0, sizeof(eth_hlen_pp));
+	memset(&eth_hlen, 0, sizeof(eth_hlen));
+
 	bpf_obj = empty_skb__open_and_load();
 	if (!ASSERT_OK_PTR(bpf_obj, "open skeleton"))
 		goto out;
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		if (tests[i].data_in == &eth_hlen)
+			eth_hlen.h_proto = tests[i].h_proto;
+
 		bpf_object__for_each_program(prog, bpf_obj->obj) {
 			bool at_egress = strstr(bpf_program__name(prog), "egress") != NULL;
 			bool at_tc = !strncmp(bpf_program__section_name(prog), "tc", 2);
+			bool is_adjust_room = !strcmp(bpf_program__name(prog), "tc_adjust_room");
 			int expected_ret;
 			char buf[128];
 
+			if (tests[i].adjust_room != is_adjust_room)
+				continue;
+
 			expected_ret = at_egress && !at_tc ? tests[i].lwt_egress_ret : tests[i].ret;
 
 			tattr.data_in = tests[i].data_in;
diff --git a/tools/testing/selftests/bpf/progs/empty_skb.c b/tools/testing/selftests/bpf/progs/empty_skb.c
index 4b0cd67532511..44326f5cc8bb4 100644
--- a/tools/testing/selftests/bpf/progs/empty_skb.c
+++ b/tools/testing/selftests/bpf/progs/empty_skb.c
@@ -35,3 +35,10 @@ int tc_redirect_egress(struct __sk_buff *skb)
 	ret = bpf_clone_redirect(skb, ifindex, 0);
 	return 0;
 }
+
+SEC("tc")
+int tc_adjust_room(struct __sk_buff *skb)
+{
+	ret = bpf_skb_adjust_room(skb, 4, BPF_ADJ_ROOM_NET, 0);
+	return 0;
+}
-- 
2.53.0



