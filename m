Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030767;
	b=3j4gW6M5zIu9t0Nlmx49H/avT/UU0w70K7WluujZiNvccX8djHN1fPZcsHLCuMKFooet
	 dEQbM2KN1gozcBxtYQuRtrUXmvz1FVhCpGM+M3AywansAK0CTTLfwRaJthfyt+EKJg/Zl
	 1/qy5H1mT1JUVQS3Rd3e11bSrzIfvas82vR8Mvx7J6qPmVeoH7dry9WlxW0nKV0ZQG2EQ
	 HW9b1lQvou3AXYtP1YcbSJljnj/GusM7XjXygxvbmqP8N+AZex+4i0wcrgGP35lI0+nxZ
	 rDGrjUGSpuZh59mbJ/oicDXazsPJZpzaysVbh8x8Tj8JJX714FhSDJyIXCI7A9PCHZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5QgpxZVQvy2pa4KPIBhWusHMjOd+WbB4B2/jF8Xi5hI=;
	b=MyIGPMgdl1xe2b4srL+WK9XWpsrf6VFhcol9RYEf+6Pfi61yZEl4TWvsxKoYM5tQYtCK
	 WDgnmmnZhLJn3meBChop+s9nczZdgEa8uyXUbc+oivrNwZNxlpAf0zPLNzCgoBoASdVIJ
	 EyoNdHr27nZUWmJoxhVStUxnazvaPoiWCJxE+nmxpDPEQVdPNlL1jFjP2nkn6IQVM3JrQ
	 QGRSJg9Pok72zXQtHJ9WfmqFgJ1v5DKMlzTKGt6gfYorJxM85ZAno9L1+eb5ivxSNXgdy
	 5BX9EhxnAIBh5x7Ze/PtVAaZ2GLc3NgJEFiVb+nltCfPHGc4edlbuGwMvjBMD/C2fDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xfyslMrE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643D8606A93D;
	Wed, 18 Nov 2026 19:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xfyslMrE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0631F000C4;
	Wed, 18 Nov 2026 19:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030767;
	bh=5QgpxZVQvy2pa4KPIBhWusHMjOd+WbB4B2/jF8Xi5hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xfyslMrEwNCWeI6HDgeDhZ+8tpBW6bL2UXLs8PLtQsoQwo8MBs/ay3soDqjxyKClM
	 +NinsuS88U4oOTA5MNR9AEfHWr4bM1GGA2miv5VWJew3K+W+ORLivCHOPeN9BubM7t
	 /xaMdpzctek6qsiG4MCerxj017M29irpo8LgLOC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0820/1756] perf/cxl: Unfreeze counters after handling an overflow interrupt
Date: Wed, 18 Nov 2026 15:49:07 +0100
Message-ID: <20261118150042.212362236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 2e4fe234c72d65a09bbfd421240a0cfd7c8046a2 ]

The counters run with Freeze on Overflow set, so one overflow freezes every
counter in the block (CXL r4.0 8.2.7.2.1), and a frozen counter "remains
frozen until explicitly unfrozen by software" (8.2.7.1.3, Table 8-183).
cxl_pmu_irq() reads the overflowed counters and clears the overflow status
but never unfreezes, so everything stays frozen until the next pmu_enable()
and events in that window are lost.

Unfreeze after clearing the status, unless the PMU has been disabled in the
meantime - cxl_pmu_disable() freezes the block deliberately. Track the
enabled state and leave it frozen in that case.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index f8195774213c4..e5ce595a965d4 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -107,6 +107,8 @@ struct cxl_pmu_info {
 	struct hlist_node node;
 	bool filter_hdm;
 	int irq;
+	/* Set between pmu_enable() and pmu_disable(), read by the IRQ handler */
+	bool enabled;
 };
 
 #define pmu_to_cxl_pmu_info(_pmu) container_of(_pmu, struct cxl_pmu_info, pmu)
@@ -592,6 +594,7 @@ static void cxl_pmu_enable(struct pmu *pmu)
 	void __iomem *base = info->base;
 
 	/* Can assume frozen at this stage */
+	WRITE_ONCE(info->enabled, true);
 	writeq(0, base + CXL_PMU_FREEZE_REG);
 }
 
@@ -600,6 +603,7 @@ static void cxl_pmu_disable(struct pmu *pmu)
 	struct cxl_pmu_info *info = pmu_to_cxl_pmu_info(pmu);
 	void __iomem *base = info->base;
 
+	WRITE_ONCE(info->enabled, false);
 	/*
 	 * Whilst bits above number of counters are RsvdZ
 	 * they are unlikely to be repurposed given
@@ -798,6 +802,21 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
 
 	writeq(overflowed, base + CXL_PMU_OVERFLOW_REG);
 
+	/*
+	 * An overflow freezes every counter in the CPMU, so unfreeze once the
+	 * overflowed ones have been read and their status cleared. Otherwise
+	 * they stay frozen until the next pmu_enable() and events are lost.
+	 *
+	 * Not while the PMU is disabled, so as not to undo an intentional freeze.
+	 * The check is advisory, not exclusive: pmu_disable() normally runs on
+	 * info->on_cpu with interrupts off, where the pinned handler cannot
+	 * preempt it. In the one window where it does not - the migration in
+	 * cxl_pmu_offline_cpu() - the counters are legitimately running again,
+	 * so unfreezing is correct there anyway.
+	 */
+	if (READ_ONCE(info->enabled))
+		writeq(0, base + CXL_PMU_FREEZE_REG);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.53.0



