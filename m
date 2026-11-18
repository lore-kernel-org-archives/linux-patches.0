Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025593;
	b=E15szWIw32B6uxnYqwyvN+5IzPG5o3RdypGFBlGd9zZbCEuWFv+Jy9D50H5IFJNHcyis
	 NH9gbarVeu7PLOBtcmAhi+FqcmAtm8OD5a64jJ7797jBc0Xm+zkJJ+GwYjPsN1/brNvxp
	 DsyF+WX/AiuWXwe+J9UveD6DgOZAB6qgVD9pOF/yiZ8jVAZ3a7zSC/YkkApSeiPDm9ZfK
	 aYUZ6seOJ72Jq9rqBwkxmPqZ6iqN8VgN2yY2cA5Z1bK6oyBMyQAVCOfHYEokTTVhN3KcJ
	 j3oTP6/O5o0SuTawdtZ9dCa0cOogi3mfT8o26ItxFql+GLYz28Sohvow3RtS/A34lIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ROEz87tTv5sJ5Z5C5U+CLRI5g8Bvy77oMMJeBbL/Peg=;
	b=tAj9FmkVxtN+XDZq70EdrJiQMNmO0Jt/XrCarOFb6cTgIQifaJf+5LzhigoB+QlVeuyq
	 DKsUh2jA6Z/waQPME9EE0or/tIQgzLNMI9x8dvO1xdRQHWl64sn2VRhLTYrMY/vuBvfqj
	 QyOrZeKpZUXLVwCA9RbmJ+o1ZKOj7UHqDZlZr8MCO3n0JQmaO2/9SK8xjfTTYFM6wsQc+
	 xgKeVOMQV3pae8vLXWR6uvb+HB043lod8BaP6Jo7ncjSo3vTVA21nsy58UcyPq0RR5/DM
	 bzC4gJfJFgPTuwtlSsxl+LBxTzTGWGtx83C5Hehr9dh/Rldhg49LcDarAyOxL5fgzMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GvJ0DzGL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85F1606A325;
	Wed, 18 Nov 2026 18:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GvJ0DzGL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF59C1F000C5;
	Wed, 18 Nov 2026 18:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025593;
	bh=ROEz87tTv5sJ5Z5C5U+CLRI5g8Bvy77oMMJeBbL/Peg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GvJ0DzGLVfMsOXgW1QhKDcz9qpUDRDYXrKoTiHjTSO38bOrRGeh7MIIDCk2nvoNXz
	 6f85DF9tku5tvwZvXyvCYq+8N9QEJDlzV+UXyFwAs3RMf/hsHsZ7HFzOK98fx9A1BW
	 U8inrU+hsRcWMvqslWG76tEYbnsBSaI86RB8hbSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1134/2151] dmaengine: ste_dma40: Validate fixed physical channel indexes
Date: Wed, 18 Nov 2026 15:47:49 +0100
Message-ID: <20261118150203.495899998@linuxfoundation.org>
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
index da0c85a9fabb5..6fb0d8f61261f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1785,6 +1785,14 @@ static int d40_validate_conf(struct d40_chan *d40c,
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



