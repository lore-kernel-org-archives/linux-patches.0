Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB0518455C;
	Tue, 30 Jul 2024 17:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360788; cv=none; b=o8IVMlIy9JIFg1E/yLp/NB1rUTOUYQNNYlXGuxW9kwCh7yF/dFfoaYbAopsQext2qsf3d83eiFNo1/7q9Bftw2tDKDSZbqQ4zdwEKOOvyoGZqR4Y6ZW5zNcpYm3EQYTjgp/m6Cl5M9XQ5grXpsYHv0BVpChyP90AIKvdjcm5r5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360788; c=relaxed/simple;
	bh=6cgal9M/Awp3VOLKKqqzUr8UzHXZ6Ci555kc7NiT0tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qWsVGPdnOO+irfETWlkHoQFs3LY++6erADPE4012k5cDFpafGOPidWYAZhY99Pg+ZJu3Pxk9Nja3MVHT52rBQwXQzYR8vZKo7jqPfG9mGfom8kg/PSsAs7aDH0ljoXb6at8y8SquMpRxXxU/hnQINGo3e36Q1DRF8HrGoNqoEtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeX4ENn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeX4ENn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7175C32782;
	Tue, 30 Jul 2024 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360788;
	bh=6cgal9M/Awp3VOLKKqqzUr8UzHXZ6Ci555kc7NiT0tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeX4ENn3Ekf0BZV0jUfoAn2+3sQ3PU6LnItTUuaHxraaaMeEm4EeLCx/Y59qcncQu
	 Ukmlh9ChkWS4+P7Wh0xi2w1/NA5oeIPVnibg+DDeSqps7faFNmMOyq39Uav7NyMGyz
	 XKphGWAd63CfE9y/BtlppeKcShKpo9gHMkHb6EPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 808/809] wifi: ath12k: fix mbssid max interface advertisement
Date: Tue, 30 Jul 2024 17:51:24 +0200
Message-ID: <20240730151756.895526362@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>

[ Upstream commit 253ec89c9013b0e61f5c54344df7c065d54934d1 ]

The Current method for advertising the maximum MBSSID interface count
assumes single radio per wiphy (multi wiphy model). However, this
assumption is incorrect for multi radio per wiphy (single wiphy model).
Therefore, populate the parameter for each radio present in the MAC
abstraction layer (ah). This approach ensure scalability for both single
wiphy and multi wiphy models.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Fixes: 519a545cfee7 ("wifi: ath12k: advertise driver capabilities for MBSSID and EMA")
Signed-off-by: Karthikeyan Periyasamy <quic_periyasa@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240613153813.3509837-1-quic_periyasa@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 0ed388a6fc804..ead37a4e002a2 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -8610,6 +8610,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	u32 ht_cap = U32_MAX, antennas_rx = 0, antennas_tx = 0;
 	bool is_6ghz = false, is_raw_mode = false, is_monitor_disable = false;
 	u8 *mac_addr = NULL;
+	u8 mbssid_max_interfaces = 0;
 
 	wiphy->max_ap_assoc_sta = 0;
 
@@ -8653,6 +8654,8 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 			mac_addr = ar->mac_addr;
 		else
 			mac_addr = ab->mac_addr;
+
+		mbssid_max_interfaces += TARGET_NUM_VDEVS;
 	}
 
 	wiphy->available_antennas_rx = antennas_rx;
@@ -8744,7 +8747,7 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
 	wiphy->iftype_ext_capab = ath12k_iftypes_ext_capa;
 	wiphy->num_iftype_ext_capab = ARRAY_SIZE(ath12k_iftypes_ext_capa);
 
-	wiphy->mbssid_max_interfaces = TARGET_NUM_VDEVS;
+	wiphy->mbssid_max_interfaces = mbssid_max_interfaces;
 	wiphy->ema_max_profile_periodicity = TARGET_EMA_MAX_PROFILE_PERIOD;
 
 	if (is_6ghz) {
-- 
2.43.0



