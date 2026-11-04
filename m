Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830902;
	b=uT9fnaPnBf2PNQvEi2pABuvIpGr02X5CzrTet8FutLpkONH9TwGzjExU5Zo0REOTfhQr
	 FIc6RxItmFFgS3v2sfd0RxSWzXJ+sjblHIedPCAsR0GwZfnr+zapqg8OlDfFi85GAwM4H
	 ifIl70zmRLlQp6mx8/JQ2jsgQQyt80wl0WoyiDRJWzzPMXBPCscx+FsINMULabCKw1X3I
	 XJoT3gt6/t1jACS+udmYx5NnKYlC3UvFoHB3O1QzCOmBYffmjQ7P8U6mMuQQT+TSYW8aa
	 FGnHO2/aSQQPPj8pQ4EoM9RQqTbCnTxBDOnIQn/GvP4oAmyeYONK0bnpH9y4HcMo2UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RJDNton1RWYQNO3tnBsWNFqndf6rIIRlpoL5BpqXAxo=;
	b=zuLvbHJnnWlQKxczRGJDBNOEypJTSUK4EGSi/64L4tUlZWXpYmcuFvXNa/ZkeBNOL5BR
	 IeUPy70u9xGBZO7u5eibqDAVqD5T+ATXVdtmUpb7bp9tSWnWHMh9+iF7CkSY1eA8UkApb
	 sVD0G/36jpsKtUZ9HcDA/cA/33/FueQigQ88yl/jJFyBaF2tmq01CcP3/NAEta2wJGIGY
	 8vEiAbs9nwg9kcA5md14rbuEcd9Dmtitf9Uoosau2ugJuGLfq58uvO9exPHeVXGixUqh8
	 o+AmDftbREUOWOkFqflTjtWmktiHiuZqi+rwRSKLRzyWEvImlqwh2Jj51EQxCH9R2AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wVt/sfV+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29672606A848;
	Wed,  4 Nov 2026 22:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wVt/sfV+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C4E1F00919;
	Wed,  4 Nov 2026 22:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830896;
	bh=RJDNton1RWYQNO3tnBsWNFqndf6rIIRlpoL5BpqXAxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wVt/sfV+xqJohH5dDO1egB68foP1rrzEdDZb/04+m5bB5Z+JXjuvgeBN4WtK8w3Vu
	 QUuevWARA/IG0FS4ICVQkaz346n1F0Iy2QU+eP0jkj0H5YKF2rOIKs7so46xPSp584
	 e4SDfn4BAv+iMET+NUrx49OGO02/MC8zSd59DeRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0380/1005] selftests: net: reuseport_bpf_numa: consider cpuless numa node
Date: Wed,  4 Nov 2026 16:01:53 -0500
Message-ID: <20261104211054.741892208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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



