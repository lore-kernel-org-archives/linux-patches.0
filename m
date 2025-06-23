Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7E92AEE4;
	Mon, 23 Jun 2025 21:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715065; cv=none; b=i8QZpyjyTIXxWwBz8m0lTEPAFggzSoDsdcYGgF6foc8pOuc1byNBblErxv59TJizNC0O2F5gv0POmS1CleyLGNjp3GunklkfIznR4TIWU6tymcGKz+Z3TBOT8r4oBTUQUUdiY6bkOGaiaUPbge0ht260fmCQ4qkmSirY/Zi1fts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715065; c=relaxed/simple;
	bh=UPe+qJRMNv3TrbWMwq77WBVSQrnaFxfRofdMtqYWRS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gm5ocZ7AgHSeCHBYGk52es2Qg60PCF/qoE9LtCIOSDisaH93iKRfKuXBdCLR+/llD12M6unl3l1V3KaEh8CBA6Z2mDUDPH199AiWd8nMaU+4N1Wab9/NNcnMERXMYQZ7h6BaQxPBmB8dzRm30tokkvpGlReppG7aS3th+1yHxw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5zktDvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5zktDvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307CFC4CEEA;
	Mon, 23 Jun 2025 21:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715065;
	bh=UPe+qJRMNv3TrbWMwq77WBVSQrnaFxfRofdMtqYWRS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5zktDvoJdBWwVT2JgOJxni9WItUK8PuobJ7fcqXVaBS8KIW8BWVHzkMUUMJlYeKE
	 d0Lz9Gxs2x+MB25466PepIYux06EULc+j99a1wueZeQ1iSOMQLoD5hN2v9+Ir6L6Nl
	 XyG4i5sDv01c+8FjHqDZ6FkRqO1LGd4RquRBMa5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balamurugan S <quic_bselvara@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 422/592] wifi: ath12k: fix incorrect CE addresses
Date: Mon, 23 Jun 2025 15:06:20 +0200
Message-ID: <20250623130710.473461080@linuxfoundation.org>
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
index 1a14b9fb86b88..f85188af5de2f 100644
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



