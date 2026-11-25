Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624221;
	b=A6pqekEtJn+I6hsL0PdNJLe6Ym5XLAQoTznBbRWyPQbbwSA+2TxMNOSzBJmFIoWv07om
	 Jq4yKvU59sdn1XcoHlUewuAGnULf7ENFKrVlpRYLniMY88tRMXkpM+m4hyNoxaHERqs4f
	 9UgGDmt45H6HBV7jlnzc7iEh/HFu2DiJTvfbJGPTfQ7ZOxihu7rZkoTTKD40Qssc6rGxw
	 uXp1AJs5IG5AYpOx8pAo8o8sU8uXy1Vav/mduR6rdnlWRp/OC7V2PUpm5o5ibMfNUxPba
	 fs+02Y33QWLrd1mO7p0u1zOr40g0mQPJEPVqbmuXJksNkG/XZX5UUpZIXWz0uTJHKjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BHnq1oEkLHo8/fMGe2zp4FfVBosDzZLX6eRpdkerL8Q=;
	b=uPr+VWMjuiNRKaDx17jW4GaGCK2raaNYYzBG0gOeC2sXAQyJzdcOULk3nRDlvF3GNBva
	 Qc3XMsq9k6dp5yeuWlD6TgxEvQHWrOBd41CxYT1aS/rOtQHjycv9PhHDkjnlfUXWX3XH6
	 Z9cGkEqQsueqFHpjjG0ZX0nw4onWmnuQNNs4g2UPFjVhiokMSUXj3l/01Go6ZIvOLKhOX
	 fzfbhUO5DQ3T9IR1wo5F5FgKxsUlCLMiB+CcoJT9Mf2+QBC3ondZDTgcDZhrLrP++PFPJ
	 hbpYqPl8s5rgFOSEZcxZBCmrtfJK9amW88WKeiGGrHCTeRrNiYNI4iAQuL39z4Nu45A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5S9z5PD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C67606A336;
	Wed, 25 Nov 2026 16:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5S9z5PD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786631F000C0;
	Wed, 25 Nov 2026 16:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624221;
	bh=BHnq1oEkLHo8/fMGe2zp4FfVBosDzZLX6eRpdkerL8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5S9z5PD7bBcGnPnpP01vaPdRrqIoeoDPZrvk9h0iHWdSacQ3qDm9+p/AMTLndfgj
	 X9LvjBiLwS4puZQR6iW5fyOwjKRmemFmGaUa38cFb+fgAkK0DVAhaB3OoIEEQvurom
	 zAGRxVZLgJznjpeFGlXPP0aTWU1KMhID01DismLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Xu <0x1207@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 121/816] net: stmmac: Set dma_sync_size to zero for discarded frames
Date: Wed, 25 Nov 2026 15:27:49 +0100
Message-ID: <20261125143852.010835468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Furong Xu <0x1207@gmail.com>

[ Upstream commit 51cfbed198ca4aa140babde816387db0e71f09e7 ]

If a frame is going to be discarded by driver, this frame is never touched
by driver and the cache lines never become dirty obviously,
page_pool_recycle_direct() wastes CPU cycles on unnecessary calling of
page_pool_dma_sync_for_device() to sync entire frame.
page_pool_put_page() with sync_size setting to 0 is the proper method.

Signed-off-by: Furong Xu <0x1207@gmail.com>
Link: https://patch.msgid.link/20250103093733.3872939-1-0x1207@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 834ec9530832 ("net: stmmac: drop split frames on AF_XDP zero-copy RX")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d8988ca3d163f..3bfc2522b2fc3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5586,7 +5586,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 							   status);
 		}
 		if (unlikely(status == discard_frame)) {
-			page_pool_recycle_direct(rx_q->page_pool, buf->page);
+			page_pool_put_page(rx_q->page_pool, buf->page, 0, true);
 			buf->page = NULL;
 			error = 1;
 			if (!priv->hwts_rx_en)
-- 
2.53.0



