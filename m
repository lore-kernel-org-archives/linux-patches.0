Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4141519AA;
	Wed,  5 Feb 2025 14:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764511; cv=none; b=q+OIv42R0c57neoXaKrkV2fnVit4DTMKkwua8xmzqhiHJG9kpemSMJGMMYhYkKbaFNOjM84/pGwLdiZ0UVV4w2SUUD0HJxecKCT8VpnRt5BP2B4C1cC9Ewq36228CdfJIcQxiU98NZ79UeC9PkLSAqtLRp6F6PcttY9GWxkbqsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764511; c=relaxed/simple;
	bh=hTxII047rdkd1oj7g8iO8sO33mLjdo3nWVsF1vns+t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TLDjRFHRZb80Gj2PE6zfZwjFgeov0IBsJ0V8B12gtfHRTY2pH8eZOuws/xoSOfxerNZCHRVM44IOznJVhS8ZBH1tynKNvpHXGlkEfiq4mVk4qiACBBpBvgZtAP8jGTnI9QTt1/mc61TeaSdZCM+naedy+4ir/SFDVRKX4hYvtGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMk4+qvy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMk4+qvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95332C4CED1;
	Wed,  5 Feb 2025 14:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764511;
	bh=hTxII047rdkd1oj7g8iO8sO33mLjdo3nWVsF1vns+t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMk4+qvywVK4bGT0cwCaRT4UyGxTGCb+3jPBqLNk4PEJKf1BeDvoLbDHaXbuSzlCQ
	 FAyBF0rjy4sz7xpMFgZ8E8yATuEoBee6Gtze3Sb6zxQx4qhx0a8NxN2m9WG/6rc/8x
	 JC4cKSrWSZfJKRkkLngt+25h1OrVBVynTDbba7f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/393] ASoC: Intel: avs: Prefix SKL/APL-specific members
Date: Wed,  5 Feb 2025 14:41:37 +0100
Message-ID: <20250205134427.111195827@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit a8f858d98f016a0209edaf1518fd45a5e5c62d47 ]

Prefix members that are platform-specific with 'avs_' to improve code
cohesiveness and reduce the chance for naming-conflics with other
drivers.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240220115035.770402-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: bca0fa5f6b5e ("ASoC: Intel: avs: Do not readq() u32 registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/apl.c      | 51 +++++++++++++++++-----------------
 sound/soc/intel/avs/avs.h      | 18 ++++++------
 sound/soc/intel/avs/core.c     |  4 +--
 sound/soc/intel/avs/messages.h | 10 +++----
 sound/soc/intel/avs/skl.c      | 30 ++++++++++----------
 5 files changed, 56 insertions(+), 57 deletions(-)

diff --git a/sound/soc/intel/avs/apl.c b/sound/soc/intel/avs/apl.c
index 1860099c782a7..24c06568b3e82 100644
--- a/sound/soc/intel/avs/apl.c
+++ b/sound/soc/intel/avs/apl.c
@@ -14,10 +14,10 @@
 #include "topology.h"
 
 static int __maybe_unused
-apl_enable_logs(struct avs_dev *adev, enum avs_log_enable enable, u32 aging_period,
-		u32 fifo_full_period, unsigned long resource_mask, u32 *priorities)
+avs_apl_enable_logs(struct avs_dev *adev, enum avs_log_enable enable, u32 aging_period,
+		    u32 fifo_full_period, unsigned long resource_mask, u32 *priorities)
 {
-	struct apl_log_state_info *info;
+	struct avs_apl_log_state_info *info;
 	u32 size, num_cores = adev->hw_cfg.dsp_cores;
 	int ret, i;
 
@@ -48,9 +48,9 @@ apl_enable_logs(struct avs_dev *adev, enum avs_log_enable enable, u32 aging_peri
 	return 0;
 }
 
-static int apl_log_buffer_status(struct avs_dev *adev, union avs_notify_msg *msg)
+static int avs_apl_log_buffer_status(struct avs_dev *adev, union avs_notify_msg *msg)
 {
-	struct apl_log_buffer_layout layout;
+	struct avs_apl_log_buffer_layout layout;
 	void __iomem *addr, *buf;
 
 	addr = avs_log_buffer_addr(adev, msg->log.core);
@@ -63,11 +63,11 @@ static int apl_log_buffer_status(struct avs_dev *adev, union avs_notify_msg *msg
 		/* consume the logs regardless of consumer presence */
 		goto update_read_ptr;
 
-	buf = apl_log_payload_addr(addr);
+	buf = avs_apl_log_payload_addr(addr);
 
 	if (layout.read_ptr > layout.write_ptr) {
 		avs_dump_fw_log(adev, buf + layout.read_ptr,
-				apl_log_payload_size(adev) - layout.read_ptr);
+				avs_apl_log_payload_size(adev) - layout.read_ptr);
 		layout.read_ptr = 0;
 	}
 	avs_dump_fw_log_wakeup(adev, buf + layout.read_ptr, layout.write_ptr - layout.read_ptr);
@@ -77,7 +77,8 @@ static int apl_log_buffer_status(struct avs_dev *adev, union avs_notify_msg *msg
 	return 0;
 }
 
-static int apl_wait_log_entry(struct avs_dev *adev, u32 core, struct apl_log_buffer_layout *layout)
+static int avs_apl_wait_log_entry(struct avs_dev *adev, u32 core,
+				  struct avs_apl_log_buffer_layout *layout)
 {
 	unsigned long timeout;
 	void __iomem *addr;
@@ -99,11 +100,11 @@ static int apl_wait_log_entry(struct avs_dev *adev, u32 core, struct apl_log_buf
 }
 
 /* reads log header and tests its type */
-#define apl_is_entry_stackdump(addr) ((readl(addr) >> 30) & 0x1)
+#define avs_apl_is_entry_stackdump(addr) ((readl(addr) >> 30) & 0x1)
 
-static int apl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
+static int avs_apl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 {
-	struct apl_log_buffer_layout layout;
+	struct avs_apl_log_buffer_layout layout;
 	void __iomem *addr, *buf;
 	size_t dump_size;
 	u16 offset = 0;
@@ -124,9 +125,9 @@ static int apl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 	if (!addr)
 		goto exit;
 
-	buf = apl_log_payload_addr(addr);
+	buf = avs_apl_log_payload_addr(addr);
 	memcpy_fromio(&layout, addr, sizeof(layout));
-	if (!apl_is_entry_stackdump(buf + layout.read_ptr)) {
+	if (!avs_apl_is_entry_stackdump(buf + layout.read_ptr)) {
 		union avs_notify_msg lbs_msg = AVS_NOTIFICATION(LOG_BUFFER_STATUS);
 
 		/*
@@ -142,11 +143,11 @@ static int apl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 	do {
 		u32 count;
 
-		if (apl_wait_log_entry(adev, msg->ext.coredump.core_id, &layout))
+		if (avs_apl_wait_log_entry(adev, msg->ext.coredump.core_id, &layout))
 			break;
 
 		if (layout.read_ptr > layout.write_ptr) {
-			count = apl_log_payload_size(adev) - layout.read_ptr;
+			count = avs_apl_log_payload_size(adev) - layout.read_ptr;
 			memcpy_fromio(pos + offset, buf + layout.read_ptr, count);
 			layout.read_ptr = 0;
 			offset += count;
@@ -165,7 +166,7 @@ static int apl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 	return 0;
 }
 
-static bool apl_lp_streaming(struct avs_dev *adev)
+static bool avs_apl_lp_streaming(struct avs_dev *adev)
 {
 	struct avs_path *path;
 
@@ -201,7 +202,7 @@ static bool apl_lp_streaming(struct avs_dev *adev)
 	return true;
 }
 
-static bool apl_d0ix_toggle(struct avs_dev *adev, struct avs_ipc_msg *tx, bool wake)
+static bool avs_apl_d0ix_toggle(struct avs_dev *adev, struct avs_ipc_msg *tx, bool wake)
 {
 	/* wake in all cases */
 	if (wake)
@@ -215,10 +216,10 @@ static bool apl_d0ix_toggle(struct avs_dev *adev, struct avs_ipc_msg *tx, bool w
 	 * Note: for cAVS 1.5+ and 1.8, D0IX is LP-firmware transition,
 	 * not the power-gating mechanism known from cAVS 2.0.
 	 */
-	return apl_lp_streaming(adev);
+	return avs_apl_lp_streaming(adev);
 }
 
-static int apl_set_d0ix(struct avs_dev *adev, bool enable)
+static int avs_apl_set_d0ix(struct avs_dev *adev, bool enable)
 {
 	bool streaming = false;
 	int ret;
@@ -231,7 +232,7 @@ static int apl_set_d0ix(struct avs_dev *adev, bool enable)
 	return AVS_IPC_RET(ret);
 }
 
-const struct avs_dsp_ops apl_dsp_ops = {
+const struct avs_dsp_ops avs_apl_dsp_ops = {
 	.power = avs_dsp_core_power,
 	.reset = avs_dsp_core_reset,
 	.stall = avs_dsp_core_stall,
@@ -241,10 +242,10 @@ const struct avs_dsp_ops apl_dsp_ops = {
 	.load_basefw = avs_hda_load_basefw,
 	.load_lib = avs_hda_load_library,
 	.transfer_mods = avs_hda_transfer_modules,
-	.log_buffer_offset = skl_log_buffer_offset,
-	.log_buffer_status = apl_log_buffer_status,
-	.coredump = apl_coredump,
-	.d0ix_toggle = apl_d0ix_toggle,
-	.set_d0ix = apl_set_d0ix,
+	.log_buffer_offset = avs_skl_log_buffer_offset,
+	.log_buffer_status = avs_apl_log_buffer_status,
+	.coredump = avs_apl_coredump,
+	.d0ix_toggle = avs_apl_d0ix_toggle,
+	.set_d0ix = avs_apl_set_d0ix,
 	AVS_SET_ENABLE_LOGS_OP(apl)
 };
diff --git a/sound/soc/intel/avs/avs.h b/sound/soc/intel/avs/avs.h
index 0cf38c9e768e7..fd394bb6479ba 100644
--- a/sound/soc/intel/avs/avs.h
+++ b/sound/soc/intel/avs/avs.h
@@ -64,8 +64,8 @@ struct avs_dsp_ops {
 #define avs_dsp_op(adev, op, ...) \
 	((adev)->spec->dsp_ops->op(adev, ## __VA_ARGS__))
 
-extern const struct avs_dsp_ops skl_dsp_ops;
-extern const struct avs_dsp_ops apl_dsp_ops;
+extern const struct avs_dsp_ops avs_skl_dsp_ops;
+extern const struct avs_dsp_ops avs_apl_dsp_ops;
 
 #define AVS_PLATATTR_CLDMA		BIT_ULL(0)
 #define AVS_PLATATTR_IMR		BIT_ULL(1)
@@ -264,7 +264,7 @@ void avs_ipc_block(struct avs_ipc *ipc);
 int avs_dsp_disable_d0ix(struct avs_dev *adev);
 int avs_dsp_enable_d0ix(struct avs_dev *adev);
 
-int skl_log_buffer_offset(struct avs_dev *adev, u32 core);
+int avs_skl_log_buffer_offset(struct avs_dev *adev, u32 core);
 
 /* Firmware resources management */
 
@@ -358,21 +358,21 @@ static inline int avs_log_buffer_status_locked(struct avs_dev *adev, union avs_n
 	return ret;
 }
 
-struct apl_log_buffer_layout {
+struct avs_apl_log_buffer_layout {
 	u32 read_ptr;
 	u32 write_ptr;
 	u8 buffer[];
 } __packed;
 
-#define apl_log_payload_size(adev) \
-	(avs_log_buffer_size(adev) - sizeof(struct apl_log_buffer_layout))
+#define avs_apl_log_payload_size(adev) \
+	(avs_log_buffer_size(adev) - sizeof(struct avs_apl_log_buffer_layout))
 
-#define apl_log_payload_addr(addr) \
-	(addr + sizeof(struct apl_log_buffer_layout))
+#define avs_apl_log_payload_addr(addr) \
+	(addr + sizeof(struct avs_apl_log_buffer_layout))
 
 #ifdef CONFIG_DEBUG_FS
 #define AVS_SET_ENABLE_LOGS_OP(name) \
-	.enable_logs = name##_enable_logs
+	.enable_logs = avs_##name##_enable_logs
 
 bool avs_logging_fw(struct avs_dev *adev);
 void avs_dump_fw_log(struct avs_dev *adev, const void __iomem *src, unsigned int len);
diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 859b217fc761b..3a36c71bbd502 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -720,7 +720,7 @@ static const struct avs_spec skl_desc = {
 		.hotfix = 0,
 		.build = 4732,
 	},
-	.dsp_ops = &skl_dsp_ops,
+	.dsp_ops = &avs_skl_dsp_ops,
 	.core_init_mask = 1,
 	.attributes = AVS_PLATATTR_CLDMA,
 	.sram_base_offset = SKL_ADSP_SRAM_BASE_OFFSET,
@@ -736,7 +736,7 @@ static const struct avs_spec apl_desc = {
 		.hotfix = 1,
 		.build = 4323,
 	},
-	.dsp_ops = &apl_dsp_ops,
+	.dsp_ops = &avs_apl_dsp_ops,
 	.core_init_mask = 3,
 	.attributes = AVS_PLATATTR_IMR,
 	.sram_base_offset = APL_ADSP_SRAM_BASE_OFFSET,
diff --git a/sound/soc/intel/avs/messages.h b/sound/soc/intel/avs/messages.h
index 7f23a304b4a94..9540401b093c1 100644
--- a/sound/soc/intel/avs/messages.h
+++ b/sound/soc/intel/avs/messages.h
@@ -357,21 +357,21 @@ enum avs_skl_log_priority {
 	AVS_SKL_LOG_VERBOSE,
 };
 
-struct skl_log_state {
+struct avs_skl_log_state {
 	u32 enable;
 	u32 min_priority;
 } __packed;
 
-struct skl_log_state_info {
+struct avs_skl_log_state_info {
 	u32 core_mask;
-	struct skl_log_state logs_core[];
+	struct avs_skl_log_state logs_core[];
 } __packed;
 
-struct apl_log_state_info {
+struct avs_apl_log_state_info {
 	u32 aging_timer_period;
 	u32 fifo_full_timer_period;
 	u32 core_mask;
-	struct skl_log_state logs_core[];
+	struct avs_skl_log_state logs_core[];
 } __packed;
 
 int avs_ipc_set_enable_logs(struct avs_dev *adev, u8 *log_info, size_t size);
diff --git a/sound/soc/intel/avs/skl.c b/sound/soc/intel/avs/skl.c
index 6bb8bbc70442b..7ea8d91b54d2e 100644
--- a/sound/soc/intel/avs/skl.c
+++ b/sound/soc/intel/avs/skl.c
@@ -13,10 +13,10 @@
 #include "messages.h"
 
 static int __maybe_unused
-skl_enable_logs(struct avs_dev *adev, enum avs_log_enable enable, u32 aging_period,
-		u32 fifo_full_period, unsigned long resource_mask, u32 *priorities)
+avs_skl_enable_logs(struct avs_dev *adev, enum avs_log_enable enable, u32 aging_period,
+		    u32 fifo_full_period, unsigned long resource_mask, u32 *priorities)
 {
-	struct skl_log_state_info *info;
+	struct avs_skl_log_state_info *info;
 	u32 size, num_cores = adev->hw_cfg.dsp_cores;
 	int ret, i;
 
@@ -45,7 +45,7 @@ skl_enable_logs(struct avs_dev *adev, enum avs_log_enable enable, u32 aging_peri
 	return 0;
 }
 
-int skl_log_buffer_offset(struct avs_dev *adev, u32 core)
+int avs_skl_log_buffer_offset(struct avs_dev *adev, u32 core)
 {
 	return core * avs_log_buffer_size(adev);
 }
@@ -53,8 +53,7 @@ int skl_log_buffer_offset(struct avs_dev *adev, u32 core)
 /* fw DbgLogWp registers */
 #define FW_REGS_DBG_LOG_WP(core) (0x30 + 0x4 * core)
 
-static int
-skl_log_buffer_status(struct avs_dev *adev, union avs_notify_msg *msg)
+static int avs_skl_log_buffer_status(struct avs_dev *adev, union avs_notify_msg *msg)
 {
 	void __iomem *buf;
 	u16 size, write, offset;
@@ -74,7 +73,7 @@ skl_log_buffer_status(struct avs_dev *adev, union avs_notify_msg *msg)
 	return 0;
 }
 
-static int skl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
+static int avs_skl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 {
 	u8 *dump;
 
@@ -88,20 +87,19 @@ static int skl_coredump(struct avs_dev *adev, union avs_notify_msg *msg)
 	return 0;
 }
 
-static bool
-skl_d0ix_toggle(struct avs_dev *adev, struct avs_ipc_msg *tx, bool wake)
+static bool avs_skl_d0ix_toggle(struct avs_dev *adev, struct avs_ipc_msg *tx, bool wake)
 {
 	/* unsupported on cAVS 1.5 hw */
 	return false;
 }
 
-static int skl_set_d0ix(struct avs_dev *adev, bool enable)
+static int avs_skl_set_d0ix(struct avs_dev *adev, bool enable)
 {
 	/* unsupported on cAVS 1.5 hw */
 	return 0;
 }
 
-const struct avs_dsp_ops skl_dsp_ops = {
+const struct avs_dsp_ops avs_skl_dsp_ops = {
 	.power = avs_dsp_core_power,
 	.reset = avs_dsp_core_reset,
 	.stall = avs_dsp_core_stall,
@@ -111,10 +109,10 @@ const struct avs_dsp_ops skl_dsp_ops = {
 	.load_basefw = avs_cldma_load_basefw,
 	.load_lib = avs_cldma_load_library,
 	.transfer_mods = avs_cldma_transfer_modules,
-	.log_buffer_offset = skl_log_buffer_offset,
-	.log_buffer_status = skl_log_buffer_status,
-	.coredump = skl_coredump,
-	.d0ix_toggle = skl_d0ix_toggle,
-	.set_d0ix = skl_set_d0ix,
+	.log_buffer_offset = avs_skl_log_buffer_offset,
+	.log_buffer_status = avs_skl_log_buffer_status,
+	.coredump = avs_skl_coredump,
+	.d0ix_toggle = avs_skl_d0ix_toggle,
+	.set_d0ix = avs_skl_set_d0ix,
 	AVS_SET_ENABLE_LOGS_OP(skl)
 };
-- 
2.39.5



