Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023439;
	b=YB9ynlK9KiwSsCW/MBBANJX1HVHaa/RezutuRZBU+ytwmwPua9CTbzJ/o0hdPmSHRg8T
	 DL/pAUYqfOappRmhVlgn/Q6TMJuIA2yI/ASir7rVjLLhzpVQGPqXNwZ5HNZNAoV+03vb+
	 kUNiKBpyqQhWFdGhBCmAjn8WKVYR6Ueh5cREzO20bxM25r3qN3KKPvd58RIyfsRJmtyDB
	 rvaE2MDRSjnoCSF1bHHiCxP5mtrY+8rJi+GbWHRYd2FFYsFTrUaGjQYE5DYJvE3aqMATp
	 4YVY+gS7wH63+UNdODfKjWnYeQq3jszqZWzOlHkWLcLHX1SPT1eYs4N3yu5hJRPZmSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f+zsZq+SCOUOtV2ke+FpVmwIHTd6dgk3yFW//VSqZ3M=;
	b=x9oOAZWkNPPmtfXeTCG7VQjzUok6KlhNd8aaIc5GtD0GkcPBUM1EhoD9Ic+6MgHqT7JY
	 L4TQM3bPAqYuF/OGC+rxHW2PtxnOPnnUzXgnwB/i1pbIdwa+mgD0zKOnWq8wy29iVJ4Mt
	 IG7wzG9HNkXK3u/noJlCBCBj9DlTJQ6Tfpw0F2p0AkyyHki1NQfeX2EXZ9ZC2S/nWXxTh
	 Fw7cBWUEuvmVGjdD+DN2F22jbJjG/AHCY0HxIVkkNYOkP2TgYKXBHr/vuwhJ2esZWnS6e
	 DT3sMvm683sNWzshR26r49/uGcVKchD5QU/EUpowORIzYiLrHZ2dnSKU+UTgHwjcfRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLHD9JeW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FB4606CA5A;
	Wed, 18 Nov 2026 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PLHD9JeW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1F31F000C4;
	Wed, 18 Nov 2026 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023439;
	bh=f+zsZq+SCOUOtV2ke+FpVmwIHTd6dgk3yFW//VSqZ3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLHD9JeW56GxdsIF318coesdAcCYyPheoLM0J4I7AjvMZXDRWkFUE2CJPZt3Cfdfj
	 LcusvMWqkLlfzSwp/MfSYw6x5tvqwcXPqH3SGQM3ljBrEBll+xq/XmSFhBQ5z/+PR3
	 LwIPER+u4acru8wpcPTskCJBQIDWh/OX491LzP8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0369/2151] dmaengine: dw-axi-dmac: Fix CH_CFG2 channel priority position
Date: Wed, 18 Nov 2026 15:35:04 +0100
Message-ID: <20261118150135.533356352@linuxfoundation.org>
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

From: Jia Wang <wangjia@ultrarisc.com>

[ Upstream commit 2a9013c20c46216b92ff09e2283b5244a91c59da ]

The CH_CFG2 channel priority field occupies bits 51:47 of the 64-bit
channel configuration register, corresponding to bits 19:15 of CH_CFG2_H.

The driver currently shifts the priority value by 20, programming the
wrong bits. Use bit 15 as the field position.

Fixes: 824351668a41 ("dmaengine: dw-axi-dmac: support DMAX_NUM_CHANNELS > 8")
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260902-dma-fix-v3-3-414c6449fbcc@ultrarisc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
index d6e53f400af25..21adc030a7109 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac.h
@@ -325,7 +325,7 @@ enum {
 #define CH_CFG2_H_TT_FC_POS		0
 #define CH_CFG2_H_HS_SEL_SRC_POS	3
 #define CH_CFG2_H_HS_SEL_DST_POS	4
-#define CH_CFG2_H_PRIORITY_POS		20
+#define CH_CFG2_H_PRIORITY_POS		15
 
 /**
  * DW AXI DMA channel interrupts
-- 
2.53.0



