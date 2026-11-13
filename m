Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585361;
	b=GaTL3HYOjWDnGlimsSiIKn4INcV7XF5SbBixKJ5NqMEIVkaz2/akWJ62WRe6F8JmoeUq
	 amOtXzdT6hGzsIy3f1luL7OX9ZAHGsSgL2/UOFgIlTUV0RRJGGW4KQvaTutkftAO5WsNm
	 5NfkoJUwPi+acBUBxKb5DIgNENrc7z6gK2GTYIY3G3aWh4YEs2+98HOcZUdeqe2GOXW4Q
	 8erWySBjUi/BxXzuNNFOT97xJGyNeSDRtazS2mM0wEm1YV2JhBa/w5pKIOH+5Oyb/YVXV
	 V+ypUAo7R0McgU0s3CmOhgbnBf7sPYa9iN4zvyRHpZEImHpQnupjUKLpki6EoJ2kvMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nylMCI2MZgwc0O83U5Kpv9tRBrZwYc0Ax4Dw0MVpiyM=;
	b=ByDCb1cwzm7x70cvPCTRSDgPy9WfrNXiIQ5VEFAP/gMMsFt6jrLpLw5lox7CFMwsjTgp
	 uzctP5OOQRBM0JQ2RSwZjeO1sOYvyjQmTEhaEkIkrgZrD+SWFxyor+w+XnH+BsySmQHvL
	 AiK91utF0d9JCixQOw26oLiyS/PhEz833ev4s+PB6H7IPMY/eKDrsZhMvjFTWP6FLJ4UW
	 UIgELQs2lvl50ispBcPKFyKEEb902Y8LdNP/iRIyjIKumSJyMX/0cZn8BgdYe585RYwLW
	 7Cc7eGOCbt1aA0TvUaenAEHzV+L5tNMARC7TWVSCrrAhr5uYkWLq0mH8zdWJ9Cd/TGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OW5++jKU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E5660A6F66;
	Fri, 13 Nov 2026 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OW5++jKU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEF31F000D0;
	Fri, 13 Nov 2026 15:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585361;
	bh=nylMCI2MZgwc0O83U5Kpv9tRBrZwYc0Ax4Dw0MVpiyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OW5++jKUvx6QPhD6TmwrRCetl4XkeKAneL/Qm3w5U6YkW5HbeRJ/eEGDl0sl5apzd
	 04VSeC6u91Orr4NwPGG7PQGr0Mj350/iCQT4ohi60zmguq8XMorzxUZdiajByygjpy
	 8pHDgc8xlzo6d+pclX47sh6sVAMKv/nBnG2aiD0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	Sumit Gupta <sumitg@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 039/507] cpufreq: CPPC: Select the frequency-invariance callback per CPU
Date: Fri, 13 Nov 2026 10:45:43 -0500
Message-ID: <20261113153754.875396187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

commit 21e018235d99bc86249b034c06646df8757b2852 upstream.

cppc_cpufreq_cpu_fie_init() initializes deferred work only for CPUs whose
feedback counters use PCC. However, if any CPU in a shared policy uses PCC,
it installs the PCC tick callback for the entire policy. With FIE enabled,
a non-PCC CPU then queues an uninitialized irq_work and can call a NULL
function pointer when that work runs.

Choose the frequency-invariance callback separately for each CPU using
the recorded work-initialization state. Processor removal can unpublish
the CPC descriptor before callback registration, so querying its counter
transport again can incorrectly select direct reads for a PCC CPU.

Register the callbacks after all counter initialization has completed, so
a failed initial read for an online CPU cannot leave a partially
registered policy. PCC CPUs use their initialized deferred work, while
non-PCC CPUs read their own counters directly from the tick.

Fixes: 997c021abc6e ("cpufreq: CPPC: Update FIE arch_freq_scale in ticks for non-PCC regs")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Link: https://patch.msgid.link/20260916162805.1039247-20-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c       |  3 +++
 drivers/cpufreq/cppc_cpufreq.c | 21 +++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 9079ddf2ead1c..8aa0ce556863a 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1633,6 +1633,9 @@ bool cppc_perf_ctrs_in_pcc_cpu(unsigned int cpu)
 {
 	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpu);
 
+	if (!cpc_desc)
+		return false;
+
 	return CPC_IN_PCC(&cpc_desc->cpc_regs[DELIVERED_CTR]) ||
 		CPC_IN_PCC(&cpc_desc->cpc_regs[REFERENCE_CTR]) ||
 		CPC_IN_PCC(&cpc_desc->cpc_regs[CTR_WRAP_TIME]);
diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index 951db2a6afb58..782b97acf5dcd 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -42,6 +42,7 @@ MODULE_PARM_DESC(fie_disabled, "Disable Frequency Invariance Engine (FIE)");
 /* Frequency invariance support */
 struct cppc_freq_invariance {
 	int cpu;
+	bool pcc_work_initialized;
 	struct irq_work irq_work;
 	struct kthread_work work;
 	struct cppc_perf_fb_ctrs prev_perf_fb_ctrs;
@@ -152,7 +153,7 @@ static struct scale_freq_data cppc_sftd_pcc = {
 
 static void cppc_cpufreq_cpu_fie_init(struct cpufreq_policy *policy)
 {
-	struct scale_freq_data *sftd = &cppc_sftd;
+	struct scale_freq_data *sftd;
 	struct cppc_freq_invariance *cppc_fi;
 	int cpu, ret;
 
@@ -169,7 +170,7 @@ static void cppc_cpufreq_cpu_fie_init(struct cpufreq_policy *policy)
 
 			kthread_init_work(&cppc_fi->work, cppc_scale_freq_workfn);
 			init_irq_work(&cppc_fi->irq_work, cppc_irq_work);
-			sftd = &cppc_sftd_pcc;
+			cppc_fi->pcc_work_initialized = true;
 		}
 
 		ret = cppc_get_perf_ctrs(cpu, &cppc_fi->prev_perf_fb_ctrs);
@@ -185,8 +186,15 @@ static void cppc_cpufreq_cpu_fie_init(struct cpufreq_policy *policy)
 		}
 	}
 
-	/* Register for freq-invariance */
-	topology_set_scale_freq_source(sftd, policy->cpus);
+	/* A shared policy may contain both PCC and non-PCC counters. */
+	for_each_cpu(cpu, policy->cpus) {
+		cppc_fi = &per_cpu(cppc_freq_inv, cpu);
+		if (cppc_fi->pcc_work_initialized)
+			sftd = &cppc_sftd_pcc;
+		else
+			sftd = &cppc_sftd;
+		topology_set_scale_freq_source(sftd, cpumask_of(cpu));
+	}
 }
 
 /*
@@ -209,11 +217,12 @@ static void cppc_cpufreq_cpu_fie_exit(struct cpufreq_policy *policy)
 	topology_clear_scale_freq_source(SCALE_FREQ_SOURCE_CPPC, policy->related_cpus);
 
 	for_each_cpu(cpu, policy->related_cpus) {
-		if (!cppc_perf_ctrs_in_pcc_cpu(cpu))
-			continue;
 		cppc_fi = &per_cpu(cppc_freq_inv, cpu);
+		if (!cppc_fi->pcc_work_initialized)
+			continue;
 		irq_work_sync(&cppc_fi->irq_work);
 		kthread_cancel_work_sync(&cppc_fi->work);
+		cppc_fi->pcc_work_initialized = false;
 	}
 }
 
-- 
2.53.0



