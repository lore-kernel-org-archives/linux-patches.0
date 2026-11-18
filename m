Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039532;
	b=fLaexzYmy5PvpwDSCVutQQtAsgAbbHKOFgj2y+Ibq8KEPeAe+HiPiLvrAhxBREgd+FoV
	 PO/sQ/GVZo7bCTvENp4l4IQxwP0pPd0mmH8jIXPj2I3YeCoAClyxlJ2LEChhTn5LBnRON
	 d794Q5LcaANldKK1T7r9LGladwnaX8+NfHfp5xm7Mc8A68QkTvXjC4GtXTql8+YiCauk0
	 S+SvaEuyfGVvLd6R6853hRn9MveKkbYWvAAPgRyKseX03eTdOazAL/+/p02jveaflpk6V
	 Wwa3Jeo9r7q0PLS9oVsTNVIuCAMzILvqNLZpaibMSDqvC5DLFiqCCTsaP9vJfGXY11Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vbXf+MCbI5d0xvWz01gocnaDs8qymbermg9/KmOLXcA=;
	b=Kpct5XmoUKkjxpFgD1DYnuehS0YNZ7da9QPpWOugOeJTlMdI82ckyZpcFRgx3McRkZQ8
	 TmgIdaqSRUbHh3ZMpx636GL67IpmdoZ5Z6SywN5zrfnT768o1YqoGjrPCIq1dmv2ag80u
	 EhTtkk7L2VgSw06Rm1uA1BEkqjJh450SuTNR3WGPoDFUsJPAYx9SzsY/t+yWwqrdZqNv6
	 b8VSpEUQqfVrzgIsp+r/svEORNeCBUYAlYnb0imrADJL1BQayPE8llv8jz6xNc8B+1sCB
	 m/BbnmI38vUQ/IJEUpy4mNkJR8whv+teobVCdCf/KV38A5R/0wgorZE50ZB+ytAfnLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIeBOFtQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05C4606A32F;
	Wed, 18 Nov 2026 22:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIeBOFtQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246AF1F000C5;
	Wed, 18 Nov 2026 22:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039532;
	bh=vbXf+MCbI5d0xvWz01gocnaDs8qymbermg9/KmOLXcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LIeBOFtQuRUe4l5LjbaOGlIHWKJhU28gWTDuvXeUoHFplU9A/jgcMsj4pE5vJFeCb
	 Z+SN4u7u7JG/4BHTYLH/+V59VhcecdkZUznBuhPrFJtBoBgaw6cZOXwAoF6KOwlH9a
	 hmZqoYZz/SMSS+txThUvqSIeqUlgtYP/2HhDmdFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Srinivas Neeli <srinivas.neeli@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2097/3318] dmaengine: xilinx_dma: Fix MCDMA descriptor fields based on DMA direction
Date: Wed, 18 Nov 2026 15:45:19 +0100
Message-ID: <20261118150424.999489440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Neeli <srinivas.neeli@amd.com>

[ Upstream commit b70ab341088b2114dcbc7be868588f3e97893e6a ]

The MCDMA BD format differs between memory-to-device (MM2S) and
device-to-memory (S2MM) directions, but the driver was using generic
'status' and 'sideband_status' fields for both. This led to incorrect
residue calculations when the hardware updates direction-specific fields.

Refactor the descriptor structure to use unions with direction-specific
field mappings, and update the residue calculation logic to select the
correct status field based on DMA direction.

This matches the hardware descriptor layout and fixes incorrect
residue reporting.

Fixes: 6ccd692bfb7f ("dmaengine: xilinx_dma: Add Xilinx AXI MCDMA Engine driver support")
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Srinivas Neeli <srinivas.neeli@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260818174151.1608971-2-srinivas.neeli@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index ee15da19515a0..02bb2d8b7cda2 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -220,6 +220,7 @@
 #define XILINX_MCDMA_IRQ_ERR_MASK		BIT(7)
 #define XILINX_MCDMA_BD_EOP			BIT(30)
 #define XILINX_MCDMA_BD_SOP			BIT(31)
+#define XILINX_MCDMA_BD_HW_SIZE			64
 
 /**
  * struct xilinx_vdma_desc_hw - Hardware Descriptor
@@ -274,8 +275,10 @@ struct xilinx_axidma_desc_hw {
  * @buf_addr_msb: MSB of Buffer address @0x0C
  * @rsvd: Reserved field @0x10
  * @control: Control Information field @0x14
- * @status: Status field @0x18
- * @sideband_status: Status of sideband signals @0x1C
+ * @mm2s_ctrl_sideband: Sideband control info for mm2s @0x18
+ * @s2mm_status: Status field for s2mm @0x18
+ * @mm2s_status: Status field for mm2s @0x1C
+ * @s2mm_sideband_status: Sideband status for s2mm @0x1C
  * @app: APP Fields @0x20 - 0x30
  */
 struct xilinx_aximcdma_desc_hw {
@@ -285,10 +288,17 @@ struct xilinx_aximcdma_desc_hw {
 	u32 buf_addr_msb;
 	u32 rsvd;
 	u32 control;
-	u32 status;
-	u32 sideband_status;
+	union {
+		u32 mm2s_ctrl_sideband;
+		u32 s2mm_status;
+	};
+	union {
+		u32 mm2s_status;
+		u32 s2mm_sideband_status;
+	};
 	u32 app[XILINX_DMA_NUM_APP_WORDS];
 } __aligned(64);
+static_assert(sizeof(struct xilinx_aximcdma_desc_hw) == XILINX_MCDMA_BD_HW_SIZE);
 
 /**
  * struct xilinx_cdma_desc_hw - Hardware Descriptor
@@ -1022,9 +1032,11 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_chan *chan,
 					   struct xilinx_aximcdma_tx_segment,
 					   node);
 			aximcdma_hw = &aximcdma_seg->hw;
-			residue +=
-				(aximcdma_hw->control & chan->xdev->max_buffer_len) -
-				(aximcdma_hw->status & chan->xdev->max_buffer_len);
+			residue += aximcdma_hw->control & chan->xdev->max_buffer_len;
+			if (chan->direction == DMA_DEV_TO_MEM)
+				residue -= aximcdma_hw->s2mm_status & chan->xdev->max_buffer_len;
+			else
+				residue -= aximcdma_hw->mm2s_status & chan->xdev->max_buffer_len;
 		}
 	}
 
-- 
2.53.0



