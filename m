Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043493;
	b=R1STwLYMqUz3CRHOTTZ9wQ+Wah0NTwl819RDB7wvd8I8jB/hf0BEhcE2ksKJSJOpRDNL
	 vb6lqQXy5TiHSgTjnt0xmAA9tnpoO7rCG5YWpFgH4oMfgneq5e1AkVQcdwUlmA3LEzY3g
	 bhro/RhSmjNTZJjSGp8ZT8UuxHc73owpYDoCHP3i+bIwBIhPA5AwMrex+sp0/SJVgkxnQ
	 auFQm7o+gba2AYavooTrNAt+aZsuE8aSlHXAecgWW4CrUl+GTky5T1CUnP0T6Hs6bxH9u
	 jSERJ1JOReuseWLU6mfZQ2nG9Al8EjypcFItNz1Rn2dkJq2hc/5i4iXKfijfBbHGiTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JIZWzBAHBKAGSk/zKN+zF0JoX63v0nNJxNcYJuxOCWk=;
	b=UySiufhKz5xuHjKtWM4vtQqxVD3RhMyXVy+6gyLc3OrC1ZltX6d3UPFeDmxqPEg7ALZ/
	 PMqBusVZLn9U7YIO76KMSWv7h5XBtlKQqQT3WhiQVsAZEp7ixyzGXV/z8SGEHngZopYPv
	 LvOzWBHeQZ1EjCsuzcUZ8eeS5UMXOAcz7KsaJWCODd4KKBF/90Cluswrc2mx5NoaOdzpT
	 TiMY+ZAnDmDAudIy7mIquv59TOeqYRZfppEpu0DDecQYS86c9YmZmXEdgFWMryxhjP962
	 0nWrTUTg2DEQYMcxCIL1gs88tiZVN4PojMoCu0IKfxzr7MTTIwtz77DHSxpRNNm/KXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2J16I1vF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF0D606A325;
	Wed, 18 Nov 2026 23:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2J16I1vF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0401F000C4;
	Wed, 18 Nov 2026 23:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043493;
	bh=JIZWzBAHBKAGSk/zKN+zF0JoX63v0nNJxNcYJuxOCWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2J16I1vFzSZ2EIqRUOr2dwU245qM0mrk56GPqlCSGFB8ym7kXOIawBB8BiZeumIwL
	 6PxX/QQChxbI88UxlQZK6aslPF7LWQ+fMfCYISQmVYORCsGIZPHepnF4KFOTCjM4n0
	 BB6sMUwapYBSYnS2Hyw0BipaXoQPid1cjOdwgj2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0229/2857] selftests: net: reuseport_bpf_numa: consider cpuless numa node
Date: Wed, 18 Nov 2026 15:21:03 +0100
Message-ID: <20261118150209.701837699@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@linux.alibaba.com>

[ Upstream commit 88b8d85e889e2fe1cce3e66e50c3029dda94842a ]

reuseport_bpf_numa case failed when testing on a platform with CXL
memory:

    #./reuseport_bpf_numa
    ---- IPv4 UDP ----
    send node 0, receive socket 0
    ./reuseport_bpf_numa: failed to pin to node: Invalid argument

The root cause is that the platform has 2 numa nodes: node 0 has
both cpu and memory, while node 1 is a CXL node which only has
memory, and caused numa_run_on_node() to fail.

Add sanity check to skip cpuless numa node for the numa binding test.

Signed-off-by: Feng Tang <feng.tang@linux.alibaba.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260807002436.43991-1-feng.tang@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/reuseport_bpf_numa.c        | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/net/reuseport_bpf_numa.c b/tools/testing/selftests/net/reuseport_bpf_numa.c
index c9ba36aa688e2..b04b511809ad2 100644
--- a/tools/testing/selftests/net/reuseport_bpf_numa.c
+++ b/tools/testing/selftests/net/reuseport_bpf_numa.c
@@ -104,6 +104,26 @@ static void attach_bpf(int fd)
 	close(bpf_fd);
 }
 
+/*
+ * Return true if it is a cpuless node. Return false if it isn't or any
+ * error (very unlikely) happens during the libnuma calls.
+ */
+static bool is_cpuless_node(int node_id)
+{
+	struct bitmask *cpumask;
+	bool ret = false;
+
+	cpumask = numa_allocate_cpumask();
+	if (!cpumask)
+		return ret;
+
+	if (!numa_node_to_cpus(node_id, cpumask) && !numa_bitmask_weight(cpumask))
+		ret = true;
+
+	numa_bitmask_free(cpumask);
+	return ret;
+}
+
 static void send_from_node(int node_id, int family, int proto)
 {
 	struct sockaddr_storage saddr, daddr;
@@ -213,6 +233,8 @@ static void test(int *rcv_fd, int len, int family, int proto)
 	for (node = 0; node < len; ++node) {
 		if (!numa_bitmask_isbitset(numa_nodes_ptr, node))
 			continue;
+		if (is_cpuless_node(node))
+			continue;
 		send_from_node(node, family, proto);
 		receive_on_node(rcv_fd, len, epfd, node, proto);
 	}
@@ -221,6 +243,8 @@ static void test(int *rcv_fd, int len, int family, int proto)
 	for (node = len - 1; node >= 0; --node) {
 		if (!numa_bitmask_isbitset(numa_nodes_ptr, node))
 			continue;
+		if (is_cpuless_node(node))
+			continue;
 		send_from_node(node, family, proto);
 		receive_on_node(rcv_fd, len, epfd, node, proto);
 	}
-- 
2.53.0



