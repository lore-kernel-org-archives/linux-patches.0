Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040836;
	b=wCkUCLW+i57/qae8+VpC/0pY/b9Q+FqX1qCTxz03HVMTZkC6TAYtxueV6jkvXpLsUI3K
	 B4c9ipqq+ukDy8RQE/jQFS37XPXF/9uzVWDZS/Z4lYKFvsQXugKK+aTuHlbtaaayPBtnn
	 9ANY53YYLBS+cAL7/UNtpu3IkBxQpQgaHh3r4O7nBjr0qtBN5uY+XmUm3Uo79GBj76iPq
	 gv48F3zJpYzIB+/5rkvlAN/DlF7kUsrQPJKU8gC65tJNYzOXQ7f3g0Z49EZPNYPrPE3eL
	 XXhcbD/OiXtdcnk18HzJIJJ0Nhf7w5Qq5n/hi3t23UOSamxIbxOuweiSQd3GFqrEDkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aA33ruZ8ErfYqnAZsWzVAkiB32EcldsYCc1t6ca4ixU=;
	b=Ewm29OSbjQvJz3jZm8RWah5mqpih2WVSLWf4ng+ub9l43sXWDC4b6Lhido7lvg4VOwtF
	 cBDYueJlVEEC5Z4fRotuSUP5pTf+qOJKNPTrCjt9cLhy+vFxtOB+WUIqg9fQF/vDFb1fU
	 VvA8UBh9KFO8z12/58Tpf3IL5bgynx4TKqAv0NTkV5cb0pUyDT/eTKhtpSRao3VHrbhsx
	 Jh7i4yChlcCPNLIYmlLeqUxjj0PTcOFTRhDMMQoOFWTQETRVARzrBSqEjOBAkBtT3qhPz
	 c+AVxurToRRyST0Vu+AQ8vVdvNLZQ1e1NUKVjVsjZbENi/RK+UYdrA4wSPwzX9AsC+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=heYrXhsN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EB3606A32A;
	Wed, 18 Nov 2026 22:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=heYrXhsN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82DE1F000C4;
	Wed, 18 Nov 2026 22:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040836;
	bh=aA33ruZ8ErfYqnAZsWzVAkiB32EcldsYCc1t6ca4ixU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heYrXhsN7aBR1QMmBLzWBmxFphvxH8rGCIW0dQVGUG/W8w3X3izhX9Bg2LOkqjCVK
	 NcfPGJRI9y5LqgqI4GuDNkAsxCvqO+0+qsaZlG3sz/ixICbS/4E5H4zu1wOy5TBkHv
	 L1rqHcUWSxix2SL8hFNkO8HV8Ern+nr08l5WoEZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2600/3318] dmaengine: ste_dma40: Fix physical cyclic capability
Date: Wed, 18 Nov 2026 15:53:42 +0100
Message-ID: <20261118150439.166095186@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 11101a8e3e42273a5910a149f6324040b88f4747 ]

d40_dmaengine_init() configures dma_both for physical channels that can
handle both slave and memcpy transfers. Physical DMA40 channel setup has
supported cyclic LLIs since cyclic transfer support was added, but the
DMA_CYCLIC capability is set on dma_slave a second time instead of
dma_both.

Set DMA_CYCLIC on dma_both so d40_ops_init() installs
device_prep_dma_cyclic and physical channels advertise cyclic support.

Fixes: 0c842b551063 ("dma40: cyclic xfer support")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-1-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 002833fb1fa04..29a5cabb8f778 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2909,7 +2909,7 @@ static int __init d40_dmaengine_init(struct d40_base *base,
 	dma_cap_zero(base->dma_both.cap_mask);
 	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);
-	dma_cap_set(DMA_CYCLIC, base->dma_slave.cap_mask);
+	dma_cap_set(DMA_CYCLIC, base->dma_both.cap_mask);
 
 	d40_ops_init(base, &base->dma_both);
 	err = dmaenginem_async_device_register(&base->dma_both);
-- 
2.53.0



