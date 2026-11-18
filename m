Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061451;
	b=l5VG2LR+5Fv6oAtVuPAwryL4PagA+oSeFktpPpsuSX2djVpYJ1XChSUr4qItUbvmru4w
	 w7yN3VNV547GqOvKAytejAoNADcisWe7sgaz6bMuoOjIm9jj9lgY9L5aNrCqsON4yjBkm
	 ydWzj0mhDD2rnFT+SKXesBb6dxDDlpdxL6tdOHkangjKbvNagd0jzj0d3gFEppk3Dk7fM
	 jkGwTaQW5v9X/ijcLvfzPRVIxWIVMjT6S5XLvb3rc1AywbVIBerAenQN3BFX6QCDHD8cU
	 4KvFDW1oWx/D+L4jpYDwnTcRQr0T4tSJ3an/HppF2Rr27iiBPvPk8qFwRawHMaiqxNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oGkgnugEtTle+giHd8qE5/yM/JkXzPrK239SXNC9fF8=;
	b=DIycCC9Uz5X9jYq4tqpOMn3VC9IVS1uzrx6hMqHuMhjSi1oiUNwOgesQfoPhKZ7L7FjJ
	 apJ7WXpJY+KSjjBstLhZsA/aNzIDxzuREBiwLKUzgwCEGjGEvc6/tOiM59NkkFDIu1msY
	 l/pK7CMktIBbuS7MkCuEFM+Zo5NKeXsZBE9jpcOdlzhR49ij8g1CbCJb7OBPibO9OEVgP
	 ufWqbmfy8t4eScod2SBXz4IQ5S0lKwlgLvctRs7Ny5LS3U9QeBR/nsZMaq1826KFVxzgn
	 5PYXYc6fK0ew7QDqm7VJhTKmZCxo+cGnHVyPolfcuWthC0NKPNSg4fMAOmAr19szK+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mWIjvJf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3E3606A335;
	Thu, 19 Nov 2026 04:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mWIjvJf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969141F000C5;
	Thu, 19 Nov 2026 04:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061451;
	bh=oGkgnugEtTle+giHd8qE5/yM/JkXzPrK239SXNC9fF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mWIjvJfxHt6b5tzgADZjk+IH3yYp0yBVcoVHVon5yqOwbACLMj6IRC8PcbHU/7tm
	 m7c3fAFgCPZ3sEf4rHZXy+Ok4C63W7oJFF8YOMGrlU+E02jgpInGgxILKtRjAmyZpS
	 2VJaWbH8F6CcjjKgGYPlmnJ1fh1yBej5Dstjz7sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1506/1848] dmaengine: ste_dma40: fix typo in comment
Date: Wed, 18 Nov 2026 15:59:04 +0100
Message-ID: <20261118150022.382175266@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lawall <Julia.Lawall@inria.fr>

[ Upstream commit a71da24ce1f8f6844c6378ae394b5c4b31ff5725 ]

Spelling mistake (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220521111145.81697-17-Julia.Lawall@inria.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 0ac4a90c4805 ("dmaengine: ste_dma40: Validate memcpy configuration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 1fd8ee3bafd2c..991e72f6831f7 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2075,7 +2075,7 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 		   dma_has_cap(DMA_SLAVE, cap)) {
 		d40c->dma_cfg = dma40_memcpy_conf_phy;
 
-		/* Generate interrrupt at end of transfer or relink. */
+		/* Generate interrupt at end of transfer or relink. */
 		d40c->dst_def_cfg |= BIT(D40_SREG_CFG_TIM_POS);
 
 		/* Generate interrupt on error. */
-- 
2.53.0



