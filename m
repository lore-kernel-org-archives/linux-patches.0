Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994651E2834;
	Wed, 25 Feb 2026 01:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983232; cv=none; b=WaxU2q3Uf+2JhjGoBFBcCpbduIJGHFgpAwgM2CPobfLJ3NsBGrsSKRmRKaGAZOJlTxc0VUIvY5eixQHiBXhLRhaev1smkDskcQPfnIsxY8nhhK2GKGb3aJ2yyzFroipk+HBa4dcSIS4vsgCpxX2uHue3ZmESDKv/oJxdmBqxPzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983232; c=relaxed/simple;
	bh=ZxP2QO5hCmV35+EEFtiVc1vE2fhkalj6Kk+bCzHoOUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo34LWADiGIEyF0X3O97FqnoZl863FClx8AkZKjmDiWw5NTm0YbtF9jKq+1+jDk8X6UUlgHonx+mV/tapXkq/NitVvqNBpfuZPFzkaYAwA0YBobVbVI9X/8nS+SLDYjh9K7IvULuGYc3t6KKOvH06uXQ5CGCypVZHbb2VouFgX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DqFMEsW9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DqFMEsW9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64664C116D0;
	Wed, 25 Feb 2026 01:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983232;
	bh=ZxP2QO5hCmV35+EEFtiVc1vE2fhkalj6Kk+bCzHoOUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DqFMEsW9YiwFRamgGvtwSexoeZDol5mhJtInEEidK0zVzurtGPunFIiyi/doPkob3
	 NuTyS+ngSi0vT3BhQVlaXno3RxEXcg1ROlM3gft4S0WOEjFIXPkkgvRjjnR87kJHcm
	 SEkkpbucqnPAmb85GMMuB/AtVuR22DtwZH8HrCDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 375/781] wifi: ath11k: add usecase firmware handling based on device compatible
Date: Tue, 24 Feb 2026 17:18:04 -0800
Message-ID: <20260225012408.890009151@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit c386a2b1068910538e87ef1cf2fc938ebf7e218f ]

For M.2 WLAN chips, there is no suitable DTS node to specify the
firmware-name property. In addition, assigning firmware for the
M.2 PCIe interface causes chips that do not use usecase specific
firmware to fail. Therefore, abandoning the approach of specifying
firmware in DTS. As an alternative, propose a static lookup table
mapping device compatible to firmware names. Currently, only WCN6855
HW2.1 requires this.

However, support for the firmware-name property is retained to keep
the ABI backwards compatible.

For details on usecase specific firmware, see:
https://lore.kernel.org/all/20250522013444.1301330-3-miaoqing.pan@oss.qualcomm.com/.

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-04685-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

Fixes: edbbc647c4f3 ("wifi: ath11k: support usercase-specific firmware overrides")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260121095055.3683957-2-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 27 ++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/core.h |  4 ++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 812686173ac8a..06b4df2370e95 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -997,6 +997,33 @@ static const struct dmi_system_id ath11k_pm_quirk_table[] = {
 	{}
 };
 
+static const struct __ath11k_core_usecase_firmware_table {
+	u32 hw_rev;
+	const char *compatible;
+	const char *firmware_name;
+} ath11k_core_usecase_firmware_table[] = {
+	{ ATH11K_HW_WCN6855_HW21, "qcom,lemans-evk", "nfa765"},
+	{ ATH11K_HW_WCN6855_HW21, "qcom,monaco-evk", "nfa765"},
+	{ ATH11K_HW_WCN6855_HW21, "qcom,hamoa-iot-evk", "nfa765"},
+	{ /* Sentinel */ }
+};
+
+const char *ath11k_core_get_usecase_firmware(struct ath11k_base *ab)
+{
+	const struct __ath11k_core_usecase_firmware_table *entry = NULL;
+
+	entry = ath11k_core_usecase_firmware_table;
+	while (entry->compatible) {
+		if (ab->hw_rev == entry->hw_rev &&
+		    of_machine_is_compatible(entry->compatible))
+			return entry->firmware_name;
+		entry++;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(ath11k_core_get_usecase_firmware);
+
 void ath11k_fw_stats_pdevs_free(struct list_head *head)
 {
 	struct ath11k_fw_stats_pdev *i, *tmp;
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index e8780b05ce11e..834988dad591c 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -1275,6 +1275,7 @@ bool ath11k_core_coldboot_cal_support(struct ath11k_base *ab);
 
 const struct firmware *ath11k_core_firmware_request(struct ath11k_base *ab,
 						    const char *filename);
+const char *ath11k_core_get_usecase_firmware(struct ath11k_base *ab);
 
 static inline const char *ath11k_scan_state_str(enum ath11k_scan_state state)
 {
@@ -1329,6 +1330,9 @@ static inline void ath11k_core_create_firmware_path(struct ath11k_base *ab,
 
 	of_property_read_string(ab->dev->of_node, "firmware-name", &fw_name);
 
+	if (!fw_name)
+		fw_name = ath11k_core_get_usecase_firmware(ab);
+
 	if (fw_name && strncmp(filename, "board", 5))
 		snprintf(buf, buf_len, "%s/%s/%s/%s", ATH11K_FW_DIR,
 			 ab->hw_params.fw.dir, fw_name, filename);
-- 
2.51.0



