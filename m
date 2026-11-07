Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060595;
	b=iXu9tOOfPd3J7shZ/tYiT0Rrgq+Au1dgyS4meWuEeOT+Hbwk7jltckkfy73RNpeUV9wN
	 dvd3B3hZaov0oXfFWDna0rb7jGSOC2WnLiPuQ7D+mILxAvqwj+L2Xf7iI9/Z2F9KUIBFB
	 7q5s6cra0GQRNKpE4oczDykZQ9jTOgX5cESmqbzWN0KwAKEte2tTSYjjVgPquWcb54+Q3
	 bWJgGy0x6xBtfxYfR4KNjSG9Es4e7OFtJ2eq9xtF6k0s/qREaFXScmBfpuYxyDjhWUTbk
	 jF3/Z+yxC4z1jAS/rfw/UYkIz5utcn9QbnvDZBpp2TYVz0hzkl28lJ0l/QxN2sBQgIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=56Rszs2dBbmexXBYXp+/UGswpQfTAJ3GhT4ilPUIWPs=;
	b=YI5UWfHUTUVfmx3ES9Ej+pa9FY3qLeQsRqLfoHnktlysoxd6OW63m4jjbKlnnu/l4oOf
	 xXiNzW+tLIjlMEskpEPCwbSNVdOJAycLxsFO5cTT2eDz/YCkr7WQ1rUcFLRsHStezxxGG
	 PmMP4cH16z7GSUKuoqcClsPeBH+E4xxKk5ZereNKEILAfjQO0LZINFwSRFJ/o5wz0IqtC
	 POfAU1d+QjwozpX+4Y+nbnbBAONC5PSEMi9X3TRhY2SIx9DFbnXYhgteQEacSNYlMrEjd
	 SzZUW2ZuXPYcsoh6AjcDx7KBGMhXyjKO1MP8nyMSgfb05JEmDk8d5C3X80VxwwpBeHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sex34TaL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CBA606A326;
	Sat,  7 Nov 2026 14:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sex34TaL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BCE1F0089F;
	Sat,  7 Nov 2026 14:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060595;
	bh=56Rszs2dBbmexXBYXp+/UGswpQfTAJ3GhT4ilPUIWPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sex34TaLl+cwYyjjquXDiXAto1Ekx6Him2VtuTiqfGMHD6Xtg/G5FwtHQqoKhIwyB
	 OZv4pbPJ9eYs6lfrQILgXGRjX/BBSV8JQZ6u2ThP6/lzkqbhiIz4GlnN6CGb8sb5ug
	 l8WMgXn4DIsc+XLQGP0Yf+ICZ15Xf3AdVzGuKauI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0051/1536] wifi: ath12k: avoid setting 320MHz support on non 6GHz band
Date: Sat,  7 Nov 2026 08:34:27 -0500
Message-ID: <20261107134959.093135961@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit eaf478b3ea68e1b5df659acd24c4df5850e12325 ]

On a split phy qcn9274 (2.4GHz + 5GHz low), "iw phy" reports 320MHz
related features on the 5GHz band while it should not:

    Wiphy phy1
    [...]
        Band 2:
    [...]
            EHT Iftypes: managed
    [...]
                EHT PHY Capabilities: (0xe2ffdbe018778000):
                    320MHz in 6GHz Supported
    [...]
                    Beamformee SS (320MHz): 7
    [...]
                    Number Of Sounding Dimensions (320MHz): 3
    [...]
                EHT MCS/NSS: (0x22222222222222222200000000):

This is also reflected in the beacons sent by a mesh interface started on
that band. They erroneously advertise 320MHz support too.

This should not happen as IEEE Std 802.11-2024, subclause 9.4.2.323.3 says
we should not set the 320MHz related fields when not operating on a 6GHz
band. For example it says about Bit 0 "Support For 320 MHz In 6 GHz"

  "Reserved if the EHT Capabilities element is indicating capabilities for
   the 2.4 GHz or 5 GHz bands."

Fix this by clearing the related bits when converting from WMI eht phy
capabilities to mac80211 phy capabilities, for bands other than 6GHz.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00218-QCAHKSWPL_SILICONZ-1

Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20260623151613.72113-1-nico.escande@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wmi.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wmi.c b/drivers/net/wireless/ath/ath12k/wmi.c
index ca359eecb42a9..e70a1e3fef04e 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4426,6 +4426,7 @@ static void ath12k_wmi_eht_caps_parse(struct ath12k_pdev *pdev, u32 band,
 				       __le32 cap_info_internal)
 {
 	struct ath12k_band_cap *cap_band = &pdev->cap.band[band];
+	u8 *phy_cap = (u8 *)&cap_band->eht_cap_phy_info[0];
 	u32 support_320mhz;
 	u8 i;
 
@@ -4439,8 +4440,22 @@ static void ath12k_wmi_eht_caps_parse(struct ath12k_pdev *pdev, u32 band,
 	for (i = 0; i < WMI_MAX_EHTCAP_PHY_SIZE; i++)
 		cap_band->eht_cap_phy_info[i] = le32_to_cpu(cap_phy_info[i]);
 
-	if (band == NL80211_BAND_6GHZ)
+	if (band == NL80211_BAND_6GHZ) {
 		cap_band->eht_cap_phy_info[0] |= support_320mhz;
+	} else {
+		/*
+		 * Firmware may report 6 GHz/320 MHz specific capabilities for
+		 * non-6 GHz bands, so explicitly clear them.
+		 */
+		phy_cap[0] &= ~IEEE80211_EHT_PHY_CAP0_320MHZ_IN_6GHZ;
+		phy_cap[1] &= ~IEEE80211_EHT_PHY_CAP1_BEAMFORMEE_SS_320MHZ_MASK;
+		phy_cap[2] &= ~IEEE80211_EHT_PHY_CAP2_SOUNDING_DIM_320MHZ_MASK;
+		phy_cap[3] &= ~IEEE80211_EHT_PHY_CAP3_SOUNDING_DIM_320MHZ_MASK;
+		phy_cap[6] &= ~IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_320MHZ;
+		phy_cap[6] &= ~IEEE80211_EHT_PHY_CAP6_EHT_DUP_6GHZ_SUPP;
+		phy_cap[7] &= ~IEEE80211_EHT_PHY_CAP7_NON_OFDMA_UL_MU_MIMO_320MHZ;
+		phy_cap[7] &= ~IEEE80211_EHT_PHY_CAP7_MU_BEAMFORMER_320MHZ;
+	}
 
 	cap_band->eht_mcs_20_only = le32_to_cpu(supp_mcs[0]);
 	cap_band->eht_mcs_80 = le32_to_cpu(supp_mcs[1]);
-- 
2.53.0



