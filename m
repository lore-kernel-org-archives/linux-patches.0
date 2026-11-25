Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622620;
	b=kJlZkWROCjLF+tEaLikbOcMm+GHciTgF2tvAlOI67KXd49q+rtAr5xtrbTwoHnBGS7E+
	 va5vFe9EMYSkWRUyab4LvS60Z9duw8dvo+p1ftW6N8rDZ4nhyp9PenpxRzMBUOqPUGIpu
	 7Td3+2b2UWM7b8NV+BqpvlTWXybaS6Ky0qHNM4/6HA+10tHLYEAm6+gGVVedh68LsjSKA
	 /ADC9uMp9lQMEfPRD3IkineIyKo74POB2eIn/9J6tS/++RirCq533h2jYivFjmsdTbIAU
	 KctcF4N5Gq0fHT6BStrDv9jCe78i6wMIbHyWWz+ZXWI9XLn5XN30aGGYmJEmC4wg6Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AnlNtP+uWh3L7cIDRc2mAC2znnN0eN9vMFGshMuiIk4=;
	b=RsZuIx1WPF3qCnWbHpQgXi+lFdF7bBIb8gZRE7eHpt1YkJZp1EHZiK0OZSP/hC7+VKpv
	 mGWj1LozduD/+cmWD6VIHv0WOS2nx8148bHgX7vwJH7DKEBdJVtusmQ4F1Op9W5StlqiX
	 UyPOh1zIklM4NsPBM0MMKHvLua5T9LIskSbTKFoX2gxpl/BYzRBKZTrhcZ7RRUEm89IM3
	 0WdCuRToBWZas6ivYfKaR2huI2Vq/XBUez2sbcbHoG4bEfjh+OV9lt8x1Mh6OlvxqajDP
	 hV/J37W734ZztBeZHNOd8EawyIvZ6/Bqly3UzaqigRbRSdK+/kNk5Fb2qo5053kSJ9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i/AXngVC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A683606A321;
	Wed, 25 Nov 2026 16:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i/AXngVC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A3F1F000D1;
	Wed, 25 Nov 2026 16:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622619;
	bh=AnlNtP+uWh3L7cIDRc2mAC2znnN0eN9vMFGshMuiIk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/AXngVCz6QWreqNHtYnFj3A3osQ8J4JGkiS/Qd3PG01mKHy1+zxxiIN+96MHhy55
	 M4yxA8H81cNfFMXR3W2o3UpfdE/IvRomiCI0NiCX3j7fcEjDbGJJCf6bbqKu7Uhw/T
	 mXVanS+fvijaSxYsITWBZB53JL1J4pJOWM/2YeZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 550/990] wifi: ath12k: fix out-of-bounds access on TX stats arrays
Date: Wed, 25 Nov 2026 15:31:57 +0100
Message-ID: <20261125143834.982031616@linuxfoundation.org>
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

From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>

[ Upstream commit c8f83d3389d1d1b318ac3bd2ae3d60c2862c90b4 ]

The fw_tx_status[], tx_wbm_rel_source[], and tqm_rel_reason[] arrays
are indexed directly by values read from hardware without bounds checks.
Values at or beyond MAX_FW_TX_STATUS, HAL_WBM_REL_SRC_MODULE_MAX, or
MAX_TQM_RELEASE_REASON respectively would write past the end of the
arrays causing memory corruption.

Add likely() bounds checks before incrementing each counter. For
tx_wbm_rel_source[] and tqm_rel_reason[], add WARN_ON_ONCE() on the
out-of-bounds else branch. For fw_tx_status[], no WARN_ON_ONCE is added
since the switch statement that follows already calls ath12k_warn() in
its default: branch for unknown values, avoiding a double-warn.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Fixes: c5c62287e690 ("wifi: ath12k: Add device dp stats support")
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260819053247.1420393-2-pardeep.kaur@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ sashal: Applied the same three bounds checks to the pre-wifi7-split dp_tx.c and used ab->device_stats instead of dp->device_stats. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_tx.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_tx.c b/drivers/net/wireless/ath/ath12k/dp_tx.c
index 92bb9fc420264..ed8c82346608b 100644
--- a/drivers/net/wireless/ath/ath12k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_tx.c
@@ -667,7 +667,8 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_base *ab, void *desc,
 
 	wbm_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	ab->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(wbm_status < MAX_FW_TX_STATUS))
+		ab->device_stats.fw_tx_status[wbm_status]++;
 
 	switch (wbm_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
@@ -1071,11 +1072,17 @@ void ath12k_dp_tx_completion_handler(struct ath12k_base *ab, int ring_id)
 		/* Find the HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE value */
 		buf_rel_source = le32_get_bits(tx_status->info0,
 					       HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE);
-		ab->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		if (likely(buf_rel_source < HAL_WBM_REL_SRC_MODULE_MAX))
+			ab->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		else
+			WARN_ON_ONCE(1);
 
 		rel_status = le32_get_bits(tx_status->info0,
 					   HAL_WBM_COMPL_TX_INFO0_TQM_RELEASE_REASON);
-		ab->device_stats.tqm_rel_reason[rel_status]++;
+		if (likely(rel_status < MAX_TQM_RELEASE_REASON))
+			ab->device_stats.tqm_rel_reason[rel_status]++;
+		else
+			WARN_ON_ONCE(1);
 
 		/* Release descriptor as soon as extracting necessary info
 		 * to reduce contention
-- 
2.53.0



