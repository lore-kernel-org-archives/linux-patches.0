Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C6F340A5A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301091; cv=none; b=owUl5ZQQF3EHb0hJ/rIpOchmBjRxUAKL8Xg7xJ3xh6jWT4pnCNDqzR6BY4D6rMVa7aq0oCiqU/wGR9SiNZbNAa91LyCfZXzBGgxFUyvNHgXMu6rz5jmCPoaNVQaEDymxRAzMleoZDnqEJ9XFkgkRomU0Bubi5RmLEIOcxtrkbwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301091; c=relaxed/simple;
	bh=0XL87ncdRefuTJBlIeL4ASiEzjFaiEv8O+qCsZfUpPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeXtWnkzPEfA2Fg1vGLYiKipPHQNC4gPi/MYuCBPfXfIjc62sTXjss3I7g7WLatEZJE+oYZ0cQJNs7oil13GCEFqMWxD0l6R51HUhE92KBjeZ6872iJXt7fC2t2FyrXxkpI5VqmUkFsse1iHGifwzrgIuGmZG3JjoZAvYNDH2sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHA02gpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHA02gpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3ECC19424;
	Sat, 28 Feb 2026 17:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301091;
	bh=0XL87ncdRefuTJBlIeL4ASiEzjFaiEv8O+qCsZfUpPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHA02gpd9k1Pb2M292xDsgt9iEVO9g9uWUcqYDKqgtlUwEMx6CowUJL3pFuO7QxB8
	 5kSDHJB10dQzjFsFwzDAZxj2BlAgc9HS9lF8iVPKRYUdydiHAuEWX0hOM3pXlRWR0U
	 1UBNVckvZSsGSNYXfTbXi9fHlKcj90p24WMxtwq+ZYK9UZaj/H5dwRjvclpVciGT9v
	 ZQKJm6FqB0knvZxSymof7R0NtkDmlxsAnGIX/H4TvhT9Ze2b3oc/3Tgi+/uEfBrydK
	 QPE2LOYPRANulknVxBO3eVwy01rfH7BGs0Bt5VhQMFMifebwF2r+a/NregxoWaQ7oG
	 BDx/vxn5f7Crg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 241/752] wifi: ath12k: fix mac phy capability parsing
Date: Sat, 28 Feb 2026 12:39:12 -0500
Message-ID: <20260228174750.1542406-241-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

[ Upstream commit b5151c9b6e3a347416a4b4b55fc00195526d8771 ]

Currently ath12k_pull_mac_phy_cap_svc_ready_ext() assumes only one band
supported in each phy, hence it skips 5 GHz band if 2 GHz band support
is detected. This does not work for device which gets only one phy but
has both bands supported, such as QCC2072.

Change to check each band individually to fix this issue.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260112-ath12k-support-qcc2072-v2-6-fc8ce1e43969@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index 6dd95bcaf2436..f3474a13e32aa 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -493,6 +493,7 @@ ath12k_pull_mac_phy_cap_svc_ready_ext(struct ath12k_wmi_pdev *wmi_handle,
 	struct ath12k_band_cap *cap_band;
 	struct ath12k_pdev_cap *pdev_cap = &pdev->cap;
 	struct ath12k_fw_pdev *fw_pdev;
+	u32 supported_bands;
 	u32 phy_map;
 	u32 hw_idx, phy_idx = 0;
 	int i;
@@ -516,14 +517,19 @@ ath12k_pull_mac_phy_cap_svc_ready_ext(struct ath12k_wmi_pdev *wmi_handle,
 		return -EINVAL;
 
 	mac_caps = wmi_mac_phy_caps + phy_idx;
+	supported_bands = le32_to_cpu(mac_caps->supported_bands);
+
+	if (!(supported_bands & WMI_HOST_WLAN_2GHZ_CAP) &&
+	    !(supported_bands & WMI_HOST_WLAN_5GHZ_CAP))
+		return -EINVAL;
 
 	pdev->pdev_id = ath12k_wmi_mac_phy_get_pdev_id(mac_caps);
 	pdev->hw_link_id = ath12k_wmi_mac_phy_get_hw_link_id(mac_caps);
-	pdev_cap->supported_bands |= le32_to_cpu(mac_caps->supported_bands);
+	pdev_cap->supported_bands |= supported_bands;
 	pdev_cap->ampdu_density = le32_to_cpu(mac_caps->ampdu_density);
 
 	fw_pdev = &ab->fw_pdev[ab->fw_pdev_count];
-	fw_pdev->supported_bands = le32_to_cpu(mac_caps->supported_bands);
+	fw_pdev->supported_bands = supported_bands;
 	fw_pdev->pdev_id = ath12k_wmi_mac_phy_get_pdev_id(mac_caps);
 	fw_pdev->phy_id = le32_to_cpu(mac_caps->phy_id);
 	ab->fw_pdev_count++;
@@ -532,10 +538,12 @@ ath12k_pull_mac_phy_cap_svc_ready_ext(struct ath12k_wmi_pdev *wmi_handle,
 	 * band to band for a single radio, need to see how this should be
 	 * handled.
 	 */
-	if (le32_to_cpu(mac_caps->supported_bands) & WMI_HOST_WLAN_2GHZ_CAP) {
+	if (supported_bands & WMI_HOST_WLAN_2GHZ_CAP) {
 		pdev_cap->tx_chain_mask = le32_to_cpu(mac_caps->tx_chain_mask_2g);
 		pdev_cap->rx_chain_mask = le32_to_cpu(mac_caps->rx_chain_mask_2g);
-	} else if (le32_to_cpu(mac_caps->supported_bands) & WMI_HOST_WLAN_5GHZ_CAP) {
+	}
+
+	if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP) {
 		pdev_cap->vht_cap = le32_to_cpu(mac_caps->vht_cap_info_5g);
 		pdev_cap->vht_mcs = le32_to_cpu(mac_caps->vht_supp_mcs_5g);
 		pdev_cap->he_mcs = le32_to_cpu(mac_caps->he_supp_mcs_5g);
@@ -545,8 +553,6 @@ ath12k_pull_mac_phy_cap_svc_ready_ext(struct ath12k_wmi_pdev *wmi_handle,
 			WMI_NSS_RATIO_EN_DIS_GET(mac_caps->nss_ratio);
 		pdev_cap->nss_ratio_info =
 			WMI_NSS_RATIO_INFO_GET(mac_caps->nss_ratio);
-	} else {
-		return -EINVAL;
 	}
 
 	/* tx/rx chainmask reported from fw depends on the actual hw chains used,
@@ -562,7 +568,7 @@ ath12k_pull_mac_phy_cap_svc_ready_ext(struct ath12k_wmi_pdev *wmi_handle,
 	pdev_cap->rx_chain_mask_shift =
 			find_first_bit((unsigned long *)&pdev_cap->rx_chain_mask, 32);
 
-	if (le32_to_cpu(mac_caps->supported_bands) & WMI_HOST_WLAN_2GHZ_CAP) {
+	if (supported_bands & WMI_HOST_WLAN_2GHZ_CAP) {
 		cap_band = &pdev_cap->band[NL80211_BAND_2GHZ];
 		cap_band->phy_id = le32_to_cpu(mac_caps->phy_id);
 		cap_band->max_bw_supported = le32_to_cpu(mac_caps->max_bw_supported_2g);
@@ -582,7 +588,7 @@ ath12k_pull_mac_phy_cap_svc_ready_ext(struct ath12k_wmi_pdev *wmi_handle,
 				le32_to_cpu(mac_caps->he_ppet2g.ppet16_ppet8_ru3_ru0[i]);
 	}
 
-	if (le32_to_cpu(mac_caps->supported_bands) & WMI_HOST_WLAN_5GHZ_CAP) {
+	if (supported_bands & WMI_HOST_WLAN_5GHZ_CAP) {
 		cap_band = &pdev_cap->band[NL80211_BAND_5GHZ];
 		cap_band->phy_id = le32_to_cpu(mac_caps->phy_id);
 		cap_band->max_bw_supported =
-- 
2.51.0

