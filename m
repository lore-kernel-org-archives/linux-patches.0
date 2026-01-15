Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A286C2874E6;
	Thu, 15 Jan 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497475; cv=none; b=aKii7n4BbTqZLPA9b9r0yDQxGhcpg6S8gXW+5WtUlnItslZHDjfUNs6W1ds+DBXtOsHqxDwDXlNTLMPFdwnIgxXwRaWVqEkr9wN09eLeQZHuvQjwfKkhayisVeXrjEVMpd5u4FzXBIVsS9fjaRhqNJulO2XYQZ/Tw0WTuQ2Ea5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497475; c=relaxed/simple;
	bh=+c2VqT2ZmiEzVLxLtJAPNH5/EDFTuY/VEb7Yi+37Jok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KITOFZPI9el4XOpc3JSmdI8R4iCvsvVL3I68h+zV6E33YIiAKwnkBmeu/81mHZT77BJQu7XAGUMnkNWQJLDYeQyWyxH3ZqeT965l5PlmTp4O5y7dHmzo0hh63OiYObz3XYEYZAWj4YNXXLXZahXN598nwnAFE7FQ1UyAdocRVYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRTPbPGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRTPbPGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E60FC116D0;
	Thu, 15 Jan 2026 17:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497475;
	bh=+c2VqT2ZmiEzVLxLtJAPNH5/EDFTuY/VEb7Yi+37Jok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wRTPbPGcQA3E4UbL+HRqv3rYN9mQeoQslAfmv8WnIuflfSo8I7os8BZNUdTWbw2Ek
	 bs5WSucgdlUVnORCqGwZV/RF3AobdEPV+oBLs9h5tOMzBfpN3lhl2kmuVpaFmXqBDj
	 8PX9TtcPr4elW3m6RjwVVyBE0tzpjQHo3jgAE/fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Leo Yan <leo.yan@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/554] coresight: etm4x: Save restore TRFCR_EL1
Date: Thu, 15 Jan 2026 17:42:39 +0100
Message-ID: <20260115164249.612004236@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 937d3f58cacf377cab7c32e475e1ffa91d611dce ]

When the CPU enters a low power mode, the TRFCR_EL1 contents could be
reset. Thus we need to save/restore the TRFCR_EL1 along with the ETM4x
registers to allow the tracing.

The TRFCR related helpers are in a new header file, as we need to use
them for TRBE in the later patches.

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20210914102641.1852544-2-suzuki.poulose@arm.com
[Fixed cosmetic details]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 64eb04ae5452 ("coresight: etm4x: Add context synchronization before enabling trace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-core.c          | 43 +++++++++++++------
 drivers/hwtracing/coresight/coresight-etm4x.h |  2 +
 .../coresight/coresight-self-hosted-trace.h   | 24 +++++++++++
 3 files changed, 57 insertions(+), 12 deletions(-)
 create mode 100644 drivers/hwtracing/coresight/coresight-self-hosted-trace.h

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 84734c7c19158..d124931ee2be5 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -40,6 +40,7 @@
 #include "coresight-etm4x.h"
 #include "coresight-etm-perf.h"
 #include "coresight-etm4x-cfg.h"
+#include "coresight-self-hosted-trace.h"
 #include "coresight-syscfg.h"
 
 static int boot_enable;
@@ -1009,7 +1010,7 @@ static void cpu_enable_tracing(struct etmv4_drvdata *drvdata)
 	if (is_kernel_in_hyp_mode())
 		trfcr |= TRFCR_EL2_CX;
 
-	write_sysreg_s(trfcr, SYS_TRFCR_EL1);
+	write_trfcr(trfcr);
 }
 
 static void etm4_init_arch_data(void *info)
@@ -1534,7 +1535,7 @@ static void etm4_init_trace_id(struct etmv4_drvdata *drvdata)
 	drvdata->trcid = coresight_get_trace_id(drvdata->cpu);
 }
 
-static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
+static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 {
 	int i, ret = 0;
 	struct etmv4_save_state *state;
@@ -1674,7 +1675,23 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	return ret;
 }
 
-static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
+static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
+{
+	int ret = 0;
+
+	/* Save the TRFCR irrespective of whether the ETM is ON */
+	if (drvdata->trfc)
+		drvdata->save_trfcr = read_trfcr();
+	/*
+	 * Save and restore the ETM Trace registers only if
+	 * the ETM is active.
+	 */
+	if (local_read(&drvdata->mode) && drvdata->save_state)
+		ret = __etm4_cpu_save(drvdata);
+	return ret;
+}
+
+static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 {
 	int i;
 	struct etmv4_save_state *state = drvdata->save_state;
@@ -1773,6 +1790,14 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	etm4_cs_lock(drvdata, csa);
 }
 
+static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
+{
+	if (drvdata->trfc)
+		write_trfcr(drvdata->save_trfcr);
+	if (drvdata->state_needs_restore)
+		__etm4_cpu_restore(drvdata);
+}
+
 static int etm4_cpu_pm_notify(struct notifier_block *nb, unsigned long cmd,
 			      void *v)
 {
@@ -1784,23 +1809,17 @@ static int etm4_cpu_pm_notify(struct notifier_block *nb, unsigned long cmd,
 
 	drvdata = etmdrvdata[cpu];
 
-	if (!drvdata->save_state)
-		return NOTIFY_OK;
-
 	if (WARN_ON_ONCE(drvdata->cpu != cpu))
 		return NOTIFY_BAD;
 
 	switch (cmd) {
 	case CPU_PM_ENTER:
-		/* save the state if self-hosted coresight is in use */
-		if (local_read(&drvdata->mode))
-			if (etm4_cpu_save(drvdata))
-				return NOTIFY_BAD;
+		if (etm4_cpu_save(drvdata))
+			return NOTIFY_BAD;
 		break;
 	case CPU_PM_EXIT:
 	case CPU_PM_ENTER_FAILED:
-		if (drvdata->state_needs_restore)
-			etm4_cpu_restore(drvdata);
+		etm4_cpu_restore(drvdata);
 		break;
 	default:
 		return NOTIFY_DONE;
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 3ab528c6b91f1..74f1ba8ed148d 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -901,6 +901,7 @@ struct etmv4_save_state {
  * @lpoverride:	If the implementation can support low-power state over.
  * @trfc:	If the implementation supports Arm v8.4 trace filter controls.
  * @config:	structure holding configuration parameters.
+ * @save_trfcr:	Saved TRFCR_EL1 register during a CPU PM event.
  * @save_state:	State to be preserved across power loss
  * @state_needs_restore: True when there is context to restore after PM exit
  * @skip_power_up: Indicates if an implementation can skip powering up
@@ -954,6 +955,7 @@ struct etmv4_drvdata {
 	bool				lpoverride;
 	bool				trfc;
 	struct etmv4_config		config;
+	u64				save_trfcr;
 	struct etmv4_save_state		*save_state;
 	bool				state_needs_restore;
 	bool				skip_power_up;
diff --git a/drivers/hwtracing/coresight/coresight-self-hosted-trace.h b/drivers/hwtracing/coresight/coresight-self-hosted-trace.h
new file mode 100644
index 0000000000000..303d71911870f
--- /dev/null
+++ b/drivers/hwtracing/coresight/coresight-self-hosted-trace.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Arm v8 Self-Hosted trace support.
+ *
+ * Copyright (C) 2021 ARM Ltd.
+ */
+
+#ifndef __CORESIGHT_SELF_HOSTED_TRACE_H
+#define __CORESIGHT_SELF_HOSTED_TRACE_H
+
+#include <asm/sysreg.h>
+
+static inline u64 read_trfcr(void)
+{
+	return read_sysreg_s(SYS_TRFCR_EL1);
+}
+
+static inline void write_trfcr(u64 val)
+{
+	write_sysreg_s(val, SYS_TRFCR_EL1);
+	isb();
+}
+
+#endif /*  __CORESIGHT_SELF_HOSTED_TRACE_H */
-- 
2.51.0



