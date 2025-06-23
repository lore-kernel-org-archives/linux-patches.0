Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95EB7482;
	Mon, 23 Jun 2025 21:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713645; cv=none; b=uJLLhmxoecCD/bjf5pgEcoiosnEq3oQepWny8fuwpM5kb2wh7wdQLHfbpq+1ttxnBK2/1La+gYIUdtLacGF6EfHUF4Nz16SaoUbL+jyX1lsqCrkN9CE7tyVngs++EmIz7xCG4JAwkQpyXbF4qFAvjM0hGAs6Zb62KZf8AGFodsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713645; c=relaxed/simple;
	bh=0/XhOuyWdAagkMygfXSRDbV9L1+aWbb2pGnZbPVSCwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JU6atsIzFRBsMpxNoYlxpVp2vOiYX4QTcI3Eoc5IgSxiOLekA9ZI3Jlz7+oEWaL4FDSyQnG9NW6+IRCaEq9HciE5N8Bqcir5GayZcf0aen46CqXIbdEsP/CirOqgdiz8R7G/w5XK1POzNbBJ4R7H+W4fXlqGioa7QBnRakS9nUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bubAicHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bubAicHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72425C4CEEA;
	Mon, 23 Jun 2025 21:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713645;
	bh=0/XhOuyWdAagkMygfXSRDbV9L1+aWbb2pGnZbPVSCwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bubAicHrLyWM1kKbFRmZtE7MkbLAsQHdSgcDHUhs2kRHjKXkB0BVXv+XfUTvAfN7w
	 sCEzxIK5KehWt8T3eJLWrtUxHFPrcJxtLcmoTdXgYLMAt8xikuM0FCpObhuVYVipfk
	 xXkNF/8DenLwzfev9DMynE2xaR9T+4VnVk5VEB+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 339/592] wifi: ath12k: fix macro definition HAL_RX_MSDU_PKT_LENGTH_GET
Date: Mon, 23 Jun 2025 15:04:57 +0200
Message-ID: <20250623130708.516821258@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 63d279fab3224..f8a51aa0217a8 100644
--- a/drivers/net/wireless/ath/ath12k/hal_desc.h
+++ b/drivers/net/wireless/ath/ath12k/hal_desc.h
@@ -707,7 +707,7 @@ enum hal_rx_msdu_desc_reo_dest_ind {
 #define RX_MSDU_DESC_INFO0_DECAP_FORMAT		GENMASK(30, 29)
 
 #define HAL_RX_MSDU_PKT_LENGTH_GET(val)		\
-	(u32_get_bits((val), RX_MSDU_DESC_INFO0_MSDU_LENGTH))
+	(le32_get_bits((val), RX_MSDU_DESC_INFO0_MSDU_LENGTH))
 
 struct rx_msdu_desc {
 	__le32 info0;
-- 
2.39.5



