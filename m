Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585943;
	b=hoebKTnYs9x/BFs6rosbWkkVbrpr7wH42xHAlx244FwCYjM1H/p5Q18cO4XSwRnj3FG8
	 zH/FnOOnGzzmiWRuEwL6qqDbA4krzy0zPPReLRy9yUfLzCq8r4+qTMX/k7d4VGcRI8di3
	 jSFbX8gVkU4J5j6CCCrcFfLTmCxow1r1oPW9xxMXASSdLca2CdLV4/ATcpKj4q45HzpfP
	 s55kLZtjFlVY0IA0PxIgXhyCgULkMnVCzr+MyexfPq/ymR6MHVtrNVT9iunZVoqNnHNAb
	 /I6esczDVwayy7KyG5V1GGfVWGXvYMYT0YfTv43sydlorQdXIJYCbW0YOAT/r/xyJbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qV11AP3BIvxWNM/2tGn9MyUHKzrQDMiQ1QT7PM0HiIY=;
	b=BlcFqdc/8XCBGWAh/w+/PoApFgZRgwbIZHC1PIgXwtjaVwPQ61E9rK7e/U8ed4eqtVYc
	 8Az63g2VHfjtxxkEfP5y7+SriIZp3/Vmd3BQYs6Tj0yvDcODOpQOOFKdg0DERgiyKBgMc
	 U0aYlR6MBGa38pm/oHVGuDxkBWHqiJiQmwpe/7u7QTI8XPW8kq8MjKJ2VE2oo8WsknXIk
	 0iO929b8x+inv6B7PgwxWPqcFvWhNIqvR7AtSZRjCWl1YCvAWGZI/D427QUCm22G4vMyg
	 lXcF9kOIS3qE4ySSzopwzGZHu6z0B86YUoy+HD3sWlx5/gKJ25xDcu+fG715PtRnLWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRhvilQD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278466070FC6;
	Fri, 13 Nov 2026 16:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZRhvilQD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78F11F000C4;
	Fri, 13 Nov 2026 16:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585943;
	bh=qV11AP3BIvxWNM/2tGn9MyUHKzrQDMiQ1QT7PM0HiIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZRhvilQD0Eid19ne0sQ57I5ItopA6D/7dud1ndDZYopyRxUyollnZRCkBuv55B5/Z
	 OEm+xig0x97YjncWGAtf/lrsC9RssY16sAjqhq2mU+cIdP3mSXrdWRTadvPu8PUhZS
	 USKAS1fXK1B2zBSjQg/XmR/EseFqhFjquoOBaStA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antti Laakso <antti.laakso@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 497/507] media: ipu6: Rename pointer to firmware context
Date: Fri, 13 Nov 2026 10:53:21 -0500
Message-ID: <20261113153813.949193495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Antti Laakso <antti.laakso@linux.intel.com>

[ Upstream commit ac1a76fdf7e1815445c76d90ef688eff85cbb012 ]

The name fwcom is used to refer firmware communication context
and firmware communication configuration. Try to avoid confusion
and rename context variable.

Signed-off-by: Antti Laakso <antti.laakso@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Stable-dep-of: d3d9bc694fe0 ("media: ipu6: Fix firmware config leak on stream start")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6-fw-isys.c   | 56 ++++++++++---------
 .../media/pci/intel/ipu6/ipu6-isys-video.c    |  4 +-
 drivers/media/pci/intel/ipu6/ipu6-isys.c      |  6 +-
 drivers/media/pci/intel/ipu6/ipu6-isys.h      |  5 +-
 4 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/media/pci/intel/ipu6/ipu6-fw-isys.c b/drivers/media/pci/intel/ipu6/ipu6-fw-isys.c
index 62ed92ff1d303..a65e9f1aa1042 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-fw-isys.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-fw-isys.c
@@ -32,7 +32,7 @@ static int handle_proxy_response(struct ipu6_isys *isys, unsigned int req_id)
 	struct ipu6_fw_isys_proxy_resp_info_abi *resp;
 	int ret;
 
-	resp = ipu6_recv_get_token(isys->fwcom, IPU6_BASE_PROXY_RECV_QUEUES);
+	resp = ipu6_recv_get_token(isys->fwctx, IPU6_BASE_PROXY_RECV_QUEUES);
 	if (!resp)
 		return 1;
 
@@ -42,7 +42,7 @@ static int handle_proxy_response(struct ipu6_isys *isys, unsigned int req_id)
 
 	ret = req_id == resp->request_id ? 0 : -EIO;
 
-	ipu6_recv_put_token(isys->fwcom, IPU6_BASE_PROXY_RECV_QUEUES);
+	ipu6_recv_put_token(isys->fwctx, IPU6_BASE_PROXY_RECV_QUEUES);
 
 	return ret;
 }
@@ -52,7 +52,7 @@ int ipu6_fw_isys_send_proxy_token(struct ipu6_isys *isys,
 				  unsigned int index,
 				  unsigned int offset, u32 value)
 {
-	struct ipu6_fw_com_context *ctx = isys->fwcom;
+	struct ipu6_fw_com_context *ctx = isys->fwctx;
 	struct device *dev = &isys->adev->auxdev.dev;
 	struct ipu6_fw_proxy_send_queue_token *token;
 	unsigned int timeout = 1000;
@@ -96,7 +96,7 @@ int ipu6_fw_isys_complex_cmd(struct ipu6_isys *isys,
 			     dma_addr_t dma_mapped_buf,
 			     size_t size, u16 send_type)
 {
-	struct ipu6_fw_com_context *ctx = isys->fwcom;
+	struct ipu6_fw_com_context *ctx = isys->fwctx;
 	struct device *dev = &isys->adev->auxdev.dev;
 	struct ipu6_fw_send_queue_token *token;
 
@@ -138,7 +138,7 @@ int ipu6_fw_isys_close(struct ipu6_isys *isys)
 	struct device *dev = &isys->adev->auxdev.dev;
 	int retry = IPU6_ISYS_CLOSE_RETRY;
 	unsigned long flags;
-	void *fwcom;
+	void *fwctx;
 	int ret;
 
 	/*
@@ -148,9 +148,9 @@ int ipu6_fw_isys_close(struct ipu6_isys *isys)
 	 * spinlock to wait the interrupt handler to be finished
 	 */
 	spin_lock_irqsave(&isys->power_lock, flags);
-	ret = ipu6_fw_com_close(isys->fwcom);
-	fwcom = isys->fwcom;
-	isys->fwcom = NULL;
+	ret = ipu6_fw_com_close(isys->fwctx);
+	fwctx = isys->fwctx;
+	isys->fwctx = NULL;
 	spin_unlock_irqrestore(&isys->power_lock, flags);
 	if (ret)
 		dev_err(dev, "Device close failure: %d\n", ret);
@@ -158,14 +158,14 @@ int ipu6_fw_isys_close(struct ipu6_isys *isys)
 	/* release probably fails if the close failed. Let's try still */
 	do {
 		usleep_range(400, 500);
-		ret = ipu6_fw_com_release(fwcom, 0);
+		ret = ipu6_fw_com_release(fwctx, 0);
 		retry--;
 	} while (ret && retry);
 
 	if (ret) {
 		dev_err(dev, "Device release time out %d\n", ret);
 		spin_lock_irqsave(&isys->power_lock, flags);
-		isys->fwcom = fwcom;
+		isys->fwctx = fwctx;
 		spin_unlock_irqrestore(&isys->power_lock, flags);
 	}
 
@@ -176,11 +176,11 @@ void ipu6_fw_isys_cleanup(struct ipu6_isys *isys)
 {
 	int ret;
 
-	ret = ipu6_fw_com_release(isys->fwcom, 1);
+	ret = ipu6_fw_com_release(isys->fwctx, 1);
 	if (ret < 0)
 		dev_warn(&isys->adev->auxdev.dev,
 			 "Device busy, fw_com release failed.");
-	isys->fwcom = NULL;
+	isys->fwctx = NULL;
 }
 
 static void start_sp(struct ipu6_bus_device *adev)
@@ -212,7 +212,7 @@ static int query_sp(struct ipu6_bus_device *adev)
 }
 
 static int ipu6_isys_fwcom_cfg_init(struct ipu6_isys *isys,
-				    struct ipu6_fw_com_cfg *fwcom,
+				    struct ipu6_fw_com_cfg *fwcom_cfg,
 				    unsigned int num_streams)
 {
 	unsigned int max_send_queues, max_sram_blocks, max_devq_size;
@@ -258,14 +258,16 @@ static int ipu6_isys_fwcom_cfg_init(struct ipu6_isys *isys,
 	if (!output_queue_cfg)
 		return -ENOMEM;
 
-	fwcom->input = input_queue_cfg;
-	fwcom->output = output_queue_cfg;
+	fwcom_cfg->input = input_queue_cfg;
+	fwcom_cfg->output = output_queue_cfg;
 
-	fwcom->num_input_queues = isys_fw_cfg->num_send_queues[type_proxy] +
+	fwcom_cfg->num_input_queues =
+		isys_fw_cfg->num_send_queues[type_proxy] +
 		isys_fw_cfg->num_send_queues[type_dev] +
 		isys_fw_cfg->num_send_queues[type_msg];
 
-	fwcom->num_output_queues = isys_fw_cfg->num_recv_queues[type_proxy] +
+	fwcom_cfg->num_output_queues =
+		isys_fw_cfg->num_recv_queues[type_proxy] +
 		isys_fw_cfg->num_recv_queues[type_dev] +
 		isys_fw_cfg->num_recv_queues[type_msg];
 
@@ -280,7 +282,7 @@ static int ipu6_isys_fwcom_cfg_init(struct ipu6_isys *isys,
 			isys_fw_cfg->buffer_partition.num_gda_pages[i] = 0;
 	}
 
-	/* FW assumes proxy interface at fwcom queue 0 */
+	/* FW assumes proxy interface at fwcom_cfg queue 0 */
 	for (i = 0; i < isys_fw_cfg->num_send_queues[type_proxy]; i++) {
 		input_queue_cfg[i].token_size =
 			sizeof(struct ipu6_fw_proxy_send_queue_token);
@@ -314,9 +316,9 @@ static int ipu6_isys_fwcom_cfg_init(struct ipu6_isys *isys,
 			IPU6_ISYS_SIZE_RECV_QUEUE;
 	}
 
-	fwcom->dmem_addr = isys->pdata->ipdata->hw_variant.dmem_offset;
-	fwcom->specific_addr = isys_fw_cfg;
-	fwcom->specific_size = sizeof(*isys_fw_cfg);
+	fwcom_cfg->dmem_addr = isys->pdata->ipdata->hw_variant.dmem_offset;
+	fwcom_cfg->specific_addr = isys_fw_cfg;
+	fwcom_cfg->specific_size = sizeof(*isys_fw_cfg);
 
 	return 0;
 }
@@ -325,23 +327,23 @@ int ipu6_fw_isys_init(struct ipu6_isys *isys, unsigned int num_streams)
 {
 	struct device *dev = &isys->adev->auxdev.dev;
 	int retry = IPU6_ISYS_OPEN_RETRY;
-	struct ipu6_fw_com_cfg fwcom = {
+	struct ipu6_fw_com_cfg fwcom_cfg = {
 		.cell_start = start_sp,
 		.cell_ready = query_sp,
 		.buttress_boot_offset = SYSCOM_BUTTRESS_FW_PARAMS_ISYS_OFFSET,
 	};
 	int ret;
 
-	ipu6_isys_fwcom_cfg_init(isys, &fwcom, num_streams);
+	ipu6_isys_fwcom_cfg_init(isys, &fwcom_cfg, num_streams);
 
-	isys->fwcom = ipu6_fw_com_prepare(&fwcom, isys->adev,
+	isys->fwctx = ipu6_fw_com_prepare(&fwcom_cfg, isys->adev,
 					  isys->pdata->base);
-	if (!isys->fwcom) {
+	if (!isys->fwctx) {
 		dev_err(dev, "isys fw com prepare failed\n");
 		return -EIO;
 	}
 
-	ret = ipu6_fw_com_open(isys->fwcom);
+	ret = ipu6_fw_com_open(isys->fwctx);
 	if (ret) {
 		dev_err(dev, "isys fw com open failed %d\n", ret);
 		return ret;
@@ -349,7 +351,7 @@ int ipu6_fw_isys_init(struct ipu6_isys *isys, unsigned int num_streams)
 
 	do {
 		usleep_range(400, 500);
-		if (ipu6_fw_com_ready(isys->fwcom))
+		if (ipu6_fw_com_ready(isys->fwctx))
 			break;
 		retry--;
 	} while (retry > 0);
diff --git a/drivers/media/pci/intel/ipu6/ipu6-isys-video.c b/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
index 3ac48d2076da9..89eb265737d79 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
@@ -1114,7 +1114,7 @@ int ipu6_isys_fw_open(struct ipu6_isys *isys)
 	 */
 	ipu6_cleanup_fw_msg_bufs(isys);
 
-	if (isys->fwcom) {
+	if (isys->fwctx) {
 		/*
 		 * Something went wrong in previous shutdown. As we are now
 		 * restarting isys we can safely delete old context.
@@ -1147,7 +1147,7 @@ void ipu6_isys_fw_close(struct ipu6_isys *isys)
 	isys->ref_count--;
 	if (!isys->ref_count) {
 		ipu6_fw_isys_close(isys);
-		if (isys->fwcom) {
+		if (isys->fwctx) {
 			isys->need_reset = true;
 			dev_warn(&isys->adev->auxdev.dev,
 				 "failed to close fw isys\n");
diff --git a/drivers/media/pci/intel/ipu6/ipu6-isys.c b/drivers/media/pci/intel/ipu6/ipu6-isys.c
index 24db2763de544..e13fbbae8c98b 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-isys.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys.c
@@ -1212,10 +1212,10 @@ static int isys_isr_one(struct ipu6_bus_device *adev)
 	u32 index;
 	u64 ts;
 
-	if (!isys->fwcom)
+	if (!isys->fwctx)
 		return 1;
 
-	resp = ipu6_fw_isys_get_resp(isys->fwcom, IPU6_BASE_MSG_RECV_QUEUES);
+	resp = ipu6_fw_isys_get_resp(isys->fwctx, IPU6_BASE_MSG_RECV_QUEUES);
 	if (!resp)
 		return 1;
 
@@ -1324,7 +1324,7 @@ static int isys_isr_one(struct ipu6_bus_device *adev)
 
 	ipu6_isys_put_stream(stream);
 leave:
-	ipu6_fw_isys_put_resp(isys->fwcom, IPU6_BASE_MSG_RECV_QUEUES);
+	ipu6_fw_isys_put_resp(isys->fwctx, IPU6_BASE_MSG_RECV_QUEUES);
 	return 0;
 }
 
diff --git a/drivers/media/pci/intel/ipu6/ipu6-isys.h b/drivers/media/pci/intel/ipu6/ipu6-isys.h
index 7fb8cb820912b..0b139ab244312 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-isys.h
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys.h
@@ -114,8 +114,7 @@ struct sensor_async_sd {
  * @csi2_rx_ctrl_cached: cached shared value between all CSI2 receivers
  * @streams_lock: serialise access to streams
  * @streams: streams per firmware stream ID
- * @fwcom: fw communication layer private pointer
- *         or optional external library private pointer
+ * @fwctx: fw communication layer context pointer
  * @phy_termcal_val: the termination calibration value, only used for DWC PHY
  * @need_reset: Isys requires d0i0->i3 transition
  * @ref_count: total number of callers fw open
@@ -136,7 +135,7 @@ struct ipu6_isys {
 	spinlock_t streams_lock;
 	struct ipu6_isys_stream streams[IPU6_ISYS_MAX_STREAMS];
 	int streams_ref_count[IPU6_ISYS_MAX_STREAMS];
-	void *fwcom;
+	void *fwctx;
 	u32 phy_termcal_val;
 	bool need_reset;
 	bool icache_prefetch;
-- 
2.53.0



