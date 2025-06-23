Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A22C226888;
	Mon, 23 Jun 2025 22:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716747; cv=none; b=mDHp3Tr+6kzy7nN69DaBU9B0g7g1BHwgP86DjLj7mHYWpiK/fvHnTtBAu+Sw8H+LUXl+vutiqmWIhuvMgSjoI3K0ljyEFLN6GJ0oMCkMV37+Xn8TGTDptaV4m8RglhBYNdM8/JCZ321/pvye/mUzbiAgrYjlnNTu1XpOutouJ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716747; c=relaxed/simple;
	bh=ar7KltM6C/PH5/oxY7pkvLSprtr0wOYbJg8H9Jl+OwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NdfQxocoyWrBPTuzQQHpI4jPNx1CZNRWwc47bNE8DHEiQkj4n9GLNXnMyHuwtTvsTnhGxuM3j6R2MUeIOSS/+T7dbcbZAZZsPdWkQY3JCi8FVCkMX7mgj09Ep/JQVGmq0hjRkNx5FVIJp7pJSUr0+iYdUxkWl2YKQapZQGazwFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4LZWcuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4LZWcuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21081C4CEEA;
	Mon, 23 Jun 2025 22:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716747;
	bh=ar7KltM6C/PH5/oxY7pkvLSprtr0wOYbJg8H9Jl+OwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4LZWcuCLW833nUaMxdye56B8QmSRJNPQ9hnHt8J+KpGt1JINAu99mGdz0NYw2aVN
	 6bxAbhTVsgGaX5CveITo++veSHmBQSXQLSgzJPrCEm0UJ7ivxnCOqk0oOsoHi9xzJG
	 JPo85z2nEm2VOMmTFJHqq9SwxTD5sPLVZnZDto1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balamurugan S <quic_bselvara@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Raj Kumar Bhagat <quic_rajkbhag@quicinc.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/414] wifi: ath12k: fix incorrect CE addresses
Date: Mon, 23 Jun 2025 15:06:56 +0200
Message-ID: <20250623130648.995332334@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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



