Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033575;
	b=3xCzrP8HLo7oBZfs7hxDgxSs3BnHSv85EymWNAclyuSHMG7PWNcTrl3j3ikTnWRRKb1t
	 a4AcfFWRQLpW+oF2lCmRUmfzbQSOffmP6MaCkHKZ3f8KpMw9eb7Z0mB+GrnYd1KFeHmLH
	 svahJG0CWPaOhC9M53z5lgiWTAxKSrXq+X63ieuUnzOLaF9KPenxHwJEylj0TIMAVrUWW
	 fSVl/qZK4AvDu+UK0WdEZDgqD4djjZUtEIC74APy78CfWXLmLOxqxbLgVkGAxRplRnZ5y
	 R0D1R5t4wt9CD7rcK3wVGeNl31cEXwna0OcQ40Z5a2ccD1DIcZ9tLwuBzCe76CfiU7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O2OwICwLT3eIs3KL6U2mSB+Zp5sP/RGacgBNY8yLonk=;
	b=hhBt0M6EVuoW615SFg5FTCfWXvxjhAyfqFWmZzKh+ROEhDgEfLHkH0Ge0VhcZw55VcZM
	 OmFqVcTWd+Uk7XXH+JF/uRKz2zh2PDBlomibTgWJZe1owH7hOIx0VpAbkI4sD0K1nkPA+
	 sGHzLNwYxt7kf8cOs4BRQ7wE8vj01FgPN9m1Tnz/Om8BncB1x0wSekoVRSYk7XWNWHLFp
	 StcDqI35grvtD341x0CG1WpONqeY2tp4X1v88LyGdL5/oOzLsvV4hMZ+rMQMZB/d75d0Y
	 Qnm3PLkDK/cowhZ4vMu4HEr1JyJFM9ZJRwek/isAmzrc6fVf5xMBiuO7pNNIImOD2Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jxIttVb5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DACF606A338;
	Wed, 18 Nov 2026 20:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jxIttVb5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE601F000C5;
	Wed, 18 Nov 2026 20:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033575;
	bh=O2OwICwLT3eIs3KL6U2mSB+Zp5sP/RGacgBNY8yLonk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxIttVb52AFahDYOIeHgcvA7ZGhf50RA2jwKo9BEEfG+cUeG+pCvKnmmH6s+SZaT1
	 Or4tAczmpiem2ba8OZQ1eohCfs3lOv9ZiImd53OqmG34LDHJoMFek00ebVBif9WiGQ
	 0Buyenad7CS7V1l9zjP+R+b37Tw0A4l+aaooUmSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0062/3318] dmaengine: dw-axi-dmac: fix __le32 on set of CH_CTL_H_LLI_VALID
Date: Wed, 18 Nov 2026 15:11:24 +0100
Message-ID: <20261118150315.842985290@linuxfoundation.org>
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
index 3152c8b52884c..1a9b9732820ba 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1082,7 +1082,7 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 				hw_desc = &desc->hw_desc[i];
 				if (hw_desc->llp == llp) {
 					axi_chan_irq_clear(chan, hw_desc->lli->status_lo);
-					hw_desc->lli->ctl_hi |= CH_CTL_H_LLI_VALID;
+					hw_desc->lli->ctl_hi |= cpu_to_le32(CH_CTL_H_LLI_VALID);
 					desc->completed_blocks = i;
 
 					if (((hw_desc->len * (i + 1)) % desc->period_len) == 0)
-- 
2.53.0



