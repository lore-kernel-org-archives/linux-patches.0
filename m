Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057061;
	b=p/v+LlFIARlOBulxA99E97v1XNsQ/x9oEWvTz9xdxsCbgPuvLbTIlK+30yGkJSQEq5/C
	 lzNmR/3s8ATFloQZEDgMKdff53RbfDZ7XsL6IQ4hF0aRITZgiv6ZEzELXCOJS9CAqhgC3
	 Dwoldn4B9+Zvftr24+n4XgoOBOF8zbaoiusCr6jWWlj6GM+4E2CC6ILTJvxq4C7G2Uvkq
	 wZRALSRoa0SIUMYXD2rehxfxQVMgziOKTNYyQLUGM5KzJhTlc5TBogk/Yyhgx8FEyK4l/
	 t+UZO1ynWWkkVbNnK5KkyA+ViZI6Hgfl8QeExsq6x1aHjnGjNQmjmWfKzix3H8mtSJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LRLEkaXAYW7F9W7r92ivyf8i4I3A6oPoiZnFDr52Akg=;
	b=0XSyjejDWa30BXISwA2iki/Pdij9iDqCCwgCcdCgCiboIs7hFgpPP7Fl1dKFn7mLl9RJ
	 NNGs9w4SN8unon7o8e8SOKXJvwT9fPZHx0vpuZjyBWj+OP7jj6VShptf9D85uHvrWU34y
	 a/FN7ut07OFWIBzNALZciuWwoulQtRJrMOooag+VOuvmdF6DkcZqA7iDZfXV9PDfuRaaU
	 80dkzyskXo+73va8nv6ZPPLUFw0N0gP5u5EcJtiF4U+NjoyGZ/viRhSC3G75ddkAmPoKt
	 mqC5pzx+nGDqvJGlyTTKFXoNkGZg7dn0RoALtM9TievnhpkNzqf8+bYhQYzv6vjK9hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmfQpdwa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAB9606A325;
	Thu, 19 Nov 2026 02:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmfQpdwa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B171F000C4;
	Thu, 19 Nov 2026 02:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057061;
	bh=LRLEkaXAYW7F9W7r92ivyf8i4I3A6oPoiZnFDr52Akg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmfQpdwajrb7cIpktFRLoYDN2plAW4xC+c2F0pLz4LheuSdSDk8apijkHW1i9LZrR
	 8Mbw27Fl4X/Yrx2TskevoaZctMrOSkIY9QI6peZdeKiJq+I+MHO9h/KJxoQ6Dn0VOQ
	 WvxR4uVXlBDYdv/58RfaoM0TW/s1OG2xYogwScR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
	Vinod Koul <vkoul@kernel.org>,
	dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 5.15 2208/2214] dmaengine: dw-axi-dmac: Fix uninitialized variable in axi_chan_block_xfer_start()
Date: Wed, 18 Nov 2026 16:04:44 +0100
Message-ID: <20261118150138.586054740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Gardner <tim.gardner@canonical.com>

commit 885633075847f475f26a29249d772cc0da85d8cd upstream.

Coverity complains of an uninitialized variable:

5. uninit_use_in_call: Using uninitialized value config.dst_per when calling axi_chan_config_write. [show details]
6. uninit_use_in_call: Using uninitialized value config.hs_sel_src when calling axi_chan_config_write. [show details]
CID 121164 (#1-3 of 3): Uninitialized scalar variable (UNINIT)
7. uninit_use_in_call: Using uninitialized value config.src_per when calling axi_chan_config_write. [show details]
418        axi_chan_config_write(chan, &config);

Fix this by initializing the structure to 0 which should at least be benign in axi_chan_config_write(). Also fix
what looks like a cut-n-paste error when initializing config.hs_sel_dst.

Fixes: 824351668a413 ("dmaengine: dw-axi-dmac: support DMAX_NUM_CHANNELS > 8")
Cc: Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Link: https://lore.kernel.org/r/20211025181656.31658-1-tim.gardner@canonical.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -375,7 +375,7 @@ static void axi_chan_block_xfer_start(st
 				      struct axi_dma_desc *first)
 {
 	u32 priority = chan->chip->dw->hdata->priority[chan->id];
-	struct axi_dma_chan_config config;
+	struct axi_dma_chan_config config = {};
 	u32 irq_mask;
 	u8 lms = 0; /* Select AXI0 master for LLI fetching */
 
@@ -393,7 +393,7 @@ static void axi_chan_block_xfer_start(st
 	config.tt_fc = DWAXIDMAC_TT_FC_MEM_TO_MEM_DMAC;
 	config.prior = priority;
 	config.hs_sel_dst = DWAXIDMAC_HS_SEL_HW;
-	config.hs_sel_dst = DWAXIDMAC_HS_SEL_HW;
+	config.hs_sel_src = DWAXIDMAC_HS_SEL_HW;
 	switch (chan->direction) {
 	case DMA_MEM_TO_DEV:
 		dw_axi_dma_set_byte_halfword(chan, true);


