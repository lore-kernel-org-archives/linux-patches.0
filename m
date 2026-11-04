Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830864;
	b=1Fd6AvxtfhfVJpfh3HmX8ZEvr1GAEwGRY2N8AaWVqWoAIC+5oL2kUhgoSOGZh4iXfssR
	 Nnrhl4JOsIX4kwMoDg2Swm2bajeSkulAFqQS3Q8LRxcMRDUbtsX7rmuLn7KxjhArS6lIa
	 /mTliaCMhjqgEiJ3faq+K5JsnZc4otcHS8XefvJ/kfTZWtBaI5LFF4DHXvAn9lEnXe+GJ
	 Zdv8RXKNNCiBAuhnbRfuwfqv8r6Pwe/Z5Cf/yP4upsJALxtCIltZNJepwlgWIs9IIA1eM
	 QkimmdfYT4bcrbvt/+y9Rg02wttf+kX04BZovTstA5fqovWD/i9oMGgRd23VKgdngPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cwHaOFceEXCU8KAEzCDx4ummVwDNhgSU+Dj0JRPBG78=;
	b=TGQ5RdRjiWeA9C/Bge3inEhldlj6ORxpMs5O5uTgzwaAq0iB6GhaYr+QPprhDVv4EwFN
	 bwAz1BnTNOyk+WDNKJbiJheFNOf/ZQ9LSCX+FH4OASqIJZKlGb3HgH55onL1K2D270Zgg
	 YjYVdYoCi22Jr2tL+a7/qhcDJxj+6HnQIAbgKOEVVZMxRFAw1qTlPjVAuC3Em7Vf2Hjix
	 VET96MDxPztkLvKmaji31kqRaZR8snaISTVD90TAfEKgnID52/K/ELhiPnzX4N2329PbV
	 IxxPKkaerVGXsLktBzYK8iP45BAnqI+E52hH+BAGfUuDWbIDeqHJkpsfwiNhGQZxIBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X0a5zF04;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FCA606D829;
	Wed,  4 Nov 2026 22:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X0a5zF04
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE5401F00A02;
	Wed,  4 Nov 2026 22:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830864;
	bh=cwHaOFceEXCU8KAEzCDx4ummVwDNhgSU+Dj0JRPBG78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0a5zF04FUiEJeAeLAVirzc3lxw3D/nxrnG3qwcT5WtXSohN6+bjovSzLZShyr55U
	 gjBG3cFt0dpHI5diI+M9hmgm8ak/lU1oi9W38Quhu9NEcvwRNSZc5PajIxsE/AmE7b
	 uywzurYS5OsK6FCVY4iBc8LjOzkPoghyjrUy9XSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Atish Patra <atishp@meta.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0367/1005] RISC-V: perf: fix resource cleanup on driver probe failure
Date: Wed,  4 Nov 2026 16:01:40 -0500
Message-ID: <20261104211054.368063473@linuxfoundation.org>
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

From: Atish Patra <atishp@meta.com>

[ Upstream commit e24a1418e90beac2ef4384bc9b0b5a10f19b806e ]

Sashiko pointed out various UAF and memory leak issues around
pmu_sbi_device_probe() error paths.

If the probe fails, here are list of cleanups needed.
a. Already registered pmu must be freed
b. per cpu IRQ must be released
c. pmu_ctr_list data structure must be freed
d. cpu hotplug state must be cleaned up only if added.

Fix the resource cleanup by reorganizing the code around probe failure.

Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Reviewed-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Signed-off-by: Atish Patra <atishp@meta.com>
Link: https://patch.msgid.link/20260807-counter_delegation-v9-1-58658104e487@meta.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_sbi.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index 25f3a45dd7869..10f64b7b60c53 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -1258,22 +1258,29 @@ static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pde
 					  DOMAIN_BUS_ANY);
 	if (!domain) {
 		pr_err("Failed to find INTC IRQ root domain\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err;
 	}
 
 	riscv_pmu_irq = irq_create_mapping(domain, riscv_pmu_irq_num);
 	if (!riscv_pmu_irq) {
 		pr_err("Failed to map PMU interrupt for node\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err;
 	}
 
 	ret = request_percpu_irq(riscv_pmu_irq, pmu_sbi_ovf_handler, "riscv-pmu", hw_events);
 	if (ret) {
 		pr_err("registering percpu irq failed [%d]\n", ret);
-		return ret;
+		irq_dispose_mapping(riscv_pmu_irq);
+		riscv_pmu_irq = 0;
+		goto err;
 	}
 
 	return 0;
+err:
+	riscv_pmu_use_irq = false;
+	return ret;
 }
 
 #ifdef CONFIG_CPU_PM
@@ -1340,7 +1347,8 @@ static void riscv_pmu_destroy(struct riscv_pmu *pmu)
 		}
 	}
 	riscv_pm_pmu_unregister(pmu);
-	cpuhp_state_remove_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
+	if (!hlist_unhashed(&pmu->node))
+		cpuhp_state_remove_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
 }
 
 static void pmu_sbi_event_init(struct perf_event *event)
@@ -1462,6 +1470,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	struct riscv_pmu *pmu = NULL;
 	int ret = -ENODEV;
 	int num_counters;
+	bool irq_requested = false;
 
 	pr_info("SBI PMU extension is available\n");
 	pmu = riscv_pmu_alloc();
@@ -1490,6 +1499,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 		pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
 		pmu->pmu.capabilities |= PERF_PMU_CAP_NO_EXCLUDE;
 	}
+	irq_requested = (ret == 0);
 
 	pmu->pmu.attr_groups = riscv_pmu_attr_groups;
 	pmu->pmu.parent = &pdev->dev;
@@ -1508,11 +1518,11 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 
 	ret = riscv_pm_pmu_register(pmu);
 	if (ret)
-		goto out_unregister;
+		goto out_destroy;
 
 	ret = perf_pmu_register(&pmu->pmu, "cpu", PERF_TYPE_RAW);
 	if (ret)
-		goto out_unregister;
+		goto out_destroy;
 
 	/* SBI PMU Snapsphot is only available in SBI v2.0 */
 	if (sbi_v2_available) {
@@ -1553,9 +1563,20 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	return 0;
 
 out_unregister:
+	perf_pmu_unregister(&pmu->pmu);
+
+out_destroy:
 	riscv_pmu_destroy(pmu);
+	if (irq_requested) {
+		free_percpu_irq(riscv_pmu_irq, pmu->hw_events);
+		irq_dispose_mapping(riscv_pmu_irq);
+		riscv_pmu_irq = 0;
+	}
 
 out_free:
+	free_percpu(pmu->hw_events);
+	kfree(pmu_ctr_list);
+	pmu_ctr_list = NULL;
 	kfree(pmu);
 	return ret;
 }
-- 
2.53.0



