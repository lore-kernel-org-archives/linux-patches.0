Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623856;
	b=3VanzmsDK99WaNCtNY/9GRmUfDZ+V3vjXWmxzMfhYunrDTBTwIz0PXmXlu7GOX88+Q5P
	 NiQCwICbwX/mDhxmgo68DvSyZO8KvkOWbF0lZeEcPSA23G1rVIsl+BmADbpX3Q/gZ1hm1
	 RvcQ9TiT9eGPSHbOktW2keK7WBdomMN0X0IpZlLSCkCtvnjr+CvxOaa4fLuKBKz1Ti9GM
	 Nw0e+5PMknksMlQm10KO31Mv0kuT1fSchFJtXYZKsBvv7RS2z7yCttUiG8cXc9pmHEKsh
	 flyXvsNO/PgkRasowuLTFLtYkw92uZHH/9qw30SFosUC6QzIrisQdSepYIBk0NWD2OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xzIMS1fYRe3NQ6xZLFWXjguyo/AOwuikdKiI1X+nkFI=;
	b=jH/gDYQJjDeGcUbU33aEtaT/xlwsNo9goqTKcgxjyIxy4Q76f+7TutXvQoPFCz/cuAT/
	 d5S9jweJW64hlWC3cbNIdHTtAueKqLNnJ4l5KgGQxDROkdTHBATjgHexs5R1XPyIElDC5
	 xRMX67DlRTMgYHm9CeVu3u/BEIsdazu6DRp28LlHHOnp8ou/rMpEzJ2zzVqXdhZrldwD6
	 ILiIE2Yrtm7ULtWre2K6aQmVY9GjLAQ6woo7c7rFoTQn1eEx1uaE1hEZ0wR62gSW9RRwH
	 eK8mUt5Plq0ZLI1y+jlMOKk3ukuytdC3SjAWWi0V2BFc++38pgPCd/BpJp+/IoYJXgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8VGy8Ud;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6A2606A329;
	Wed, 25 Nov 2026 16:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J8VGy8Ud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5D51F000C4;
	Wed, 25 Nov 2026 16:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623856;
	bh=xzIMS1fYRe3NQ6xZLFWXjguyo/AOwuikdKiI1X+nkFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J8VGy8UddqikBitX/drP4WIlgY565BdTleO3OBBNr9ww/6D9FXXZl6HBOVbDBarQw
	 ARe2Qb7m2g3foJXG11RdlXjWGAawpuYBTKvAfoINIA3LtD28edrvLiYRBH4t5LIjPv
	 CJgNZkESufbGdCcHsfJJpjYN1kEmQvBj46L/tft8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.18 981/990] wifi: ath12k: fix EHT TX MCS limitation due to wrong 20 MHz-only parsing
Date: Wed, 25 Nov 2026 15:39:08 +0100
Message-ID: <20261125143844.958833825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

commit 60fb2cf51e77bb1c0261160b4be44209d68956b1 upstream.

When connecting to an AP configured for EHT 20 MHz with a full EHT
MCS/NSS map (supporting MCS 0-13)

Supported EHT-MCS and NSS Set
    EHT-MCS Map (BW <= 80MHz): 0x444444
        .... .... .... .... .... 0100 = Rx Max Nss That Supports EHT-MCS 0-9: 4
        .... .... .... .... 0100 .... = Tx Max Nss That Supports EHT-MCS 0-9: 4
        .... .... .... 0100 .... .... = Rx Max Nss That Supports EHT-MCS 10-11: 4
        .... .... 0100 .... .... .... = Tx Max Nss That Supports EHT-MCS 10-11: 4
        .... 0100 .... .... .... .... = Rx Max Nss That Supports EHT-MCS 12-13: 4
        0100 .... .... .... .... .... = Tx Max Nss That Supports EHT-MCS 12-13: 4

TX throughput is observed to be significantly lower than expected.
Investigation shows that TX rates are limited to EHT MCS 11, even though
the AP advertises support for EHT MCS 12/13.

The root cause is an incorrect parsing of the Supported EHT-MCS and NSS
Set element in ath12k_peer_assoc_h_eht().

IEEE Std 802.11be-2024 Figure 9-1074as describes the format for 20
MHz-Only Non-AP STAs.

IEEE Std 802.11be-2024 Figure 9-1074at describes the format for all
other AP and non-AP STAs.

Currently the first format is parsed when the peer advertises no wider
HE channel width support, without considering whether it is an AP or a
non-AP STA. This is incorrect: the peer AP's capabilities must be parsed
using Figure 9-1074at even when it operates on 20 MHz only. Parsing it
as Figure 9-1074as causes rx_tx_mcs13_max_nss to be interpreted as zero,
which is then passed to firmware, leading firmware to assume the peer
does not support MCS 13 and to limit TX rates at MCS 11.

Fix this by parsing the Figure 9-1074as format only when the peer is a
20 MHz-Only non-AP STA, i.e. when the local interface operates as AP or
mesh point.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: 6c95151e2e77 ("wifi: ath12k: Add EHT MCS/NSS rates to Peer Assoc")
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260514-ath12k-fix-20mhz-only-mcs-map-v1-1-a38d4a9b21a2@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/mac.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3356,7 +3356,9 @@ static void ath12k_peer_assoc_h_eht(stru
 		arg->peer_eht_mcs_count++;
 		fallthrough;
 	default:
-		if (!(link_sta->he_cap.he_cap_elem.phy_cap_info[0] &
+		if ((vif->type == NL80211_IFTYPE_AP ||
+		     vif->type == NL80211_IFTYPE_MESH_POINT) &&
+		    !(link_sta->he_cap.he_cap_elem.phy_cap_info[0] &
 		      IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_MASK_ALL)) {
 			bw_20 = &eht_cap->eht_mcs_nss_supp.only_20mhz;
 
@@ -3385,7 +3387,9 @@ static void ath12k_peer_assoc_h_eht(stru
 	arg->punct_bitmap = ~arvif->punct_bitmap;
 	arg->eht_disable_mcs15 = link_conf->eht_disable_mcs15;
 
-	if (!(link_sta->he_cap.he_cap_elem.phy_cap_info[0] &
+	if ((vif->type == NL80211_IFTYPE_AP ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
+	    !(link_sta->he_cap.he_cap_elem.phy_cap_info[0] &
 	      IEEE80211_HE_PHY_CAP0_CHANNEL_WIDTH_SET_MASK_ALL)) {
 		if (bw_20->rx_tx_mcs13_max_nss)
 			max_nss = max(max_nss, u8_get_bits(bw_20->rx_tx_mcs13_max_nss,


