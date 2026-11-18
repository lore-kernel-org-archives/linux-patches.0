Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047945;
	b=lO42DPOHmLuanVUhxQhZ7LNbary+EPsBtUEm75zCGUV+5BydUAh/7mr8n4wclE8RHNEM
	 2lxlO8yVzKQSg6KJwRONMdsHLlNElN6onDaSCHRlUu+4V2m+tbAoIUW7r7jvmDRmSyzjl
	 pWw48QO5EYeodHBlDLUKfscic7wPs+fxq5N7nGa1pwrTOu2QYfJJ4eYawZqRQkeisR1H0
	 wn5r6TPKYHus6vEOyQWD7i7p17VccNpxBfueRW/iBJ6953hszAVTFcRxB8mFEv++z9xs1
	 XgdcLF48VEv9wSrwPAca7EJkOhKz9JxXWPeUDLsu3d8pU+yH780SQhV+tHVxyvuosMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6POxPvB9ye13+pEwl7aDaoOYK//EKqk1Uaq4UETIosg=;
	b=MFTYWyMiDiVxuUa5vcVLUO0IbdYMmIOQMJjUUlVRQxVy1ZQS87SXWivJ3K3mkYA5x1gs
	 4cP8YVIDo5ZkWZMRC4iGcH0Q9yYS0Zs/zVGg/JXdAO8yBDcTIghdqx26RaFD7dy0rBAIF
	 RFEswgF7WdV8AwLN0NzocQlAzeEH0YsTzVfU3MAOMUs9KoGzjoAnfoe5srisiM5nZVoOw
	 ByR6ijjKbZIB30C3tGh4ULq95cwYS5gW7RZ7k3eiEeNklhLGuRCB43VYP68LGeiu+3suU
	 JD66Y11NfybDeWI3S6wtjKWLPXCE1cRiMpnwSiSLMRDRLl+T4dUjJeOXXTwkqvQ6ErA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2JlCI2O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525D9606A330;
	Thu, 19 Nov 2026 00:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D2JlCI2O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15411F000C4;
	Thu, 19 Nov 2026 00:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047945;
	bh=6POxPvB9ye13+pEwl7aDaoOYK//EKqk1Uaq4UETIosg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2JlCI2Ocic7DxH0RBwomLxMccq3qd7MCYp7NBxHH3WApXrjg++Ex1l0NLRsW7eBQ
	 W0QwkW8bxhKE48ZdAqtVXes81skG05Lk/v4PDzadk2dmts+/SHUzv/rt3LsjQ2zVZ0
	 xaxq0jEseBrOgN5LxE/rxHoTV3Qrmc8RSedjNopg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1778/2857] soundwire: intel: add bus management callbacks in hw_ops
Date: Wed, 18 Nov 2026 15:46:52 +0100
Message-ID: <20261118150305.294127613@linuxfoundation.org>
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

[ Upstream commit 3db0c5a6a2832c7b4b40676299e4bbbe1a96bc8b ]

No functionality change, only add indirection for bus management
helpers.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20221111013135.38289-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: ee8a8cfe4e8d ("soundwire: intel: initialise quirk_mask before reading it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c           | 24 ++++++++++++--------
 drivers/soundwire/intel.h           | 34 +++++++++++++++++++++++++++++
 include/linux/soundwire/sdw_intel.h | 11 ++++++++++
 3 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index ae564c15b4a48..90b1c42247dde 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1432,6 +1432,12 @@ const struct sdw_intel_hw_ops sdw_intel_cnl_hw_ops = {
 
 	.register_dai = intel_register_dai,
 
+	.check_clock_stop = intel_check_clock_stop,
+	.start_bus = intel_start_bus,
+	.start_bus_after_reset = intel_start_bus_after_reset,
+	.start_bus_after_clock_stop = intel_start_bus_after_clock_stop,
+	.stop_bus = intel_stop_bus,
+
 	.pre_bank_switch = intel_pre_bank_switch,
 	.post_bank_switch = intel_post_bank_switch,
 };
@@ -1626,7 +1632,7 @@ int intel_link_startup(struct auxiliary_device *auxdev)
 	sdw_intel_debugfs_init(sdw);
 
 	/* start bus */
-	ret = intel_start_bus(sdw);
+	ret = sdw_intel_start_bus(sdw);
 	if (ret) {
 		dev_err(dev, "bus start failed: %d\n", ret);
 		goto err_power_up;
@@ -1854,7 +1860,7 @@ static int __maybe_unused intel_suspend(struct device *dev)
 		return 0;
 	}
 
-	ret = intel_stop_bus(sdw, false);
+	ret = sdw_intel_stop_bus(sdw, false);
 	if (ret < 0) {
 		dev_err(dev, "%s: cannot stop bus: %d\n", __func__, ret);
 		return ret;
@@ -1880,14 +1886,14 @@ static int __maybe_unused intel_suspend_runtime(struct device *dev)
 	clock_stop_quirks = sdw->link_res->clock_stop_quirks;
 
 	if (clock_stop_quirks & SDW_INTEL_CLK_STOP_TEARDOWN) {
-		ret = intel_stop_bus(sdw, false);
+		ret = sdw_intel_stop_bus(sdw, false);
 		if (ret < 0) {
 			dev_err(dev, "%s: cannot stop bus during teardown: %d\n",
 				__func__, ret);
 			return ret;
 		}
 	} else if (clock_stop_quirks & SDW_INTEL_CLK_STOP_BUS_RESET || !clock_stop_quirks) {
-		ret = intel_stop_bus(sdw, true);
+		ret = sdw_intel_stop_bus(sdw, true);
 		if (ret < 0) {
 			dev_err(dev, "%s: cannot stop bus during clock_stop: %d\n",
 				__func__, ret);
@@ -1945,7 +1951,7 @@ static int __maybe_unused intel_resume(struct device *dev)
 	 */
 	sdw_clear_slave_status(bus, SDW_UNATTACH_REQUEST_MASTER_RESET);
 
-	ret = intel_start_bus(sdw);
+	ret = sdw_intel_start_bus(sdw);
 	if (ret < 0) {
 		dev_err(dev, "cannot start bus during resume\n");
 		intel_link_power_down(sdw);
@@ -1999,7 +2005,7 @@ static int __maybe_unused intel_resume_runtime(struct device *dev)
 		 */
 		sdw_clear_slave_status(bus, SDW_UNATTACH_REQUEST_MASTER_RESET);
 
-		ret = intel_start_bus(sdw);
+		ret = sdw_intel_start_bus(sdw);
 		if (ret < 0) {
 			dev_err(dev, "%s: cannot start bus after teardown: %d\n", __func__, ret);
 			intel_link_power_down(sdw);
@@ -2014,7 +2020,7 @@ static int __maybe_unused intel_resume_runtime(struct device *dev)
 			return ret;
 		}
 
-		ret = intel_start_bus_after_reset(sdw);
+		ret = sdw_intel_start_bus_after_reset(sdw);
 		if (ret < 0) {
 			dev_err(dev, "%s: cannot start bus after reset: %d\n", __func__, ret);
 			intel_link_power_down(sdw);
@@ -2022,7 +2028,7 @@ static int __maybe_unused intel_resume_runtime(struct device *dev)
 		}
 	} else if (!clock_stop_quirks) {
 
-		intel_check_clock_stop(sdw);
+		sdw_intel_check_clock_stop(sdw);
 
 		ret = intel_link_power_up(sdw);
 		if (ret) {
@@ -2030,7 +2036,7 @@ static int __maybe_unused intel_resume_runtime(struct device *dev)
 			return ret;
 		}
 
-		ret = intel_start_bus_after_clock_stop(sdw);
+		ret = sdw_intel_start_bus_after_clock_stop(sdw);
 		if (ret < 0) {
 			dev_err(dev, "%s: cannot start bus after clock stop: %d\n", __func__, ret);
 			intel_link_power_down(sdw);
diff --git a/drivers/soundwire/intel.h b/drivers/soundwire/intel.h
index 0521cab311a33..99a2d875a3316 100644
--- a/drivers/soundwire/intel.h
+++ b/drivers/soundwire/intel.h
@@ -84,4 +84,38 @@ static inline int sdw_intel_register_dai(struct sdw_intel *sdw)
 	return -ENOTSUPP;
 }
 
+static inline void sdw_intel_check_clock_stop(struct sdw_intel *sdw)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, check_clock_stop))
+		SDW_INTEL_OPS(sdw, check_clock_stop)(sdw);
+}
+
+static inline int sdw_intel_start_bus(struct sdw_intel *sdw)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, start_bus))
+		return SDW_INTEL_OPS(sdw, start_bus)(sdw);
+	return -ENOTSUPP;
+}
+
+static inline int sdw_intel_start_bus_after_reset(struct sdw_intel *sdw)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, start_bus_after_reset))
+		return SDW_INTEL_OPS(sdw, start_bus_after_reset)(sdw);
+	return -ENOTSUPP;
+}
+
+static inline int sdw_intel_start_bus_after_clock_stop(struct sdw_intel *sdw)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, start_bus_after_clock_stop))
+		return SDW_INTEL_OPS(sdw, start_bus_after_clock_stop)(sdw);
+	return -ENOTSUPP;
+}
+
+static inline int sdw_intel_stop_bus(struct sdw_intel *sdw, bool clock_stop)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, stop_bus))
+		return SDW_INTEL_OPS(sdw, stop_bus)(sdw, clock_stop);
+	return -ENOTSUPP;
+}
+
 #endif /* __SDW_INTEL_LOCAL_H */
diff --git a/include/linux/soundwire/sdw_intel.h b/include/linux/soundwire/sdw_intel.h
index 5be63d4fe62ec..cee61bc9af8ad 100644
--- a/include/linux/soundwire/sdw_intel.h
+++ b/include/linux/soundwire/sdw_intel.h
@@ -300,6 +300,11 @@ struct sdw_intel;
  * @debugfs_init: initialize all debugfs capabilities
  * @debugfs_exit: close and cleanup debugfs capabilities
  * @register_dai: read all PDI information and register DAIs
+ * @check_clock_stop: throw error message if clock is not stopped.
+ * @start_bus: normal start
+ * @start_bus_after_reset: start after reset
+ * @start_bus_after_clock_stop: start after mode0 clock stop
+ * @stop_bus: stop all bus
  * @pre_bank_switch: helper for bus management
  * @post_bank_switch: helper for bus management
  */
@@ -309,6 +314,12 @@ struct sdw_intel_hw_ops {
 
 	int (*register_dai)(struct sdw_intel *sdw);
 
+	void (*check_clock_stop)(struct sdw_intel *sdw);
+	int (*start_bus)(struct sdw_intel *sdw);
+	int (*start_bus_after_reset)(struct sdw_intel *sdw);
+	int (*start_bus_after_clock_stop)(struct sdw_intel *sdw);
+	int (*stop_bus)(struct sdw_intel *sdw, bool clock_stop);
+
 	int (*pre_bank_switch)(struct sdw_intel *sdw);
 	int (*post_bank_switch)(struct sdw_intel *sdw);
 };
-- 
2.53.0



