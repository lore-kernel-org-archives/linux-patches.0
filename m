Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025335;
	b=Aay4vAOppELv8xe31MRUI9/RHT+qElt9kNOskd3uicuJxxAEic7cwya2xikWyjCteuKH
	 czhjaHq6wZfl1KpVxnJc5IFIF9f5GFxkrt7vFKIufzID0eO486Zg2Jk+ZGWIThI6F9VOw
	 wECZl6RarFPcnld9OKNvlb1ky28vKXCpZ88nCeQ6hZxlUbi6+Ig9erk59RKiI4aE0Q1FE
	 +N+aQDqKiTZwGnfTl8GtyDw7X/Fbi2vvwpHcfLNOQgUVRl764i32xQXPgKDCiu2EJpJnj
	 VCFryxZcZrlsACqzbsRAI12Kg2/nZI/tGV9zDLeIe7fAoD5/C7YdZdRuPqVmHfpoINg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6apcGQ3Bwc8k8AjgRneVaajIYbXMdhhQWpL3rUug+bY=;
	b=C7JUqjDiFo5ZYSpQnfAbJ+Ah5lmzn0Mfuhu3xlwzE40E0GDg8NrihEwDbwRVk5rcQ0pP
	 2j23uC8pjN2I9NRotqB6yyRDZ3C21lJY1MN23IQVoZFumIz6gJe8g9DgpFDBJE7y8xZa5
	 1/D/XGVZlRXHHwbyUSBu3VroaFEi7fr0fBoHv+S7u+ipGjye34cLvv8u/Zr3wZvdvoGmE
	 q0pxQlp+qbS1sLStAmxskeJAxDQGxU9f442vLJ4NXPu2c7POhpxYOPc/Q/vNIS/tfNE00
	 zvd/FEATLXVSs621JXhOzHfwUMyyQkr87Q9Xjry207hAdxwp7FMQi9HMeP3sUUJuCKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AY1Qoaw/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F74460A2600;
	Wed, 18 Nov 2026 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AY1Qoaw/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64ED81F000C5;
	Wed, 18 Nov 2026 18:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025334;
	bh=6apcGQ3Bwc8k8AjgRneVaajIYbXMdhhQWpL3rUug+bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AY1Qoaw/hTwSSup0j/Mb586r5leWIwmVTWanEc+sURY2vSLVW/zY9QJE5ewUzOKae
	 SfZmN32/HQ+Q/1fJRs7nuJsGiqgzHx77wRzbjHxsK8BvnRgIxhTd7qMuluwVvbS3zN
	 YSHqmXBywPhL1jmrRBujiLh6ueU8aLtJNxz4Na7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1043/2151] perf/cxl: Unfreeze counters after handling an overflow interrupt
Date: Wed, 18 Nov 2026 15:46:18 +0100
Message-ID: <20261118150200.325419297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 912cc125b41aa..1d2bc25155929 100644
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
@@ -595,6 +597,7 @@ static void cxl_pmu_enable(struct pmu *pmu)
 	void __iomem *base = info->base;
 
 	/* Can assume frozen at this stage */
+	WRITE_ONCE(info->enabled, true);
 	writeq(0, base + CXL_PMU_FREEZE_REG);
 }
 
@@ -603,6 +606,7 @@ static void cxl_pmu_disable(struct pmu *pmu)
 	struct cxl_pmu_info *info = pmu_to_cxl_pmu_info(pmu);
 	void __iomem *base = info->base;
 
+	WRITE_ONCE(info->enabled, false);
 	/*
 	 * Whilst bits above number of counters are RsvdZ
 	 * they are unlikely to be repurposed given
@@ -801,6 +805,21 @@ static irqreturn_t cxl_pmu_irq(int irq, void *data)
 
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



