Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634BC1EB9E9;
	Tue, 15 Oct 2024 11:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993119; cv=none; b=rJd0wso5ppyHe3rZi+psey+8GP5B5u6wO4gN3mTwoD2PAMcrWYzBAr/Ng8ZDu7ADfQcNetKKFoLYFhEVmGMSFkHQfTrjP/t4bhYuciAllNt8avBXTdZRHcahYxrmd60AiOKDkkVvP8tphqPFFp9th57HdLj1XeFxB5B2WxRoqDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993119; c=relaxed/simple;
	bh=W7bxDe8cPFaamWPnvihJb4ILMQ5aJRCwf2r9fratBLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc9ykIar6OD42X5+VnAEIZ8tanxoLOaWv+6XA/VQuWJUn2f10d98JZ1FngLkikmnvp6sZpRqOarxsXizQXSDkV4yNA2D/ujtK3nZz5mSAc4QDRsexG7vjeI3f0awwCFOZyQJHunfglTaqsGmzWIhbnoS/VbgzXdPNh5sCKiVShY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpKCtZPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpKCtZPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5E5C4CECE;
	Tue, 15 Oct 2024 11:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993119;
	bh=W7bxDe8cPFaamWPnvihJb4ILMQ5aJRCwf2r9fratBLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpKCtZPE3QqnO1ANAVarpS004PVf1x0OcHwwHG+AFEmmoSnysyK0Tlvlh6kHRkrb7
	 CLmKm85zwJTNoBbMLGZsUIA8ue5NZjwX0o0XhKKvrK+wjtadFLT7lqcODaOpgvmFt8
	 HoG4bxI00xybmFYWXwzRT4CFDIGbc70xKpr1paDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Hancock <robert.hancock@calian.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/691] net: axienet: reduce default RX interrupt threshold to 1
Date: Tue, 15 Oct 2024 13:23:53 +0200
Message-ID: <20241015112451.658639603@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Hancock <robert.hancock@calian.com>

[ Upstream commit 40da5d680e02ca8d61237192db4b5833d3c9639f ]

Now that NAPI has been implemented, the hardware interrupt mitigation
mechanism is not needed to avoid excessive interrupt load in most cases.
Reduce the default RX interrupt threshold to 1 to reduce introduced
latency. This can be increased with ethtool if desired if some applications
still want to reduce interrupts.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5a6caa2cfabb ("net: xilinx: axienet: Fix packet counting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index e8a210201f744..d2c17def082b4 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -122,7 +122,7 @@
 /* Default TX/RX Threshold and waitbound values for SGDMA mode */
 #define XAXIDMA_DFT_TX_THRESHOLD	24
 #define XAXIDMA_DFT_TX_WAITBOUND	254
-#define XAXIDMA_DFT_RX_THRESHOLD	24
+#define XAXIDMA_DFT_RX_THRESHOLD	1
 #define XAXIDMA_DFT_RX_WAITBOUND	254
 
 #define XAXIDMA_BD_CTRL_TXSOF_MASK	0x08000000 /* First tx packet */
-- 
2.43.0



