Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018325;
	b=an8GbHZ15iGT39rzaON4p/exln9t8v9X2jWdS+OeM8Ooxz7SG8hm5etP4b2qQ2nQZYPW
	 3n8juz0sCzwkdnlAcKsTlzkizEaF5KqqoT17Up84ajM+7answakbkgvdY02YlAmm9Hnhf
	 pXP9hKO2TMmbfcrGoW05CyELdPpiq1s45Zo/oZziOZwK6pzq+87dvgbD31z8gPZ0ZjDdy
	 sJr/ylJcJBfFJ8kKtPIlUyUXzpqGUWiXFTEg3OucB2t+5O/k8kjpCd3qwNcxz6jdloceT
	 NrsQzB8S2zniBqiwXoHXhATQbLV/8+obED97h1XoYgjK8ZGHyhJNH1/AMuomIgIDVgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hg4iULxIUVnWrDE3pGITX29VthDEyjF/QriH+vI7XjE=;
	b=yaw1GQNMDRfoZRAFf1slIYLmxCI030SrGKkbelBYMPkOScEJW+ppvqB7YCqh++eTX9B4
	 B4oQENBAGg9XmaPFbSW+kR83wYbFmKdij+HcTtACep+SXLg4FMfOcpjlWvt5mkZDMPezO
	 4B7cTpZbERv6X45eIBKk9wX0wSYqkow0a9VwmdzATARwE4Ri4rUDVsZi4UlxKw/pbAVoB
	 +Nnry6lIfemf3t5UgfV9H6+NgV8G37duY10gGzJIwuZWHTdl0SH6NXHUsDNU1xbzg9u2/
	 +5hpVLBTMBYeIS9P3b8MRt9h8Lxz9O7K1jG0nqv4034minTP2wmL2XwYTJ4xFu7b5vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJvAgG+7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC07606A334;
	Wed, 18 Nov 2026 16:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RJvAgG+7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A2881F000C5;
	Wed, 18 Nov 2026 16:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018324;
	bh=hg4iULxIUVnWrDE3pGITX29VthDEyjF/QriH+vI7XjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RJvAgG+7gtNz67oOmBBWUDJSLt+2Kek5NaDrFK5FQ04YpP+39VEbOyjggQrNJzzwH
	 NKRV0zLqzgY/LZPbM5wvGPf1wWHYIiGI38F48+Tg/90k5KyWOIwvXLXuZ04ptbLzP0
	 6axvR8/M2s2Zg/rukgkshDgukD8GwgJgd/MsJc7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Mike Leach <mike.leach@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1200/2651] coresight: etm3x: fix inconsistencies with sysfs configuration
Date: Wed, 18 Nov 2026 15:40:40 +0100
Message-ID: <20261118150331.197075342@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 950cca5352b009dcf8ef0ca4a2fae850d26b552f ]

The current ETM3x configuration via sysfs can lead to the following
inconsistencies:

  - If a configuration is modified via sysfs while a perf session is
    active, the running configuration may differ between before
    a sched-out and after a subsequent sched-in.

To resolve these issues, separate the configuration into:

  - curr_config: the configuration applied to the current session
  - config: the configuration set via sysfs

Additionally:

  - Since curr_config and related fields are accessed only by the local CPU
    in etm_enable/disable_sysfs_smp_call() (similar to perf enable/disable),
    remove the lock/unlock from the sysfs enable/disable path and
    starting/dying_cpu path except when to access config fields only.

  - Some of sysfs interface read etm register directly. To reduce lock
    scope while the etm_enable_hw()/etm_disable_hw(), handle it via
    IPI so that registers could be read from on proper CPU.

Fixes: 1925a470ce69 ("coresight: etm3x: splitting struct etm_drvdata")
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Mike Leach <mike.leach@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20261003-separate_etm_cfg_v2-v13-5-5d8a29aead95@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm.h   |  4 +-
 .../coresight/coresight-etm3x-core.c          | 66 ++++++++-------
 .../coresight/coresight-etm3x-sysfs.c         | 80 +++++++++++++------
 3 files changed, 98 insertions(+), 52 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm.h b/drivers/hwtracing/coresight/coresight-etm.h
index 1d753cca29439..52f23a3c73642 100644
--- a/drivers/hwtracing/coresight/coresight-etm.h
+++ b/drivers/hwtracing/coresight/coresight-etm.h
@@ -226,7 +226,8 @@ struct etm_config {
  * @etmccr:	value of register ETMCCR.
  * @etmccer:	value of register ETMCCER.
  * @traceid:	value of the current ID for this component.
- * @config:	structure holding configuration parameters.
+ * @curr_config:	structure holding current running configuration.
+ * @config:	structure holding sysfs mode configuration.
  */
 struct etm_drvdata {
 	struct csdev_access		csa;
@@ -248,6 +249,7 @@ struct etm_drvdata {
 	u32				etmccr;
 	u32				etmccer;
 	u32				traceid;
+	struct etm_config		curr_config;
 	struct etm_config		config;
 };
 
diff --git a/drivers/hwtracing/coresight/coresight-etm3x-core.c b/drivers/hwtracing/coresight/coresight-etm3x-core.c
index 862ad0786699c..dcadcc3830123 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-core.c
@@ -308,7 +308,7 @@ void etm_config_trace_mode(struct etm_config *config)
 static int etm_parse_event_config(struct etm_drvdata *drvdata,
 				  struct perf_event *event)
 {
-	struct etm_config *config = &drvdata->config;
+	struct etm_config *config = &drvdata->curr_config;
 	struct perf_event_attr *attr = &event->attr;
 	u8 ts_level;
 
@@ -367,7 +367,7 @@ static int etm_enable_hw(struct etm_drvdata *drvdata)
 {
 	int i, rc;
 	u32 etmcr;
-	struct etm_config *config = &drvdata->config;
+	struct etm_config *config = &drvdata->curr_config;
 	struct coresight_device *csdev = drvdata->csdev;
 
 	CS_UNLOCK(drvdata->csa.base);
@@ -448,26 +448,22 @@ struct etm_enable_arg {
 static void etm_enable_sysfs_smp_call(void *info)
 {
 	struct etm_enable_arg *arg = info;
+	struct etm_drvdata *drvdata;
 	struct coresight_device *csdev;
 
 	if (WARN_ON(!arg))
 		return;
 
-	csdev = arg->drvdata->csdev;
-	if (!coresight_take_mode(csdev, CS_MODE_SYSFS)) {
-		/* Someone is already using the tracer */
-		arg->rc = -EBUSY;
-		return;
-	}
+	drvdata = arg->drvdata;
+	csdev = drvdata->csdev;
 
-	arg->rc = etm_enable_hw(arg->drvdata);
+	drvdata->traceid = arg->path->trace_id;
 
-	/* The tracer didn't start */
-	if (arg->rc) {
-		coresight_set_mode(csdev, CS_MODE_DISABLED);
+	arg->rc = etm_enable_hw(arg->drvdata);
+	if (arg->rc)
 		return;
-	}
 
+	drvdata->sticky_enable = true;
 	csdev->path = arg->path;
 }
 
@@ -512,9 +508,10 @@ static int etm_enable_sysfs(struct coresight_device *csdev, struct coresight_pat
 	struct etm_enable_arg arg = { };
 	int ret;
 
-	spin_lock(&drvdata->spinlock);
-
-	drvdata->traceid = path->trace_id;
+	if (!coresight_take_mode(csdev, CS_MODE_SYSFS)) {
+		/* Someone is already using the tracer */
+		return -EBUSY;
+	}
 
 	/*
 	 * Configure the ETM only if the CPU is online.  If it isn't online
@@ -523,23 +520,27 @@ static int etm_enable_sysfs(struct coresight_device *csdev, struct coresight_pat
 	if (cpu_online(drvdata->cpu)) {
 		arg.drvdata = drvdata;
 		arg.path = path;
+
+		scoped_guard(spinlock, &drvdata->spinlock) {
+			drvdata->curr_config = drvdata->config;
+		}
+
 		ret = smp_call_function_single(drvdata->cpu,
 					       etm_enable_sysfs_smp_call, &arg, 1);
 		if (!ret)
 			ret = arg.rc;
-		if (!ret)
-			drvdata->sticky_enable = true;
 	} else {
 		ret = -ENODEV;
 	}
 
-	if (ret)
+	if (!ret) {
+		dev_dbg(&csdev->dev, "ETM tracing enabled\n");
+	} else {
 		etm_release_trace_id(drvdata);
+		/* The tracer didn't start */
+		coresight_set_mode(csdev, CS_MODE_DISABLED);
+	}
 
-	spin_unlock(&drvdata->spinlock);
-
-	if (!ret)
-		dev_dbg(&csdev->dev, "ETM tracing enabled\n");
 	return ret;
 }
 
@@ -565,7 +566,7 @@ static int etm_enable(struct coresight_device *csdev, struct perf_event *event,
 static void etm_disable_hw(struct etm_drvdata *drvdata)
 {
 	int i;
-	struct etm_config *config = &drvdata->config;
+	struct etm_config *config = &drvdata->curr_config;
 	struct coresight_device *csdev = drvdata->csdev;
 
 	CS_UNLOCK(drvdata->csa.base);
@@ -593,7 +594,6 @@ static void etm_disable_sysfs_smp_call(void *info)
 	etm_disable_hw(drvdata);
 
 	drvdata->csdev->path = NULL;
-	coresight_set_mode(drvdata->csdev, CS_MODE_DISABLED);
 }
 
 static void etm_disable_perf(struct coresight_device *csdev)
@@ -630,8 +630,9 @@ static void etm_disable_perf(struct coresight_device *csdev)
 static void etm_disable_sysfs(struct coresight_device *csdev)
 {
 	struct etm_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
-
-	spin_lock(&drvdata->spinlock);
+	struct etm_config *config = &drvdata->config;
+	const struct etm_config *curr_config = &drvdata->curr_config;
+	int i;
 
 	/*
 	 * Executing etm_disable_hw on the cpu whose ETM is being disabled
@@ -640,7 +641,14 @@ static void etm_disable_sysfs(struct coresight_device *csdev)
 	smp_call_function_single(drvdata->cpu, etm_disable_sysfs_smp_call,
 				 drvdata, 1);
 
-	spin_unlock(&drvdata->spinlock);
+	/*
+	 * Userspace may read seq_curr_state and cntr_val through sysfs
+	 * after the sysfs-session has been disabled.
+	 */
+	for (i = 0; i < drvdata->nr_cntr; i++)
+		config->cntr_val[i] = curr_config->cntr_val[i];
+
+	config->seq_curr_state = curr_config->seq_curr_state;
 
 	/*
 	 * we only release trace IDs when resetting sysfs.
@@ -649,6 +657,8 @@ static void etm_disable_sysfs(struct coresight_device *csdev)
 	 * prior trace id allocation method
 	 */
 
+	coresight_set_mode(drvdata->csdev, CS_MODE_DISABLED);
+
 	dev_dbg(&csdev->dev, "ETM tracing disabled\n");
 }
 
diff --git a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
index cdb70a4382eb8..284998f180170 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
@@ -6,10 +6,48 @@
 
 #include <linux/pid_namespace.h>
 #include <linux/pm_runtime.h>
+#include <linux/smp.h>
 #include <linux/sysfs.h>
 #include "coresight-etm.h"
 #include "coresight-priv.h"
 
+struct etm_readl_cslocked_arg {
+	struct etm_drvdata *drvdata;
+	u32 off;
+	unsigned long *val;
+};
+
+static void etm_readl_cslocked_smp_call(void *info)
+{
+	struct etm_readl_cslocked_arg *arg = info;
+
+	CS_UNLOCK(arg->drvdata->csa.base);
+	*arg->val = etm_readl(arg->drvdata, arg->off);
+	CS_LOCK(arg->drvdata->csa.base);
+}
+
+static int etm_readl_cslocked(struct etm_drvdata *drvdata, u32 off,
+			      unsigned long *val)
+{
+	int ret;
+	struct etm_readl_cslocked_arg arg;
+
+	ret = pm_runtime_get_sync(drvdata->csdev->dev.parent);
+	if (ret < 0)
+		goto out;
+
+	arg.drvdata = drvdata;
+	arg.off = off;
+	arg.val = val;
+
+	ret = smp_call_function_single(drvdata->cpu,
+				       etm_readl_cslocked_smp_call,
+				       (void *)&arg, 1);
+out:
+	pm_runtime_put(drvdata->csdev->dev.parent);
+	return ret;
+}
+
 static ssize_t nr_addr_cmp_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -45,18 +83,13 @@ static DEVICE_ATTR_RO(nr_ctxid_cmp);
 static ssize_t etmsr_show(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
-	unsigned long flags, val;
+	int ret;
+	unsigned long val;
 	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
 
-	pm_runtime_get_sync(dev->parent);
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-	CS_UNLOCK(drvdata->csa.base);
-
-	val = etm_readl(drvdata, ETMSR);
-
-	CS_LOCK(drvdata->csa.base);
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	pm_runtime_put(dev->parent);
+	ret = etm_readl_cslocked(drvdata, ETMSR, &val);
+	if (ret)
+		return ret;
 
 	return sprintf(buf, "%#lx\n", val);
 }
@@ -76,7 +109,7 @@ static ssize_t reset_store(struct device *dev,
 		return ret;
 
 	if (IS_ERR_OR_NULL(drvdata->csdev) ||
-	    coresight_get_mode(drvdata->csdev))
+	    coresight_get_mode(drvdata->csdev) == CS_MODE_SYSFS)
 		return -EBUSY;
 
 	if (val) {
@@ -721,7 +754,9 @@ static DEVICE_ATTR_RW(cntr_rld_event);
 static ssize_t cntr_val_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
+	int ret;
 	u32 val;
+	unsigned long val2;
 	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
 	struct etm_config *config = &drvdata->config;
 
@@ -730,7 +765,10 @@ static ssize_t cntr_val_show(struct device *dev,
 		val = config->cntr_val[config->cntr_idx];
 		spin_unlock(&drvdata->spinlock);
 	} else {
-		val = etm_readl(drvdata, ETMCNTVRn(config->cntr_idx));
+		ret = etm_readl_cslocked(drvdata, ETMCNTVRn(config->cntr_idx), &val2);
+		if (ret)
+			return ret;
+		val = val2;
 	}
 
 	return sysfs_emit(buf, "%#x\n", val);
@@ -749,7 +787,7 @@ static ssize_t cntr_val_store(struct device *dev,
 	if (ret)
 		return ret;
 	if (IS_ERR_OR_NULL(drvdata->csdev) ||
-	    coresight_get_mode(drvdata->csdev))
+	    coresight_get_mode(drvdata->csdev) == CS_MODE_SYSFS)
 		return -EBUSY;
 
 	spin_lock(&drvdata->spinlock);
@@ -937,7 +975,8 @@ static DEVICE_ATTR_RW(seq_13_event);
 static ssize_t seq_curr_state_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	unsigned long val, flags;
+	int ret;
+	unsigned long val;
 	struct etm_drvdata *drvdata = dev_get_drvdata(dev->parent);
 	struct etm_config *config = &drvdata->config;
 
@@ -946,15 +985,10 @@ static ssize_t seq_curr_state_show(struct device *dev,
 		goto out;
 	}
 
-	pm_runtime_get_sync(dev->parent);
-	spin_lock_irqsave(&drvdata->spinlock, flags);
-
-	CS_UNLOCK(drvdata->csa.base);
-	val = (etm_readl(drvdata, ETMSQR) & ETM_SQR_MASK);
-	CS_LOCK(drvdata->csa.base);
-
-	spin_unlock_irqrestore(&drvdata->spinlock, flags);
-	pm_runtime_put(dev->parent);
+	ret = etm_readl_cslocked(drvdata, ETMSQR, &val);
+	if (ret)
+		return ret;
+	val &= ETM_SQR_MASK;
 out:
 	return sprintf(buf, "%#lx\n", val);
 }
-- 
2.53.0



