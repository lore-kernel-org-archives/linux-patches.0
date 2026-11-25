Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618239;
	b=G4TEO6meHZ+PLxzjphbepJtxwhdFU6mndSlAS2qINft0Y7s3UicsUQmRV5yReThOdFg9
	 2YJvlSyNo5a/VzRXYbkkqxU/E+NlbZmzvDgl7d17QqqGXkcS7j/OazwHOm2gvLV79gwts
	 HZ9FgMoR9XuUqFktvRyIEGOCCweJb1x0y0Fxhj4eMdnVJm8bi5U3er+VTiwGU11ZDQ65X
	 PDB0Bgxc4mb7PggiYxuDNJVqpBd+UdBtL06nVES/Ga/nr11c43BremGO5SN3pAe62s5Oh
	 GuVODHizn4lzHy3tOKNvGTG1Zwz60DUvDfFLJODSTlbIAKSgTHNxCAtfgwq5k/ZrqFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ApNpEt3LwIKqVFRBLD7fhgh0s52U2Vox0XduZ4qEFyM=;
	b=W8p0jLaFjyM8qOEuJ8O5emkgh04AIeFU3DppMBj+3YCm3Q71xBP5kdCivLRR/mRhI5f5
	 qevP//UI++uJK1iJAWlDL7JVYwgz99Tl++pd0CqkArsR0leSePPxAhw3/Dw69iMeApC1h
	 RH4OAs7SPm3BeRQN99sXLMmcg3z6ZwBiZv8nyIBm5XvQXg0uSPvfNavZxdb/4cmatg4HZ
	 EWRjklzt/cfGjphRndqS+mmuG/Dh2IzqLOUp98/4E5tfEriZE1xAlxiIRf8inSZXLJ4ut
	 4utwCRXiFPxq2JYbDFZhHfb22tJgS2NKHPhDo0Kedv07h93GsBLKzz7BchutZRBkWww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UC4DItCC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C195D606A31E;
	Wed, 25 Nov 2026 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UC4DItCC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1501F000C0;
	Wed, 25 Nov 2026 14:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618239;
	bh=ApNpEt3LwIKqVFRBLD7fhgh0s52U2Vox0XduZ4qEFyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UC4DItCCbycQfxrgSbiopPeahF/qiZz8a2neZYy8jWSfGldIjf6kAZI0KnwnQ7iN2
	 saY0C70WCxG6waS1H4wL3GgH9/HzFkFsulLuGtfJtKu5+27JvuaWr+AprjdPvi2Ii6
	 x8gP9Zmx3uGElMOjt8SDvKTDTBrQhcxJuhGXVRa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Petrzhikovskii <vladimir@dfb.sh>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0171/1005] wifi: ath12k: dont advertise EHT-MCS15 to firmware unless we support it
Date: Wed, 25 Nov 2026 15:25:09 +0100
Message-ID: <20261125143825.747196409@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b5c3519065a2a..beccf11eb8aad 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -3366,6 +3366,7 @@ static void ath12k_peer_assoc_h_eht(struct ath12k *ar,
 	u32 *rx_mcs, *tx_mcs;
 	u16 *eht_mcs_mask;
 	u8 max_nss = 0;
+	u8 mcs15;
 
 	lockdep_assert_wiphy(ath12k_ar_to_hw(ar)->wiphy);
 
@@ -3416,6 +3417,16 @@ static void ath12k_peer_assoc_h_eht(struct ath12k *ar,
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



