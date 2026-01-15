Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8369274B43;
	Thu, 15 Jan 2026 16:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496213; cv=none; b=HBukd79tXVY3tIpEsGVSO+veZNw9XnGOo1HFfh85Ihd95l0HlPlLfBf2Mq40woqgXC7ruJBi3UTPNFLftE+SCqmVLauUBzHcqFzKz+/FY1RyahCu3Jii9cLEESBDpprmQ7J+MCRSqSozGMc7AHDNVpQfw57h0oQJLltvehS1/+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496213; c=relaxed/simple;
	bh=D3mNTflgwJmlqoyRHvCW6b2yEhKRidRDNTfdr9UET0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxyM8oGuafD0Js6anfex5ffwQwyGJmj6iIng5IPjG5DM1KjQtnOipVyU3cUDiZUdjZK5+s0voO6zL4GhgopKsx4oBiFA3LPf+tbfkNNNGuAQugANnlT1clEuLb7vNR217HCum2MjVuDBAjB+k8y63RGv9lfPsUnrNLZlA9zK6YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9eI2RpK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9eI2RpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F923C116D0;
	Thu, 15 Jan 2026 16:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496213;
	bh=D3mNTflgwJmlqoyRHvCW6b2yEhKRidRDNTfdr9UET0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9eI2RpK8lBHtoOoawbkxyWvJVyDVEQ8FEnSZyVyetRw1dwA30U/3gRFUBuqLG1c0
	 FxoOSAM06aabMKx5zVQc9kSQdZZtu2hp5CawgnO5v/o7ByY5Dr5Yz/XJTnLFj4wMmN
	 Zyan8/QqzYDYKCqWpGV1HXxnY1OSsGUeDt/If6qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/181] net: airoha: Fix npu rx DMA definitions
Date: Thu, 15 Jan 2026 17:47:35 +0100
Message-ID: <20260115164206.574682662@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit a7fc8c641cab855824c45e5e8877e40fd528b5df ]

Fix typos in npu rx DMA descriptor definitions.

Fixes: b3ef7bdec66fb ("net: airoha: Add airoha_offload.h header")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260102-airoha-npu-dma-rx-def-fixes-v1-1-205fc6bf7d94@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soc/airoha/airoha_offload.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/soc/airoha/airoha_offload.h b/include/linux/soc/airoha/airoha_offload.h
index 6f66eb339b3fc..1a33f846afafa 100644
--- a/include/linux/soc/airoha/airoha_offload.h
+++ b/include/linux/soc/airoha/airoha_offload.h
@@ -70,12 +70,12 @@ static inline void airoha_ppe_dev_check_skb(struct airoha_ppe_dev *dev,
 #define NPU_RX1_DESC_NUM	512
 
 /* CTRL */
-#define NPU_RX_DMA_DESC_LAST_MASK	BIT(29)
-#define NPU_RX_DMA_DESC_LEN_MASK	GENMASK(28, 15)
-#define NPU_RX_DMA_DESC_CUR_LEN_MASK	GENMASK(14, 1)
+#define NPU_RX_DMA_DESC_LAST_MASK	BIT(27)
+#define NPU_RX_DMA_DESC_LEN_MASK	GENMASK(26, 14)
+#define NPU_RX_DMA_DESC_CUR_LEN_MASK	GENMASK(13, 1)
 #define NPU_RX_DMA_DESC_DONE_MASK	BIT(0)
 /* INFO */
-#define NPU_RX_DMA_PKT_COUNT_MASK	GENMASK(31, 28)
+#define NPU_RX_DMA_PKT_COUNT_MASK	GENMASK(31, 29)
 #define NPU_RX_DMA_PKT_ID_MASK		GENMASK(28, 26)
 #define NPU_RX_DMA_SRC_PORT_MASK	GENMASK(25, 21)
 #define NPU_RX_DMA_CRSN_MASK		GENMASK(20, 16)
-- 
2.51.0



