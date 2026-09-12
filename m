Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631342D8382;
	Sat, 12 Sep 2026 07:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199713; cv=none; b=Ha07qdkZXgoOCQKdYZrf/KdvGIEraROJMrxrYWnOiujshIXJK4e+5Ia/GMwV+lXB+4Mn/ar7OXCSMFCKcEzDSG4+WyjnwNE/KrqRjyJKY+uy/w1u19rToNBR1DrjaE1uqjNHATNfG3/QHhbaOTPa++kN05gjUnSvbk+uw+HLTWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199713; c=relaxed/simple;
	bh=r55B5cpKK0ReDJaBFh3WwAUgA175S9ypAkZtQJ6dmy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pisp2GaUwX7B9+OIMVCxKYO9Rw9xXChT0fouT1X5ZUYu9MBZ6qClykcLU7G/RsgrOJSVtL65sV7ZeeZ4AhtGkrF6kEd6f/jcmHKzAM9bTq/4deL2KCbEX+01NyAYR+M26icqYll61CWWBHdm8rrshtsgCoq0vpaaQNlMoqqaV1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFyQqIUU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFyQqIUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020561F000FF;
	Sat, 12 Sep 2026 07:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199712;
	bh=Od3fYPcgFLmXKMcPY4qZvVemv/n5eX7feGqfakfE8LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFyQqIUUb0p6DtA30h7Duo+MHXNygjHuQq0fj7tN/yIOtT6RIfaLTlqiK420hxeai
	 Jba7mexDGA2yXdSKGociZ4QwlO9/BpaHW41CNqke6UW7vo+QMC/EWQJGa4ZceqKlzb
	 Jg70uSpH0wNMylux8jZHV/E2hdBs9R+t70KTC+l4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0599/1815] wifi: ath12k: Set IEEE80211_OFFLOAD_ENCAP_4ADDR after tx_encap_type vdev param
Date: Sat, 12 Sep 2026 08:39:09 +0200
Message-ID: <20260912065702.946551679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>

[ Upstream commit be72d6aecea491ee202de81fc3a71c7ea9d34d2b ]

Currently, IEEE80211_OFFLOAD_ENCAP_4ADDR is set when
IEEE80211_OFFLOAD_ENCAP_ENABLED is present in vif->offload_flags
at the beginning of ath12k_mac_update_vif_offload().

However, if the WMI vdev set_param for tx_encap_type fails,
IEEE80211_OFFLOAD_ENCAP_ENABLED is cleared but
IEEE80211_OFFLOAD_ENCAP_4ADDR remains set, leaving the flags in
an inconsistent state.

Fix this by setting IEEE80211_OFFLOAD_ENCAP_4ADDR only after the
tx_encap_type has been configured via the WMI vdev set parameter.

Compile tested only.

Fixes: 729cad3c3c9e ("wifi: ath12k: Add 4-address mode support for eth offload")
Signed-off-by: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260701182428.906441-1-tamizh.raja@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 6ce3add492355..5329df86d5d91 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -10170,16 +10170,15 @@ static void ath12k_mac_update_vif_offload(struct ath12k_link_vif *arvif)
 	    vif->type != NL80211_IFTYPE_AP)
 		vif->offload_flags &= ~(IEEE80211_OFFLOAD_ENCAP_ENABLED |
 					IEEE80211_OFFLOAD_DECAP_ENABLED |
-					IEEE80211_OFFLOAD_ENCAP_MCAST);
+					IEEE80211_OFFLOAD_ENCAP_MCAST |
+					IEEE80211_OFFLOAD_ENCAP_4ADDR);
 
-	if (vif->offload_flags & IEEE80211_OFFLOAD_ENCAP_ENABLED) {
+	if (vif->offload_flags & IEEE80211_OFFLOAD_ENCAP_ENABLED)
 		ahvif->dp_vif.tx_encap_type = ATH12K_HW_TXRX_ETHERNET;
-		vif->offload_flags |= IEEE80211_OFFLOAD_ENCAP_4ADDR;
-	} else if (test_bit(ATH12K_FLAG_RAW_MODE, &ab->dev_flags)) {
+	else if (test_bit(ATH12K_FLAG_RAW_MODE, &ab->dev_flags))
 		ahvif->dp_vif.tx_encap_type = ATH12K_HW_TXRX_RAW;
-	} else {
+	else
 		ahvif->dp_vif.tx_encap_type = ATH12K_HW_TXRX_NATIVE_WIFI;
-	}
 
 	ret = ath12k_wmi_vdev_set_param_cmd(ar, arvif->vdev_id,
 					    param_id, ahvif->dp_vif.tx_encap_type);
@@ -10190,7 +10189,8 @@ static void ath12k_mac_update_vif_offload(struct ath12k_link_vif *arvif)
 	}
 
 	if (vif->offload_flags & IEEE80211_OFFLOAD_ENCAP_ENABLED)
-		vif->offload_flags |= IEEE80211_OFFLOAD_ENCAP_MCAST;
+		vif->offload_flags |= (IEEE80211_OFFLOAD_ENCAP_MCAST |
+				       IEEE80211_OFFLOAD_ENCAP_4ADDR);
 
 	param_id = WMI_VDEV_PARAM_RX_DECAP_TYPE;
 	if (vif->offload_flags & IEEE80211_OFFLOAD_DECAP_ENABLED)
-- 
2.53.0



