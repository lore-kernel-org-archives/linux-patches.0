Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590779;
	b=EXHvP+FzOwwGwFjQbgkwK5fmDkCqhWCLMWWFGpbfpD3bOZU1vYvn4VngrtQR2lFyFbfe
	 h7QzMF/6NZJ3n/E7YJAbxCcqxlyUUxVEzBIIr/4YF9FO7huSSz8VIFOS+KQSM5Zcdrf70
	 UNJstxEc9Iyo15x+0yLOSfryzeCihnFmZYH5+FTjIYbuj9NVdQJbeRgI82BJbQcbQguVW
	 zmwSKwAWEkwLc6TzJMuaaKwDTcJkdnq+6uSWRUViX/BmbaK/ZwmxeLRX1IiMpeB9LbMjq
	 nQrMbdQ+dZXVymJpopMj/OdtZlbxGV4fg19u3LB+WAJ9WNuklnYq1LnTroCtpUSngUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GUnBNBDPZadrXh82HEitl6snz+Xo0cpQZ+pQwNHOEuU=;
	b=2musJEYR4qwU53GEs/kAw4E1jT7rBqdFP3v2UW73W04rWeW2AYfwrUs/o2s/dNw8NCCM
	 E1eWS7tjowXdNvKMcmhAIPOKgAEEbbd/zg3hwsqEVzgOtKc7HTWOqQJRHV/nvRLok73Nq
	 miynXOXGXmB9mp4yQSWLszCDJjYOJBW7zAJE28I3gFsUBhBEco09rZ9gEDGwOukEs2+5e
	 SJ7duOPlX80lNvyqlFkrcYgBjJqT42vZRUx4TP5eQMxgJhpHsK8n+r4L80OaXxp7tLZ7a
	 efTOVJ10IGcVya6uBOSeg7bNcuTugCoBpdFkbKsVmeyRtkwor/mwdGwUTBGzgzCGymQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVe1D7ZS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D726E607C379;
	Fri, 13 Nov 2026 17:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVe1D7ZS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745FC1F000C4;
	Fri, 13 Nov 2026 17:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590779;
	bh=GUnBNBDPZadrXh82HEitl6snz+Xo0cpQZ+pQwNHOEuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVe1D7ZSiSDHGjG1fW/QyY9kJ+fCi3SOoTt0uyZZcNX4q0kfXcSoKWYJkmNfomm27
	 b1AjxiQimAkzaXYAvAcpKTz1wI8qwOvEYM+vZoEgmRWRWy17CSKZu7ajgQFAbeRQ7c
	 J0ytYo567MVt56hNB2cJsWnIuS9+Mo77Yragnfqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 648/686] LoongArch: Dont init & online empty nodes
Date: Fri, 13 Nov 2026 10:53:01 -0500
Message-ID: <20261113153843.733135226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 87c6d144bc7bbed0c4573848b9c92006edca7848 ]

Don't init & online empty nodes without any CPU cores (and memory), in
this way "lscpu" will not display confusing empty nodes.

Modify fake_numa_init() to make sure at least Node-0 isn't empty for the
FDT booting case.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
[ sashal: adjusted context in fake_numa_init(), which still sets node 0 in numa_nodes_parsed ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/numa.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kernel/numa.c b/arch/loongarch/kernel/numa.c
index 8b89898e20df1..69ea85c4f232e 100644
--- a/arch/loongarch/kernel/numa.c
+++ b/arch/loongarch/kernel/numa.c
@@ -216,6 +216,8 @@ static int __init fake_numa_init(void)
 	phys_addr_t start = memblock_start_of_DRAM();
 	phys_addr_t end = memblock_end_of_DRAM() - 1;
 
+	set_cpuid_to_node(0, 0);
+	early_numa_add_cpu(0, 0);
 	node_set(0, numa_nodes_parsed);
 	pr_info("Faking a node at [mem %pap-%pap]\n", &start, &end);
 
@@ -245,8 +247,10 @@ int __init init_numa_memory(void)
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



