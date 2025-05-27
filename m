Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C487139579;
	Tue, 27 May 2025 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365796; cv=none; b=uWXBjau4MXFQMQdJuQJAtz66zPeO3JKp8N9sxIaseScOzb1jkeTrbeAHK44T4C1x43iseSta4FXhiunIwaP4FcNf9Nf9+1YA3+2l9Mdjj3dLqt0Uy2AXfqEWh/pqNL55X+9X/mE9yY7aPje0GxsY2LQbX3ecl6rdtUOz1xtOIH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365796; c=relaxed/simple;
	bh=reDql2G7H9SKIM4M6/Z7MlpQvMldaM6TsVBKrTVfqRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ov23WjMIDOFfIYlxmIw9hsXRBTqKgWYPN5DV1UNUMVCKHmvhTLKjkaaLAE6yI0ox6Xr3CqgNvmK2rj6BvEZEIiy/KlOxtmXBZZqiBH6uFBhacAuQSvDuwYQ/QyMQXQJAQTG52GeWryQXUEIQdvd2EfZp+gWxtvzL6r6UZHCJFcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diO2hVAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diO2hVAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F5E2C4CEE9;
	Tue, 27 May 2025 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365795;
	bh=reDql2G7H9SKIM4M6/Z7MlpQvMldaM6TsVBKrTVfqRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diO2hVAse1Dp3vDJWMtX+B40DSkpMWCNHVAonMh76GF4uFJx/RvVsWK55sWc93sdr
	 TSX+rfH+zvWxw+ylEmLPZJLB2matS9ntlT1ZTIqTOkuWoRzk9DVX9pbRiWgVTcA8/b
	 d25JZmHeHqXhh+pOTSqvHU0F2UMubFaTKjBdv8e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 492/626] wifi: ath12k: Fix end offset bit definition in monitor ring descriptor
Date: Tue, 27 May 2025 18:26:25 +0200
Message-ID: <20250527162504.973259795@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 739f73370015e..4f745cfd7d8e7 100644
--- a/drivers/net/wireless/ath/ath12k/hal_desc.h
+++ b/drivers/net/wireless/ath/ath12k/hal_desc.h
@@ -2966,7 +2966,7 @@ struct hal_mon_buf_ring {
 
 #define HAL_MON_DEST_COOKIE_BUF_ID      GENMASK(17, 0)
 
-#define HAL_MON_DEST_INFO0_END_OFFSET		GENMASK(15, 0)
+#define HAL_MON_DEST_INFO0_END_OFFSET		GENMASK(11, 0)
 #define HAL_MON_DEST_INFO0_FLUSH_DETECTED	BIT(16)
 #define HAL_MON_DEST_INFO0_END_OF_PPDU		BIT(17)
 #define HAL_MON_DEST_INFO0_INITIATOR		BIT(18)
-- 
2.39.5



