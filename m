Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6931B22331C;
	Mon,  2 Jun 2025 14:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874037; cv=none; b=YJnyGx1cwhgYHbFqvTIqHmVVdskd6qH//jIcIz9eOo2U2pZtkRI4kGlJYJ4St/cB4ZiYGnqkybzYJcy+LUdremnv1DmsfwwBg6jsdkx7KQIhz4OueKM5B21lDUpWkYWvdIdb7PHdZaYVOJHXbKwynSdT7yMbKO/Uc0yzExJo53M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874037; c=relaxed/simple;
	bh=/JYOIh6B8BW9AYBY/SlC1pkFJpT5jJ+CwQIeO5TwTkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELllUCm45btn/6bs7l4hpJ+9CLyUYURBAZSjPpZ36Zwzl/roy+ckl9hIuXbNcdOYzRrPPbsQiZtibebLzlE7hx1OvDEapy9elsIUsMIH9bi5eR8largF3K9X8JDM7ju8AyxM9yFcyv4EzRpQ7yjtQm6j20J7NiC55LTH9PTc53o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBdQD4VZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBdQD4VZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0983C4CEEB;
	Mon,  2 Jun 2025 14:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874037;
	bh=/JYOIh6B8BW9AYBY/SlC1pkFJpT5jJ+CwQIeO5TwTkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBdQD4VZ4UiqcZ83IP6kVZXlhVsutBdhBHyn6pBP8sKVlZy4H9oBDnr/qNxMYpiVP
	 CnedQCb/fV78bNqWByfljG+gfxikOOYIBsHzFryAeECTITMeZNqElbKVkD+QKA0Ini
	 MU6IA+ATnaK/wT+IUcUHTEl0y1c7LN0m1vsD78RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 307/444] wifi: ath12k: Fix end offset bit definition in monitor ring descriptor
Date: Mon,  2 Jun 2025 15:46:11 +0200
Message-ID: <20250602134353.393449043@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 6788a666000d600bd8f2e9f991cad9cc805e7f01 ]

End offset for the monitor destination ring descriptor is defined as
16 bits, while the firmware definition specifies only 12 bits.
The remaining bits (bit 12 to bit 15) are reserved and may contain
junk values, leading to invalid information retrieval. Fix this issue
by updating the correct genmask values.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Link: https://patch.msgid.link/20241223060132.3506372-8-quic_ppranees@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hal_desc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/hal_desc.h b/drivers/net/wireless/ath/ath12k/hal_desc.h
index 6c17adc6d60b5..1bb840c2bef57 100644
--- a/drivers/net/wireless/ath/ath12k/hal_desc.h
+++ b/drivers/net/wireless/ath/ath12k/hal_desc.h
@@ -2918,7 +2918,7 @@ struct hal_mon_buf_ring {
 
 #define HAL_MON_DEST_COOKIE_BUF_ID      GENMASK(17, 0)
 
-#define HAL_MON_DEST_INFO0_END_OFFSET		GENMASK(15, 0)
+#define HAL_MON_DEST_INFO0_END_OFFSET		GENMASK(11, 0)
 #define HAL_MON_DEST_INFO0_FLUSH_DETECTED	BIT(16)
 #define HAL_MON_DEST_INFO0_END_OF_PPDU		BIT(17)
 #define HAL_MON_DEST_INFO0_INITIATOR		BIT(18)
-- 
2.39.5



