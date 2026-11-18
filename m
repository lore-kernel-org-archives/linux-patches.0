Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017369;
	b=orgJJlYcgkuvwOUvXPd74+yyTNB4HL/rEODcX8/ZFui/YoA6HGRzPLDjkCMe0kkSkWQM
	 fam4WJo6c7DYpLpVZeN7S43X7bfrhblKKFdt+4zgKt3ucRUxeaUJ1D8fAeIA4NprAmr69
	 uhvjcIZ8/nz7qiBcpCJtaJ3PD37KRCkZMJKf9o//xd23jXtMvFJ6AfYhnmMm808r90xf7
	 bkrn6q0xXmSfc3+OWKbYIRaJ003+Zplx5EVvw059MEJKNDdq4cZW566zd68Frrkzx/xXI
	 +8mMn3HpOjJz6vMl5LsWO5Paacki3uK1pZqJVkpBaQZRziNkeqcyT6/rR03b11uR1EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gQYEVBtBgQrzmPMHCo0KsTOI5mZFhljXXbKR27VNpi8=;
	b=LE78LYdrLLigd0CGgk8097Xuec1+p3BouEdJA183GIlcF3PNryXqGPo/l91bYbrIWh6x
	 UTPa/WuSj3q+yFbnpJDFCXHUXUzEYeth3YYH4TtkPbGkjlrLckomGNdhVE3rP8EhjtHKo
	 r4LV+1G36D7k6YYiTopBGbt+X02NqMS+y55L1vCU00qziHpcgXmVzrwglqblnFMDqKTj8
	 cWiV5aGHMsTSNqHjyvGzXmi8Gg1KEUzvtb+V8WgD6ze2gdpEf6x57kGlyCy/KMhc4oB7q
	 QbZZbFaRUYlys+x9UwS7HU+MMD40qpp+yUa23cKwMN1R5eR+r4b6FaSkZR/yGsRZkUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NU9W3NVs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B0D606A31C;
	Wed, 18 Nov 2026 15:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NU9W3NVs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A871F000C4;
	Wed, 18 Nov 2026 15:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017369;
	bh=gQYEVBtBgQrzmPMHCo0KsTOI5mZFhljXXbKR27VNpi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NU9W3NVs+p9vBPVJjejDXBofULVYkAioM3dtqb+PiLRCS/ClVDBV5OFHen0R3nCgJ
	 KwAyhfOPNScSUqGvbh6GdRmZi3mR4wLMWFkaWEPz1yq1xWgu9JRth8WF+OExXw2g6T
	 VzQmkMamqEyVUsziJn855PaoKETDT1XitlsEQ3F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0859/2651] wifi: ath12k: fix out-of-bounds access on TX stats arrays
Date: Wed, 18 Nov 2026 15:34:59 +0100
Message-ID: <20261118150318.787706047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
index 3f6df96de160e..4ce0948d429f8 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c
@@ -589,7 +589,8 @@ ath12k_dp_tx_process_htt_tx_complete(struct ath12k_dp *dp, void *desc,
 
 	wbm_status = le32_get_bits(status_desc->info0,
 				   HTT_TX_WBM_COMP_INFO0_STATUS);
-	dp->device_stats.fw_tx_status[wbm_status]++;
+	if (likely(wbm_status < MAX_FW_TX_STATUS))
+		dp->device_stats.fw_tx_status[wbm_status]++;
 
 	switch (wbm_status) {
 	case HAL_WBM_REL_HTT_TX_COMP_STATUS_OK:
@@ -993,11 +994,17 @@ void ath12k_wifi7_dp_tx_completion_handler(struct ath12k_dp *dp, int ring_id)
 		/* Find the HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE value */
 		buf_rel_source = le32_get_bits(tx_status->info0,
 					       HAL_WBM_RELEASE_INFO0_REL_SRC_MODULE);
-		dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		if (likely(buf_rel_source < HAL_WBM_REL_SRC_MODULE_MAX))
+			dp->device_stats.tx_wbm_rel_source[buf_rel_source]++;
+		else
+			WARN_ON_ONCE(1);
 
 		rel_status = le32_get_bits(tx_status->info0,
 					   HAL_WBM_COMPL_TX_INFO0_TQM_RELEASE_REASON);
-		dp->device_stats.tqm_rel_reason[rel_status]++;
+		if (likely(rel_status < MAX_TQM_RELEASE_REASON))
+			dp->device_stats.tqm_rel_reason[rel_status]++;
+		else
+			WARN_ON_ONCE(1);
 
 		/* Release descriptor as soon as extracting necessary info
 		 * to reduce contention
-- 
2.53.0



