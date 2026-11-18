Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047942;
	b=06SkD9h/6ydJmGU3ViU78qHrvNnG6rORKwJAJMTh6TIuM3+YTIl4423UWZGgdDFNB3Yj
	 3UE/WTeqoQbpgy+rnr9z473KO+P1rUELhcd0POqR5RNqlJLqn16zu38Q9kvjVYcnUywvL
	 YrNQtRmDbx3LfvUvDDPOIlVebjfCANrcSPcGibNep8UceAP07QYzcTYzF93wOgzDakpBl
	 5a9sQ1OeHOdrAStlwxmiIoPCVho68f/QuF2zWgT6b/QPPApB4GAbcqhP/OmbHmtudpNBJ
	 R4M/5zi0N/EsHWpHDWRjXG7P5QAYnQW2U2JJZ8atK/agsC09Zenvc+NErsz3SxyIXZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047942;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YGfU68sHtXDaNJVQAKpNf6lrjEiFF/MmpdFkfau37S4=;
	b=j0iXpWTklXc3Duy1vZ0gP5VCxlWOSpzGr3/pAdyK9GKm7UJpbNnUDXKrQyMuCqz4YJQ7
	 qivKjL5yGLLVf6+Dx7OUD9fiA0QB3uC8sD5zLc3q7HzK7dPJmNey+GVPtcNmPDozXWe9N
	 pZOSNZDSL0zU6rki+04L1wf6g1ZMfnEKQLyDcQlhktoqzw6vPges51EZINGeNVfiSCL4Z
	 xgLLQaB21FtBcpIqOEDzwGZhuNRqiBs8w53OZnIB3FR5k5k3qIKdapo2obg1gu7wnwf6t
	 4qolT5XJ1WkcbGrWt0XiYOQzji45AD/Ml2QOnkkcRw6UZsX+M8g5uyAuUGcjy73JI7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hftK7DZj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CF1606A32C;
	Thu, 19 Nov 2026 00:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hftK7DZj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59451F000C5;
	Thu, 19 Nov 2026 00:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047942;
	bh=YGfU68sHtXDaNJVQAKpNf6lrjEiFF/MmpdFkfau37S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hftK7DZjcYRCtLRR5FGhWovy+X4i63/HIXVf5lVnWl5/Q0U4iQEVy7ky/8EN5GFzh
	 OSqALZVL49xVDPN93HlJ+U/hT5vWxEFwm4E+kr7TvkCFhN0ScdExyRmhfxT71BFwLx
	 RU0QWMzcx6s64FjjSBC7AnEx65BqfM8fZ77/XA2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1777/2857] soundwire: intel: add register_dai callback in hw_ops
Date: Wed, 18 Nov 2026 15:46:51 +0100
Message-ID: <20261118150305.258498228@linuxfoundation.org>
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

[ Upstream commit b6234bcc6589a0719ec91d810114c0b556a5b88b ]

No functionality change, only add indirection for DAI registration
helper.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20221111013135.38289-4-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: ee8a8cfe4e8d ("soundwire: intel: initialise quirk_mask before reading it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c           | 4 +++-
 drivers/soundwire/intel.h           | 7 +++++++
 include/linux/soundwire/sdw_intel.h | 3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 832bc0697464e..ae564c15b4a48 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1430,6 +1430,8 @@ const struct sdw_intel_hw_ops sdw_intel_cnl_hw_ops = {
 	.debugfs_init = intel_debugfs_init,
 	.debugfs_exit = intel_debugfs_exit,
 
+	.register_dai = intel_register_dai,
+
 	.pre_bank_switch = intel_pre_bank_switch,
 	.post_bank_switch = intel_post_bank_switch,
 };
@@ -1615,7 +1617,7 @@ int intel_link_startup(struct auxiliary_device *auxdev)
 		goto err_init;
 
 	/* Register DAIs */
-	ret = intel_register_dai(sdw);
+	ret = sdw_intel_register_dai(sdw);
 	if (ret) {
 		dev_err(dev, "DAI registration failed: %d\n", ret);
 		goto err_power_up;
diff --git a/drivers/soundwire/intel.h b/drivers/soundwire/intel.h
index 5548b8451d014..0521cab311a33 100644
--- a/drivers/soundwire/intel.h
+++ b/drivers/soundwire/intel.h
@@ -77,4 +77,11 @@ static inline void sdw_intel_debugfs_exit(struct sdw_intel *sdw)
 		SDW_INTEL_OPS(sdw, debugfs_exit)(sdw);
 }
 
+static inline int sdw_intel_register_dai(struct sdw_intel *sdw)
+{
+	if (SDW_INTEL_CHECK_OPS(sdw, register_dai))
+		return SDW_INTEL_OPS(sdw, register_dai)(sdw);
+	return -ENOTSUPP;
+}
+
 #endif /* __SDW_INTEL_LOCAL_H */
diff --git a/include/linux/soundwire/sdw_intel.h b/include/linux/soundwire/sdw_intel.h
index 211924e4ebf21..5be63d4fe62ec 100644
--- a/include/linux/soundwire/sdw_intel.h
+++ b/include/linux/soundwire/sdw_intel.h
@@ -299,6 +299,7 @@ struct sdw_intel;
 /* struct intel_sdw_hw_ops - SoundWire ops for Intel platforms.
  * @debugfs_init: initialize all debugfs capabilities
  * @debugfs_exit: close and cleanup debugfs capabilities
+ * @register_dai: read all PDI information and register DAIs
  * @pre_bank_switch: helper for bus management
  * @post_bank_switch: helper for bus management
  */
@@ -306,6 +307,8 @@ struct sdw_intel_hw_ops {
 	void (*debugfs_init)(struct sdw_intel *sdw);
 	void (*debugfs_exit)(struct sdw_intel *sdw);
 
+	int (*register_dai)(struct sdw_intel *sdw);
+
 	int (*pre_bank_switch)(struct sdw_intel *sdw);
 	int (*post_bank_switch)(struct sdw_intel *sdw);
 };
-- 
2.53.0



