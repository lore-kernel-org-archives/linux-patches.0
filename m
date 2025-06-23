Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5162222C2;
	Mon, 23 Jun 2025 21:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714618; cv=none; b=jppoFMR7cnRobnplX198sJiyxqY5Wa53b/oecXySLNvwzTc3TXjZx19Y3EaDBB8k4y1J2UBU7yTl7/3CClh4Gq194yAlbjHkNItXxRFIoOrklV6MfrAWrC2O8b8cgIaobiRVDVdCBFsXpOZiRMCjT+JVZow8d6hOc0SghTcGiQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714618; c=relaxed/simple;
	bh=XariNoynrmYluLPmQQHNWFNZjnNUXCrokIlZJk0oD7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpWIlzeDWROWqL94afUa8WzUG2tNQj6ABsDDPAJaP8hg4PqNzwoqixdWYB9jjnkOtW03qZeaIzJOZd3QJTEKMcKH2FxYDXF8+b0tR4dgTIE/rDvWI9VaB9UdGQEe+s1TRchKGiYKii9efqQxousfaeTR+j/+b6htQ06xjSNIJlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwYv6u0g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwYv6u0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F15BC4CEF0;
	Mon, 23 Jun 2025 21:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714617;
	bh=XariNoynrmYluLPmQQHNWFNZjnNUXCrokIlZJk0oD7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwYv6u0g/hvXzVWvTb0whRwB6/ogPvQYEQkxXMnsL0M/QALEY5+mJkYZYH4M1/JCk
	 r0VEe1gSmihe0wPB/Nbq+3icQWAKhKKmRYS+8Bz3oBlMQ7es19rTuaQmRWNPXPU3Bn
	 UKLh63XRycRASDN1OqmfQOlvvZw8qGrHn3525lc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/290] wifi: ath12k: fix macro definition HAL_RX_MSDU_PKT_LENGTH_GET
Date: Mon, 23 Jun 2025 15:06:49 +0200
Message-ID: <20250623130631.347831387@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit a69bbf89d751ba2d6da21d773c4e29c91c5e53c4 ]

Currently, HAL_RX_MSDU_PKT_LENGTH_GET uses u32_get_bits to obtain the
MSDU length from the MSDU description.

This is not right. Because all halphy descriptions are little endian.

So use le32_get_bits for HAL_RX_MSDU_PKT_LENGTH_GET.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1

Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250421023444.1778-9-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hal_desc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/hal_desc.h b/drivers/net/wireless/ath/ath12k/hal_desc.h
index 1bb840c2bef57..5fd9232ad101e 100644
--- a/drivers/net/wireless/ath/ath12k/hal_desc.h
+++ b/drivers/net/wireless/ath/ath12k/hal_desc.h
@@ -683,7 +683,7 @@ enum hal_rx_msdu_desc_reo_dest_ind {
 #define RX_MSDU_DESC_INFO0_DECAP_FORMAT		GENMASK(30, 29)
 
 #define HAL_RX_MSDU_PKT_LENGTH_GET(val)		\
-	(u32_get_bits((val), RX_MSDU_DESC_INFO0_MSDU_LENGTH))
+	(le32_get_bits((val), RX_MSDU_DESC_INFO0_MSDU_LENGTH))
 
 struct rx_msdu_desc {
 	__le32 info0;
-- 
2.39.5



