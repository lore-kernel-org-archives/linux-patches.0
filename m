Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1923A26D4C1;
	Tue, 11 Nov 2025 01:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824210; cv=none; b=O8+6MQVOSpQF6MLWKx420QpiU8F39LCr4nn2b/WBATgp3lOyMK+/CwwAl89hc56VzoKRstkopwtlBHlM+kgqFJ3/y9pqWwKiukPvORHRbaPwrXqZA3ZtfEmHaUP2w5QO8Zu1yUKe3KveVWBK9nIYL60sQl8mDgxi443/2nRFtXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824210; c=relaxed/simple;
	bh=sDOAACzSP3M3wuC2kIFefoPeo+vuPvL7bxEzMsPCkrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgnOn+prvjOBZ7vHnTotShb7eA+QjC4Uh5ed3xOYThD39fSnrFB5d2v0Zk+sY2G6WoCXBPlmSzLtH6AeyeRCBdrDTYBtrRZkh2gSUA95JntrYrAU1LYkOaXvq7bM8Es4K0WGH3vihWjoa+ju3r2w7rzZonNq8WMC0jeAyjoYGeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5sMGTLt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5sMGTLt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85322C19424;
	Tue, 11 Nov 2025 01:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824209;
	bh=sDOAACzSP3M3wuC2kIFefoPeo+vuPvL7bxEzMsPCkrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5sMGTLt72CvQQRu5uzqN5WU5ZZhuvCPHfqkgnXEcy0vk3EXWv9Xq6Z6SmX1dZFja
	 Z3REz7pcFdds3/zEG2eQqRubsx3NjxV5HkXUiDc7AMSc2onZAWKcVpUUuNziiLejOG
	 ULZB/eWA/l9s3bR7Vbo+4q3nCIJkszr3Hwjxbq90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 411/565] wifi: ath12k: Increase DP_REO_CMD_RING_SIZE to 256
Date: Tue, 11 Nov 2025 09:44:27 +0900
Message-ID: <20251111004536.114750271@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>

[ Upstream commit 82993345aef6987a916337ebd2fca3ff4a6250a7 ]

Increase DP_REO_CMD_RING_SIZE from 128 to 256 to avoid
queuing failures observed during stress test scenarios.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.3.1-00173-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250806111750.3214584-2-nithyanantham.paramasivam@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp.h b/drivers/net/wireless/ath/ath12k/dp.h
index 2fb18b83b3eec..ec140052097e9 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -167,7 +167,7 @@ struct ath12k_pdev_dp {
 #define DP_REO_REINJECT_RING_SIZE	32
 #define DP_RX_RELEASE_RING_SIZE		1024
 #define DP_REO_EXCEPTION_RING_SIZE	128
-#define DP_REO_CMD_RING_SIZE		128
+#define DP_REO_CMD_RING_SIZE		256
 #define DP_REO_STATUS_RING_SIZE		2048
 #define DP_RXDMA_BUF_RING_SIZE		4096
 #define DP_RX_MAC_BUF_RING_SIZE		2048
-- 
2.51.0



