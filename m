Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061294;
	b=Sl09wBdeuNUb9qjgdE8eXJIBJwQ23DMTZkvi1budBXVBGRxYoi/k2hsBdfad4eW2+sH7
	 bWl3HPriYH9chTL+Dl+WNpkraBMHoyCNyJOC1vR4ST0ciSgzFlyHTSVq6B1LaD8/YjJWP
	 CchiWoUs9v+zGJFSrChwyDF/oYCPNt7o0nvgAT4HQe59oU/KrKC2qwu37RoVVAK5D3ANA
	 mh2h+iwXzSm3UIPJmTdSgP64u/j2bMsuTjEcWqAjN6/fLJwF1M3nXgN/dwt/TSRdomTFF
	 A5x95rPFfd22wlLMe4jOUW+IvT1Fo+R6vsUwNF+HfkwWyAyYmmnJraxecOrgzINuFsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7PKaoS1hUqNC7qFCGl9uf908St1vKZnAoTYR0I/dEMg=;
	b=5iqBLRM1C4K2K2J+1Bh9+bAUXXgxXvqwp5tpmy+jrYlOZq3oxHcnEm5I/hEb/BuJ5j8S
	 8qNyViBuiPNZGtkJsRSNqOs71wFlqkc4+g1DxN78sb4gxDFMXr2hJSty3SHrS7rMgjBaE
	 DpJ7/+xONutW9T62y9pGCxWZwH5XjGa8wmuj+Nc6V48dF9AHszpcVBt4isEr/VhJdkY6N
	 tTD8rXWuOsn8u6rkBhoDaEztNgS542BAEiCm/1VuUbHdgtgYAarYh8Ltnvczh9G9AeKrq
	 DYRuV9HzY/2rsJW9wQIfUFvw4bUPDMDt3mf+DutSt+gfEJYu2XDiW1CQsVFoHXbbESQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WcOn8/Ri";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A362606A325;
	Thu, 19 Nov 2026 04:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WcOn8/Ri
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011FE1F000C4;
	Thu, 19 Nov 2026 04:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061294;
	bh=7PKaoS1hUqNC7qFCGl9uf908St1vKZnAoTYR0I/dEMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WcOn8/RiKxN8U677BLT9fmJWDM5JM9MbyXCkRn1MoE7MTdNgOks8gTYnU0qf/vFvc
	 ujWXUMAl7rVPDqqzYcpM0GnRDg3McHMtLxCh4pM8uqCm8I90mna0AF6FPftm9o+vvd
	 nNyCO8SsOVIabii1a4sXnulqpmbNqMyp9AUswJ7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1500/1848] dmaengine: ste_dma40: Validate DMA specifier length
Date: Wed, 18 Nov 2026 15:58:58 +0100
Message-ID: <20261118150022.153919463@linuxfoundation.org>
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
index 8cb561d0dad70..824fbff30db59 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2398,6 +2398,9 @@ static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
 	dma_cap_mask_t cap;
 	u32 flags;
 
+	if (dma_spec->args_count != 3)
+		return NULL;
+
 	memset(&cfg, 0, sizeof(struct stedma40_chan_cfg));
 
 	dma_cap_zero(cap);
-- 
2.53.0



