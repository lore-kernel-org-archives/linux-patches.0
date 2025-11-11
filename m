Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947F32DC78C;
	Tue, 11 Nov 2025 01:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825007; cv=none; b=aDcbET8uoSlz7aEtzVwhwsFRVV3VaBdv2KvXFwCCYmvj7jgsw7dOvwBW+EkmFtNMu2hX2TtcEC4JBOHsUElKbW3lYt5tv6xdFcdf4eczH1ZC/X6lGQ65rDDvBUcogvrJHbGfnt6kLxl5R676reM3+oqrREJr3TDM0BCKuh4Nkrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825007; c=relaxed/simple;
	bh=4o71WmC4OV8HqdpG6cg+O46gO/X/mkTF28593C774QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d60DgsXEjeGCVanuFpuD7U1BfVQ4dLTl4Afzt/6nzqyCzUuGJtqh8If9q7nNx5XvqRDn0xFdRxmVUhg19f0+BBXipJWRbDqavLDA/IZQW+rl0niVsAaxNoOKmWtXXUR09LUcs1C3rk9o1VZpa8l0ZPCEcmrk9I8IXyrJrvZXTcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaQuIC82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaQuIC82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35DAAC19422;
	Tue, 11 Nov 2025 01:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825007;
	bh=4o71WmC4OV8HqdpG6cg+O46gO/X/mkTF28593C774QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaQuIC824wsogkP88/w8KsTHj8vFqTPkEl0IQqdUHM/MZ7BaRDC4q8s3OSKcLU73n
	 EzAmZM63mnfwdHcQa+7Efr0j+UF+bzYFpH3y23rZqzyCLcyVS/LYKecm2i98zCXrUC
	 m8rB9ttwC5OECelcpFugpcuD/t0oXl8GPE7fhKPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nithyanantham Paramasivam <nithyanantham.paramasivam@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 616/849] wifi: ath12k: Increase DP_REO_CMD_RING_SIZE to 256
Date: Tue, 11 Nov 2025 09:43:06 +0900
Message-ID: <20251111004551.323091879@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 7baa48b86f7ad..10093b4515882 100644
--- a/drivers/net/wireless/ath/ath12k/dp.h
+++ b/drivers/net/wireless/ath/ath12k/dp.h
@@ -184,7 +184,7 @@ struct ath12k_pdev_dp {
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



