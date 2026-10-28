Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213903;
	b=vmwo+7M0aZaskwb47mUX354LqD28Y2DxMNjO2jL7xtAngfVA4FyAZ+Dt9PBTLXdbAhPX
	 8YNrnzYtxplTBI+XkudH362IHR18quTwp5QWeaaVCFqKZ3gzJI7yESQvIGGbcvXw+6i9D
	 Yb4r8gT5FM3+K8SEvB1axc/9Li24geMbdId7tdlLdLgHA31TSiu1/QYajnqZJuR+FqzO+
	 jB4jlT8P/1jspLsHEKBnymYOmSbBMg7VbrDEElA18GvNuNOOhNO3SQMsu9nGgBFpijsnF
	 4Q2Zf9Au+6DNMgW7FqyIAnVheVPZaSkEt9h2vsOY+YQ0BKdXGCiyS4DQ46GCD5THtQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=68bGH2Tj+nAiwQpF6UnBfuD6qJyhKh8hef52G12t5RM=;
	b=QCMhVvM9m7QzIytZSGboQsKL7iPD+KD7mHKNLQrTZO8vrqPE6ruW1Pev1SdLOkwrKFxg
	 VbzdEFc4yHBsZ9a1ykhOWRnCWtXvfMHzkqYhSb6rExOxedqcDPVA2jEB2ifw+wyIjNMYD
	 +ijOlqu4l0iiW1/Km+5z3ExwYPtuZD2XRjTnXWfc2d8io/7egZlzSqsYNRcRMRoXKI5yV
	 8rm27MpkySseb2E6gTrerlLj/BgpS/Z9mkyIXtSt0jePIwQlCMtBsaRfFWz1YpvnAXSBF
	 6vwjTdHL5LVvh6lB23eAv5y227PdUBt6rycd282fHk2/BJjUhjb5SnVBjw8dN8gZ9nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BqwrfNx5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F9C606A31A;
	Wed, 28 Oct 2026 18:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BqwrfNx5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B7B1F01825;
	Wed, 28 Oct 2026 18:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213903;
	bh=68bGH2Tj+nAiwQpF6UnBfuD6qJyhKh8hef52G12t5RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqwrfNx5Voxe//zz0pYwAXBXx8HVgQVcd3B8l1Cq85O9qClJfCgnOEB1bJhsUQy0k
	 c0NThhcE3iIECj5WoC4pRReWU2Gr8+1g96Ja9Q5jj6fBoXreaIP16KkeMndD3pKccW
	 mt5cbrosMa18di5P5OAcEHPKiNiN6WyhmSobPqug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0627/1887] LoongArch: Update cpu_sibling_map when disabling nonboot CPUs
Date: Wed, 28 Oct 2026 17:45:23 +0100
Message-ID: <20261028170513.677997739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 752cd08da320a667a833803a8fd6bb266114cce5 ]

Update cpu_sibling_map when disabling nonboot CPUs by defining & calling
clear_cpu_sibling_map(), otherwise we get such errors on SMT systems:

jump label: negative count!
WARNING: CPU: 6 PID: 45 at kernel/jump_label.c:263 __static_key_slow_dec_cpuslocked+0xec/0x100
CPU: 6 PID: 45 Comm: cpuhp/6 Not tainted 6.8.0-rc5+ #1340
pc 90000000004c302c ra 90000000004c302c tp 90000001005bc000 sp 90000001005bfd20
a0 000000000000001b a1 900000000224c278 a2 90000001005bfb58 a3 900000000224c280
a4 900000000224c278 a5 90000001005bfb50 a6 0000000000000001 a7 0000000000000001
t0 ce87a4763eb5234a t1 ce87a4763eb5234a t2 0000000000000000 t3 0000000000000000
t4 0000000000000006 t5 0000000000000000 t6 0000000000000064 t7 0000000000001964
t8 000000000009ebf6 u0 9000000001f2a068 s9 0000000000000000 s0 900000000246a2d8
s1 ffffffffffffffff s2 ffffffffffffffff s3 90000000021518c0 s4 0000000000000040
s5 9000000002151058 s6 9000000009828e40 s7 00000000000000b4 s8 0000000000000006
   ra: 90000000004c302c __static_key_slow_dec_cpuslocked+0xec/0x100
  ERA: 90000000004c302c __static_key_slow_dec_cpuslocked+0xec/0x100
 CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=CC DACM=CC -WE)
 PRMD: 00000004 (PPLV0 +PIE -PWE)
 EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
 ECFG: 00071c1c (LIE=2-4,10-12 VS=7)
ESTAT: 000c0000 [BRK] (IS= ECode=12 EsubCode=0)
 PRID: 0014d000 (Loongson-64bit, Loongson-3A6000-HV)
CPU: 6 PID: 45 Comm: cpuhp/6 Not tainted 6.8.0-rc5+ #1340
Stack : 0000000000000000 900000000203f258 900000000179afc8 90000001005bc000
        90000001005bf980 0000000000000000 90000001005bf988 9000000001fe0be0
        900000000224c280 900000000224c278 90000001005bf8c0 0000000000000001
        0000000000000001 ce87a4763eb5234a 0000000007f38000 90000001003f8cc0
        0000000000000000 0000000000000006 0000000000000000 4c206e6f73676e6f
        6f4c203a656d616e 000000000009ec99 0000000007f38000 0000000000000000
        900000000214b000 9000000001fe0be0 0000000000000004 0000000000000000
        0000000000000107 0000000000000009 ffffffffffafdabe 00000000000000b4
        0000000000000006 90000000004c302c 9000000000224528 00005555939a0c7c
        00000000000000b0 0000000000000004 0000000000000000 0000000000071c1c
        ...
Call Trace:
[<9000000000224528>] show_stack+0x48/0x1a0
[<900000000179afc8>] dump_stack_lvl+0x78/0xa0
[<9000000000263ed0>] __warn+0x90/0x1a0
[<90000000017419b8>] report_bug+0x1b8/0x280
[<900000000179c564>] do_bp+0x264/0x420
[<90000000004c302c>] __static_key_slow_dec_cpuslocked+0xec/0x100
[<90000000002b4d7c>] sched_cpu_deactivate+0x2fc/0x300
[<9000000000266498>] cpuhp_invoke_callback+0x178/0x8a0
[<9000000000267f70>] cpuhp_thread_fun+0xf0/0x240
[<90000000002a117c>] smpboot_thread_fn+0x1dc/0x2e0
[<900000000029a720>] kthread+0x140/0x160
[<9000000000222288>] ret_from_kernel_thread+0xc/0xa4

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/smp.c | 129 ++++++++++++++++++++----------------
 1 file changed, 72 insertions(+), 57 deletions(-)

diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
index 356918d5aa28f..671e660746c01 100644
--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -89,6 +89,77 @@ void show_ipi_list(struct seq_file *p, int prec)
 	}
 }
 
+static inline void set_cpu_core_map(int cpu)
+{
+	int i;
+
+	cpumask_set_cpu(cpu, &cpu_core_setup_map);
+
+	for_each_cpu(i, &cpu_core_setup_map) {
+		if (cpu_data[cpu].package == cpu_data[i].package) {
+			cpumask_set_cpu(i, &cpu_core_map[cpu]);
+			cpumask_set_cpu(cpu, &cpu_core_map[i]);
+		}
+	}
+}
+
+static inline void set_cpu_sibling_map(int cpu)
+{
+	int i;
+
+	cpumask_set_cpu(cpu, &cpu_sibling_setup_map);
+
+	if (smp_num_siblings <= 1)
+		cpumask_set_cpu(cpu, &cpu_sibling_map[cpu]);
+	else {
+		for_each_cpu(i, &cpu_sibling_setup_map) {
+			if (cpus_are_siblings(cpu, i)) {
+				cpumask_set_cpu(i, &cpu_sibling_map[cpu]);
+				cpumask_set_cpu(cpu, &cpu_sibling_map[i]);
+			}
+		}
+	}
+}
+
+static inline void clear_cpu_sibling_map(int cpu)
+{
+	int i;
+
+	for_each_cpu(i, &cpu_sibling_setup_map) {
+		if (cpus_are_siblings(cpu, i)) {
+			cpumask_clear_cpu(i, &cpu_sibling_map[cpu]);
+			cpumask_clear_cpu(cpu, &cpu_sibling_map[i]);
+		}
+	}
+
+	cpumask_clear_cpu(cpu, &cpu_sibling_setup_map);
+}
+
+/*
+ * Calculate a new cpu_foreign_map mask whenever a
+ * new cpu appears or disappears.
+ */
+void calculate_cpu_foreign_map(void)
+{
+	int i, k, core_present;
+	cpumask_t temp_foreign_map;
+
+	/* Re-calculate the mask */
+	cpumask_clear(&temp_foreign_map);
+	for_each_online_cpu(i) {
+		core_present = 0;
+		for_each_cpu(k, &temp_foreign_map)
+			if (cpus_are_siblings(i, k))
+				core_present = 1;
+		if (!core_present)
+			cpumask_set_cpu(i, &temp_foreign_map);
+	}
+
+	for_each_online_cpu(i)
+		cpumask_andnot(&cpu_foreign_map[i],
+			       &temp_foreign_map, &cpu_sibling_map[i]);
+}
+
 /* Send mailbox buffer via Mail_Send */
 static void csr_mail_send(uint64_t data, int cpu, int mailbox)
 {
@@ -263,6 +334,7 @@ int loongson_cpu_disable(void)
 	numa_remove_cpu(cpu);
 #endif
 	set_cpu_online(cpu, false);
+	clear_cpu_sibling_map(cpu);
 	calculate_cpu_foreign_map();
 	local_irq_save(flags);
 	irq_migrate_all_off_this_cpu();
@@ -340,63 +412,6 @@ static int __init ipi_pm_init(void)
 core_initcall(ipi_pm_init);
 #endif
 
-static inline void set_cpu_sibling_map(int cpu)
-{
-	int i;
-
-	cpumask_set_cpu(cpu, &cpu_sibling_setup_map);
-
-	if (smp_num_siblings <= 1)
-		cpumask_set_cpu(cpu, &cpu_sibling_map[cpu]);
-	else {
-		for_each_cpu(i, &cpu_sibling_setup_map) {
-			if (cpus_are_siblings(cpu, i)) {
-				cpumask_set_cpu(i, &cpu_sibling_map[cpu]);
-				cpumask_set_cpu(cpu, &cpu_sibling_map[i]);
-			}
-		}
-	}
-}
-
-static inline void set_cpu_core_map(int cpu)
-{
-	int i;
-
-	cpumask_set_cpu(cpu, &cpu_core_setup_map);
-
-	for_each_cpu(i, &cpu_core_setup_map) {
-		if (cpu_data[cpu].package == cpu_data[i].package) {
-			cpumask_set_cpu(i, &cpu_core_map[cpu]);
-			cpumask_set_cpu(cpu, &cpu_core_map[i]);
-		}
-	}
-}
-
-/*
- * Calculate a new cpu_foreign_map mask whenever a
- * new cpu appears or disappears.
- */
-void calculate_cpu_foreign_map(void)
-{
-	int i, k, core_present;
-	cpumask_t temp_foreign_map;
-
-	/* Re-calculate the mask */
-	cpumask_clear(&temp_foreign_map);
-	for_each_online_cpu(i) {
-		core_present = 0;
-		for_each_cpu(k, &temp_foreign_map)
-			if (cpus_are_siblings(i, k))
-				core_present = 1;
-		if (!core_present)
-			cpumask_set_cpu(i, &temp_foreign_map);
-	}
-
-	for_each_online_cpu(i)
-		cpumask_andnot(&cpu_foreign_map[i],
-			       &temp_foreign_map, &cpu_sibling_map[i]);
-}
-
 /* Preload SMP state for boot cpu */
 void smp_prepare_boot_cpu(void)
 {
-- 
2.53.0



