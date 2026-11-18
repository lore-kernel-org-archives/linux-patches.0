Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049216;
	b=IbxLj+3gfG7L5DtWY8uSSw34fexWQPx5dI3loriBEYPU75XwSevbuDUxnsnTgf66XoI0
	 jmHJhFemlZbLl/3Su3wLGJgqFwLwSEIwZfT7rs4wN8MYkdsb2bXkz8tGLWiwZYKk1iRJX
	 sqSP4OmPyNAhOOJxa309fn2ovrUgFkfD+4q3IF4Bb7FtCkDu3EuvlPrfYTYjkdstAZnBE
	 HfhVBR9tw34V1m4hAKTzBzILRKjo/rcpWjimX7tuROF7yIsiORZV33DvOnsvcnJz9Gusz
	 uLhAvcNgR8AXmP8G3iz8GvbOf2OOMZYKsvfCZR/vkuz39WTa7mlFSyH4XgCDgxkFCpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SOc77bqSrTyJaEkBIiWTpHf1MHjIxRHJYYw3J2WVnLc=;
	b=WAHMt0N9V5pMI8/e7w8VmK923B0irqp/osZZS2jWP+s0bJIY5ztM+oV8tzGJaDQQDxkx
	 fYftXJSwC1fT3l1ucrTRA+4b1KpVDJgjNR1BdytUlfbzqsclUt5qdFf49TttDdbgVKdop
	 74Lr0IrNdM6hvVJpk6RHjTmru4OOzKsh4mY3ayZGwuVmrlY2FeMrekwnJl9ojZmuT7yBs
	 ZTkQ2kOniVfzHNct6Dpc+xAdIVFlZrULjXhO3P0KJUV3/NdjSE98cGzEav7vNVtDoLIlv
	 UVmsFNhVfM1RX8JVUz1QkS9hI7W+P6JT5ednqqmFzq3OD56FSf8YqhlYnFGLvpgiaHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOHBtxtl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F91606A320;
	Thu, 19 Nov 2026 00:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JOHBtxtl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF79A1F000C4;
	Thu, 19 Nov 2026 00:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049216;
	bh=SOc77bqSrTyJaEkBIiWTpHf1MHjIxRHJYYw3J2WVnLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOHBtxtlUqdoeeNOIH12n5HJ25388DLVxlmCl8D9AZ7q2aira4oYrSVQvYWkPOYF+
	 ufr1pf7iWjGiZN0FplKgA4D20MB2kYZ3vfD3FQOqwiERhDebIhkhmQCyl6Bq3zgf/q
	 RdD/hBDzbNmRNSuag1H3I4uaF502ykJRNUJEzw9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2270/2857] dmaengine: ste_dma40: Validate fixed physical channel indexes
Date: Wed, 18 Nov 2026 15:55:04 +0100
Message-ID: <20261118150323.184900870@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 884e01160bc727509b4fdf04e763a86b936df464 ]

Fixed physical memcpy allocation uses dma_cfg.phy_channel directly as an
index into phy_res when use_fixed_channel is set. d40_validate_conf()
validates dev_type but not the fixed physical channel, allowing an invalid
configuration to access memory outside the array.

Validate the fixed physical channel centrally before accepting the channel
configuration.

Fixes: f000df8c5a0e ("dmaengine: ste_dma40: support fixed physical channel allocation")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225008.5F9651F000E9@smtp.kernel.org/
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-23-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index adea958581079..6f0a918e65812 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1787,6 +1787,14 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		res = -EINVAL;
 	}
 
+	if (conf->use_fixed_channel &&
+	    (conf->phy_channel < 0 ||
+	     conf->phy_channel >= d40c->base->num_phy_chans)) {
+		chan_err(d40c, "Invalid physical channel (%d)\n",
+			 conf->phy_channel);
+		res = -EINVAL;
+	}
+
 	if (conf->dir == DMA_DEV_TO_DEV) {
 		/*
 		 * DMAC HW supports it. Will be added to this driver,
-- 
2.53.0



