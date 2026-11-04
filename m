Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829391;
	b=GGiNQhmLm6lEWTd664phL3yXG/jp953GyWYMBpLraNRTTKBfhoP8kKDjWCnDHl0MyM3H
	 Gj1A4Q0J9NgYB3+hpiSXFo9xtcT8EL5J+2Dod05BsXnD/odNs3bHlANDwme6dRxICmWrL
	 VtH6UA3buQ5B7aAmLYN4XEbQOPO+1Cxwxs3Cec5Dps2YuKc5XmriNHoUURkOh+EL2wUMP
	 XZAOS5kh1oLQbirnkQOtB+NMXehQ+tmtCQGXoX9/By3rPudMdk82zjSaBI5ccidujiRNC
	 xPxyN+tMA6bx6CPPUmHZDgiPK0z4runsHXRCDtzBc+yD2IKK+pdny1YAZ9D970T16Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J3qTgnAwImS6IzWITarqpXzP5C+DyYxERKw7ncTbZJA=;
	b=oX13NcNWoLIC/0miJhH9h3E5SH7CuZ0EJfNyoY71qFW7UE4dc+l3BRWaUbDAACVySwVK
	 s7xFw2ENQ/x8bcwuNGgWb0ITy+wMJGXG6GuUb+LcxfD/0nio97X4Vwqiso5y+xUFeAgw3
	 YUWyWUnATwD3HApOPeBgYjrBEakfqLQhvcsbAVoI6C6AFGsjnIII6AcUrGUKsR+Qoc6Nc
	 46R2+sHxzRCm/Lb3ERQtiFH7o7gvzyUsaDKulrTXE9rXrv+DSlvXgNXVYFxEiemWsd+pJ
	 vCwY3tycn+TXkYveyxgbSbHPpEAhCX8eJFq6FUOxlXrAvu8X07mnCL7oZzdiHo3z6vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aejbIkW/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6197606A865;
	Wed,  4 Nov 2026 21:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aejbIkW/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E0E1F000C1;
	Wed,  4 Nov 2026 21:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829390;
	bh=J3qTgnAwImS6IzWITarqpXzP5C+DyYxERKw7ncTbZJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aejbIkW/AnaG9CZY3BoVBl0oA3eEkT72j+gEy3DdMf1im657a5gwp/KiFjW6veqR7
	 iiySRChtzEBHrgO0+k1i6gdKrk4kchjeMoCQGxYTmmWp0K+QZl1FUAmv0k3uunuZF4
	 eJAGK49JyJ/U7M3yN4yOwUWmSb+2L8AGetFhZSpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0057/1005] wifi: ath12k: avoid setting 320MHz support on non 6GHz band
Date: Wed,  4 Nov 2026 15:56:30 -0500
Message-ID: <20261104211045.192312073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index ade14ba6703f3..39d5110eca901 100644
--- a/drivers/net/wireless/ath/ath12k/wmi.c
+++ b/drivers/net/wireless/ath/ath12k/wmi.c
@@ -4939,6 +4939,7 @@ static void ath12k_wmi_eht_caps_parse(struct ath12k_pdev *pdev, u32 band,
 				       __le32 cap_info_internal)
 {
 	struct ath12k_band_cap *cap_band = &pdev->cap.band[band];
+	u8 *phy_cap = (u8 *)&cap_band->eht_cap_phy_info[0];
 	u32 support_320mhz;
 	u8 i;
 
@@ -4952,8 +4953,22 @@ static void ath12k_wmi_eht_caps_parse(struct ath12k_pdev *pdev, u32 band,
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



