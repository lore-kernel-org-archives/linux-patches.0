Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68D3522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3F1C433C7;
	Sun,  9 Jul 2023 11:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901805;
	bh=ytuecNVYaZ08wM20Kye8Nbmh6OaAzrU4YAWjRvMf7sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Txcp8O39lAqx+paJQBquOwPEJ0MjJIjxWGD6vyH5USpp7wtNjCqa+9t1EKIfwPKV6
	 Gt6GaGSA3k3Y2RZcDBNk+pblFlfX2hQLrzLu0YwIyDILMOtU72V1LKGhbSjBBgS2I9
	 frHFNi6ccAcO3ksIWdxaZl0EWgtfeW/ZuUUlsC9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Huang <hzyitc@outlook.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 123/431] wifi: ath11k: Restart firmware after cold boot calibration for IPQ5018
Date: Sun,  9 Jul 2023 13:11:11 +0200
Message-ID: <20230709111454.040669121@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Huang <hzyitc@outlook.com>

[ Upstream commit 80c5390e1f5e5b16d820512265530ef26073d8e0 ]

Restart is required after cold boot calibration on IPQ5018. Otherwise,
we get the following exception:

	[   14.412829] qcom-q6-mpd cd00000.remoteproc: fatal error received: err_smem_ver.2.1:
	[   14.412829] QC Image Version : QC_IMAGE_VERSION_STRING=WLAN.HK.2.6.0.1-00974-QCAHKSWPL_SILICONZ-1
	[   14.412829] Image Variant : IMAGE_VARIANT_STRING=5018.wlanfw2.map_spr_spr_evalQ
	[   14.412829] DALSysLogEvent.c:174 Assertion 0 failed param0 :zero,param1 :zero,param2 :zero
	[   14.412829] Thread ID : 0x00000048 Thread name : WLAN RT0 Process ID : 0x00000001 Process name :wlan0
	[   14.412829]
	[   14.412829] Registers:
	[   14.412829] SP : 0x4c81c120
	[   14.412829] FP : 0x4c81c138
	[   14.412829] PC : 0xb022c590
	[   14.412829] SSR : 0x00000000
	[   14.412829] BADVA : 0x00000000
	[   14.412829] LR : 0xb0008490
	[   14.412829]
	[   14.412829] StackDump
	[   14.412829] from:0x4c81c120
	[   14.412829] to: 0x00000000:
	[   14.412829]
	[   14.463006] remoteproc remoteproc0: crash detected in cd00000.remoteproc: type fatal error

Fixes: 8dfe875aa24a ("wifi: ath11k: update hw params for IPQ5018")
Signed-off-by: Ziyang Huang <hzyitc@outlook.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/TYZPR01MB55566969818BD4B49E770445C953A@TYZPR01MB5556.apcprd01.prod.exchangelabs.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 75fdbe4ef83a4..329f0957f9f09 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -671,6 +671,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.hal_params = &ath11k_hw_hal_params_ipq8074,
 		.single_pdev_only = false,
 		.cold_boot_calib = true,
+		.cbcal_restart_fw = true,
 		.fix_l1ss = true,
 		.supports_dynamic_smps_6ghz = false,
 		.alloc_cacheable_memory = true,
-- 
2.39.2



