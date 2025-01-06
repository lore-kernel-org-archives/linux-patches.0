Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACF1154C04;
	Mon,  6 Jan 2025 15:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177113; cv=none; b=q21iLQsjbLzdVHbpKTZQ57yCw+YRrRkkG/WI0R9X88WEHFZ3/vR/q/Z7vqpaAmhPXDkysNZ+aTJAuqLEIQSzEH4c+5H8oDPUsOFHzAVU2WOiSWtcpN9+OKFomyNwZVJpaf44kDriGk83lmkp684GtJdcuRqW2DSpzHqY23bFYiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177113; c=relaxed/simple;
	bh=iVARYi28QNd5wycPEb6PX2pYMlKCNhgs1RrajOltfzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ivc4C3Yc5SaQUIlFlC61iAzyCtPlsLKyk6st1CS3bw4x9sZJIVlWRGaLg1xgHzwhp9F5jOu3R9NV63lwhlEhy1gdc4ykPmH6vu+/Df7BTbptjhyJJcu4QetjL/2k1qN3+1TNFj1d+9vYOFr+w4axHiZjyLeNWxByQ9TZm/2V/TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOOXmXYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOOXmXYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD9AC4CED2;
	Mon,  6 Jan 2025 15:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177113;
	bh=iVARYi28QNd5wycPEb6PX2pYMlKCNhgs1RrajOltfzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOOXmXYME1cCAZL0ybdDLY/NT0cznW5jNXagTQ0DjMHTU+psRuxgTO1oodd7iuopZ
	 bA7BcRovJVj4pdn3bTjTeTmBQXn90lYgsA5ul2gQuABhBlsl7HLl8EY5u4ILLR5yuY
	 TU2C5LxSJFD4phI7nKEHmk87zPPydBGCFC9sBmfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengfei Fan <quic_tengfan@quicinc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/222] remoteproc: qcom: pas: Add support for SA8775p ADSP, CDSP and GPDSP
Date: Mon,  6 Jan 2025 16:14:18 +0100
Message-ID: <20250106151152.651080060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengfei Fan <quic_tengfan@quicinc.com>

[ Upstream commit 9091225ba28c0106d3cd041c7abf5551a94bb524 ]

Add support for PIL loading on ADSP, CDSP0, CDSP1, GPDSP0 and GPDSP1 on
SA8775p SoCs.

Signed-off-by: Tengfei Fan <quic_tengfan@quicinc.com>
Co-developed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20240805-topic-sa8775p-iot-remoteproc-v4-3-86affdc72c04@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 009e288c989b ("remoteproc: qcom: pas: enable SAR2130P audio DSP support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 92 ++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index fd66bb8b23f8..4a73723e375a 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -786,6 +786,23 @@ static const struct adsp_data adsp_resource_init = {
 		.ssctl_id = 0x14,
 };
 
+static const struct adsp_data sa8775p_adsp_resource = {
+	.crash_reason_smem = 423,
+	.firmware_name = "adsp.mbn",
+	.pas_id = 1,
+	.minidump_id = 5,
+	.auto_boot = true,
+	.proxy_pd_names = (char*[]){
+		"lcx",
+		"lmx",
+		NULL
+	},
+	.load_state = "adsp",
+	.ssr_name = "lpass",
+	.sysmon_name = "adsp",
+	.ssctl_id = 0x14,
+};
+
 static const struct adsp_data sdm845_adsp_resource_init = {
 		.crash_reason_smem = 423,
 		.firmware_name = "adsp.mdt",
@@ -885,6 +902,42 @@ static const struct adsp_data cdsp_resource_init = {
 	.ssctl_id = 0x17,
 };
 
+static const struct adsp_data sa8775p_cdsp0_resource = {
+	.crash_reason_smem = 601,
+	.firmware_name = "cdsp0.mbn",
+	.pas_id = 18,
+	.minidump_id = 7,
+	.auto_boot = true,
+	.proxy_pd_names = (char*[]){
+		"cx",
+		"mxc",
+		"nsp",
+		NULL
+	},
+	.load_state = "cdsp",
+	.ssr_name = "cdsp",
+	.sysmon_name = "cdsp",
+	.ssctl_id = 0x17,
+};
+
+static const struct adsp_data sa8775p_cdsp1_resource = {
+	.crash_reason_smem = 633,
+	.firmware_name = "cdsp1.mbn",
+	.pas_id = 30,
+	.minidump_id = 20,
+	.auto_boot = true,
+	.proxy_pd_names = (char*[]){
+		"cx",
+		"mxc",
+		"nsp",
+		NULL
+	},
+	.load_state = "nsp",
+	.ssr_name = "cdsp1",
+	.sysmon_name = "cdsp1",
+	.ssctl_id = 0x20,
+};
+
 static const struct adsp_data sdm845_cdsp_resource_init = {
 	.crash_reason_smem = 601,
 	.firmware_name = "cdsp.mdt",
@@ -987,6 +1040,40 @@ static const struct adsp_data sm8350_cdsp_resource = {
 	.ssctl_id = 0x17,
 };
 
+static const struct adsp_data sa8775p_gpdsp0_resource = {
+	.crash_reason_smem = 640,
+	.firmware_name = "gpdsp0.mbn",
+	.pas_id = 39,
+	.minidump_id = 21,
+	.auto_boot = true,
+	.proxy_pd_names = (char*[]){
+		"cx",
+		"mxc",
+		NULL
+	},
+	.load_state = "gpdsp0",
+	.ssr_name = "gpdsp0",
+	.sysmon_name = "gpdsp0",
+	.ssctl_id = 0x21,
+};
+
+static const struct adsp_data sa8775p_gpdsp1_resource = {
+	.crash_reason_smem = 641,
+	.firmware_name = "gpdsp1.mbn",
+	.pas_id = 40,
+	.minidump_id = 22,
+	.auto_boot = true,
+	.proxy_pd_names = (char*[]){
+		"cx",
+		"mxc",
+		NULL
+	},
+	.load_state = "gpdsp1",
+	.ssr_name = "gpdsp1",
+	.sysmon_name = "gpdsp1",
+	.ssctl_id = 0x22,
+};
+
 static const struct adsp_data mpss_resource_init = {
 	.crash_reason_smem = 421,
 	.firmware_name = "modem.mdt",
@@ -1163,6 +1250,11 @@ static const struct of_device_id adsp_of_match[] = {
 	{ .compatible = "qcom,qcs404-adsp-pas", .data = &adsp_resource_init },
 	{ .compatible = "qcom,qcs404-cdsp-pas", .data = &cdsp_resource_init },
 	{ .compatible = "qcom,qcs404-wcss-pas", .data = &wcss_resource_init },
+	{ .compatible = "qcom,sa8775p-adsp-pas", .data = &sa8775p_adsp_resource},
+	{ .compatible = "qcom,sa8775p-cdsp0-pas", .data = &sa8775p_cdsp0_resource},
+	{ .compatible = "qcom,sa8775p-cdsp1-pas", .data = &sa8775p_cdsp1_resource},
+	{ .compatible = "qcom,sa8775p-gpdsp0-pas", .data = &sa8775p_gpdsp0_resource},
+	{ .compatible = "qcom,sa8775p-gpdsp1-pas", .data = &sa8775p_gpdsp1_resource},
 	{ .compatible = "qcom,sc7180-adsp-pas", .data = &sm8250_adsp_resource},
 	{ .compatible = "qcom,sc7180-mpss-pas", .data = &mpss_resource_init},
 	{ .compatible = "qcom,sc7280-mpss-pas", .data = &mpss_resource_init},
-- 
2.39.5



