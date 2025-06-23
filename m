Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B6D221FCC;
	Mon, 23 Jun 2025 21:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715346; cv=none; b=IVGPPbvNsqmQgwwil8GpbkKcMRaB7T2IzVhJVooHjYrOL6j6kXzuEnEARnNcUnIxLNeeXHUJtOJG4G6Azdb8OH8cuPaHGI5jvp5g/J6H4B1w2qcAwIqejH7xfkFp3meVy8UxZwUAwK2R0f9v+1BfaStr+Yl0QrYF5F3DRnNm1+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715346; c=relaxed/simple;
	bh=ZL5AFCgdyXwIGk4Yb8rB65FH30OnjhI+MW6uy84ZkTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sm9MT5JKUIh4/MO6eT3ZL8IhV7Xs1VfOQ6x15vX6Lt72hPsE6ylOia8rd10CPmYI9fta6en4/WSSNmMIa1ehrz4fk5m5uEmppdk4660VsTVv5yPAHd/Bq+8hXuHL26p9GTEGiPstCHVsj4/1S2HH1tPwkI0lvA06uw+TS2u1vi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKRj03yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKRj03yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30813C4CEEA;
	Mon, 23 Jun 2025 21:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715346;
	bh=ZL5AFCgdyXwIGk4Yb8rB65FH30OnjhI+MW6uy84ZkTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RKRj03yqBrgCHK1KC/M8ibJ63juktpuZRhAvNjheTEV639rPv8qE945CU0lpyUtgQ
	 HYl8HyfIgIzbxaFp2gqLVGXCPEu+CUCfvB9TXlJ6t4t3lEnO51WRbz1/hqe1+/6MlO
	 BFHXnDXLKOt94FJvV9Z5NzzB0eV32yj7OcYdkiwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/508] wifi: ath11k: fix soc_dp_stats debugfs file permission
Date: Mon, 23 Jun 2025 15:04:34 +0200
Message-ID: <20250623130650.893592925@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Johnson <quic_jjohnson@quicinc.com>

[ Upstream commit fa645e663165d69f05f95a0c3aa3b3d08f4fdeda ]

Currently the soc_dp_stats debugfs file has the following permissions:

-rw------- 1 root root 0 Mar  4 15:04 /sys/kernel/debug/ath11k/pci-0000:03:00.0/soc_dp_stats

However this file does not actually support write operations -- no .write()
method is registered. Therefore use the correct permissions when creating
the file.

After the change:

-r-------- 1 root root 0 Mar  4 15:15 /sys/kernel/debug/ath11k/pci-0000:03:00.0/soc_dp_stats

Tested-on: WCN6855 hw2.1 PCI WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.30

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240305-fix-soc_dp_stats-permission-v1-1-2ec10b42f755@quicinc.com
Stable-dep-of: 9f6e82d11bb9 ("wifi: ath11k: avoid burning CPU in ath11k_debugfs_fw_stats_request()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 5bb6fd17fdf6f..34aa04d27a1d7 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: BSD-3-Clause-Clear
 /*
  * Copyright (c) 2018-2020 The Linux Foundation. All rights reserved.
+ * Copyright (c) 2021-2024 Qualcomm Innovation Center, Inc. All rights reserved.
  */
 
 #include <linux/vmalloc.h>
@@ -979,7 +980,7 @@ int ath11k_debugfs_pdev_create(struct ath11k_base *ab)
 	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
 			    &fops_simulate_fw_crash);
 
-	debugfs_create_file("soc_dp_stats", 0600, ab->debugfs_soc, ab,
+	debugfs_create_file("soc_dp_stats", 0400, ab->debugfs_soc, ab,
 			    &fops_soc_dp_stats);
 
 	if (ab->hw_params.sram_dump.start != 0)
-- 
2.39.5



