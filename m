Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018514;
	b=BAoz3yfSMJL17sZanojlw52zsCQ/GM2BhsbCSltrXD5hAu6eja2MWei+ZkqVgoc3SNno
	 ZrVS+6X8ZSI1lpv2xiEEV1qCQ1xdgNO2SMmqi+sS/L0otX2iGvDOQVZTV0Rqn73bPIrxh
	 fyzZQ8tWLmSk19fw+oHQCVUwZUyGvxXDCNN+iYanzwjJQzSLLoIwmRKuHjTdlBpaPrUOQ
	 KV0MYioEeLq3E8gdx5yG1XkMVhzjTYNK8df6PSl7aGT6ShGYJOxPtCb0NWaTSFoI3mYXs
	 l2ozwToWzNWUD5i+ua/7xZm3tz9Rlbi20XL7RmKO1pwrlBPVkZKWN1n0HK0Le5z/b+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0kH2NM0Ejm1J24NYmVV125Ytx0CJKBzJVCWZt3j+lws=;
	b=uCFO4dYH6zTZkKVJb4LjMS1QpyqG/y6bOXTk2Mn1LimvPdJvWkBgxZcCQJVvd30dVZo7
	 +GQTPUJbaNxmJk7qRvkMBfEspD0a4eVxK3aFu7QMqJnrIG5Xkq53Y7dfOthbt9gM369nO
	 i4zchIavP09jCH5RgcWpmDU7B+5xvw7xjSUy/YFwSfh89DuGQvGn5dV9lS5IugkspCpOR
	 hlZOii6nKg8g8/OV39MUjP4h0YG5C0UGmx+Ftptrsg5k11ruvrG2Kcp1AofQ5QIwMh/C+
	 Qp0Qgt9E/P5F5HsxJ7wHExwcLdK13Tlb5Fns0IxzgcKVmuN4vmTYHkwVAqbyAHI2/6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDy+4MTK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F17606A339;
	Wed, 18 Nov 2026 16:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDy+4MTK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752341F000C4;
	Wed, 18 Nov 2026 16:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018514;
	bh=0kH2NM0Ejm1J24NYmVV125Ytx0CJKBzJVCWZt3j+lws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDy+4MTKmEqTd0/ypwmAkEEWRN1AyJcW62eYcZrGWUXM2wuXGn/BqxZYQSrYRV2eV
	 IbKjfzBV7IOklhCbQ42oDdam2ujc//794iEmvGk46Gv2xT27JguJ+elXzwG0nJ1Z0T
	 +onczgLX3GkS48dUA7AE/vrF1Sgmci/Mq1Jv7ukI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1260/2651] perf/cxl: Clear stale overflow status before using a counter
Date: Wed, 18 Nov 2026 15:41:40 +0100
Message-ID: <20261118150333.338705609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 05d82cf377f706d0b566b572bc66e3a2057bd68e ]

cxl_pmu_event_stop() leaves the counter's bit set in the overflow status
register and only cxl_pmu_irq() ever clears it, so a counter handed from
one event to the next starts with the previous owner's overflow pending.
The perf core stops and starts back to back with interrupts off, so an
interrupt latched over the handover lands on the new event. prev_count is 0
by then, so the read path adds a full period: 2^counter_width phantom
counts.

Clear the bit in cxl_pmu_event_start(), before the config write arms
Interrupt on Overflow. Clear the whole register at probe too, for counters
no event ever owns - the driver never touched it, so firmware or a previous
kernel can leave a bit set there.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: Richard Cheng <icheng@nvidia.com>
Closes: https://lore.kernel.org/linux-cxl/anAVpO--i5heVfz9@MWDK4CY14F/
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index c1c1f71c8d0a8..b22ef68b4a75a 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -795,6 +795,15 @@ static void cxl_pmu_event_start(struct perf_event *event, int flags)
 	 */
 	cfg |= FIELD_PREP(CXL_PMU_COUNTER_CFG_THRESHOLD_MSK,
 			  cxl_pmu_config1_get_threshold(event));
+
+	/*
+	 * Drop any overflow the previous owner of this counter left pending;
+	 * cxl_pmu_event_stop() does not. Otherwise an interrupt latched over
+	 * the handover gets charged to this event. Do it before arming Interrupt
+	 * on Overflow below, and note RW1C leaves the other counters alone.
+	 */
+	writeq(BIT_ULL(hwc->idx), base + CXL_PMU_OVERFLOW_REG);
+
 	writeq(cfg, base + CXL_PMU_COUNTER_CFG_REG(hwc->idx));
 
 	local64_set(&hwc->prev_count, 0);
@@ -1026,6 +1035,14 @@ static int cxl_pmu_probe(struct device *dev)
 	if (!irq_name)
 		return -ENOMEM;
 
+	/*
+	 * Same for counters no event owns yet: clear whatever firmware or a
+	 * previous kernel left set before the handler goes live. Bits above the
+	 * implemented counters are reserved, so only write those.
+	 */
+	writeq(GENMASK_ULL(info->num_counters - 1, 0),
+	       info->base + CXL_PMU_OVERFLOW_REG);
+
 	/*
 	 * The handler must run on info->on_cpu, so the interrupt cannot be
 	 * shared - IRQF_NOBALANCING is only honoured for the first action on a
-- 
2.53.0



