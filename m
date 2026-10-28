Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216484;
	b=BJtQYfr+J5C/2Lx1EpatnLanP2b0K/dlLgUpN3BNIoYsnVe9eGAHMCRS38QyWodlBI+i
	 gGpYqVtTIK0XAYNOJMkfJyx7kC9quRZQnz53Pmj06z2exoWAj1my7cOieA1ynb1jgbjKg
	 KDWOzbTZxABhsC9BVJ5Ar8DUzIW1PlCGNyHc59mdbqfHY6ez1SDTeUwXi7vUulNktltvN
	 RTcRiWhjJNYsUf3Ez+9wolY685yKmuv5qi5rH5YEGVkEJNMvVIwi4tXdOo0qxnMovnZXB
	 so7yHcV4rZdm30AE0n4tU+jq2hzzW+Q4Fj0l4xVDNpaN/9nyVTk2gVvqoQ+qVtkAf7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=679N6Kh6KKPQ4zGYlEHRFqcNd73TJZaBARRe0e8zlbY=;
	b=sFoz4sEvqXZC+lINaYkAGto8FRsz/YMqEdVNm9n34twjhtqJLuV8A35usqoNh9EtQYuv
	 sV7SdYMYtG+oZuP2HSvevMaARt8xZXQo6Y65lOQK0i+7HPozt1jLPjmJxYq3x3OGr8zzH
	 5Qnfsd/RVXcBYzaTNJlOyZ1xwGGXA7djU20rQBdceE9uPSFg8nwt2qz19t/6wosEFWwpT
	 /YPrLw+xaok3voZEZschL0rlQQLnJ8FtSdMvv6U56BY2Dxp9PQ2pdXeYvBRBSFSS3BX4J
	 L+DErhoG8KSw31Qx3UI4khqEeOKQCGNwltvz7FbQCwtuBs9O64LPwB2xBo5uLGlTs9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oj5ScrEc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF067606A31C;
	Wed, 28 Oct 2026 19:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oj5ScrEc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EEC1F01825;
	Wed, 28 Oct 2026 19:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216483;
	bh=679N6Kh6KKPQ4zGYlEHRFqcNd73TJZaBARRe0e8zlbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oj5ScrEcbO66igIQVS5/w52sU3QH8JRkDXBcqWM0nVvHoh4yLrkIZKF09URqyk34L
	 pn1Ee32bm83DDBOSICfgg7SnhEnMddrrjOz42eTpOh728UdG7DC3v2k5+ocH0lQQZ3
	 /Ll3iP287rrPpeAX+snMIh7yfvvZx9WR4UoF2j5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1572/1887] coresight: etm4x: missing cscfg_csdev_disable_active_config() in perf enable
Date: Wed, 28 Oct 2026 18:01:08 +0100
Message-ID: <20261028170535.239623977@linuxfoundation.org>
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

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 0a47f0be6557b4a851addd430383a4dc7ee08752 ]

In the perf enable path, there are missing cases where
cscfg_csdev_disable_active_config() is not called:

  - Branch broadcast is selected but not supported by the hardware
  - etm4_enable_hw() fails

This can lead to a leak of config_desc->active_cnt.
Fix this by properly calling cscfg_csdev_disable_active_config()
in these error paths.

Fixes: 810ac401db1f ("coresight: etm4x: Add complex configuration handlers to etmv4")
Suggested-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260725113645.57519-6-yeoreum.yun@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-core.c          | 38 +++++++++++--------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 32be2cd1b3b7d..0b77c180d8557 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -669,8 +669,6 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
 	struct etmv4_config *config = &drvdata->config;
 	struct perf_event_attr *attr = &event->attr;
-	unsigned long cfg_hash;
-	int preset;
 
 	/* Clear configuration from previous run */
 	memset(config, 0, sizeof(struct etmv4_config));
@@ -740,20 +738,6 @@ static int etm4_parse_event_config(struct coresight_device *csdev,
 		/* bit[12], Return stack enable bit */
 		config->cfg |= TRCCONFIGR_RS;
 
-	/*
-	 * Set any selected configuration and preset.
-	 *
-	 * This extracts the values of PMU_FORMAT_ATTR(configid) and PMU_FORMAT_ATTR(preset)
-	 * in the perf attributes defined in coresight-etm-perf.c.
-	 * configid uses bits 63:32 of attr->config2, preset uses bits 3:0 of attr->config.
-	 * A zero configid means no configuration active, preset = 0 means no preset selected.
-	 */
-	if (attr->config2 & GENMASK_ULL(63, 32)) {
-		cfg_hash = (u32)(attr->config2 >> 32);
-		preset = attr->config & 0xF;
-		ret = cscfg_csdev_enable_active_config(csdev, cfg_hash, preset);
-	}
-
 	/* branch broadcast - enable if selected and supported */
 	if (attr->config & BIT(ETM_OPT_BRANCH_BROADCAST)) {
 		if (!drvdata->trcbb) {
@@ -777,6 +761,9 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 {
 	int ret = 0;
 	struct etmv4_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
+	struct perf_event_attr *attr = &event->attr;
+	unsigned long cfg_hash = 0;
+	int preset;
 
 	if (WARN_ON_ONCE(drvdata->cpu != smp_processor_id())) {
 		ret = -EINVAL;
@@ -787,8 +774,27 @@ static int etm4_enable_perf(struct coresight_device *csdev,
 	ret = etm4_parse_event_config(csdev, event);
 	if (ret)
 		goto out;
+
+	/*
+	 * Set any selected configuration and preset.
+	 *
+	 * This extracts the values of PMU_FORMAT_ATTR(configid) and PMU_FORMAT_ATTR(preset)
+	 * in the perf attributes defined in coresight-etm-perf.c.
+	 * configid uses bits 63:32 of attr->config2, preset uses bits 3:0 of attr->config.
+	 * A zero configid means no configuration active, preset = 0 means no preset selected.
+	 */
+	if (attr->config2 & GENMASK_ULL(63, 32)) {
+		cfg_hash = (u32)(attr->config2 >> 32);
+		preset = attr->config & 0xF;
+		ret = cscfg_csdev_enable_active_config(csdev, cfg_hash, preset);
+		if (ret)
+			goto out;
+	}
+
 	/* And enable it */
 	ret = etm4_enable_hw(drvdata);
+	if (ret && cfg_hash)
+		cscfg_csdev_disable_active_config(csdev);
 
 out:
 	return ret;
-- 
2.53.0



