Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6994D1E502;
	Tue, 17 Jun 2025 16:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179053; cv=none; b=BRMPhhDuDgDjiqqgecfjjOxnl6pop5MwK9l9BZgvxrgY8nUQ+oJiPrHQXASWaX9XmTeLZGq/VP6hxpgxm+/rycK5T44rNmCqjep1k04btOB6i7kq5phXQRJTM66f9SwldfsUpbnPYEzlETyWJtr2mv/Vt3JqnCW/0G5byF9i69E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179053; c=relaxed/simple;
	bh=umBlyDwbuC7HkXVEbEetNYf2cPIu1xDfJteLlyVS1Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=llVN0GNP8k8Qk6uTJMa0C5oi0jrYhn/GTuzPsAFVXYciKZEMAZSIbdfYd8n+NOsZ1D2OsPnrROsWL1/Fq7Lq6KT6zCaJXPIUz+Mjpt5OeJXK8eLpk4EfQ8Ss/PmGbIXjxK19cFsOI5oI/+4iF7GWL4j32/nQHRfV5OeBV2w+61w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTDu714a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTDu714a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECDFC4CEE3;
	Tue, 17 Jun 2025 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179053;
	bh=umBlyDwbuC7HkXVEbEetNYf2cPIu1xDfJteLlyVS1Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTDu714a961utopPQ2O0WmdmlMFPblZ4WfXzSQgDkHUy5sKhLloAvh0JwsCX3eNvo
	 iDEvv7dCiKfwCaMPN5BM53xAhvr5ecVzMPvSHv/xrSXzkDxNdQz6JAn5I+myFYKWM2
	 pR7M+AOrl9qVMEss9aL6NGCazmT2Zv0dTe2g+Oa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bean Huo <beanhuo@micron.com>,
	=?UTF-8?q?Lo=C3=AFc=20Minier?= <loic.minier@oss.qualcomm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 633/780] scsi: ufs: qcom: Map devfreq OPP freq to UniPro Core Clock freq
Date: Tue, 17 Jun 2025 17:25:41 +0200
Message-ID: <20250617152517.252159195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Guo <quic_cang@quicinc.com>

[ Upstream commit 8c5bcb3daeef9bc54c9939c36dca9a626126eb59 ]

On some platforms, the devfreq OPP freq may be different than the unipro
core clock freq. Implement ufs_qcom_opp_freq_to_clk_freq() and use it to
find the unipro core clk freq.

Fixes: c02fe9e222d1 ("scsi: ufs: qcom: Implement the freq_to_gear_speed() vop")
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Co-developed-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Signed-off-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Link: https://lore.kernel.org/r/20250522021537.999107-3-quic_ziqichen@quicinc.com
Reported-by: Luca Weiss <luca.weiss@fairphone.com>
Closes: https://lore.kernel.org/linux-arm-msm/D9FZ9U3AEXW4.1I12FX3YQ3JPW@fairphone.com/
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Loïc Minier <loic.minier@oss.qualcomm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 81 ++++++++++++++++++++++++++++++++-----
 1 file changed, 71 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 28515f89ce798..2b000c1708ce4 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -103,7 +103,9 @@ static const struct __ufs_qcom_bw_table {
 };
 
 static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
-static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, unsigned long freq);
+static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
+						   unsigned long freq, char *name);
+static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, bool is_scale_up, unsigned long freq);
 
 static struct ufs_qcom_host *rcdev_to_ufs_host(struct reset_controller_dev *rcd)
 {
@@ -602,7 +604,7 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 			return -EINVAL;
 		}
 
-		err = ufs_qcom_set_core_clk_ctrl(hba, ULONG_MAX);
+		err = ufs_qcom_set_core_clk_ctrl(hba, true, ULONG_MAX);
 		if (err)
 			dev_err(hba->dev, "cfg core clk ctrl failed\n");
 		/*
@@ -1360,29 +1362,46 @@ static int ufs_qcom_set_clk_40ns_cycles(struct ufs_hba *hba,
 	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_VS_CORE_CLK_40NS_CYCLES), reg);
 }
 
-static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, unsigned long freq)
+static int ufs_qcom_set_core_clk_ctrl(struct ufs_hba *hba, bool is_scale_up, unsigned long freq)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki;
 	u32 cycles_in_1us = 0;
 	u32 core_clk_ctrl_reg;
+	unsigned long clk_freq;
 	int err;
 
+	if (hba->use_pm_opp && freq != ULONG_MAX) {
+		clk_freq = ufs_qcom_opp_freq_to_clk_freq(hba, freq, "core_clk_unipro");
+		if (clk_freq) {
+			cycles_in_1us = ceil(clk_freq, HZ_PER_MHZ);
+			goto set_core_clk_ctrl;
+		}
+	}
+
 	list_for_each_entry(clki, head, list) {
 		if (!IS_ERR_OR_NULL(clki->clk) &&
 		    !strcmp(clki->name, "core_clk_unipro")) {
-			if (!clki->max_freq)
+			if (!clki->max_freq) {
 				cycles_in_1us = 150; /* default for backwards compatibility */
-			else if (freq == ULONG_MAX)
+				break;
+			}
+
+			if (freq == ULONG_MAX) {
 				cycles_in_1us = ceil(clki->max_freq, HZ_PER_MHZ);
-			else
-				cycles_in_1us = ceil(freq, HZ_PER_MHZ);
+				break;
+			}
 
+			if (is_scale_up)
+				cycles_in_1us = ceil(clki->max_freq, HZ_PER_MHZ);
+			else
+				cycles_in_1us = ceil(clk_get_rate(clki->clk), HZ_PER_MHZ);
 			break;
 		}
 	}
 
+set_core_clk_ctrl:
 	err = ufshcd_dme_get(hba,
 			    UIC_ARG_MIB(DME_VS_CORE_CLK_CTRL),
 			    &core_clk_ctrl_reg);
@@ -1425,7 +1444,7 @@ static int ufs_qcom_clk_scale_up_pre_change(struct ufs_hba *hba, unsigned long f
 		return ret;
 	}
 	/* set unipro core clock attributes and clear clock divider */
-	return ufs_qcom_set_core_clk_ctrl(hba, freq);
+	return ufs_qcom_set_core_clk_ctrl(hba, true, freq);
 }
 
 static int ufs_qcom_clk_scale_up_post_change(struct ufs_hba *hba)
@@ -1457,7 +1476,7 @@ static int ufs_qcom_clk_scale_down_pre_change(struct ufs_hba *hba)
 static int ufs_qcom_clk_scale_down_post_change(struct ufs_hba *hba, unsigned long freq)
 {
 	/* set unipro core clock attributes and clear clock divider */
-	return ufs_qcom_set_core_clk_ctrl(hba, freq);
+	return ufs_qcom_set_core_clk_ctrl(hba, false, freq);
 }
 
 static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
@@ -1922,11 +1941,53 @@ static int ufs_qcom_config_esi(struct ufs_hba *hba)
 	return ret;
 }
 
+static unsigned long ufs_qcom_opp_freq_to_clk_freq(struct ufs_hba *hba,
+						   unsigned long freq, char *name)
+{
+	struct ufs_clk_info *clki;
+	struct dev_pm_opp *opp;
+	unsigned long clk_freq;
+	int idx = 0;
+	bool found = false;
+
+	opp = dev_pm_opp_find_freq_exact_indexed(hba->dev, freq, 0, true);
+	if (IS_ERR(opp)) {
+		dev_err(hba->dev, "Failed to find OPP for exact frequency %lu\n", freq);
+		return 0;
+	}
+
+	list_for_each_entry(clki, &hba->clk_list_head, list) {
+		if (!strcmp(clki->name, name)) {
+			found = true;
+			break;
+		}
+
+		idx++;
+	}
+
+	if (!found) {
+		dev_err(hba->dev, "Failed to find clock '%s' in clk list\n", name);
+		dev_pm_opp_put(opp);
+		return 0;
+	}
+
+	clk_freq = dev_pm_opp_get_freq_indexed(opp, idx);
+
+	dev_pm_opp_put(opp);
+
+	return clk_freq;
+}
+
 static u32 ufs_qcom_freq_to_gear_speed(struct ufs_hba *hba, unsigned long freq)
 {
 	u32 gear = UFS_HS_DONT_CHANGE;
+	unsigned long unipro_freq;
+
+	if (!hba->use_pm_opp)
+		return gear;
 
-	switch (freq) {
+	unipro_freq = ufs_qcom_opp_freq_to_clk_freq(hba, freq, "core_clk_unipro");
+	switch (unipro_freq) {
 	case 403000000:
 		gear = UFS_HS_G5;
 		break;
-- 
2.39.5



