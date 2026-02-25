Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7C618B0A;
	Wed, 25 Feb 2026 01:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983233; cv=none; b=nza4seDHKSaIdnbdamVawgc7zMLMFhnocZbxb7f8iIy5OuCpX6LpUw8KHRjXGqDkPwIxawK3eoG4omfb8R6f7wdVNqs7Q9YWV3+j9zOiJb88eozhbnlktvsIpkVKYjYJ/AmizH4XiEFm8JxWgipCEvPjKdmwqiY+yIRwvene6U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983233; c=relaxed/simple;
	bh=OOsI3sMnTZKxZXAEW/unyUS8w5teGUeeVzINyV38gMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cn7+jKd2rEJ+ezhAUqXWBDEn7ugvJ9Os7NqS/VZUZSF79HfDh7XXVrpD3amzfRAAhZDBMF1WWmVCOntrvIcnQnRLrmL+ScRdglrvT4+llQjT6gglQpOgF1EOtVJiTVZ+/rw1YwRKxGsyiqFdanDlpwDsoWV/4Wj8UneIb2u8d9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FN7Y1Dqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FN7Y1Dqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473BDC116D0;
	Wed, 25 Feb 2026 01:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983233;
	bh=OOsI3sMnTZKxZXAEW/unyUS8w5teGUeeVzINyV38gMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FN7Y1DqjEg2ZR9mtlDW3uu3QHshaJ8CaOTXtZElS7TAksZqLdHVpaKJbq1+AM+e/Y
	 DJ09ZfWd/l4UN1GlVtisPqCA5PbSwfIG/oNBBBuqLMNKvtUlq3k+NrjCuw7MQ1KFej
	 trhkrnq7GylWyYIbHxSK6H3g8U0HUikrgf2kWy0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 376/781] wifi: ath12k: Fix index decrement when array_len is zero
Date: Tue, 24 Feb 2026 17:18:05 -0800
Message-ID: <20260225012408.914531700@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>

[ Upstream commit e4763898bb1325dbb3792961b6d607b5c6452d64 ]

Currently, print_array_to_buf_index() decrements index unconditionally.
This may lead to invalid buffer access when array_len is zero.

Fix this by decrementing index only when array_len is non-zero.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.5-01651-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3

Fixes: adf6df963c03 ("wifi: ath12k: Add support to parse requested stats_type")
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260123071253.2202644-2-aaradhana.sahu@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
index 48b010a1b7566..4f749d473d0e1 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2021-2025 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
  */
 
 #include <linux/vmalloc.h>
@@ -29,8 +29,10 @@ print_array_to_buf_index(u8 *buf, u32 offset, const char *header, u32 stats_inde
 				   " %u:%u,", stats_index++, le32_to_cpu(array[i]));
 	}
 	/* To overwrite the last trailing comma */
-	index--;
-	*(buf + offset + index) = '\0';
+	if (array_len > 0) {
+		index--;
+		*(buf + offset + index) = '\0';
+	}
 
 	if (footer) {
 		index += scnprintf(buf + offset + index,
-- 
2.51.0



