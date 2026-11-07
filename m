Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060938;
	b=z36EoU6g3xEUCILYxMpCNhT8zdBpsWw4cUzagoj8AH7//gfZG08z1T7xl7Xade4haX6J
	 tadkt9evRYyzIFj8Xp3S25o7nv2/OGxI2JLcnEHIXg3NxqxbsIW7LMz0FhbtG7jc7oSh5
	 jDPoWF0lFNldV8IjD+7HXlSRPhp+s7Ub5RyBfHDCuXStkkHBW8ooFKLpxb+me+AdcXjKo
	 BD8TXJ7xPQv+Sj1JsTgAcC2k3xwH3asLUfgsdFe8sOfjeM+HtYN5hSdYnMGlA7RJ9qDOJ
	 Ym43W8Kgi3w/3BSrhxF7PRCK0wyC+jaS9O7MJSXHV2/VqrNq244dfQPKyOWQirgS/BQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m0My93mtUq6DoRUA5C/luJSJXm2jjQ/Ej33MRGdhwWc=;
	b=ldMo2uS6eMMEEt+Sj+pMX/iaoYAxtNSE6ql39t3WCjexPsKwSOfY9V+2W8/MsTJDnIgS
	 HCD5To3xDbeo9ZeLfh6T2ZSukgf72gfxMoiDVjaQmTFJatVR3kSeO4jWSj7ZemyLoCYg6
	 PPFlDI8elkpsG2wMSKTxUF3kXjl3CfY0qJVT1uwpsRPwOUCpOPsfNMWMFm9dWj8+OXKd5
	 PYJxbuv8hgMzTZ6de25SlPmQtuzf2dW5OPDDqfGJF0jadIoKbXeuloRe4NBCK7XS/zZTy
	 R3KAo2oIryYtO+zpt7vXWVbEOB3Mk20cwyj85UY+TRbxO5h3IFFOhRclDHFH90iTcjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVM4TTWt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900DD606D81F;
	Sat,  7 Nov 2026 14:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mVM4TTWt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE141F0089F;
	Sat,  7 Nov 2026 14:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060938;
	bh=m0My93mtUq6DoRUA5C/luJSJXm2jjQ/Ej33MRGdhwWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mVM4TTWt8VlfNl7dJhrno1WhzEmp7asM/vcREoV/LLacXkNwSPMqQCzVuMEn0VY0z
	 AEiSpXYKOkGlRyW2tNtx6Fn6wC3DwO4s8EkBRKPjBKbxvjVQlbZM/8jpYRhis7OHah
	 qMx3AM+0j11bjxvDDynPoMnJdFa647m9X8LucmQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Charlie Jenkins <thecharlesjenkins@gmail.com>,
	Atish Patra <atishp@meta.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0302/1536] RISC-V: perf: fix resource cleanup on driver probe failure
Date: Sat,  7 Nov 2026 08:38:38 -0500
Message-ID: <20261107135006.207618368@linuxfoundation.org>
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
index accc6ee9b5fe0..9bc5611581fc6 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -1165,22 +1165,29 @@ static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pde
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
@@ -1247,7 +1254,8 @@ static void riscv_pmu_destroy(struct riscv_pmu *pmu)
 		}
 	}
 	riscv_pm_pmu_unregister(pmu);
-	cpuhp_state_remove_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
+	if (!hlist_unhashed(&pmu->node))
+		cpuhp_state_remove_instance(CPUHP_AP_PERF_RISCV_STARTING, &pmu->node);
 }
 
 static void pmu_sbi_event_init(struct perf_event *event)
@@ -1369,6 +1377,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 	struct riscv_pmu *pmu = NULL;
 	int ret = -ENODEV;
 	int num_counters;
+	bool irq_requested = false;
 
 	pr_info("SBI PMU extension is available\n");
 	pmu = riscv_pmu_alloc();
@@ -1397,6 +1406,7 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 		pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
 		pmu->pmu.capabilities |= PERF_PMU_CAP_NO_EXCLUDE;
 	}
+	irq_requested = (ret == 0);
 
 	pmu->pmu.attr_groups = riscv_pmu_attr_groups;
 	pmu->pmu.parent = &pdev->dev;
@@ -1415,11 +1425,11 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
 
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
@@ -1460,9 +1470,20 @@ static int pmu_sbi_device_probe(struct platform_device *pdev)
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



