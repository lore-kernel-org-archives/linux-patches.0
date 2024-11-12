Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BEC20F5AF;
	Tue, 12 Nov 2024 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408364; cv=none; b=MWOHM+4frx8rkLAlbQQ7rz+3DkyCGaHBUCX/GYmNZJS7MUU3MlPqF9GvNL/EiIBmAP68kfRCgL8Luim//6zW/puZwNZXqwPg9emDpQ8ImbYheIYwrjbVLI7XAb8MUvuT1xChz9gyMIjGqJKEy59air4KAHSkWN5s95Yvi0ddW/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408364; c=relaxed/simple;
	bh=exmaS/oaKSXWbDs3piCnJn66KN8z/7qqJITE/OlXHzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSiZazZGGHzPr+4urrx0v/71HAylmZWMIWVOcbEoBMrUfbYCs4ajwUsk9qiTvERjLLpa9phWVCuTOp20ok/R95Qgcz3lsK/iWYZR8sc/FYbNUuJxFu3EALxMyrhRnt8+1qvPIB6TmRFPVhcXB8lMtoifw0MY0efd/g9f+uvsFsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gV1nUbFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gV1nUbFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691B8C4CECD;
	Tue, 12 Nov 2024 10:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408363;
	bh=exmaS/oaKSXWbDs3piCnJn66KN8z/7qqJITE/OlXHzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gV1nUbFfj30iE0Ta+GFn7PQYq5gOqdZjugZdDvNFcxL+SySeU5hCCZi7wTwdN6Sl3
	 Q0DtE0mDW7PHLJwR5gW38szfPqrK3VlrM22c9mC9VCmwpLrHK9RBmcQI1Hc2I24xWm
	 ORbaQfU45KXWCF473UUpM14o8nHw2BY64/SrnwP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Patil Rajesh Reddy <Patil.Reddy@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.11 140/184] platform/x86/amd/pmf: Update SMU metrics table for 1AH family series
Date: Tue, 12 Nov 2024 11:21:38 +0100
Message-ID: <20241112101906.246457924@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit 8f2407cb3f1e8586622e80269338efb7bed2f05b upstream.

The SMU metrics table has been revised for the 1AH family series.
Introduce a new metrics table structure to retrieve comprehensive metrics
information from the PMFW. This information will be utilized by the PMF
driver to adjust system thermals.

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Co-developed-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Patil Rajesh Reddy <Patil.Reddy@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20240819063404.378061-2-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd/pmf/core.c |   14 +++++++++
 drivers/platform/x86/amd/pmf/pmf.h  |   49 ++++++++++++++++++++++++++++++++++
 drivers/platform/x86/amd/pmf/spc.c  |   51 ++++++++++++++++++++++++------------
 3 files changed, 97 insertions(+), 17 deletions(-)

--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -255,7 +255,19 @@ int amd_pmf_set_dram_addr(struct amd_pmf
 
 	/* Get Metrics Table Address */
 	if (alloc_buffer) {
-		dev->buf = kzalloc(sizeof(dev->m_table), GFP_KERNEL);
+		switch (dev->cpu_id) {
+		case AMD_CPU_ID_PS:
+		case AMD_CPU_ID_RMB:
+			dev->mtable_size = sizeof(dev->m_table);
+			break;
+		case PCI_DEVICE_ID_AMD_1AH_M20H_ROOT:
+			dev->mtable_size = sizeof(dev->m_table_v2);
+			break;
+		default:
+			dev_err(dev->dev, "Invalid CPU id: 0x%x", dev->cpu_id);
+		}
+
+		dev->buf = kzalloc(dev->mtable_size, GFP_KERNEL);
 		if (!dev->buf)
 			return -ENOMEM;
 	}
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -187,6 +187,53 @@ struct apmf_fan_idx {
 	u32 fan_ctl_idx;
 } __packed;
 
+struct smu_pmf_metrics_v2 {
+	u16 core_frequency[16];		/* MHz */
+	u16 core_power[16];		/* mW */
+	u16 core_temp[16];		/* centi-C */
+	u16 gfx_temp;			/* centi-C */
+	u16 soc_temp;			/* centi-C */
+	u16 stapm_opn_limit;		/* mW */
+	u16 stapm_cur_limit;		/* mW */
+	u16 infra_cpu_maxfreq;		/* MHz */
+	u16 infra_gfx_maxfreq;		/* MHz */
+	u16 skin_temp;			/* centi-C */
+	u16 gfxclk_freq;		/* MHz */
+	u16 fclk_freq;			/* MHz */
+	u16 gfx_activity;		/* GFX busy % [0-100] */
+	u16 socclk_freq;		/* MHz */
+	u16 vclk_freq;			/* MHz */
+	u16 vcn_activity;		/* VCN busy % [0-100] */
+	u16 vpeclk_freq;		/* MHz */
+	u16 ipuclk_freq;		/* MHz */
+	u16 ipu_busy[8];		/* NPU busy % [0-100] */
+	u16 dram_reads;			/* MB/sec */
+	u16 dram_writes;		/* MB/sec */
+	u16 core_c0residency[16];	/* C0 residency % [0-100] */
+	u16 ipu_power;			/* mW */
+	u32 apu_power;			/* mW */
+	u32 gfx_power;			/* mW */
+	u32 dgpu_power;			/* mW */
+	u32 socket_power;		/* mW */
+	u32 all_core_power;		/* mW */
+	u32 filter_alpha_value;		/* time constant [us] */
+	u32 metrics_counter;
+	u16 memclk_freq;		/* MHz */
+	u16 mpipuclk_freq;		/* MHz */
+	u16 ipu_reads;			/* MB/sec */
+	u16 ipu_writes;			/* MB/sec */
+	u32 throttle_residency_prochot;
+	u32 throttle_residency_spl;
+	u32 throttle_residency_fppt;
+	u32 throttle_residency_sppt;
+	u32 throttle_residency_thm_core;
+	u32 throttle_residency_thm_gfx;
+	u32 throttle_residency_thm_soc;
+	u16 psys;
+	u16 spare1;
+	u32 spare[6];
+} __packed;
+
 struct smu_pmf_metrics {
 	u16 gfxclk_freq; /* in MHz */
 	u16 socclk_freq; /* in MHz */
@@ -284,6 +331,7 @@ struct amd_pmf_dev {
 	int hb_interval; /* SBIOS heartbeat interval */
 	struct delayed_work heart_beat;
 	struct smu_pmf_metrics m_table;
+	struct smu_pmf_metrics_v2 m_table_v2;
 	struct delayed_work work_buffer;
 	ktime_t start_time;
 	int socket_power_history[AVG_SAMPLE_SIZE];
@@ -308,6 +356,7 @@ struct amd_pmf_dev {
 	bool smart_pc_enabled;
 	u16 pmf_if_version;
 	struct input_dev *pmf_idev;
+	size_t mtable_size;
 };
 
 struct apmf_sps_prop_granular_v2 {
--- a/drivers/platform/x86/amd/pmf/spc.c
+++ b/drivers/platform/x86/amd/pmf/spc.c
@@ -53,30 +53,49 @@ void amd_pmf_dump_ta_inputs(struct amd_p
 void amd_pmf_dump_ta_inputs(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in) {}
 #endif
 
-static void amd_pmf_get_smu_info(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in)
+static void amd_pmf_get_c0_residency(u16 *core_res, size_t size, struct ta_pmf_enact_table *in)
 {
 	u16 max, avg = 0;
 	int i;
 
-	memset(dev->buf, 0, sizeof(dev->m_table));
-	amd_pmf_send_cmd(dev, SET_TRANSFER_TABLE, 0, 7, NULL);
-	memcpy(&dev->m_table, dev->buf, sizeof(dev->m_table));
-
-	in->ev_info.socket_power = dev->m_table.apu_power + dev->m_table.dgpu_power;
-	in->ev_info.skin_temperature = dev->m_table.skin_temp;
-
 	/* Get the avg and max C0 residency of all the cores */
-	max = dev->m_table.avg_core_c0residency[0];
-	for (i = 0; i < ARRAY_SIZE(dev->m_table.avg_core_c0residency); i++) {
-		avg += dev->m_table.avg_core_c0residency[i];
-		if (dev->m_table.avg_core_c0residency[i] > max)
-			max = dev->m_table.avg_core_c0residency[i];
+	max = *core_res;
+	for (i = 0; i < size; i++) {
+		avg += core_res[i];
+		if (core_res[i] > max)
+			max = core_res[i];
 	}
-
-	avg = DIV_ROUND_CLOSEST(avg, ARRAY_SIZE(dev->m_table.avg_core_c0residency));
+	avg = DIV_ROUND_CLOSEST(avg, size);
 	in->ev_info.avg_c0residency = avg;
 	in->ev_info.max_c0residency = max;
-	in->ev_info.gfx_busy = dev->m_table.avg_gfx_activity;
+}
+
+static void amd_pmf_get_smu_info(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in)
+{
+	/* Get the updated metrics table data */
+	memset(dev->buf, 0, dev->mtable_size);
+	amd_pmf_send_cmd(dev, SET_TRANSFER_TABLE, 0, 7, NULL);
+
+	switch (dev->cpu_id) {
+	case AMD_CPU_ID_PS:
+		memcpy(&dev->m_table, dev->buf, dev->mtable_size);
+		in->ev_info.socket_power = dev->m_table.apu_power + dev->m_table.dgpu_power;
+		in->ev_info.skin_temperature = dev->m_table.skin_temp;
+		in->ev_info.gfx_busy = dev->m_table.avg_gfx_activity;
+		amd_pmf_get_c0_residency(dev->m_table.avg_core_c0residency,
+					 ARRAY_SIZE(dev->m_table.avg_core_c0residency), in);
+		break;
+	case PCI_DEVICE_ID_AMD_1AH_M20H_ROOT:
+		memcpy(&dev->m_table_v2, dev->buf, dev->mtable_size);
+		in->ev_info.socket_power = dev->m_table_v2.apu_power + dev->m_table_v2.dgpu_power;
+		in->ev_info.skin_temperature = dev->m_table_v2.skin_temp;
+		in->ev_info.gfx_busy = dev->m_table_v2.gfx_activity;
+		amd_pmf_get_c0_residency(dev->m_table_v2.core_c0residency,
+					 ARRAY_SIZE(dev->m_table_v2.core_c0residency), in);
+		break;
+	default:
+		dev_err(dev->dev, "Unsupported CPU id: 0x%x", dev->cpu_id);
+	}
 }
 
 static const char * const pmf_battery_supply_name[] = {


