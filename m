Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018871;
	b=bPXISY6LX0DvJYrbTFMPZDXjq6rJCClUHS41B6WLmheRIJUceEOHNFMKEVjk5wEFAVNR
	 topHMidQ41rfU3+Y0X+5Lp+RKWx21vY2tBOsULIDuSUNGiOOgBCTJnn/C0AwI4WXXgFTN
	 swGQo8FRNSE/pWNtmCXhgWxGjFl8VTvFQacX2ToKUoeik1T7JbiDn1BSFFX81R7GvA6fA
	 cDOVz+xAeJH7BGQE/r1nkMFr8HrNAhpL0PoHoE5eZlwGjiZDckV3Y489++jXUHBr+b555
	 ms6AADY9/qKPsvnyY+nzSRgNwzZahco8O7E8c6b74V+9NnLqUIAXCFZ6sG9NWcKQDRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ENeOoHUE2PebJZBW2Y3BJf13iSt2TwANH+JcqORsd0w=;
	b=xh71xq9EGy3kw/WO1PS0YVvrsZ55U2oATS02IxC0dyqkeruhaVh6IYgKH3mRTgKdvpSN
	 mZCGA7Eh4m0/S7ip9bg+yVFYkbPoh7aY8M0YDoKIrC3qEZ9buSTm/3CkOIoto1s9bgiLw
	 Q0KvYAqhMnd9LxxCgU3RpGAzNknnLC3anQloRjx22K4ydoF+KPzHJWACrHgBZ8VrOZb4h
	 Io4V6jkWuJhC17pNlBMjPOKUSXVWSSM1WoVdG7guQMNdVBX9QX8ETbrVwcni0InpjdHe0
	 oytC8Hc2/eBX96qQ9vwq4ZBdSBiIScD7/yly3jUUlxyvV1Qx+8Vi9TlTDcWbDjtC8AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6SWagvd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE2F606A320;
	Wed, 18 Nov 2026 16:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o6SWagvd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6194D1F000C5;
	Wed, 18 Nov 2026 16:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018870;
	bh=ENeOoHUE2PebJZBW2Y3BJf13iSt2TwANH+JcqORsd0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o6SWagvd6GRxm3Yu9jT6vzsmCgfykz4Bt2lWCRrw+fhjaOxa26xxvze8DhJFRHuPr
	 RaQ3SGm0K1K+9NW+goshWxTgd0duWzUkVA4CegQQKStpsFUSVk7Vhr+rifppgq66Nj
	 N1GrwCEodRALK2RiFmfYKHzjbyEPoPDfRFx0hEa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1353/2651] dmaengine: ste_dma40: Validate fixed physical channel indexes
Date: Wed, 18 Nov 2026 15:43:13 +0100
Message-ID: <20261118150336.734241350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index a5471a9157cd4..57868e5cd63e3 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1916,6 +1916,14 @@ static int d40_validate_conf(struct d40_chan *d40c,
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



