Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050995;
	b=CfJJ2q7/ndT6eEo9nydsraRNr7U0AR43S5ZeProchUGdQQnZaxZZQmh+p3nqB58g9aIi
	 GOpIqxYNrEz+fmh4PVvg3ak1EKDflt7u5K6//K2935aQTuy5bS4gdlyYwDkpfvQ23x8oD
	 A3RwG0gDMVYTSZJNiknmlER0knjsJMwdPbwJ0+cGdI/XYd+HPMXp02ciH13dOJaaxjlGC
	 lfxBruynXeelpAZ9X1h4MNu5Hrmj8sj/mCsM8fKWFAjn+U58KXVEEIKsLAMCsJHSneI92
	 2+7hxJx78XB8i7pZYgHCKUnm9xo8LiCVhEt6trN/JZC4cYTE1A9Ne94kYquymVw80zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VI4KB7f7gIzvo5mnZxGyvFzYYWsrIptVb6EDCKwN8Rs=;
	b=x+dQq3Vh6B7XxwqQMudZvhWlkTXjqNNE9E847f635uLJIfUqVz8WxTIA8nrexznRZrWp
	 KtZW0uZC9kVlH2lyEQIApr7azEZJAg9dWE/u/VNLPDDw5w2aqcmH4Y/JPiCPKyaLZguPk
	 4QHS9Wna+DEpm0EIjHQl1pBuynFBTLHRXer5NxVT/wAIwAO0xorqCbr4XVXu6tDFouJgF
	 nXaFE+G7e4DEi6Q1p39O9BV7opDgUno12gngrbzFW3zrws3o0O1FAmUxFwTX1xdU/QSaP
	 6LJQITOSalkECRbnzFXTI0sE/MznnIa5SMsnn3ne+71dhjnekF5tqGsvS7f/ub5oPPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w/gxyGsl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28664606A32C;
	Thu, 19 Nov 2026 01:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w/gxyGsl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB861F000C4;
	Thu, 19 Nov 2026 01:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050994;
	bh=VI4KB7f7gIzvo5mnZxGyvFzYYWsrIptVb6EDCKwN8Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/gxyGsl1+FOBpbC5IVIlyeV56FKChuqd2pzZcS7gw+UO8M2LYDMZCHXRAX4Ghqsz
	 m2+rn2dWbp269rwHwVnE9WDiL5jnpML/8IBazz4lifPAkQHS3eUD2enjTPFO4UiYjB
	 ARpc54m5vS0U3LzcKOiUCCy3o5ozFyv4a+zJkBzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0052/2214] dmaengine: dw-axi-dmac: fix __le32 on set of CH_CTL_H_LLI_VALID
Date: Wed, 18 Nov 2026 15:28:48 +0100
Message-ID: <20261118150012.116010624@linuxfoundation.org>
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

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 89aba9c39bdda8a973a6ffed7c9e93321edcfc16 ]

When writing the lli->ctl_hi, this is an __le32 type so the
value being orred should be convered to __le32 by cpu_to_le32.

Fixes 1deb96c0fa58a ("dmaegine: dw-axi-dmac: Support device_prep_dma_cyclic()")
--
Note, the call to axi_chan_irq_clear() is passing lli->status_lo
through which is also an __le32 but it does not seem to be set
anywhere. Is this also a bug?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://patch.msgid.link/20260617084944.705266-1-ben.dooks@codethink.co.uk
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 08777129b6f86..decfd838df3f4 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1038,7 +1038,7 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 				hw_desc = &desc->hw_desc[i];
 				if (hw_desc->llp == llp) {
 					axi_chan_irq_clear(chan, hw_desc->lli->status_lo);
-					hw_desc->lli->ctl_hi |= CH_CTL_H_LLI_VALID;
+					hw_desc->lli->ctl_hi |= cpu_to_le32(CH_CTL_H_LLI_VALID);
 					desc->completed_blocks = i;
 
 					if (((hw_desc->len * (i + 1)) % desc->period_len) == 0)
-- 
2.53.0



