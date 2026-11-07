Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060958;
	b=CVIPOuc2Md4Qd7kpGrQ2HCsiZV/WgUrNh0+K1imx/V+8ydZoEaS5iDr4Jfom/VeHxkla
	 QfXPi4KBZM4Csl9R65E3TtIwvKz7h6dAlvcucYTrnJJn8FhPY4XXAIsto9tURNW9Tubd1
	 UFFUj7bhp1SPgo9PhaeIYf1j32dZtJ6L/V+XQaw+Vr1WBPx+6Su6OevNb/ORzdUfX/LZm
	 3yZrEvE2RRasL1HHZIeyjnBuUh2A1fHxmm+/6+WA6ob6h8V5dCkxb/bFvNkzaCXy3K1Sy
	 TMoV+JOzQPlk+/pxJz/UfpowQESYg/HNz+e/iN6dl0f3mbUeD6/lnFxx3RhbzPfjVHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gc2BmDEW+zdzrmazzYbeb5tvHCqHmeVPtnwHN2xDLPo=;
	b=1pXLF42Mb75eXeT3TEiHfyc86TSbiwks9ut/yyU7YjxhIDhjbNZh/jhVIQW79igs9I+Z
	 a+wi7VdBXcNua3ce5DafpD48tO0XSL78H3pITlmxz4IRYUgdcAnomVUYJIS5ywrN04o9A
	 Vsags8fCr46lSVo/tSDtduzk1S5Rr9TQ9h2x9Gs43EnKm1Ga5cdgfjfuvyZoksb8bKcxM
	 25hg65Acuv6MctxsGyFtYCJn14ovP8jg+h85Xjt045zHVpBGXGEMzS+899mb2+5xbiML5
	 PkLEqCdsd5nZfFWvVG08/p3cef1T6TkvuuUgM42UNQR4kLInM16O6vpU+/4CGeDQU8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzJWPAOb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38044606D80C;
	Sat,  7 Nov 2026 14:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CzJWPAOb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44A01F0089F;
	Sat,  7 Nov 2026 14:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060958;
	bh=gc2BmDEW+zdzrmazzYbeb5tvHCqHmeVPtnwHN2xDLPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CzJWPAObXgLEqsvBb1s96fCz7nm4fTB+guTAkUKBlkLt0mEx0ObgIVc00moqlUGOp
	 E4q37/2GjISn05VmEPFWbWrvbjJUY7pwdQqnKekJog6GXj5qXkCgKTxcfbZI7zNeSe
	 y19MnNrHMALHdu8aaE67Y3MNPN6nqgT/Ryy+gSn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0315/1536] selftests: net: reuseport_bpf_numa: consider cpuless numa node
Date: Sat,  7 Nov 2026 08:38:51 -0500
Message-ID: <20261107135006.568556309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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



