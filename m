Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621254;
	b=UMSEJr8b1JONFwgYk8FTi59mITmRtanQRb+Bq9scKnmBWVp/Q7vbSFHaFAN1ZZZLQh9c
	 A260MUN7AQrS+j3Cqm2tduQtLcN3Dy6DR+9hCVQLGEnXRNQJ9jQHEE6MVN94FWDERmvM/
	 wFGEei97TjnhPPKRXkkB57G3fpen0PnysZdPMjC0uesFEKxx/Cf5MNJ0roLuGuw1vzMJu
	 V3SG1UraU64OdXx6f7NuBMchCWm+tD1DsdzHb/nONg3BftgiFzOv3U182tkVloUZot4vW
	 +3ZJ5vRBU4ls0d7H1vnOhMYusQTB2rO/vcp7cL7qrHBR76FpSn+wu0ANwb3051/zJaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+aTifPswarImLDC03LK4nO8xKQn7uuCKms/UUbd0TIY=;
	b=wb5Aj+n3ZzL43rcmI51s1uEtUksC/rUW8jXFAh7sHYzRRosSgOZKCRR+7kVYG28UVtc9
	 7efBdTSD+7QXdXv9Yeu+H8L4K05h1YcnSfcA7JigCEZUHmW2Q0LVs+Hx3P5012ztmozYX
	 t+zMapI7n6dwSFYPu/qdWYDqT7Pg555UZGyhnvh00wCQt1y7Wb33lB5kXC8X1jFntzll/
	 tfvvFFAB//0zjaBrHhry/acFYkcPgDE+wgn6jS95YoI6ekS0Buz1FNNS3sgd7MglDrVbR
	 rVgP2uUbW1reVeca/sjnSaU5bHUn20Vga00dJL+2gniz43ZYOWDYTzfRrpSYt1IALUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tghZ/Ie6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15059606A695;
	Wed, 25 Nov 2026 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tghZ/Ie6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CC51F01577;
	Wed, 25 Nov 2026 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621253;
	bh=+aTifPswarImLDC03LK4nO8xKQn7uuCKms/UUbd0TIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tghZ/Ie60PzznZY4KSvYVmC2mK5QzW+Bf78GAmbYUNREVQbOSXicC/2WjyJd/t2Mp
	 B9Kvgdywokz0cZTNSkreyp3aA7lbvSSrQjw5UoWUQBuwqWqXn6fjSAWSCuBdRtBRMM
	 odC2MnG6zVJ3CJm+4m23dRvvntayvNXzjSgfjlas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Petrzhikovskii <vladimir@dfb.sh>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/990] wifi: ath12k: dont advertise EHT-MCS15 to firmware unless we support it
Date: Wed, 25 Nov 2026 15:25:37 +0100
Message-ID: <20261125143826.076604603@linuxfoundation.org>
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

[ Upstream commit 83d689bbe8f90ce39961bcc3a64f2ca2ec184019 ]

ath12k_peer_assoc_h_eht() copies the peer's EHT PHY capabilities into
the WMI peer assoc command as is, including the EHT-MCS15 support bits.
Firmware rate control enables EHT-MCS15 for TX whenever those bits are
set, without checking whether the local PHY supports MCS15.

Currently WCN7850 firmware does not support EHT-MCS15 for TX and does
not advertise it in its own EHT PHY capabilities. When connected to an
AP that advertises MCS15 support, rate control may still select
EHT-MCS15, and every PPDU at that rate is aborted by the PHY before it
goes on the air. TX then stops for minutes while the association stays
up, and frames sit in the queue until the firmware releases them as aged.

Keep only the peer's MCS15 support bits that we also support ourselves
to fix it. Chips that support MCS15 are not affected.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 17bbb8aa74fd ("wifi: ath12k: prepare EHT peer assoc parameters")
Reported-by: Vladimir Petrzhikovskii <vladimir@dfb.sh>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=222136
Tested-by: Vladimir Petrzhikovskii <vladimir@dfb.sh>
Signed-off-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20261029-ath12k-mcs15-v1-1-3bcfab101f00@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 94e5af15cd618..c3f761cc35558 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3239,6 +3239,7 @@ static void ath12k_peer_assoc_h_eht(struct ath12k *ar,
 	u32 *rx_mcs, *tx_mcs;
 	u16 *eht_mcs_mask;
 	u8 max_nss = 0;
+	u8 mcs15;
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
@@ -3289,6 +3290,16 @@ static void ath12k_peer_assoc_h_eht(struct ath12k *ar,
 	memcpy(arg->peer_eht_cap_phy, eht_cap->eht_cap_elem.phy_cap_info,
 	       sizeof(eht_cap->eht_cap_elem.phy_cap_info));
 
+	/*
+	 * Firmware rate control enables EHT-MCS15 based only on the peer's
+	 * MCS15 support bits, so keep only the ones we support ourselves.
+	 */
+	mcs15 = u8_get_bits(eht_cap->eht_cap_elem.phy_cap_info[6] &
+			    own_eht_cap->eht_cap_elem.phy_cap_info[6],
+			    IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_MASK);
+	u8p_replace_bits(&((u8 *)arg->peer_eht_cap_phy)[6], mcs15,
+			 IEEE80211_EHT_PHY_CAP6_MCS15_SUPP_MASK);
+
 	rx_mcs = arg->peer_eht_rx_mcs_set;
 	tx_mcs = arg->peer_eht_tx_mcs_set;
 
-- 
2.53.0



