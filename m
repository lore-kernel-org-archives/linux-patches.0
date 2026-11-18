Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017816;
	b=tV6OP8oOWluZwfRDhFnOY3viIcC+2su85bSeXZHvDePEI/9IVxdOSGd6mAi+U2JHzyyA
	 WwAF8ipvrVwWrztvJv7zJ9Z0+LhY4Jfc3WHF8Y69GWCnX3x0MVkhbwl5sPntVyQEidqKX
	 AKWhLD7vMQItVSgn+3MMTS96vCjD1JgtiXbkYggBPL2g0MlHmbD0xPm0HjsTg8Av567dK
	 +H+jJY9d05Fl7PUh/cMX6batKgPnuLmfUI8u9Eoml2hhgdixY59yKVlDShtRaqVaY/8ys
	 hzP7h4U3crPN2h64mfAZMHQ3sXSmA044H2mrslJQaaHwdgUyyejOM0vQt1eQaEKfXnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FN8Hw09pWJH4Rpm+UkzdhS+BBB71EB9sBk32kU+4n8k=;
	b=u4Dl1qH04cVMLalUWyuNfJicAgr1yKXBQepjIZ8mI9F13g2lvc71EPPRXAALVmo3ecJ7
	 VoufI2EE6tmh1IiIRi0SJbGlkfe5bKvd8ZcyrVX6w9UWg8xEBN27BdDRlt7TjH+kWTCkw
	 CsaWgD6p4JUkCMUTcmtqDgvhtAqL6oDqq500JHF3xhOZFfqev/85/uj6NG5o41W1CaXNG
	 6gWYNziNj8zJtsOrtUYgZnUtE1YBPFobR+WEW/G/6N8PRLlP12KcP+kv/xs3a91LSZlZC
	 GB043BZqsh1kWU7FbVdZCWQggp4qjAe9O5P6fw+ujUGEn4BP5d+quUfS7oWspduZaHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASVKX9Pl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEE0606A31C;
	Wed, 18 Nov 2026 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASVKX9Pl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11BEF1F000C5;
	Wed, 18 Nov 2026 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017816;
	bh=FN8Hw09pWJH4Rpm+UkzdhS+BBB71EB9sBk32kU+4n8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASVKX9PlvVVM9RZzTCs840jWBBwjSBkYT69WRBD7LOBXyi0Nn7tXuHuRFBQBnAwHQ
	 lkYVIeVIg7J7UmveZySJFPcGmjPX9aEjguWmu5S0In1ESl3i8jvrNYwNwy/+wAuOD4
	 /jXLds3EzPN0J4DRK/ld0aPLASN0rxKBSnSx5cR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vishnu Reddy <busanna.reddy@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1019/2651] Revert "media: iris: Add Gen2 firmware autodetect and fallback"
Date: Wed, 18 Nov 2026 15:37:39 +0100
Message-ID: <20261118150324.617766542@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 6f4eb91fa27644ed57cbb43fa44ce8eea02bce0c ]

The commit 412a2e5955e0 ("media: iris: Add Gen2 firmware autodetect and
fallback") added support for detecting the firmware HFI interface based
on the firmware contents, but it has issues with the MDT split files and
with synchronisation / locking. Revert the commit, it will be replaced
by the better version.

Fixes: 412a2e5955e0 ("media: iris: Add Gen2 firmware autodetect and fallback")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vishnu Reddy <busanna.reddy@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
[bod: Fixed merge conflict adding additional v4l2_device_register();]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/qcom/iris/iris_firmware.c  | 119 +++---------------
 .../platform/qcom/iris/iris_platform_common.h |   6 +-
 .../platform/qcom/iris/iris_platform_vpu2.c   |  13 +-
 .../platform/qcom/iris/iris_platform_vpu3x.c  |  10 +-
 drivers/media/platform/qcom/iris/iris_probe.c |   4 +
 drivers/media/platform/qcom/iris/iris_vidc.c  |   3 -
 6 files changed, 34 insertions(+), 121 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_firmware.c b/drivers/media/platform/qcom/iris/iris_firmware.c
index 21cdf1c398357..ea9654dd679e1 100644
--- a/drivers/media/platform/qcom/iris/iris_firmware.c
+++ b/drivers/media/platform/qcom/iris/iris_firmware.c
@@ -17,109 +17,20 @@
 
 #define MAX_FIRMWARE_NAME_SIZE	128
 
-/* Detect Gen2 firmware by scanning the blob for:
- *   QC_IMAGE_VERSION_STRING=<version>
- * and then checking:
- *   - version starts with "vfw", OR
- *   - version matches "video-firmware.N.M" with N >= 2
- */
-
-static bool iris_detect_gen2_from_fwdata(const u8 *data, size_t size)
-{
-	static const char *marker = "QC_IMAGE_VERSION_STRING=";
-	const size_t mlen = strlen(marker);
-	static const char *vfw = "vfw";
-	const size_t vfwlen = strlen(vfw);
-	static const char *vf = "video-firmware.";
-	const size_t vflen = strlen(vf);
-
-	for (size_t i = 0; i + mlen < size; i++) {
-		const char *found;
-
-		if (memcmp(data + i, marker, mlen))
-			continue;
-
-		found = data + i + mlen;
-		size -= i + mlen;
-
-		/* vfw => Gen2 */
-		if (size > vfwlen && !memcmp(found, vfw, vfwlen))
-			return true;
-
-		if (size < vflen ||
-		    memcmp(found, vf, vflen))
-			return false;
-
-		found += vflen;
-		size -= vflen;
-
-		/*
-		 * video-firmware.1.x is Gen1.
-		 * video-firmware.2.x and video-firmware.10.x are Gen2.
-		 */
-		return size >= 2 &&
-			(*found >= '2' || (*found == '1' && found[1] != '.'));
-	}
-
-	return false;
-}
-
-static const struct firmware *iris_detect_firmware(struct iris_core *core,
-						   const char **fw_name)
-{
-	const struct firmware *firmware;
-	bool has_both_gens;
-	int ret;
-
-	*fw_name = NULL;
-	if (core->iris_platform_data->firmware_desc_gen2)
-		core->iris_firmware_desc = core->iris_platform_data->firmware_desc_gen2;
-	else if (core->iris_platform_data->firmware_desc_gen1)
-		core->iris_firmware_desc = core->iris_platform_data->firmware_desc_gen1;
-	else
-		return ERR_PTR(-EINVAL);
-
-	has_both_gens = core->iris_platform_data->firmware_desc_gen2 &&
-		core->iris_platform_data->firmware_desc_gen1;
-
-	ret = of_property_read_string_index(dev_of_node(core->dev), "firmware-name", 0, fw_name);
-	if (ret) {
-		*fw_name = core->iris_firmware_desc->fwname;
-		ret = request_firmware(&firmware, *fw_name, core->dev);
-		if (ret && has_both_gens) {
-			core->iris_firmware_desc = core->iris_platform_data->firmware_desc_gen1;
-			*fw_name = core->iris_firmware_desc->fwname;
-			ret = request_firmware(&firmware, *fw_name, core->dev);
-		}
-
-		return ret ? ERR_PTR(ret) : firmware;
-	}
-
-	ret = request_firmware(&firmware, *fw_name, core->dev);
-	if (ret)
-		return ERR_PTR(ret);
-
-	if (has_both_gens &&
-	    !iris_detect_gen2_from_fwdata((const u8 *)firmware->data, firmware->size)) {
-		dev_info(core->dev, "Gen1 FW detected in %s\n", *fw_name);
-		core->iris_firmware_desc = core->iris_platform_data->firmware_desc_gen1;
-	}
-
-	return firmware;
-}
-
-static int iris_load_fw_to_memory(struct iris_core *core)
+static int iris_load_fw_to_memory(struct iris_core *core, const char *fw_name)
 {
 	const struct firmware *firmware = NULL;
 	struct device *dev = core->dev;
 	struct resource res;
 	phys_addr_t mem_phys;
-	const char *fw_name;
 	size_t res_size;
 	ssize_t fw_size;
 	void *mem_virt;
 	int ret;
 
+	if (strlen(fw_name) >= MAX_FIRMWARE_NAME_SIZE - 4)
+		return -EINVAL;
+
 	ret = of_reserved_mem_region_to_resource(dev->of_node, 0, &res);
 	if (ret)
 		return ret;
@@ -127,11 +38,9 @@ static int iris_load_fw_to_memory(struct iris_core *core)
 	mem_phys = res.start;
 	res_size = resource_size(&res);
 
-	firmware = iris_detect_firmware(core, &fw_name);
-	if (IS_ERR(firmware))
-		return PTR_ERR(firmware);
-
-	core->iris_firmware_data = core->iris_firmware_desc->firmware_data;
+	ret = request_firmware(&firmware, fw_name, dev);
+	if (ret)
+		return ret;
 
 	fw_size = qcom_mdt_get_size(firmware);
 	if (fw_size < 0 || res_size < (size_t)fw_size) {
@@ -158,12 +67,18 @@ static int iris_load_fw_to_memory(struct iris_core *core)
 int iris_fw_load(struct iris_core *core)
 {
 	const struct tz_cp_config *cp_config;
+	const char *fwpath = NULL;
 	int i, ret;
 
-	ret = iris_load_fw_to_memory(core);
+	ret = of_property_read_string_index(core->dev->of_node, "firmware-name", 0,
+					    &fwpath);
+	if (ret)
+		fwpath = core->iris_firmware_desc->fwname;
+
+	ret = iris_load_fw_to_memory(core, fwpath);
 	if (ret) {
-		dev_err(core->dev, "firmware download failed %d\n", ret);
-		return ret;
+		dev_err(core->dev, "firmware download failed\n");
+		return -ENOMEM;
 	}
 
 	ret = qcom_pas_auth_and_reset(IRIS_PAS_ID);
@@ -185,7 +100,7 @@ int iris_fw_load(struct iris_core *core)
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 int iris_fw_unload(struct iris_core *core)
diff --git a/drivers/media/platform/qcom/iris/iris_platform_common.h b/drivers/media/platform/qcom/iris/iris_platform_common.h
index 9748095091461..a9453d539fc23 100644
--- a/drivers/media/platform/qcom/iris/iris_platform_common.h
+++ b/drivers/media/platform/qcom/iris/iris_platform_common.h
@@ -292,7 +292,11 @@ struct iris_firmware_desc {
 };
 
 struct iris_platform_data {
-	const struct iris_firmware_desc *firmware_desc_gen1, *firmware_desc_gen2;
+	/*
+	 * XXX: replace with gen1 / gen2 pointers once we have platforms
+	 * supporting both firmware kinds.
+	 */
+	const struct iris_firmware_desc *firmware_desc;
 
 	const struct vpu_ops *vpu_ops;
 	const struct icc_info *icc_tbl;
diff --git a/drivers/media/platform/qcom/iris/iris_platform_vpu2.c b/drivers/media/platform/qcom/iris/iris_platform_vpu2.c
index bbdbf21961d7d..cfff647cf4403 100644
--- a/drivers/media/platform/qcom/iris/iris_platform_vpu2.c
+++ b/drivers/media/platform/qcom/iris/iris_platform_vpu2.c
@@ -29,12 +29,6 @@ static const struct iris_firmware_desc iris_vpu20_p1_gen1_desc = {
 	.fwname = "qcom/vpu/vpu20_p1.mbn",
 };
 
-static const struct iris_firmware_desc iris_vpu20_p1_gen2_s6_desc = {
-	.firmware_data = &iris_hfi_gen2_data,
-	.get_vpu_buffer_size = iris_vpu33_buf_size,
-	.fwname = "qcom/vpu/vpu20_p1_gen2_s6.mbn",
-};
-
 static const struct iris_firmware_desc iris_vpu20_p4_gen1_desc = {
 	.firmware_data = &iris_hfi_gen1_data,
 	.get_vpu_buffer_size = iris_vpu_buf_size,
@@ -78,7 +72,7 @@ static const struct tz_cp_config tz_cp_config_vpu2[] = {
 };
 
 const struct iris_platform_data milos_data = {
-	.firmware_desc_gen1 = &iris_milos_desc,
+	.firmware_desc = &iris_milos_desc,
 	.vpu_ops = &iris_vpu2_ops,
 	.icc_tbl = iris_icc_info_milos,
 	.icc_tbl_size = ARRAY_SIZE(iris_icc_info_milos),
@@ -106,8 +100,7 @@ const struct iris_platform_data milos_data = {
 };
 
 const struct iris_platform_data sc7280_data = {
-	.firmware_desc_gen1 = &iris_vpu20_p1_gen1_desc,
-	.firmware_desc_gen2 = &iris_vpu20_p1_gen2_s6_desc,
+	.firmware_desc = &iris_vpu20_p1_gen1_desc,
 	.vpu_ops = &iris_vpu2_ops,
 	.icc_tbl = iris_icc_info_vpu2,
 	.icc_tbl_size = ARRAY_SIZE(iris_icc_info_vpu2),
@@ -136,7 +129,7 @@ const struct iris_platform_data sc7280_data = {
 };
 
 const struct iris_platform_data sm8250_data = {
-	.firmware_desc_gen1 = &iris_vpu20_p4_gen1_desc,
+	.firmware_desc = &iris_vpu20_p4_gen1_desc,
 	.vpu_ops = &iris_vpu2_ops,
 	.icc_tbl = iris_icc_info_vpu2,
 	.icc_tbl_size = ARRAY_SIZE(iris_icc_info_vpu2),
diff --git a/drivers/media/platform/qcom/iris/iris_platform_vpu3x.c b/drivers/media/platform/qcom/iris/iris_platform_vpu3x.c
index 74626b35d9cb3..2c63adbc55791 100644
--- a/drivers/media/platform/qcom/iris/iris_platform_vpu3x.c
+++ b/drivers/media/platform/qcom/iris/iris_platform_vpu3x.c
@@ -90,7 +90,7 @@ static const struct tz_cp_config tz_cp_config_vpu3[] = {
  * - inst_caps to platform_inst_cap_qcs8300
  */
 const struct iris_platform_data qcs8300_data = {
-	.firmware_desc_gen2 = &iris_vpu30_p4_s6_gen2_desc,
+	.firmware_desc = &iris_vpu30_p4_s6_gen2_desc,
 	.vpu_ops = &iris_vpu3_ops,
 	.icc_tbl = iris_icc_info_vpu3x,
 	.icc_tbl_size = ARRAY_SIZE(iris_icc_info_vpu3x),
@@ -119,7 +119,7 @@ const struct iris_platform_data qcs8300_data = {
 };
 
 const struct iris_platform_data sm8550_data = {
-	.firmware_desc_gen2 = &iris_vpu30_p4_gen2_desc,
+	.firmware_desc = &iris_vpu30_p4_gen2_desc,
 	.vpu_ops = &iris_vpu3_ops,
 	.icc_tbl = iris_icc_info_vpu3x,
 	.icc_tbl_size = ARRAY_SIZE(iris_icc_info_vpu3x),
@@ -154,7 +154,7 @@ const struct iris_platform_data sm8550_data = {
  * - controller_rst_tbl to sm8650_controller_reset_table
  */
 const struct iris_platform_data sm8650_data = {
-	.firmware_desc_gen2 = &iris_vpu33_p4_gen2_desc,
+	.firmware_desc = &iris_vpu33_p4_gen2_desc,
 	.vpu_ops = &iris_vpu33_ops,
 	.icc_tbl = iris_icc_info_vpu3x,
 	.icc_tbl_size = ARRAY_SIZE(iris_icc_info_vpu3x),
@@ -185,7 +185,7 @@ const struct iris_platform_data sm8650_data = {
 };
 
 const struct iris_platform_data sm8750_data = {
-	.firmware_desc_gen2 = &iris_vpu35_p4_gen2_desc,
+	.firmware_desc = &iris_vpu35_p4_gen2_desc,
 	.vpu_ops = &iris_vpu35_ops,
 	.icc_tbl = iris_icc_info_vpu3x,
 	.icc_tbl_size = ARRAY_SIZE(iris_icc_info_vpu3x),
@@ -220,7 +220,7 @@ const struct iris_platform_data sm8750_data = {
  * - different num_vpp_pipe
  */
 const struct iris_platform_data x1p42100_data = {
-	.firmware_desc_gen2 = &iris_vpu30_p1_gen2_desc,
+	.firmware_desc = &iris_vpu30_p1_gen2_desc,
 	.vpu_ops = &iris_vpu3_ops,
 	.icc_tbl = iris_icc_info_vpu3x,
 	.icc_tbl_size = ARRAY_SIZE(iris_icc_info_vpu3x),
diff --git a/drivers/media/platform/qcom/iris/iris_probe.c b/drivers/media/platform/qcom/iris/iris_probe.c
index c4b8b4be339d9..5e5d77736d5fa 100644
--- a/drivers/media/platform/qcom/iris/iris_probe.c
+++ b/drivers/media/platform/qcom/iris/iris_probe.c
@@ -306,6 +306,8 @@ static int iris_probe(struct platform_device *pdev)
 		return core->irq;
 
 	core->iris_platform_data = of_device_get_match_data(core->dev);
+	core->iris_firmware_desc = core->iris_platform_data->firmware_desc;
+	core->iris_firmware_data = core->iris_firmware_desc->firmware_data;
 
 	core->ubwc_cfg = qcom_ubwc_config_get_data();
 	if (IS_ERR(core->ubwc_cfg))
@@ -329,6 +331,8 @@ static int iris_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	iris_session_init_caps(core);
+
 	ret = v4l2_device_register(dev, &core->v4l2_dev);
 	if (ret)
 		goto err_unresv_iova_region;
diff --git a/drivers/media/platform/qcom/iris/iris_vidc.c b/drivers/media/platform/qcom/iris/iris_vidc.c
index f1d7f186002d9..2dff38053532f 100644
--- a/drivers/media/platform/qcom/iris/iris_vidc.c
+++ b/drivers/media/platform/qcom/iris/iris_vidc.c
@@ -9,7 +9,6 @@
 #include <media/v4l2-mem2mem.h>
 #include <media/videobuf2-dma-contig.h>
 
-#include "iris_ctrls.h"
 #include "iris_vidc.h"
 #include "iris_instance.h"
 #include "iris_vdec.h"
@@ -197,8 +196,6 @@ int iris_open(struct file *filp)
 		goto fail_m2m_release;
 	}
 
-	iris_session_init_caps(core);
-
 	if (inst->domain == DECODER)
 		ret = iris_vdec_inst_init(inst);
 	else if (inst->domain == ENCODER)
-- 
2.53.0



