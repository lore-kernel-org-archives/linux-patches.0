Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047828;
	b=XzvbJBW2RIH+BoqxLQNgkEPeo+DvXACeBPjwgm3MlPUhBf3kVV2xWSIGWJ1h8GkCUD/J
	 qXhYN+tVJ6rWNOIEMY0xGYSG/uemI9FfubKnTe0E9EA17daAiIFfQH/ZHHtTJh5cVbQhE
	 S9H08LEjWYaBJV3imi9f89kd7DHZNOgMnNbdzThJHIL01NhtoU0X4jh9ZuqBSSmq0GEjm
	 Nga7H04yc3KDoMw0h70GQmhz9/UL3bd57QQZHvM2lJO5kijcHcUmooSIFqV51J3SccDuy
	 koncExWf9nDIDHj16f8ziUs1+N7hEcRS9zgJCFa/DQUDNMvenSPPSM57QlE4ALRAA/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k8F7iwsbZBP7+rt9yPq8KXiAQImk+No4L+ejqof+CwQ=;
	b=VpX2Y46Dl+zuegxNPX6FaF7ZKuE8tM7yknC+POTFJb6dp5ErlodDwk4FTCUmj75fuij5
	 yd+g0cZ1DnQw9/8pZFHAfgDoU2jif6yo9VxXfE1xstzcQihohzKJ7fOed+JHyWuLCopYq
	 V4vbWA36z+l4kuH/qgyZCazROPN6j1y0t1Etg/0RaPwi0kKOBo0Gyd7j/89KKluVP+gEI
	 g18DLY6Tu9y5sgXHen9G8psn7g6exrzqLpKMiq4gCyifU9AkEN/kFy0uG7kFFFTZkdmwV
	 /xR045+abmb1k8MC4pzIW5Opob5aDJhMX4D3d+kK+NlWwrVZ+BZadOw5aWaMzIGGaCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IMmjTkGQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F018606A31C;
	Thu, 19 Nov 2026 00:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IMmjTkGQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9441F000C4;
	Thu, 19 Nov 2026 00:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047828;
	bh=k8F7iwsbZBP7+rt9yPq8KXiAQImk+No4L+ejqof+CwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IMmjTkGQfNnRrBuXd/lCOm8Q9lk4GmFBeeC/ckvBpRbH6cYgbreSJojWmuIOoK9Ch
	 nlhpRD3kU/btwGJOvellyHc0vEt4n0WPppsUFzCs6LSLxioOmxmEFpVA8h6kIIiXQP
	 C7v7m7C4elNJgkrYd8KrQtAMQB9f5ng6SuO16UHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1779/2857] soundwire: intel: add link power management callbacks in hw_ops
Date: Wed, 18 Nov 2026 15:46:53 +0100
Message-ID: <20261118150305.330731861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 49c9ff45991a5a62e040c8b43c89a9ab38a0a91f ]

No functionality change, only add indirection for link power
management helpers.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20221111013135.38289-6-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: ee8a8cfe4e8d ("soundwire: intel: initialise quirk_mask before reading it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c           | 23 +++++++++++++----------
 drivers/soundwire/intel.h           | 14 ++++++++++++++
 include/linux/soundwire/sdw_intel.h |  5 +++++
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 90b1c42247dde..7377247bffd0e 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1438,6 +1438,9 @@ const struct sdw_intel_hw_ops sdw_intel_cnl_hw_ops = {
 	.start_bus_after_clock_stop = intel_start_bus_after_clock_stop,
 	.stop_bus = intel_stop_bus,
 
+	.link_power_up = intel_link_power_up,
+	.link_power_down = intel_link_power_down,
+
 	.pre_bank_switch = intel_pre_bank_switch,
 	.post_bank_switch = intel_post_bank_switch,
 };
@@ -1618,7 +1621,7 @@ int intel_link_startup(struct auxiliary_device *auxdev)
 	bus->multi_link = multi_link;
 
 	/* Initialize shim, controller */
-	ret = intel_link_power_up(sdw);
+	ret = sdw_intel_link_power_up(sdw);
 	if (ret)
 		goto err_init;
 
@@ -1683,7 +1686,7 @@ int intel_link_startup(struct auxiliary_device *auxdev)
 	return 0;
 
 err_power_up:
-	intel_link_power_down(sdw);
+	sdw_intel_link_power_down(sdw);
 err_init:
 	return ret;
 }
@@ -1939,7 +1942,7 @@ static int __maybe_unused intel_resume(struct device *dev)
 			pm_runtime_idle(dev);
 	}
 
-	ret = intel_link_power_up(sdw);
+	ret = sdw_intel_link_power_up(sdw);
 	if (ret) {
 		dev_err(dev, "%s failed: %d\n", __func__, ret);
 		return ret;
@@ -1954,7 +1957,7 @@ static int __maybe_unused intel_resume(struct device *dev)
 	ret = sdw_intel_start_bus(sdw);
 	if (ret < 0) {
 		dev_err(dev, "cannot start bus during resume\n");
-		intel_link_power_down(sdw);
+		sdw_intel_link_power_down(sdw);
 		return ret;
 	}
 
@@ -1993,7 +1996,7 @@ static int __maybe_unused intel_resume_runtime(struct device *dev)
 	clock_stop_quirks = sdw->link_res->clock_stop_quirks;
 
 	if (clock_stop_quirks & SDW_INTEL_CLK_STOP_TEARDOWN) {
-		ret = intel_link_power_up(sdw);
+		ret = sdw_intel_link_power_up(sdw);
 		if (ret) {
 			dev_err(dev, "%s: power_up failed after teardown: %d\n", __func__, ret);
 			return ret;
@@ -2008,13 +2011,13 @@ static int __maybe_unused intel_resume_runtime(struct device *dev)
 		ret = sdw_intel_start_bus(sdw);
 		if (ret < 0) {
 			dev_err(dev, "%s: cannot start bus after teardown: %d\n", __func__, ret);
-			intel_link_power_down(sdw);
+			sdw_intel_link_power_down(sdw);
 			return ret;
 		}
 
 
 	} else if (clock_stop_quirks & SDW_INTEL_CLK_STOP_BUS_RESET) {
-		ret = intel_link_power_up(sdw);
+		ret = sdw_intel_link_power_up(sdw);
 		if (ret) {
 			dev_err(dev, "%s: power_up failed after bus reset: %d\n", __func__, ret);
 			return ret;
@@ -2023,14 +2026,14 @@ static int __maybe_unused intel_resume_runtime(struct device *dev)
 		ret = sdw_intel_start_bus_after_reset(sdw);
 		if (ret < 0) {
 			dev_err(dev, "%s: cannot start bus after reset: %d\n", __func__, ret);
-			intel_link_power_down(sdw);
+			sdw_intel_link_power_down(sdw);
 			return ret;
 		}
 	} else if (!clock_stop_quirks) {
 
 		sdw_intel_check_clock_stop(sdw);
 
-		ret = intel_link_power_up(sdw);
+		ret = sdw_intel_link_power_up(sdw);
 		if (ret) {
 			dev_err(dev, "%s: power_up failed: %d\n", __func__, ret);
 			return ret;
@@ -2039,7 +2042,7 @@ static int __maybe_unused intel_resume_runtime(struct device *dev)
 		ret = sdw_intel_start_bus_after_clock_stop(sdw);
 		if (ret < 0) {
 			dev_err(dev, "%s: cannot start bus after clock stop: %d\n", __func__, ret);
-			intel_link_power_down(sdw);
+			sdw_intel_link_power_down(sdw);
 			return ret;
 		}
 	} else {
diff --git a/drivers/soundwire/intel.h b/drivers/soundwire/intel.h
index 99a2d875a3316..0f63e75841321 100644
--- a/drivers/soundwire/intel.h
+++ b/drivers/soundwire/intel.h
@@ -118,4 +118,18 @@ static inline int sdw_intel_stop_bus(struct sdw_intel *sdw, bool clock_stop)
 	return -ENOTSUPP;
 }
 
+static inline int sdw_intel_link_power_up(struct sdw_intel *sdw)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, link_power_up))
+		return SDW_INTEL_OPS(sdw, link_power_up)(sdw);
+	return -ENOTSUPP;
+}
+
+static inline int sdw_intel_link_power_down(struct sdw_intel *sdw)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, link_power_down))
+		return SDW_INTEL_OPS(sdw, link_power_down)(sdw);
+	return -ENOTSUPP;
+}
+
 #endif /* __SDW_INTEL_LOCAL_H */
diff --git a/include/linux/soundwire/sdw_intel.h b/include/linux/soundwire/sdw_intel.h
index cee61bc9af8ad..81430201b8b9d 100644
--- a/include/linux/soundwire/sdw_intel.h
+++ b/include/linux/soundwire/sdw_intel.h
@@ -305,6 +305,8 @@ struct sdw_intel;
  * @start_bus_after_reset: start after reset
  * @start_bus_after_clock_stop: start after mode0 clock stop
  * @stop_bus: stop all bus
+ * @link_power_up: power-up using chip-specific helpers
+ * @link_power_down: power-down with chip-specific helpers
  * @pre_bank_switch: helper for bus management
  * @post_bank_switch: helper for bus management
  */
@@ -320,6 +322,9 @@ struct sdw_intel_hw_ops {
 	int (*start_bus_after_clock_stop)(struct sdw_intel *sdw);
 	int (*stop_bus)(struct sdw_intel *sdw, bool clock_stop);
 
+	int (*link_power_up)(struct sdw_intel *sdw);
+	int (*link_power_down)(struct sdw_intel *sdw);
+
 	int (*pre_bank_switch)(struct sdw_intel *sdw);
 	int (*post_bank_switch)(struct sdw_intel *sdw);
 };
-- 
2.53.0



