Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042992;
	b=SPfF3IB2LmgJpcHNIOwf/k67vY+qeRn4s2OcnDah4R2BZ5/SgLwbu5UGBXPNkNiEbrbZ
	 t7bLtl+sj6e9tjTplpAQthmouGFx7Iw1Y5XWsMWKuf9sDhfu6IVVxBpBd+uR8UrRhFjZc
	 AM9M/ibkl420P7iquzm8AI27apPVwZuUZ2ShCLrR/SyQUUR6Fgg9F4CGAQ1Nd7k6DPEzH
	 G28lFg+Nn9NMQhf7LfRU2lNcLB2aYef5Ym75NpubNe4Op0gfdRBXkNOfF8Znr9rOZ/Ca/
	 5h/yStbxFB1ENjWmzN3dWOzalqwM1IU54uDVHLSt3mYTVzkcuWxRUwDL/+7bp7Cg15w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aXOb9Ny3IECR/8EK8cjvArzfuNlceVedehi5RnHb+YQ=;
	b=xv89KIzUj2pMhsRx752byXWl9vwVVCzpbyYaiCq6i1StrESXkyq78HfFLj8fTYytMw/h
	 RQTNqPFW6fcUE2tGUjl1I+1oHVhIhOqIg8mEt4FfysPFkKp/Zqt+IHDQr8XCAcxKgP4WQ
	 P9YIOvCW1RzQ9m+iAjC9e3+ae4zlAG6dHhzP8cqOlldRMae74Wi6tsvNKbVLBGh+2UsUQ
	 KEMH+i1xVlGw27jQ5smJoi/jqO13OUZcTICmkIL+CrByzyciFJESkVrYW5g1o3uO0tXYf
	 MkS0lZ19xmEtK2iuX+tF1qyG7MZeXJ8O/EKstTUs7lPEpnxiVn8hcSt75B8ESznsfNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QocdDBA3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FB5606A325;
	Wed, 18 Nov 2026 23:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QocdDBA3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13641F000C4;
	Wed, 18 Nov 2026 23:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042992;
	bh=aXOb9Ny3IECR/8EK8cjvArzfuNlceVedehi5RnHb+YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QocdDBA3BitL4yqO+cWTOT9+o2GKRczpWOnnqoVH+3C0ygTDDlfC3ml+d/7Ap1Fii
	 MN84s4PlDtaRfK3LM/a4HTZHNaijroUwuEiBp3Bm0rx7RTzWr3cRXVq6YrPGLeQ3Ma
	 O9SwbID584vRue1nQdhV0AJVbxguWWrPsqb88YZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0051/2857] dmaengine: dw-axi-dmac: fix __le32 on set of CH_CTL_H_LLI_VALID
Date: Wed, 18 Nov 2026 15:18:05 +0100
Message-ID: <20261118150203.153070241@linuxfoundation.org>
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
index d313db5379f8c..e1faa6562104a 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -1076,7 +1076,7 @@ static void axi_chan_block_xfer_complete(struct axi_dma_chan *chan)
 				hw_desc = &desc->hw_desc[i];
 				if (hw_desc->llp == llp) {
 					axi_chan_irq_clear(chan, hw_desc->lli->status_lo);
-					hw_desc->lli->ctl_hi |= CH_CTL_H_LLI_VALID;
+					hw_desc->lli->ctl_hi |= cpu_to_le32(CH_CTL_H_LLI_VALID);
 					desc->completed_blocks = i;
 
 					if (((hw_desc->len * (i + 1)) % desc->period_len) == 0)
-- 
2.53.0



