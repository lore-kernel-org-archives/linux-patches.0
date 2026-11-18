Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047831;
	b=tiudvJdBYNY3fElj+mZNsphsHerTe/F84+iuW/SaK0H8O/yP0fZECPIcuoDKJCXHxU+r
	 sYiAQyH4F2W8hLXc6bZPuX1EqDiQVlY4V0aYsoWI3HAioUtPFQ6SOY/C0v8ObXV23oSLf
	 CRzfACc4hIaoDSR8CoJmnoc/MECB5zEfFsdynby0rj75kYP84b09ulQ0zkLYEJLNsi6vv
	 A2NlD8Qwez4EfOqYa/0oxWg3XXJutcLWoeAkkfTQO07xabelIaQKxcO6rlvWLajdJQcuk
	 aqJ1LExVEBU7cWyH1cwF3IyJ1r5JqsU1mp4KCw95PcvCjIcnOOmR1wOaRFIE70ih3xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QdOHX992ScfQZ54CCikiJrrksWGMIKwy93fmKeCW3zw=;
	b=OnPM6ctfld6Uwe/WSUKWU26mDWGZzaJxB0zzOkjnUcMPmt4+RfYsYdLjhw1rHVf/BHCe
	 MRwNi8fePH0ssW8WwvjoODrH+wBkYwNiFeV7sMU0O+qGE3L5Ub6crFin2Ew+5ZmK5+c5Z
	 g7Kqc9ybGxTTpwKqtre+pa4GR1pMbBqu01sI4JriXtBWwHakQH/vwcc+uzXDjTnu2U0z7
	 M9F4GZvxKXjPHZs1cTW0PtKN80Xm6gAULuWDbMEgFkmS4iuTwtbEoi/BHlo9PeHOowzjd
	 MGriX8mkgdO1oZsXkUwYgINFWQrNG3eNlZoRvZOa7Q67uayW7VTcQ2CWQCEglH7Tfbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lToddhR3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7527A606A325;
	Thu, 19 Nov 2026 00:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lToddhR3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66591F000C4;
	Thu, 19 Nov 2026 00:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047831;
	bh=QdOHX992ScfQZ54CCikiJrrksWGMIKwy93fmKeCW3zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lToddhR3egoplz4uJIFhGRxIl4QwiVytDQyWLlkDXqwO3jEvQ+M+nD0EBcvm9wfw5
	 aUd3CXqlbcncoG9lTBrnV3vzwfSrdow9/lFh8X3PAHTTmHNokDijpQRTtdBnNW17cO
	 H6JvJke471mdHh9ooQn4ED7TM8G2dpzsmZl5/UJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1780/2857] soundwire: intel: add in-band wake callbacks in hw_ops
Date: Wed, 18 Nov 2026 15:46:54 +0100
Message-ID: <20261118150305.368683243@linuxfoundation.org>
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

[ Upstream commit 36e3b385f35a33a10b792ec46350dd87d79e84dd ]

No functionality change, only add indirection for in-band wake
management helpers.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20221111013135.38289-7-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: ee8a8cfe4e8d ("soundwire: intel: initialise quirk_mask before reading it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c           | 11 +++++++----
 drivers/soundwire/intel.h           | 13 +++++++++++++
 include/linux/soundwire/sdw_intel.h |  5 +++++
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 7377247bffd0e..a13f4d74da587 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1441,6 +1441,9 @@ const struct sdw_intel_hw_ops sdw_intel_cnl_hw_ops = {
 	.link_power_up = intel_link_power_up,
 	.link_power_down = intel_link_power_down,
 
+	.shim_check_wake = intel_shim_check_wake,
+	.shim_wake = intel_shim_wake,
+
 	.pre_bank_switch = intel_pre_bank_switch,
 	.post_bank_switch = intel_post_bank_switch,
 };
@@ -1724,11 +1727,11 @@ int intel_link_process_wakeen_event(struct auxiliary_device *auxdev)
 		return 0;
 	}
 
-	if (!intel_shim_check_wake(sdw))
+	if (!sdw_intel_shim_check_wake(sdw))
 		return 0;
 
 	/* disable WAKEEN interrupt ASAP to prevent interrupt flood */
-	intel_shim_wake(sdw, false);
+	sdw_intel_shim_wake(sdw, false);
 
 	/*
 	 * resume the Master, which will generate a bus reset and result in
@@ -1856,7 +1859,7 @@ static int __maybe_unused intel_suspend(struct device *dev)
 				 */
 				dev_err(dev, "%s: invalid config: parent is suspended\n", __func__);
 			} else {
-				intel_shim_wake(sdw, false);
+				sdw_intel_shim_wake(sdw, false);
 			}
 		}
 
@@ -1991,7 +1994,7 @@ static int __maybe_unused intel_resume_runtime(struct device *dev)
 	}
 
 	/* unconditionally disable WAKEEN interrupt */
-	intel_shim_wake(sdw, false);
+	sdw_intel_shim_wake(sdw, false);
 
 	clock_stop_quirks = sdw->link_res->clock_stop_quirks;
 
diff --git a/drivers/soundwire/intel.h b/drivers/soundwire/intel.h
index 0f63e75841321..9ac3397757a07 100644
--- a/drivers/soundwire/intel.h
+++ b/drivers/soundwire/intel.h
@@ -132,4 +132,17 @@ static inline int sdw_intel_link_power_down(struct sdw_intel *sdw)
 	return -ENOTSUPP;
 }
 
+static inline int sdw_intel_shim_check_wake(struct sdw_intel *sdw)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, shim_check_wake))
+		return SDW_INTEL_OPS(sdw, shim_check_wake)(sdw);
+	return -ENOTSUPP;
+}
+
+static inline void sdw_intel_shim_wake(struct sdw_intel *sdw, bool wake_enable)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, shim_wake))
+		SDW_INTEL_OPS(sdw, shim_wake)(sdw, wake_enable);
+}
+
 #endif /* __SDW_INTEL_LOCAL_H */
diff --git a/include/linux/soundwire/sdw_intel.h b/include/linux/soundwire/sdw_intel.h
index 81430201b8b9d..0942cd4640953 100644
--- a/include/linux/soundwire/sdw_intel.h
+++ b/include/linux/soundwire/sdw_intel.h
@@ -307,6 +307,8 @@ struct sdw_intel;
  * @stop_bus: stop all bus
  * @link_power_up: power-up using chip-specific helpers
  * @link_power_down: power-down with chip-specific helpers
+ * @shim_check_wake: check if a wake was received
+ * @shim_wake: enable/disable in-band wake management
  * @pre_bank_switch: helper for bus management
  * @post_bank_switch: helper for bus management
  */
@@ -325,6 +327,9 @@ struct sdw_intel_hw_ops {
 	int (*link_power_up)(struct sdw_intel *sdw);
 	int (*link_power_down)(struct sdw_intel *sdw);
 
+	int  (*shim_check_wake)(struct sdw_intel *sdw);
+	void (*shim_wake)(struct sdw_intel *sdw, bool wake_enable);
+
 	int (*pre_bank_switch)(struct sdw_intel *sdw);
 	int (*post_bank_switch)(struct sdw_intel *sdw);
 };
-- 
2.53.0



