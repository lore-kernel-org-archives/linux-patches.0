Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5780934B68F;
	Fri, 21 Nov 2025 13:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732857; cv=none; b=YvNNNnqfH88PHtT75NntzKyeqZox+Z3xEQdGh322qThSzKpbEs3YcNrJihZNEpQz592P4r5oPfhetiT6lgiyFOKpG2k0F0hbXIfpe0qwc1FHgH7PEwiajfGc03wlUfND36BSpnPQN0Wr4LcDGGT7VQXCk1HQVVWQz/x81bcusr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732857; c=relaxed/simple;
	bh=vtGa2ttcxqSu7Yfr4jIfOEAg2CcLwOxvDUg2/GSN/7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld4q7dbO8C11+yw1kXrd9fAy9Q3VncAFgq8l/IfI+imwN62V4JCkMNDGJ7PteV2s6fBUympu8sLLaXYRdHpvyCwjUXZyqiJ88MkUtQ54xMm/eDOGDmjT4D0U26MpoymbnAa6qUuXElixGkiJom/qaU///Ik4nfZ2HjCgk/BinnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8bPN409; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8bPN409"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9E7C4CEF1;
	Fri, 21 Nov 2025 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732857;
	bh=vtGa2ttcxqSu7Yfr4jIfOEAg2CcLwOxvDUg2/GSN/7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8bPN4092fPATXsZnZQXnfcqiEZ3FvJT4/dbwTtQ9hTWK5mfm4zZOGBXKlj0Xg6go
	 O8JhTVD7GfidTP8HJpBi3wNW6PUI2KpbiVYtEoimT2dpaWQ0kF332P8ixr0S2cperU
	 prXi1LVqHJRLkFVaZdLKuXsZc67hgTob6WCCumDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 267/529] wifi: ath12k: Increase DP_REO_CMD_RING_SIZE to 256
Date: Fri, 21 Nov 2025 14:09:26 +0100
Message-ID: <20251121130240.522947125@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 61f765432516b..284032db0b98d 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -162,7 +162,7 @@ struct ath12k_pdev_dp {
 #define DP_REO_REINJECT_RING_SIZE	32
 #define DP_RX_RELEASE_RING_SIZE		1024
 #define DP_REO_EXCEPTION_RING_SIZE	128
-#define DP_REO_CMD_RING_SIZE		128
+#define DP_REO_CMD_RING_SIZE		256
 #define DP_REO_STATUS_RING_SIZE		2048
 #define DP_RXDMA_BUF_RING_SIZE		4096
 #define DP_RXDMA_REFILL_RING_SIZE	2048
-- 
2.51.0



