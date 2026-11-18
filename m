Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023245;
	b=2mNX04tCMbETrTFbZL8e8ekh7PhRold8kplK8bSA3y0A9cgPYJjgmbkfaR63XF9rAFkA
	 yDiN2p7A6D7dLwxQqsEtsN+wH63oGPGkn11Kn2Bo1BHg6Z3fp6m/lqehS532SqbVajBqu
	 +VAVPqgkjxHRVZLaWm90u0VYRPonrH0ECEZsrby1xbXGF7l9c9R9H2EtcZ3J9bwhnHYbQ
	 Dvyq0rePjay/23z2ZpRPwJqaQL6Y0jZxriYCnMEOxqt4IMnLkTo64J+4BAthGous8sQbu
	 ySUDQxXwNOar40J89skHFF7zoRcpqPHy1Xj7crACvjFcviJEC94PzV/Y4PVadH0YMAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5XHMptjgZpzTX8zhr37r6AtlNLpir6rfmRPhfRrUEyw=;
	b=HSQp4VRT4GncYNvDAu3ZwnK5usmaP/JzuQDshkwZ0c+B7HzS9SyCshMujR3p+Pfd7Pkn
	 YzTf3ezDG8r5ypNEgzsJdqmDG9ok4yvEkQ5dvqVgqhy3l/fiQJzGXwyD6fdr7G4vruBtV
	 /crwM7B7dSED29KRbflEl7ae7DFMAY8OAmlguueOmW02/7+lFctSv4dtu43mEJKQzo5I5
	 iNWVyAA1syz8AvnQwfgQlua2qJG3DCYW7guGb0K4aqtdy2RsynMwBurIFyBf77EAG8wzT
	 GAATm3BBpomrcYQkCr4ZR8bXNyqXXBOJ7jl4+14IZcaLE704sj7LcGcJVDZrvPZzAcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uw83vB9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2EFD606A32A;
	Wed, 18 Nov 2026 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uw83vB9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E171F000C4;
	Wed, 18 Nov 2026 17:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023245;
	bh=5XHMptjgZpzTX8zhr37r6AtlNLpir6rfmRPhfRrUEyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uw83vB9G26aITkMZRuFU8jEVqzsomX6eB5FiDJGUOZ/R3TQhKQx8Ggh+5pc7f4vDS
	 cajbvhhg31iNYmIM/hOiBCLqVmilGYMP5ZKLw7dZQcJBNc0KyrG+RyiPlwxZFxKyOd
	 eBRQ0p3TafmBWyrqwkQ0jVSMv1xNRAqhuPCEFkiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Srinivas Neeli <srinivas.neeli@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0302/2151] dmaengine: xilinx_dma: Fix MCDMA descriptor fields based on DMA direction
Date: Wed, 18 Nov 2026 15:33:57 +0100
Message-ID: <20261118150132.917077390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 94d2e5398dd69..20dc3f4a15c9a 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -223,6 +223,7 @@
 #define XILINX_MCDMA_IRQ_ERR_MASK		BIT(7)
 #define XILINX_MCDMA_BD_EOP			BIT(30)
 #define XILINX_MCDMA_BD_SOP			BIT(31)
+#define XILINX_MCDMA_BD_HW_SIZE			64
 
 /**
  * struct xilinx_vdma_desc_hw - Hardware Descriptor
@@ -277,8 +278,10 @@ struct xilinx_axidma_desc_hw {
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
@@ -288,10 +291,17 @@ struct xilinx_aximcdma_desc_hw {
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
@@ -1025,9 +1035,11 @@ static u32 xilinx_dma_get_residue(struct xilinx_dma_chan *chan,
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



