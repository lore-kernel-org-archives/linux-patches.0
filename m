Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D061C68C;
	Sun,  1 Sep 2024 16:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208841; cv=none; b=Ux0IRQ3gkAKZUfgGDVhJrEr494uj+SKS0ZcveWTLTWJoR5ijD4zJ4K8Az2zYcMUlnEExi2wuLOddlZQ6F8mzMb6ToHAe0DN6pbYg/erxCR8xomDDwSzivSg6UKpeKwbwtpjxBzgpJCnDMb6N92GlDDl9cfEMClIQxPRy1bYVhR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208841; c=relaxed/simple;
	bh=Xm4S1pQfHqY3pQDVfqUs7Lsb6+GwcfOpbcOKHAiS8rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmkr90ivw+F5/+5urP981Vy+KbLwVgRiKnTuk7IlWYpT+vcJABlfSi5A3SfzPyOUsRMM65jDuREUjt+DqKaXrFU0DU8zyXzBKdkQHngOQSvKQ14k5igNvlXQBeLQE+2LeFbCSs4GDXF5FbeHiBytdL0IenDp6YU9tmlgSTPTRkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSC9co5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSC9co5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A276DC4CEC3;
	Sun,  1 Sep 2024 16:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208841;
	bh=Xm4S1pQfHqY3pQDVfqUs7Lsb6+GwcfOpbcOKHAiS8rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSC9co5kIX0jPetcXvv61WB+RNhlXHA+hbu6QLftPcXML2cn1rv9umGLflifJ0TxT
	 0NlejfMpYYLnJP9a6Z2j0GxDievAzlEhHYPmKl71XDGKiXk7FeplFabl64/+P4IFHN
	 ZmSUsB0KsamDsf7DwSlayLq46QnujhXeNNddX3SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/134] net: axienet: Drop MDIO interrupt registers from ethtools dump
Date: Sun,  1 Sep 2024 18:16:09 +0200
Message-ID: <20240901160810.981665149@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit c30cb8f0bec69d56e1fbc7fb65bd735c729a69e4 ]

Newer revisions of the IP don't have these registers. Since we don't
really use them, just drop them from the ethtools dump.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9ff2f816e2aa ("net: axienet: Fix register defines comment description")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/xilinx_axienet.h      | 7 -------
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ----
 2 files changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h b/drivers/net/ethernet/xilinx/xilinx_axienet.h
index 04e51af32178c..fb7450ca5c532 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
@@ -165,13 +165,6 @@
 #define XAE_MDIO_MCR_OFFSET	0x00000504 /* MII Management Control */
 #define XAE_MDIO_MWD_OFFSET	0x00000508 /* MII Management Write Data */
 #define XAE_MDIO_MRD_OFFSET	0x0000050C /* MII Management Read Data */
-#define XAE_MDIO_MIS_OFFSET	0x00000600 /* MII Management Interrupt Status */
-/* MII Mgmt Interrupt Pending register offset */
-#define XAE_MDIO_MIP_OFFSET	0x00000620
-/* MII Management Interrupt Enable register offset */
-#define XAE_MDIO_MIE_OFFSET	0x00000640
-/* MII Management Interrupt Clear register offset. */
-#define XAE_MDIO_MIC_OFFSET	0x00000660
 #define XAE_UAW0_OFFSET		0x00000700 /* Unicast address word 0 */
 #define XAE_UAW1_OFFSET		0x00000704 /* Unicast address word 1 */
 #define XAE_FMI_OFFSET		0x00000708 /* Filter Mask Index */
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 88bb3b0663ae4..76f719c28355c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1259,10 +1259,6 @@ static void axienet_ethtools_get_regs(struct net_device *ndev,
 	data[20] = axienet_ior(lp, XAE_MDIO_MCR_OFFSET);
 	data[21] = axienet_ior(lp, XAE_MDIO_MWD_OFFSET);
 	data[22] = axienet_ior(lp, XAE_MDIO_MRD_OFFSET);
-	data[23] = axienet_ior(lp, XAE_MDIO_MIS_OFFSET);
-	data[24] = axienet_ior(lp, XAE_MDIO_MIP_OFFSET);
-	data[25] = axienet_ior(lp, XAE_MDIO_MIE_OFFSET);
-	data[26] = axienet_ior(lp, XAE_MDIO_MIC_OFFSET);
 	data[27] = axienet_ior(lp, XAE_UAW0_OFFSET);
 	data[28] = axienet_ior(lp, XAE_UAW1_OFFSET);
 	data[29] = axienet_ior(lp, XAE_FMI_OFFSET);
-- 
2.43.0



