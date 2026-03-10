Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1136C2BF3E2;
	Tue, 10 Mar 2026 11:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141264; cv=none; b=I3awW0HxjxA3sW7sjr1kg6orBcuupiTmtcrPU71DmRzZ/GYKnyRcHhEzxteTwAZd470us4OEs+FpY3pynQNPdhKdtPOWX2PSSs2KfmEuaePlnUgb4fjrUFb8X8mPFCs4s3Vfhc0wLd3r5LgVmBNvu59WyksteDJnNsHbbpv2oBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141264; c=relaxed/simple;
	bh=wXX8rIa8/LqREvERfGBGR0pyfXjsZLiU1JV0xUIyviI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q585VEGjVDV1gIHHbgr4j8OOoG1RKeFaUlNxETc6pBeDHp6+KKT3iKMwCEiOkQymrUVq9P4BLzEpacyUZP9Tm6KypKVxZ0CJDnXOyORo2taV65lE1aV4YDhn29t84t+pHTm6R70I5yYnFWCDpUMFDIeJ1UH+JHOm9t015pbadcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nK0zc3FP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nK0zc3FP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CE7C19423;
	Tue, 10 Mar 2026 11:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141263;
	bh=wXX8rIa8/LqREvERfGBGR0pyfXjsZLiU1JV0xUIyviI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nK0zc3FP+y3MMRy/VVVHytExuRDsDlkVsfUT4o8gEeT8WUFYNGWS1pzweN1nI6T1a
	 tw1uHnwjcnCvabVe86WB3AFCb0X3NHrcNyUOQGl/mjHX89phRzAxO1Zc3v2lgpPG4M
	 AqYynWf0j/rL5/Q73gXxpbnsahlM1qnf1BHvTz94jvyMd/ABT/SoiKqmSfy4fmMzoH
	 QW81VydVOtU7m+b2cqzKjxZ1uu2QifRcVQSX0SuPXLKSogsNsfnOwq3gup899+/9Ub
	 U0fhP1tl/rEQy6Sa7i9Y5qbtVZgSW/YrT8op+JuCCcAVaP60WL83MaCQo2agEIhLto
	 o/sLg0iFVXAgg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Kyle Meyer <kyle.meyer@hpe.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 266/311] x86/numa: Store extra copy of numa_nodes_parsed
Date: Tue, 10 Mar 2026 07:05:13 -0400
Message-ID: <5ba37dd8aa6bb7e06c63fafc31f496955df413f9.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 48084cc153a5b0fbf0aa98d47670d3be0b9f64d5 ]

The topology setup code needs to know the total number of physical
nodes enumerated in SRAT; however NUMA_EMU can cause the existing
numa_nodes_parsed bitmap to be fictitious. Therefore, keep a copy of
the bitmap specifically to retain the physical node count.

Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Kyle Meyer <kyle.meyer@hpe.com>
Link: https://patch.msgid.link/20260303110059.889884023@infradead.org
Stable-dep-of: 528d89a4707e ("x86/topo: Fix SNC topology mess")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/numa.h | 6 ++++++
 arch/x86/mm/numa.c          | 8 ++++++++
 arch/x86/mm/srat.c          | 2 ++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 53ba39ce010cd..a9063f332fa6e 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -22,6 +22,7 @@ extern int numa_off;
  */
 extern s16 __apicid_to_node[MAX_LOCAL_APIC];
 extern nodemask_t numa_nodes_parsed __initdata;
+extern nodemask_t numa_phys_nodes_parsed __initdata;
 
 static inline void set_apicid_to_node(int apicid, s16 node)
 {
@@ -48,6 +49,7 @@ extern void __init init_cpu_to_node(void);
 extern void numa_add_cpu(unsigned int cpu);
 extern void numa_remove_cpu(unsigned int cpu);
 extern void init_gi_nodes(void);
+extern int num_phys_nodes(void);
 #else	/* CONFIG_NUMA */
 static inline void numa_set_node(int cpu, int node)	{ }
 static inline void numa_clear_node(int cpu)		{ }
@@ -55,6 +57,10 @@ static inline void init_cpu_to_node(void)		{ }
 static inline void numa_add_cpu(unsigned int cpu)	{ }
 static inline void numa_remove_cpu(unsigned int cpu)	{ }
 static inline void init_gi_nodes(void)			{ }
+static inline int num_phys_nodes(void)
+{
+	return 1;
+}
 #endif	/* CONFIG_NUMA */
 
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 7a97327140df8..99d0a9332c145 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -48,6 +48,8 @@ s16 __apicid_to_node[MAX_LOCAL_APIC] = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
+nodemask_t numa_phys_nodes_parsed __initdata;
+
 int numa_cpu_node(int cpu)
 {
 	u32 apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
@@ -57,6 +59,11 @@ int numa_cpu_node(int cpu)
 	return NUMA_NO_NODE;
 }
 
+int __init num_phys_nodes(void)
+{
+	return bitmap_weight(numa_phys_nodes_parsed.bits, MAX_NUMNODES);
+}
+
 cpumask_var_t node_to_cpumask_map[MAX_NUMNODES];
 EXPORT_SYMBOL(node_to_cpumask_map);
 
@@ -210,6 +217,7 @@ static int __init dummy_numa_init(void)
 	       0LLU, PFN_PHYS(max_pfn) - 1);
 
 	node_set(0, numa_nodes_parsed);
+	node_set(0, numa_phys_nodes_parsed);
 	numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
 
 	return 0;
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 6f8e0f21c7103..44ca666517561 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -57,6 +57,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
 	}
 	set_apicid_to_node(apic_id, node);
 	node_set(node, numa_nodes_parsed);
+	node_set(node, numa_phys_nodes_parsed);
 	pr_debug("SRAT: PXM %u -> APIC 0x%04x -> Node %u\n", pxm, apic_id, node);
 }
 
@@ -97,6 +98,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
 
 	set_apicid_to_node(apic_id, node);
 	node_set(node, numa_nodes_parsed);
+	node_set(node, numa_phys_nodes_parsed);
 	pr_debug("SRAT: PXM %u -> APIC 0x%02x -> Node %u\n", pxm, apic_id, node);
 }
 
-- 
2.51.0

