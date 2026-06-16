Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEC6477E36;
	Tue, 16 Jun 2026 17:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630658; cv=none; b=EoRs7lvGT1mi2SZl6v1KHNsuoPwxMMJIGuX/MX8vf3GLeCTbmd4EVIpcouRSvJGZFiR0u2JZ0KV9sG6eSurNLtntV5ZNJFI3UAnkKFP3YatMXpTiu8lKhX/DRFoyZTIG2oovPKosOrvjTnd01NKCbNmu4tcxQ7/d9i/NIbZehcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630658; c=relaxed/simple;
	bh=cY7cSHVFOG7uMQlcbgku3W+RlacvcuNa3WWgWgcJByM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBxmMR7IiBdxFReQceltDq3DH/8W7HhiUDCNuFjIP8bPjgehBgQuQ0glA+265yl39biaSeuq5lLeHJk9nKVPJLbDquQt9P1c7FBK/Gn0D+goHbSWaQ9j/kjEgiaB+971LSPiTrni0/veDpvghE7vZzMPO+VT+ca1G+Y2L0GmAuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXYqH7kD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXYqH7kD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818A61F000E9;
	Tue, 16 Jun 2026 17:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630657;
	bh=yn/uapPjG+ajpvMjgqNZyd9rvnQFWRpF+aibY87d1Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXYqH7kDD+OUQ3O5YOVm6FZvQMrK9Hyxmm/oeyspdjeCvwJ1lRUX6ba+gTKAoAc5e
	 GO6Mmza0Mfsk7RnWiOBVxEwc0Sjisfw4mfboNzJuDypuuDb0YC+nL0eELpE/vkqOxR
	 hooqZw3FJSjmgt2sdN0FMPU1nqzR41+GGgxgFing=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	David Vernet <void@manifault.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/522] selftests/bpf: S/iptables/iptables-legacy/ in the bpf_nf and xdp_synproxy test
Date: Tue, 16 Jun 2026 20:23:31 +0530
Message-ID: <20260616145128.790200973@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit de9c8d848d90cf2e53aced50b350827442ca5a4f ]

The recent vm image in CI has reported error in selftests that use
the iptables command.  Manu Bretelle has pointed out the difference
in the recent vm image that the iptables is sym-linked to the iptables-nft.
With this knowledge,  I can also reproduce the CI error by manually running
with the 'iptables-nft'.

This patch is to replace the iptables command with iptables-legacy
to unblock the CI tests.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: David Vernet <void@manifault.com>
Link: https://lore.kernel.org/bpf/20221012221235.3529719-1-martin.lau@linux.dev
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c       | 6 +++---
 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index b2998896f9f7bc..b30ff6b3b81ae3 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -49,14 +49,14 @@ static int connect_to_server(int srv_fd)
 
 static void test_bpf_nf_ct(int mode)
 {
-	const char *iptables = "iptables -t raw %s PREROUTING -j CONNMARK --set-mark 42/0";
+	const char *iptables = "iptables-legacy -t raw %s PREROUTING -j CONNMARK --set-mark 42/0";
 	int srv_fd = -1, client_fd = -1, srv_client_fd = -1;
 	struct sockaddr_in peer_addr = {};
 	struct test_bpf_nf *skel;
 	int prog_fd, err;
 	socklen_t len;
 	u16 srv_port;
-	char cmd[64];
+	char cmd[128];
 	LIBBPF_OPTS(bpf_test_run_opts, topts,
 		.data_in = &pkt_v4,
 		.data_size_in = sizeof(pkt_v4),
@@ -69,7 +69,7 @@ static void test_bpf_nf_ct(int mode)
 
 	/* Enable connection tracking */
 	snprintf(cmd, sizeof(cmd), iptables, "-A");
-	if (!ASSERT_OK(system(cmd), "iptables"))
+	if (!ASSERT_OK(system(cmd), cmd))
 		goto end;
 
 	srv_port = (mode == TEST_XDP) ? 5005 : 5006;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
index 879f5da2f21e63..13daa3746064af 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
@@ -94,12 +94,12 @@ static void test_synproxy(bool xdp)
 	SYS("sysctl -w net.ipv4.tcp_syncookies=2");
 	SYS("sysctl -w net.ipv4.tcp_timestamps=1");
 	SYS("sysctl -w net.netfilter.nf_conntrack_tcp_loose=0");
-	SYS("iptables -t raw -I PREROUTING \
+	SYS("iptables-legacy -t raw -I PREROUTING \
 	    -i tmp1 -p tcp -m tcp --syn --dport 8080 -j CT --notrack");
-	SYS("iptables -t filter -A INPUT \
+	SYS("iptables-legacy -t filter -A INPUT \
 	    -i tmp1 -p tcp -m tcp --dport 8080 -m state --state INVALID,UNTRACKED \
 	    -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460");
-	SYS("iptables -t filter -A INPUT \
+	SYS("iptables-legacy -t filter -A INPUT \
 	    -i tmp1 -m state --state INVALID -j DROP");
 
 	ctrl_file = SYS_OUT("./xdp_synproxy --iface tmp1 --ports 8080 \
-- 
2.53.0



