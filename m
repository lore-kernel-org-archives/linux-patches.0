Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E31A346E48;
	Tue, 16 Dec 2025 11:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885091; cv=none; b=eFXb1XVcmb65QQqSMQp5Qdpf+TJjNbddg4I8K4HiimqsGf/YX6dxSbwIvmKC/6GM0R/WikqpBaAS+8uUqk3nKFU7OhKq1t0rIiiIHarDEof5snqyJ1m7uM/s18bqOGObV6wdTuwnygSEnswqe+oa1VK7C7N71AiRbJabli9Px3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885091; c=relaxed/simple;
	bh=XJOI8peay1KOgs5u8BWk44UdnyIiuwolB5AzFplJLi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uF2Ghoexa9dUW9PM5ICD3vxswL9X1Iok3lRY5fJoaNXF27KVodimIuqQBAHnEOZY9P9e1i8zjEh75SHmAdEZLIO3eSb+SeotJ09wPhDl2o5/AASvwCYlp88UPymgAaJYghTCCB9A9i5wf/xXq1BDpNXEsok7zxCIGeyrWew7Qio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peleyFnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peleyFnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8499C4CEF5;
	Tue, 16 Dec 2025 11:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885091;
	bh=XJOI8peay1KOgs5u8BWk44UdnyIiuwolB5AzFplJLi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peleyFnzqIbk3ZM9GUEwgkqQZmr7mi2mcLWel442Dg4Gx0AH8a2CQCzlk3ha9ObOp
	 ebN/v58b5NY1I9lt+8oemhUHfBrFO8tMrx0lglgmPwY3y3qF497wRZR/EkZYo643yD
	 ffa4aaHbqiZh1tOLqryswI4WRfzy/d5JKh97I1LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 036/507] wifi: ath12k: fix TX and RX MCS rate configurations in HE mode
Date: Tue, 16 Dec 2025 12:07:57 +0100
Message-ID: <20251216111346.849225536@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>

[ Upstream commit 9c5f229b1312a31aff762b2111f6751e4e3722fe ]

Currently, the TX and RX MCS rate configurations per peer are
reversed when sent to the firmware. As a result, RX MCS rates
are configured for TX, and vice versa. This commit rectifies
the configuration to match what the firmware expects.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0.1-00029-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20251009211656.2386085-3-quic_pradeepc@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 828abccda125a..98b684b27566a 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -2638,9 +2638,10 @@ static void ath12k_peer_assoc_h_he(struct ath12k *ar,
 	switch (link_sta->bandwidth) {
 	case IEEE80211_STA_RX_BW_160:
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.rx_mcs_160);
+		v = ath12k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_rx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_160] = v;
 
-		v = ath12k_peer_assoc_h_he_limit(v, he_mcs_mask);
+		v = le16_to_cpu(he_cap->he_mcs_nss_supp.tx_mcs_160);
 		arg->peer_he_tx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_160] = v;
 
 		arg->peer_he_mcs_count++;
@@ -2650,10 +2651,10 @@ static void ath12k_peer_assoc_h_he(struct ath12k *ar,
 
 	default:
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.rx_mcs_80);
+		v = ath12k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_rx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_80] = v;
 
 		v = le16_to_cpu(he_cap->he_mcs_nss_supp.tx_mcs_80);
-		v = ath12k_peer_assoc_h_he_limit(v, he_mcs_mask);
 		arg->peer_he_tx_mcs_set[WMI_HECAP_TXRX_MCS_NSS_IDX_80] = v;
 
 		arg->peer_he_mcs_count++;
-- 
2.51.0



