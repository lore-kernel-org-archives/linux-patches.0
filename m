Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025344;
	b=FvZNpfJBaWrKxyvRIsI8Uc6RUmxayRW7p5WP5IOaBDts5F0Vt+zQLXz3BG0iCSHNu/YG
	 V09s487TcI7+0g9GPqFYyEqUj5O8+0QXjDIf+80R1VxmDidVQbiDKxji/RaQ4yGMpMQDQ
	 3UGQssh5reAMwJb6b8J/3ZjbTbR8eDIyW39cDscMw9aXomVDr+tohXG/nkij0qRRb6Juh
	 jfpn4UvqBo/jthiC3x7bx0JKPAtbYXdnaG0P9MfA/j98Ws6S82eXAFMWsPnpHD2C9nDD8
	 umF4nbJBlh4c7/21pNlTij+wbQLkbU5GXrVP5JLHLDL+0xicdrYbaX9WCipY5zHOU+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=97g5GLuAtul5c4eWsXAK5MZ7COgMKebIrha2fi/o3Yk=;
	b=X27Rgj8t+WAr0lFZs0+Lpx2uw8EYGfNglvcxvRh37mx+Ou1xOmywaYRHlkfKU/fygNvM
	 WB3/CJJO5+I/pT57qDbC2sgmC7AQSL1FZbiM+Qhyc8Z8zEIxqRCmgx2xna5LlfPBUS8tS
	 A3Q4lrNh8E/4gFIdXijPNpVSMEfC8MWm5CxWwg4XhVpfv/vsolb+ih94LeuT19Wj545Zb
	 Yma16VyM0HDQ9JW1CY0k3ju5MbKMcf8URhPLmNC+uPHD6yqNq+elm/KySvpa+dQwaUuzh
	 JzjFXU6BAqXvKbNX7Qd808L0RYM9htLYvRpduZ9TQLbc40gPs3Uvev8yLdcETSQ/H4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wiMnSd6R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F013B60A2606;
	Wed, 18 Nov 2026 18:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wiMnSd6R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F259A1F000C5;
	Wed, 18 Nov 2026 18:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025343;
	bh=97g5GLuAtul5c4eWsXAK5MZ7COgMKebIrha2fi/o3Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wiMnSd6RAHE05+Ckd1ezCVH9sKFUpD/swdHPVQnVrZ+/PHmyEouckuzVVbl7nZzfH
	 9QsdDIw9Pqvt/GbzLW6hS44mm0pmjoIO8cs1hR6zrC9HJLIe4Aa7lpLEAqBm0B9ZM5
	 jad6lJW0YMbv4YwU7rzJ25R9S0j6h47uYu97y0Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1046/2151] perf/cxl: Clear stale overflow status before using a counter
Date: Wed, 18 Nov 2026 15:46:21 +0100
Message-ID: <20261118150200.429857878@linuxfoundation.org>
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
index 44fb4a4692c8e..b9c158c2f864f 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -682,6 +682,15 @@ static void cxl_pmu_event_start(struct perf_event *event, int flags)
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
@@ -913,6 +922,14 @@ static int cxl_pmu_probe(struct device *dev)
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



