Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215876;
	b=S97cyXQ7WX4VN+fNoGyqUdgcggTAEfX1Na6Y3hyUPKm3nLyUIfU7sfLcCLZ7361iAuZw
	 JQhmAFVwImKcpOgDkob8xXnwt9A2s9qq6e/3iBH7A3jOZ/0y3aEgDUOlNjk1uIBsSPGfa
	 lPFIxsYQOJltxpckVM11nKpP6TMgCXllf3ehyZHnsK+tePf/l/9b673l1p2cUvTwVJZnP
	 xpD/+tMNRm3Ja8wysiGhNIuuIBtiWS3be/FoJLV5sfvBTLHPiC4Xawu9GzCAkPW3uo285
	 zAX/3E1UJYQm1osRG8h9Jjnp4eigd8b08y1DtW9XXhO2v3o3SkICx1SAZf3MW7i9Syg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b7MnG2wAEiqruJ7Kg/qfaPUbRnuIhtM8gQw83nMrZjU=;
	b=Yv9p1MZ0WtP01U2AgWQo+lSoz2stYQAFjf4VDgjzky3UKkkBrAxWGQJ301AJnxjVtnPg
	 wOoFBYRnqxlqqnsp0bJ7S9JzmkE8DCCOatTPtHYQxc7jV6/0to8QOkWld7C1HeyvjIxtY
	 s2ETZ2RwqqczVAZ7jYToJx3VtCOQJ6JtHyC3xzp+9OFY99Ao4lS324ol+oZPERTVe25C0
	 y9cs7WDHDHYl7K5gq+Q+olFy2WC6/meoEZuhq8aGI/ef0Sxq+z78Z6riGfvcgnD9rO7qd
	 La2N43Bo3Sd6yLryq1miyQ+qW50MBVe4p97G4fLCr5Oom62d2XzYJ9OjcF33Ki1Z6nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3tZjrwk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F29606A320;
	Wed, 28 Oct 2026 19:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3tZjrwk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797E31F01825;
	Wed, 28 Oct 2026 19:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215876;
	bh=b7MnG2wAEiqruJ7Kg/qfaPUbRnuIhtM8gQw83nMrZjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3tZjrwk0d5lgTUslBJRtLtVhounJIOPUR/Pv4MHFaRTVo2Hk9viaCeRJ1vi7wtvI
	 aviDOCovBl6/TVhmVjW+GAjC+bz4sVPNec2rUOuvNREjq/Ie0kFdTKqn+iUeEUDo3N
	 2+5JVTogPmnmTxnf6cjpdfmqUgxyp5LM3EfcMWTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1361/1887] ntb: Store original DMA address for future release
Date: Wed, 28 Oct 2026 17:57:37 +0100
Message-ID: <20261028170530.414793189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit da6d997ac556479c112554ab5d95cbd04683eb11 ]

The DMA API requires that dma_free_attrs receive the exact dma_handle
originally returned by the allocation function. Do not modify it.

Fixes: fc5d1829f9bf ("NTB: transport: Try harder to alloc an aligned MW buffer")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260501-dma-attrs-debug-v2-1-8dbac75cd501@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/ntb_transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 8cb5439cf3b09..a0143aafa73b5 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -211,6 +211,7 @@ struct ntb_transport_mw {
 	void *alloc_addr;
 	void *virt_addr;
 	dma_addr_t dma_addr;
+	dma_addr_t original_dma_addr;
 };
 
 struct ntb_transport_client_dev {
@@ -798,7 +799,7 @@ static void ntb_free_mw(struct ntb_transport_ctx *nt, int num_mw)
 
 	ntb_mw_clear_trans(nt->ndev, PIDX, num_mw);
 	dma_free_coherent(dma_dev, mw->alloc_size,
-			  mw->alloc_addr, mw->dma_addr);
+			  mw->alloc_addr, mw->original_dma_addr);
 	mw->xlat_size = 0;
 	mw->buff_size = 0;
 	mw->alloc_size = 0;
@@ -834,6 +835,7 @@ static int ntb_alloc_mw_buffer(struct ntb_transport_mw *mw,
 		return -ENOMEM;
 	}
 	virt_addr = alloc_addr;
+	mw->original_dma_addr = dma_addr;
 
 	/*
 	 * we must ensure that the memory address allocated is BAR size
-- 
2.53.0



