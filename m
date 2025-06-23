Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611C21FECBA;
	Mon, 23 Jun 2025 21:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715324; cv=none; b=cgX0zweiMWXhE/hDVxtGoBWghi1Wqim6GKpjI/P76kylS4dpvnOZ1QrZtgTiDK1MNn8jFh36bGHzGZu1F3WDRSm2yNVNvb+XtBXcqbshSswNUHO8DLzkSpcldRp4LrYSWjNwnyXl4xbQpJat0Yrp+nY/9Pvujd1b2XRcAIJyEB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715324; c=relaxed/simple;
	bh=Is5MoJfrJeHDJxDtF+G77dej9qKZWZ06s/LQBgcA7WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnrFjqp7e3n+gqKFHG17Ffql22lkJqrwh2OSwmpGDUEtkWQiWzCXzttw/GOboafPnJ8Enu4zjirBpJ02Cfhq9hGVh+gvOMvP4/AhrWjMm1vt63qZALDlRUz0EQh12tSXqokD4mzzSLthISAFKTPEnJmoqUosHDWsC69vvsmO3kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtwDhgLj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtwDhgLj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0A9C4CEEA;
	Mon, 23 Jun 2025 21:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715324;
	bh=Is5MoJfrJeHDJxDtF+G77dej9qKZWZ06s/LQBgcA7WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtwDhgLjTpPKcfrz7cZdAKXrWFbdPkQuqNkOe9WDTkP0nxHC2GodwiWtWzQOqBoA1
	 KnlTCLC8HseN9LBz0RwwInfryq42a1oGuyv5Qtx/snqfLGMXzp0L13XOEzgOXW/VmE
	 10j1MLESM91TfDOvcvSSodZ8cADAKmrGEXRH6Vls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balamurugan S <quic_bselvara@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/290] wifi: ath12k: fix incorrect CE addresses
Date: Mon, 23 Jun 2025 15:07:33 +0200
Message-ID: <20250623130632.635740830@linuxfoundation.org>
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

From: Balamurugan S <quic_bselvara@quicinc.com>

[ Upstream commit 60031d9c3589c7983fd1deb4a4c0bebf0929890e ]

In the current ath12k implementation, the CE addresses
CE_HOST_IE_ADDRESS and CE_HOST_IE_2_ADDRESS are incorrect. These
values were inherited from ath11k, but ath12k does not currently use
them.

However, the Ath12k AHB support relies on these addresses. Therefore,
correct the CE addresses for ath12k.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.3.1-00130-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00210-QCAHKSWPL_SILICONZ-1

Signed-off-by: Balamurugan S <quic_bselvara@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Signed-off-by: Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>
Link: https://patch.msgid.link/20250321-ath12k-ahb-v12-2-bb389ed76ae5@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/ce.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ce.h b/drivers/net/wireless/ath/ath12k/ce.h
index 857bc5f9e946a..f9547a3945e44 100644
--- a/drivers/net/wireless/ath/ath12k/ce.h
+++ b/drivers/net/wireless/ath/ath12k/ce.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: BSD-3-Clause-Clear */
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2022, 2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2021-2022, 2024-2025 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #ifndef ATH12K_CE_H
@@ -39,8 +39,8 @@
 #define PIPEDIR_INOUT_H2H	4 /* bidirectional, host to host */
 
 /* CE address/mask */
-#define CE_HOST_IE_ADDRESS	0x00A1803C
-#define CE_HOST_IE_2_ADDRESS	0x00A18040
+#define CE_HOST_IE_ADDRESS	0x75804C
+#define CE_HOST_IE_2_ADDRESS	0x758050
 #define CE_HOST_IE_3_ADDRESS	CE_HOST_IE_ADDRESS
 
 #define CE_HOST_IE_3_SHIFT	0xC
-- 
2.39.5



