Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE45B37204A;
	Sat, 12 Sep 2026 07:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197210; cv=none; b=QwEV4JNJJ4roRtAF/5sbjZyAaniOJvYQaTWlVC6VupW0m1FzfvM590PmOvyZbTX5C5X97Vnd84vmclGHk0BRgaJH6ctNcofA/GO8UUvbcRyLHtZFr6IFjQmR81N3ZY91BB14lNVGeZ/oilhH/rXP2rcmWc8YOBTzUwQuNhoiEtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197210; c=relaxed/simple;
	bh=XZbJ1vVwUaBWbj+BwMTpzS4K4kkONaK+ruesTYQ+H1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3ak+tvuK5r2E0jHgnEdRem9AW4aQeknttI/fN6ttGWrwj4exvhrNtXnvlOgxb0godJMnNEiBAOz1KlYcLu9ZDIOf4AdFkLFMnvaMcM2SH7R9gGxuMkU0aQ6SKV4//mxNSQfp+lfSwKL4Y+Q8aRdPQB5UPgSilDrjnCPYhWCi7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6pYj1SP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6pYj1SP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24EF1F000FF;
	Sat, 12 Sep 2026 07:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197208;
	bh=ICjWc60kxa1VcY5PcpeP9w9KcxxdZgctXpc35iwX4gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6pYj1SPoTB4R/JC5s7N+guXzebWdu0/svLPO4JJnyw+NJIkd9TUxI7W9/yTbu+rO
	 d0PJnjhtalQrC2fUU+4WS9NYYon4SEbD7LBkYb6q1PJemOmvZxlWBGfBVP98D4Z1Th
	 6rPUR3JlpIbj3Rlcm9mmTB64x1/8coY6QQwEzy+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0124/1815] wifi: ath12k: fix TLV32 length mask
Date: Sat, 12 Sep 2026 08:31:14 +0200
Message-ID: <20260912065651.924781638@linuxfoundation.org>
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

From: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>

[ Upstream commit d762bbc08ca70a1985c9f9420c4bf67e0ba0e9be ]

HAL_TLV_HDR_LEN was using the wrong bitmask; fix it to cover
bits [21:10]. Also drop HAL_SRNG_TLV_HDR_{TAG,LEN} and use the
generic TLV header bit definitions for TLV32/TLV64 encode/decode
to avoid redundant macros.

Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00068-QCACOLSWPL_V1_TO_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260509025819.1641630-2-miaoqing.pan@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hal.c | 8 ++++----
 drivers/net/wireless/ath/ath12k/hal.h | 5 +----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hal.c b/drivers/net/wireless/ath/ath12k/hal.c
index a164563fff289..f03817b2fbc52 100644
--- a/drivers/net/wireless/ath/ath12k/hal.c
+++ b/drivers/net/wireless/ath/ath12k/hal.c
@@ -828,8 +828,8 @@ void *ath12k_hal_encode_tlv64_hdr(void *tlv, u64 tag, u64 len)
 {
 	struct hal_tlv_64_hdr *tlv64 = tlv;
 
-	tlv64->tl = le64_encode_bits(tag, HAL_TLV_HDR_TAG) |
-		    le64_encode_bits(len, HAL_TLV_HDR_LEN);
+	tlv64->tl = le64_encode_bits(tag, HAL_TLV_64_HDR_TAG) |
+		    le64_encode_bits(len, HAL_TLV_64_HDR_LEN);
 
 	return tlv64->value;
 }
@@ -851,7 +851,7 @@ u16 ath12k_hal_decode_tlv64_hdr(void *tlv, void **desc)
 	struct hal_tlv_64_hdr *tlv64 = tlv;
 	u16 tag;
 
-	tag = le64_get_bits(tlv64->tl, HAL_SRNG_TLV_HDR_TAG);
+	tag = le64_get_bits(tlv64->tl, HAL_TLV_64_HDR_TAG);
 	*desc = tlv64->value;
 
 	return tag;
@@ -863,7 +863,7 @@ u16 ath12k_hal_decode_tlv32_hdr(void *tlv, void **desc)
 	struct hal_tlv_hdr *tlv32 = tlv;
 	u16 tag;
 
-	tag = le32_get_bits(tlv32->tl, HAL_SRNG_TLV_HDR_TAG);
+	tag = le32_get_bits(tlv32->tl, HAL_TLV_HDR_TAG);
 	*desc = tlv32->value;
 
 	return tag;
diff --git a/drivers/net/wireless/ath/ath12k/hal.h b/drivers/net/wireless/ath/ath12k/hal.h
index 21c551d8b2481..3ee49d93e24a0 100644
--- a/drivers/net/wireless/ath/ath12k/hal.h
+++ b/drivers/net/wireless/ath/ath12k/hal.h
@@ -1444,7 +1444,7 @@ struct hal_ops {
 };
 
 #define HAL_TLV_HDR_TAG		GENMASK(9, 1)
-#define HAL_TLV_HDR_LEN		GENMASK(25, 10)
+#define HAL_TLV_HDR_LEN		GENMASK(21, 10)
 #define HAL_TLV_USR_ID		GENMASK(31, 26)
 
 #define HAL_TLV_ALIGN	4
@@ -1464,9 +1464,6 @@ struct hal_tlv_64_hdr {
 	u8 value[];
 } __packed;
 
-#define HAL_SRNG_TLV_HDR_TAG		GENMASK(9, 1)
-#define HAL_SRNG_TLV_HDR_LEN		GENMASK(25, 10)
-
 dma_addr_t ath12k_hal_srng_get_tp_addr(struct ath12k_base *ab,
 				       struct hal_srng *srng);
 dma_addr_t ath12k_hal_srng_get_hp_addr(struct ath12k_base *ab,
-- 
2.53.0



