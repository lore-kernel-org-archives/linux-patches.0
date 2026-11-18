Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018885;
	b=DmcDmFKmiGRU9xxWAc59lM8mS1r1PFeLnhr1AsximmbDbyjM8cmev2uITXBeqTiO21LJ
	 N3Ha77rjz/aZmQufazvpi9LVVf5O4lVY3d95c4tAl+X/3h1SkVGi54C6C5qyJYoJhBzg8
	 w/yDmbJ7WL4103PJQ2aOSmiFU1TyrlcN761PUmYDO+fx/ZFVBBWUiDBxA2LMes8Uw23am
	 OA0sJO7XgGtsKHu8OZJh/aKjs7FORNijp3GWn8Hy4uicPuS/1urYYk97UBtwI4dT2WdPl
	 otIc1Qub5pk1+pKGL15zbOVdVtOQ1RB5BG7G8tdIlgL4wz6SrtqJHPUOrUHmayej4xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=StMoou/t7csASj5/dAbGHB2KxKwB1RNCEpSPQGKfS0s=;
	b=IJ75K32WXOZaIU/cvAf4kP2Fm+4XS+Tu3gRcBfOd1BJmCtzC5oJJSsgWuMURXTJn+P0a
	 bkRjyBoZ6BrIVojCJKH1Bd2hpLeqldGNZB94iERoWaz1PBjOBkFm5eaIADbzhv7pMkaki
	 gTT0iHb/aJgWyqaX5pbsuMzPFyQqIxFc0/2WfTUqKe17nv2zRLgZo69T74roCPak80xfe
	 BdYlWVuSBHFghsW9GePEUIH1k/trFTUnuRYm6br1XAgko+Te2Cb0CFhBbUUNEqVAxKv9t
	 FhEl1h+yMRQNW5ywhiuBUU+SiHv1K0LDmbQcW3iDPZsBpQ8rLe525sjDonxMGjDpxFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rOIU/4jA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052F1606A31C;
	Wed, 18 Nov 2026 16:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rOIU/4jA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCCD1F000C4;
	Wed, 18 Nov 2026 16:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018884;
	bh=StMoou/t7csASj5/dAbGHB2KxKwB1RNCEpSPQGKfS0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rOIU/4jA9rws/7rXDl8FDtX/ITiZj27aw+08iVF19SKJTIvMj4FZ/3oLkHXv7//kx
	 Hi2cUYDplortNr2P02YctA6ai3I4v5TCEOgJPX6ROp4e5o2Umbs5HD8mHE6b+9PuJM
	 wZjJmaoeokmMSI2eU/ntON1v/9FXOVpH7yPpSWho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1348/2651] dmaengine: ste_dma40: Validate DMA specifier length
Date: Wed, 18 Nov 2026 15:43:08 +0100
Message-ID: <20261118150336.552443499@linuxfoundation.org>
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

[ Upstream commit 9f1064ebe17cf3ab65ac6eb166398e02678aea33 ]

The DMA40 binding requires three cells, but d40_xlate() reads args[0],
args[1], and args[2] without checking args_count. A malformed provider node
can specify fewer cells, leaving some of these values uninitialized when
the OF DMA core invokes the translation callback.

Reject specifiers that do not contain exactly three cells before reading
the argument array.

Fixes: fa332de5c6b3 ("dmaengine: ste_dma40: Supply full Device Tree parsing support")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-17-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 32dd63a2c27a6..479e69313e4a4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2542,6 +2542,9 @@ static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
 	dma_cap_mask_t cap;
 	u32 flags;
 
+	if (dma_spec->args_count != 3)
+		return NULL;
+
 	memset(&cfg, 0, sizeof(struct stedma40_chan_cfg));
 
 	dma_cap_zero(cap);
-- 
2.53.0



