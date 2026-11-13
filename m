Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591573;
	b=fALmccZqt/0wi9VLOOM1qlJggrcq8jJM3dpcRYgJh1CrZoIX5pJZBH2TgMIxhWuo6yKg
	 puUf4AGzYa8+vaNa9uhlYgHqJS+maXrkiwHsBFrU4FgFQDZL2UyaxYJ74EOhMgHusSt4q
	 6gOJLyHQBQXGwHQCHa/UPL9Va83Y5VTt6H1HV0gOl2X/M03MzXA99KJs2yRm2Hm9uIQrh
	 FRDImKa3/rZcb+5yt1ARxkrk67rNx0nqA7MVpJxzfrLlnCIQ+fMG5T0CNTQYhCLZ7UqcG
	 56zyai7/o9fg+yTzKBY9yqFxYRCmTlKD5Mg09UH31Y1IqESqtwPYzgUabRO85X8f/yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591573;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PbcK9TcMWB35MKf4uu2+jLmJAXkgSmtKmfQk4kvLdEU=;
	b=khuU1FyEytEH9voVJ4z0Oi3Uby0mzG4MQKOHKS1uCaDGK6Q1oiCWVykFPlqZAyMtBbcp
	 77cxkB1XZK37oO1jjIO1hDGiTKdx0bLBBvDKcizsT6rCCeI0rqdgdd42yuC+krTskx4QT
	 yLdsfO7OpBWm2iDz+ugrQBVfXwDUfUFDdqPXsWBUrUOP1kcf3zKQHXBCi2b87nnpJrO68
	 NBZr6REmEFNnqP/kHf2yUK0gl7pKIQlht1o4e1fMVNj9Q9wZNavRtveUWcbezx30zOxFm
	 i/0x8mFnT26JGzgJMBUkWLXi3X/2zWL+PEle4iqoZYdBKftFyVd+sR6qQznnmwwhrGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzr2PtzV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BB2606E658;
	Fri, 13 Nov 2026 17:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vzr2PtzV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655761F000C4;
	Fri, 13 Nov 2026 17:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591573;
	bh=PbcK9TcMWB35MKf4uu2+jLmJAXkgSmtKmfQk4kvLdEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzr2PtzVCuXFYcRshd4b6h4rYtxKAhlmfqzcuXNH4nkKcmw9iGiF2aPJD1LULTIhh
	 u0fnPdvOOaJU2AnGj8GNQegHAZdHHR+6i/Z2CygFWOZOnaXV62YOmUQLzzd/1qUdqk
	 tQvhMSQ4PDG2yTWB73CfjXm0Qy6XZPHGytO+1T/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 623/670] LoongArch: Dont init & online empty nodes
Date: Fri, 13 Nov 2026 10:53:07 -0500
Message-ID: <20261113153832.913140156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 84fe7f8548209..fc62ec78a8403 100644
--- a/arch/loongarch/kernel/numa.c
+++ b/arch/loongarch/kernel/numa.c
@@ -318,6 +318,8 @@ static int __init fake_numa_init(void)
 	phys_addr_t start = memblock_start_of_DRAM();
 	phys_addr_t end = memblock_end_of_DRAM() - 1;
 
+	set_cpuid_to_node(0, 0);
+	early_numa_add_cpu(0, 0);
 	node_set(0, numa_nodes_parsed);
 	pr_info("Faking a node at [mem %pap-%pap]\n", &start, &end);
 
@@ -353,8 +355,10 @@ int __init init_numa_memory(void)
 		return -EINVAL;
 
 	for_each_node_mask(node, node_possible_map) {
-		node_mem_init(node);
-		node_set_online(node);
+		if (!cpumask_empty(&cpus_on_node[node])) {
+			node_mem_init(node);
+			node_set_online(node);
+		}
 	}
 	max_low_pfn = PHYS_PFN(memblock_end_of_DRAM());
 
-- 
2.53.0



