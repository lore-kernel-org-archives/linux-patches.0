Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065475;
	b=XzH9qpd1sc/JFAttS1IoYjcV1PUOZ4lShxrok5fBqhRCqYGDYrS4KuKRY3IlLLiyEtFZ
	 fe+gCKc/qQ5Yd0csGMQOSPylR59MFOGAuMmFSttRJPS/TFdh5UPdnUhcIDsRDGjZfNPH/
	 jQIQBe4lsdXK46UODGJJFzPVLkZSRgA5KQia23N/PwS6AAkK/2lHR45y/apBYgB0mmJMv
	 cF+8kHk6sTVOhAGNfEf4Usv3IwK85udd1yAbJIVPavQoP648uSostyeInbUPV3xcF6kJa
	 LBKj7h04Q4s0VHuzWj9oh9iHbS1KiyOJ4aa4xMcnVI1jJJOCalFYTpc11xpicYwVP/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SEOzuSyrvm8h5mh/sK9z0NV5+N9cNRYzmgMDSinRJ9Y=;
	b=uLbJ2rQbjHplo6U2V+q9EvOjiAl9pbBU12KR2htn0wrmVjao36vzhH9Az+HmMcUZxXiM
	 NHFCKLuDxxqqEyu9uFVqrp0doBcpneDiQPWX9iyyAOKtA7OyKn6Q18vsg8HuB1UzJvjL6
	 5ptNXeOcvufejSGhG+Y4KaL/Rj1RcPzl40kOfrt9ce1o0ihKRhUL2oJCcsO0VDQspXBDk
	 W6D8fdMVOrdr5pqRuBFl33zf7tMGct0QO43SpMungy//PArH9sIMQ0/4wi6usvXJ8nAHi
	 wo1Ma7hZBNXqSlkfJ8eukEucmQfmeKSJyPK5XzW6/vFfkaQ9AgMGvqRWZy2s2etRt+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnlp8P3P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44A5606A32C;
	Sat,  7 Nov 2026 15:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnlp8P3P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480621F008A1;
	Sat,  7 Nov 2026 15:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065474;
	bh=SEOzuSyrvm8h5mh/sK9z0NV5+N9cNRYzmgMDSinRJ9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnlp8P3PxvoYJvGFVWt4r4Te9thh278waIvDz/LhfxCSH9pOFMfZlQ+YrSsSBr91B
	 c33Av70cS+IpCIIUvv8iZvQKsZ5LShIVIyiozwQB+Itie7DzYoDa9+k7YRePBLZmtr
	 zsj8+pRwS7RIbNGDipWBlFQjb9wrMBDr6f9AuhKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1163/1257] LoongArch: Dont init & online empty nodes
Date: Sat,  7 Nov 2026 08:57:39 -0500
Message-ID: <20261107135011.310802852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 87c6d144bc7bbed0c4573848b9c92006edca7848 ]

Don't init & online empty nodes without any CPU cores (and memory), in
this way "lscpu" will not display confusing empty nodes.

Modify fake_numa_init() to make sure at least Node-0 isn't empty for the
FDT booting case.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/numa.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kernel/numa.c b/arch/loongarch/kernel/numa.c
index c96c536237151..7dedc134ddfe0 100644
--- a/arch/loongarch/kernel/numa.c
+++ b/arch/loongarch/kernel/numa.c
@@ -216,6 +216,8 @@ static int __init fake_numa_init(void)
 	phys_addr_t start = memblock_start_of_DRAM();
 	phys_addr_t end = memblock_end_of_DRAM() - 1;
 
+	set_cpuid_to_node(0, 0);
+	early_numa_add_cpu(0, 0);
 	pr_info("Faking a node at [mem %pap-%pap]\n", &start, &end);
 
 	return numa_add_memblk(0, start, end + 1);
@@ -244,8 +246,10 @@ int __init init_numa_memory(void)
 		return -EINVAL;
 
 	for_each_node_mask(node, node_possible_map) {
-		node_mem_init(node);
-		node_set_online(node);
+		if (!cpumask_empty(&cpus_on_node[node])) {
+			node_mem_init(node);
+			node_set_online(node);
+		}
 	}
 	max_pfn = PFN_DOWN(memblock_end_of_DRAM());
 	max_low_pfn = min(PFN_DOWN(HIGHMEM_START), max_pfn);
-- 
2.53.0



