Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047940;
	b=b3RJcqqoz0Hlhcu/ul3k+tZOBMJm56tKtUtegCsJET1C7COroM27hSBNo6boq7k/nHEJ
	 IpiKzAp9dQAstWGWN97E4ZVgmSJrEy05Ndy05trT0zB/Zzi/U72owLioGvwOTgCO1fn6u
	 EV8tZWZrGb6/P+AatCSW9p5YF+Bic81KRX/bx3Kpcg5nczK1i5q+J0pqJcyMc3c68yPCJ
	 OrQ3hJRrVbmZYLBX0oNbD55BBfWLR7NqzKonVDg1cYP8JK68BE5jCLRoMU/rxC2+elUJB
	 MCKDBXjDIFJUdNUtI4W+OwVz+Ds7RpT5GeUQvZDBSVGnCqiEyObgYKcjMUkxkfd+CMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NYpqNMn3hHAUn2LcIOn+rZHZelVBnHkj6mfex4U+d3E=;
	b=Q54vODdn62oCEw79h9UIt8J6QfKFaqq5IJK+slrxea4RYZABLUkYPs67M6p+BXw0Ok7i
	 WghKnHn0jJaWuML8lqy+mmDmAVty+rOca0EV+o4O/8iGT+NDZDFn37jXChuMQBJcUUS2j
	 acCTP0QOqz8/escj/VmrVuIe5BMr9eiFgr/BJx0DqdmWDADEy8N7PwJkwdwPgBtkmJ/P3
	 /qfXCxIOyzkzdajtXt1vr2juiFVPXkcbUxDUqdF/Csw96vs9hp2tfMnAf6+EdoV5qTmC4
	 4HRi+z/D5lWVwntBX0lYn2C62/c9XBG+7BtcmeedJJK/teXenFeug/stiYV0qTx5TnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQ06yLYK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EE8606A325;
	Thu, 19 Nov 2026 00:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQ06yLYK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B31E1F000C4;
	Thu, 19 Nov 2026 00:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047939;
	bh=NYpqNMn3hHAUn2LcIOn+rZHZelVBnHkj6mfex4U+d3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQ06yLYKHYxTdziswMZOE0wWlTIfTldu6/jyT9qwu2uU90waA3CyhJbvQRYtlZtMI
	 8ur+eZ2tLEBnKeWOcgWT73BJuwnyzPB29djUhELZlTOWvN5Ut7AOEt4ibqSjr1g1gp
	 YyX1JQARUYUF9L9LHe0volTuw/aZfW7J9JYrEg5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1776/2857] soundwire: intel: add debugfs callbacks in hw_ops
Date: Wed, 18 Nov 2026 15:46:50 +0100
Message-ID: <20261118150305.225480473@linuxfoundation.org>
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

[ Upstream commit fb2dc6a0a5f885233d632b1e92be9c0be977b0dc ]

No functionality change, only add indirection for debugfs helpers.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20221111013135.38289-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: ee8a8cfe4e8d ("soundwire: intel: initialise quirk_mask before reading it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c           |  7 +++++--
 drivers/soundwire/intel.h           | 16 ++++++++++++++++
 include/linux/soundwire/sdw_intel.h |  5 +++++
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index e3eaedd612353..832bc0697464e 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1427,6 +1427,9 @@ static int intel_stop_bus(struct sdw_intel *sdw, bool clock_stop)
 }
 
 const struct sdw_intel_hw_ops sdw_intel_cnl_hw_ops = {
+	.debugfs_init = intel_debugfs_init,
+	.debugfs_exit = intel_debugfs_exit,
+
 	.pre_bank_switch = intel_pre_bank_switch,
 	.post_bank_switch = intel_post_bank_switch,
 };
@@ -1618,7 +1621,7 @@ int intel_link_startup(struct auxiliary_device *auxdev)
 		goto err_power_up;
 	}
 
-	intel_debugfs_init(sdw);
+	sdw_intel_debugfs_init(sdw);
 
 	/* start bus */
 	ret = intel_start_bus(sdw);
@@ -1689,7 +1692,7 @@ static void intel_link_remove(struct auxiliary_device *auxdev)
 	 * SDW_INTEL_CLK_STOP_NOT_ALLOWED
 	 */
 	if (!bus->prop.hw_disabled) {
-		intel_debugfs_exit(sdw);
+		sdw_intel_debugfs_exit(sdw);
 		sdw_cdns_enable_interrupt(cdns, false);
 	}
 	sdw_bus_master_delete(bus);
diff --git a/drivers/soundwire/intel.h b/drivers/soundwire/intel.h
index 3170df76b4110..5548b8451d014 100644
--- a/drivers/soundwire/intel.h
+++ b/drivers/soundwire/intel.h
@@ -61,4 +61,20 @@ struct sdw_intel_link_dev {
 #define auxiliary_dev_to_sdw_intel_link_dev(auxiliary_dev) \
 	container_of(auxiliary_dev, struct sdw_intel_link_dev, auxdev)
 
+#define SDW_INTEL_CHECK_OPS(sdw, cb)	((sdw) && (sdw)->link_res && (sdw)->link_res->hw_ops && \
+					 (sdw)->link_res->hw_ops->cb)
+#define SDW_INTEL_OPS(sdw, cb)		((sdw)->link_res->hw_ops->cb)
+
+static inline void sdw_intel_debugfs_init(struct sdw_intel *sdw)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, debugfs_init))
+		SDW_INTEL_OPS(sdw, debugfs_init)(sdw);
+}
+
+static inline void sdw_intel_debugfs_exit(struct sdw_intel *sdw)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, debugfs_exit))
+		SDW_INTEL_OPS(sdw, debugfs_exit)(sdw);
+}
+
 #endif /* __SDW_INTEL_LOCAL_H */
diff --git a/include/linux/soundwire/sdw_intel.h b/include/linux/soundwire/sdw_intel.h
index 2dbe34b41ef14..211924e4ebf21 100644
--- a/include/linux/soundwire/sdw_intel.h
+++ b/include/linux/soundwire/sdw_intel.h
@@ -297,10 +297,15 @@ irqreturn_t sdw_intel_thread(int irq, void *dev_id);
 struct sdw_intel;
 
 /* struct intel_sdw_hw_ops - SoundWire ops for Intel platforms.
+ * @debugfs_init: initialize all debugfs capabilities
+ * @debugfs_exit: close and cleanup debugfs capabilities
  * @pre_bank_switch: helper for bus management
  * @post_bank_switch: helper for bus management
  */
 struct sdw_intel_hw_ops {
+	void (*debugfs_init)(struct sdw_intel *sdw);
+	void (*debugfs_exit)(struct sdw_intel *sdw);
+
 	int (*pre_bank_switch)(struct sdw_intel *sdw);
 	int (*post_bank_switch)(struct sdw_intel *sdw);
 };
-- 
2.53.0



