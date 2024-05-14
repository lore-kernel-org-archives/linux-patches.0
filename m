Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF33A33CC2;
	Tue, 14 May 2024 11:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686289; cv=none; b=TQ4GXohaK8WhuYIOQevKsVq6Caa4egkR53mAa+BC6mRVNI/+vwONssh9hofb2qrY3IhqNJ2o1xm1TWXnVGnpuu21mbAIID3M6jrdGYjBkP4KxObca6m74AFOsbAuqN+qDsAmLst5Aps7oiv3KOSkIQzA9zcc45KH8p6129NdX/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686289; c=relaxed/simple;
	bh=G33F742CWsSCjrq6GPgxaXXCrRa2HiIQGH05096Nwsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkw+LluCRLKCbPoiP6Ewx9ylp5aK2aHKqP42arhUWblx1kTPqjevfouZCYI67j6kYwxdvslIRLpOhSCSw673k8PA2DERxA/urCy0bGC1vBpquPYDGry2e5Pu0LkLNWJr3h/V0Bl8xo1nMDpo5+caOlBG+h8fSnMfGYmGR2twkck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tAhf/3ld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tAhf/3ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46270C2BD10;
	Tue, 14 May 2024 11:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686289;
	bh=G33F742CWsSCjrq6GPgxaXXCrRa2HiIQGH05096Nwsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAhf/3ld3Geq9ohKWEjJw1XN+dqK0FaUSJWeL0t0iF9K822ssonkL4scsB7oZw1Mg
	 ScuVcjQwI1akZVpsOksnRxC9M291EkmxUz8F7GbLTRi91bsCifpy3PaYWnk0DevWxz
	 jaA1sMxK6EBs4a/hL/8bRQg1LitvG7nKBK9qbJw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/236] spi: introduce new helpers with using modern naming
Date: Tue, 14 May 2024 12:16:46 +0200
Message-ID: <20240514101022.016671715@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit b8d3b056a78dcc941fd1a117697ab2b956c2953f ]

For using modern names host/target to instead of all the legacy names,
I think it takes 3 steps:
  - step1: introduce new helpers with modern naming.
  - step2: switch to use these new helpers in all drivers.
  - step3: remove all legacy helpers and update all legacy names.

This patch is for step1, it introduces new helpers with host/target
naming for drivers using.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221011092204.950288-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0064db9ce4aa ("spi: axi-spi-engine: fix version format string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c       | 11 ++++++++++
 include/linux/spi/spi.h | 47 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 19688f333e0bc..4aa2e0928de9c 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2774,6 +2774,17 @@ int spi_slave_abort(struct spi_device *spi)
 }
 EXPORT_SYMBOL_GPL(spi_slave_abort);
 
+int spi_target_abort(struct spi_device *spi)
+{
+	struct spi_controller *ctlr = spi->controller;
+
+	if (spi_controller_is_target(ctlr) && ctlr->target_abort)
+		return ctlr->target_abort(ctlr);
+
+	return -ENOTSUPP;
+}
+EXPORT_SYMBOL_GPL(spi_target_abort);
+
 static ssize_t slave_show(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 8e9054d9f6df0..6edf8a2962d4a 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -376,6 +376,7 @@ extern struct spi_device *spi_new_ancillary_device(struct spi_device *spi, u8 ch
  * @max_speed_hz: Highest supported transfer speed
  * @flags: other constraints relevant to this driver
  * @slave: indicates that this is an SPI slave controller
+ * @target: indicates that this is an SPI target controller
  * @devm_allocated: whether the allocation of this struct is devres-managed
  * @max_transfer_size: function that returns the max transfer size for
  *	a &spi_device; may be %NULL, so the default %SIZE_MAX will be used.
@@ -460,6 +461,7 @@ extern struct spi_device *spi_new_ancillary_device(struct spi_device *spi, u8 ch
  * @mem_caps: controller capabilities for the handling of memory operations.
  * @unprepare_message: undo any work done by prepare_message().
  * @slave_abort: abort the ongoing transfer request on an SPI slave controller
+ * @target_abort: abort the ongoing transfer request on an SPI target controller
  * @cs_gpiods: Array of GPIO descs to use as chip select lines; one per CS
  *	number. Any individual value may be NULL for CS lines that
  *	are not GPIOs (driven by the SPI controller itself).
@@ -556,8 +558,12 @@ struct spi_controller {
 	/* Flag indicating if the allocation of this struct is devres-managed */
 	bool			devm_allocated;
 
-	/* Flag indicating this is an SPI slave controller */
-	bool			slave;
+	union {
+		/* Flag indicating this is an SPI slave controller */
+		bool			slave;
+		/* Flag indicating this is an SPI target controller */
+		bool			target;
+	};
 
 	/*
 	 * on some hardware transfer / message size may be constrained
@@ -671,6 +677,7 @@ struct spi_controller {
 	int (*unprepare_message)(struct spi_controller *ctlr,
 				 struct spi_message *message);
 	int (*slave_abort)(struct spi_controller *ctlr);
+	int (*target_abort)(struct spi_controller *ctlr);
 
 	/*
 	 * These hooks are for drivers that use a generic implementation
@@ -748,6 +755,11 @@ static inline bool spi_controller_is_slave(struct spi_controller *ctlr)
 	return IS_ENABLED(CONFIG_SPI_SLAVE) && ctlr->slave;
 }
 
+static inline bool spi_controller_is_target(struct spi_controller *ctlr)
+{
+	return IS_ENABLED(CONFIG_SPI_SLAVE) && ctlr->target;
+}
+
 /* PM calls that need to be issued by the driver */
 extern int spi_controller_suspend(struct spi_controller *ctlr);
 extern int spi_controller_resume(struct spi_controller *ctlr);
@@ -784,6 +796,21 @@ static inline struct spi_controller *spi_alloc_slave(struct device *host,
 	return __spi_alloc_controller(host, size, true);
 }
 
+static inline struct spi_controller *spi_alloc_host(struct device *dev,
+						    unsigned int size)
+{
+	return __spi_alloc_controller(dev, size, false);
+}
+
+static inline struct spi_controller *spi_alloc_target(struct device *dev,
+						      unsigned int size)
+{
+	if (!IS_ENABLED(CONFIG_SPI_SLAVE))
+		return NULL;
+
+	return __spi_alloc_controller(dev, size, true);
+}
+
 struct spi_controller *__devm_spi_alloc_controller(struct device *dev,
 						   unsigned int size,
 						   bool slave);
@@ -803,6 +830,21 @@ static inline struct spi_controller *devm_spi_alloc_slave(struct device *dev,
 	return __devm_spi_alloc_controller(dev, size, true);
 }
 
+static inline struct spi_controller *devm_spi_alloc_host(struct device *dev,
+							 unsigned int size)
+{
+	return __devm_spi_alloc_controller(dev, size, false);
+}
+
+static inline struct spi_controller *devm_spi_alloc_target(struct device *dev,
+							   unsigned int size)
+{
+	if (!IS_ENABLED(CONFIG_SPI_SLAVE))
+		return NULL;
+
+	return __devm_spi_alloc_controller(dev, size, true);
+}
+
 extern int spi_register_controller(struct spi_controller *ctlr);
 extern int devm_spi_register_controller(struct device *dev,
 					struct spi_controller *ctlr);
@@ -1162,6 +1204,7 @@ static inline void spi_message_free(struct spi_message *m)
 extern int spi_setup(struct spi_device *spi);
 extern int spi_async(struct spi_device *spi, struct spi_message *message);
 extern int spi_slave_abort(struct spi_device *spi);
+extern int spi_target_abort(struct spi_device *spi);
 
 static inline size_t
 spi_max_message_size(struct spi_device *spi)
-- 
2.43.0



