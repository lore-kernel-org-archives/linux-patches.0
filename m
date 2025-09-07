Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC4D1A9FAA;
	Sun,  7 Sep 2025 20:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276550; cv=none; b=rC2nIq9xRIQ/kiLT26D2Ton4EpHLlshkGVEs2v0oGXpimfmF0biFxCk9/Ost+u28QXVlnz2RT33UTYM0RIiK/sHuuhfVrWjtmxH42Qs/slRDtqUdEM2eo3zHGvZbuI1J5odjNQXSwacxAmt0RWknoe5LTxbCMKSN0SWabMzeGnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276550; c=relaxed/simple;
	bh=Y9KVGBmJxi4xPRos8FBB6riJXeg/8Cl9nysMa6w10xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwcqRZTTTFgIXTjYridUsP8ZuNWR9IDmITi8FDU76ukOr0GQY28aYmb3ZjlycM8vuQCTdHgG4z06YgJO9ePbL15rgqH1HCWY/YOhYJcyXIOVbHjVCBEoeTCP8FmUky32aBRVVR5lB/jLg77DbEBY72NQT/b0QRLepWNuic7Z6v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kv6O1bAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kv6O1bAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23ECCC4CEF0;
	Sun,  7 Sep 2025 20:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276550;
	bh=Y9KVGBmJxi4xPRos8FBB6riJXeg/8Cl9nysMa6w10xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kv6O1bAeZV/N28GeiQ7500IdtatVxxF2vD64aW4T6b/SS/BU/Cx3GSveMx0Cx6BMW
	 LW0gw44MO16L7bt3PwM0+HnsmlNXPG3zZYMzOxAvSb0jOvEpLe7K9YCbPXsz17UGw7
	 hnEp1T5DPhlcX9PE6hBkMhFTJX9sTllo1kGD/Qmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/121] wifi: ath11k: rename ath11k_start_vdev_delay()
Date: Sun,  7 Sep 2025 21:57:50 +0200
Message-ID: <20250907195610.706051649@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 629642fa8b25b8dfecefc9e2177a44c009858da7 ]

Rename ath11k_start_vdev_delay() as ath11k_mac_start_vdev_delay()
to follow naming convention.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1
Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23
Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240123025700.2929-3-quic_bqiang@quicinc.com
Stable-dep-of: 97acb0259cc9 ("wifi: ath11k: fix group data packet drops during rekey")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index cc9c09d05f63f..58cc079f0df4a 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -254,8 +254,8 @@ static const u32 ath11k_smps_map[] = {
 	[WLAN_HT_CAP_SM_PS_DISABLED] = WMI_PEER_SMPS_PS_NONE,
 };
 
-static int ath11k_start_vdev_delay(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif);
+static int ath11k_mac_start_vdev_delay(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif);
 
 enum nl80211_he_ru_alloc ath11k_mac_phy_he_ru_to_nl80211_he_ru_alloc(u16 ru_phy)
 {
@@ -4966,7 +4966,7 @@ static int ath11k_mac_station_add(struct ath11k *ar,
 	if (ab->hw_params.vdev_start_delay &&
 	    !arvif->is_started &&
 	    arvif->vdev_type != WMI_VDEV_TYPE_AP) {
-		ret = ath11k_start_vdev_delay(ar->hw, vif);
+		ret = ath11k_mac_start_vdev_delay(ar->hw, vif);
 		if (ret) {
 			ath11k_warn(ab, "failed to delay vdev start: %d\n", ret);
 			goto free_tx_stats;
@@ -7546,8 +7546,8 @@ static void ath11k_mac_op_change_chanctx(struct ieee80211_hw *hw,
 	mutex_unlock(&ar->conf_mutex);
 }
 
-static int ath11k_start_vdev_delay(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif)
+static int ath11k_mac_start_vdev_delay(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif)
 {
 	struct ath11k *ar = hw->priv;
 	struct ath11k_base *ab = ar->ab;
-- 
2.50.1



