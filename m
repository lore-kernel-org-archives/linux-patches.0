Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945CB3064B3;
	Wed, 28 Jan 2026 15:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615475; cv=none; b=jddrkKsnVBo55tWhAx+hHOM+KukEQfHCn6ddetisLcK7wZjMB2UivkGMNiv89cnczdkdgdgOiNN+NjCqYHkdCaCwG1Pb2MOES+eo0hjwKB7/xxviyrTHAQyEdYr709CZhVbZi+c/eAMVXCjZbr4BcN1p4MVlshTtVlaYdBdjgos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615475; c=relaxed/simple;
	bh=P9cT+ob1BKJYN7qrEVW9vUVBN/C7HG47qynnVheZugc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGTdMug+/R8McDEHpoAeUGQ5Q4BmzjZT1VJQtpfwHSmLbeNvD9CCCyiVEHZ+UVwCyqlAIJ4dc2s1Z0H80P3uf7cZJkg7XZSiDFBuIZF4oL3pymiTNNZ3CtVCDd1qQvLjxTr6sOFU6y4+D1ifkfbmCrwl6fSYC6x45XIdI04NsSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNhUGAeT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNhUGAeT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083A2C4CEF1;
	Wed, 28 Jan 2026 15:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615475;
	bh=P9cT+ob1BKJYN7qrEVW9vUVBN/C7HG47qynnVheZugc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNhUGAeT2CAbShMwQ4oRMFXyZURiHbuHV90oFpOeWqMbr2r1qi4BdkyoBG7u5SZvy
	 jQXBHV7vSWZySsMU+yLi+P/KYdSLPcwz6mAI9fr12Dx0XiKHWKIvKL73eNrRpE++sc
	 ETETikVJn1rvl9se9neNyXzvw3rG5aVkMusnSKAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingying Tang <yingying.tang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	linux-next@vger.kernel.org,
	netdev@vger.kernel.org,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/227] wifi: ath12k: Fix wrong P2P device link id issue
Date: Wed, 28 Jan 2026 16:21:05 +0100
Message-ID: <20260128145345.069879352@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingying Tang <yingying.tang@oss.qualcomm.com>

[ Upstream commit 31707572108da55a005e7fed32cc3869c16b7c16 ]

Wrong P2P device link id value of 0 was introduced in ath12k_mac_op_tx() by [1].

During the P2P negotiation process, there is only one scan vdev with link ID 15.
Currently, the device link ID is incorrectly set to 0 in ath12k_mac_op_tx()
during the P2P negotiation process, which leads to TX failures.

Set the correct P2P device link ID to 15 to fix the TX failure issue.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: 648a121bafa3 ("wifi: ath12k: ath12k_mac_op_tx(): MLO support") # [1]
Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Cc: linux-next@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: https://patch.msgid.link/20260113054636.2620035-1-yingying.tang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>

---

Note to linux-next and netdev maintainers:

This patch going through the "current" tree conflicts with
the following going through the "next" tree:
commit 631ee338f04d ("Merge branch 'ath12k-ng' into ath-next")

The conflict resolution is to leave the following file unmodified:
drivers/net/wireless/ath/ath12k/mac.

And to apply the following patch to ath12k_wifi7_mac_op_tx()
in the file drivers/net/wireless/ath/ath12k/wifi7/hw.c -705,7 +705,10

 			return;
 		}
 	} else {
-		link_id = 0;
+		if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
+			link_id = ATH12K_FIRST_SCAN_LINK;
+		else
+			link_id = 0;
 	}

 	arvif = rcu_dereference(ahvif->link[link_id]);

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index d6a44c19e2245..256ffae4d7f7d 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -8840,7 +8840,10 @@ static void ath12k_mac_op_tx(struct ieee80211_hw *hw,
 			return;
 		}
 	} else {
-		link_id = 0;
+		if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
+			link_id = ATH12K_FIRST_SCAN_LINK;
+		else
+			link_id = 0;
 	}
 
 	arvif = rcu_dereference(ahvif->link[link_id]);
-- 
2.51.0



