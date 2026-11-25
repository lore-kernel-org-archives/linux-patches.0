Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626340;
	b=3ndcbr6dPWDEYLDbdjqfUdkwmJxEgXUf3H893RVsjmoCmZNLiSVD/G8UjDRJlvhnlId3
	 /SmXIyfKxZ9MaDTgLsPlSisoyNaYeVJPZoaqCvx40xxA7cU6FYmsHhS+gzLd2jO/vqLKa
	 SWtb5mYB9bG/8Vilokrry+inL7MvFRRiXjhK6JqBB144V7ES8BTcDlUuoslnHwldBgfij
	 zMBOs1/QY0UkDLEqEYZ1DXh9Xkc2vSW9FvBxVrfTs3EiY0uIwhUp3DbVbghZf9xE4RfkG
	 F8ofa3Wi+c4VMYz5vXw62plz7gjn0fdWlg6ehoSnaCoN9C125vvBe1GgC+YqTWl1sKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3m0Zvv0bfYv6mjKaFEZhzbwQO0EIp2aY8fE2lyKJoDI=;
	b=H29tr0RD424iX9sBNKlI4b3YXMnVXMfUnQCz1fY5fNXwpRxvuqVhttWiGvwElSyU8JRi
	 QqM/IykstiN+CEqObGw7C9/JUuPgf0Mi653oU5qkJ2g+J+Ch0KQ6vR/BYcrJ0r/oPTD8V
	 qOEWK7x/Vs8Hb6uVwH7uuBwWfwBqfLXbk+vkFo/G93tFhlzggbumQR7MrcwLwr8A59yVf
	 8tjU/DEDkkFvRMMqXAumfXimYKZn+jc8oHXlBtN0SyhHrNIQWbz7Uze7ZonE5dtSd41bN
	 rI77HVqmeCawnYFpMRXIOzsLAvSyGx7+6R4EDFKQ6JJlK6wm8AZxevLA4OJh99NGneQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nL3q1BNm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875B4606A32C;
	Wed, 25 Nov 2026 17:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nL3q1BNm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A94A1F000C4;
	Wed, 25 Nov 2026 17:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626340;
	bh=3m0Zvv0bfYv6mjKaFEZhzbwQO0EIp2aY8fE2lyKJoDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nL3q1BNm5f/EHH657D02YsO8ygKYuIzDRHSRdNCHJdKXWd/21o+UtL1FjITkurozZ
	 BFxmZUOlelTP31Tp5K6WfdEmk2l7xXu3RZQu13+NwlAMF8DtSgDnx5U7LJzWvZ/+ag
	 mvDuIhQCISdWs6CjKBN5us5yYHi2NwVzkIyy+7Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Brad Griffis <bgriffis@nvidia.com>,
	Ido Schimmel <idosch@idosch.org>,
	Furong Xu <0x1207@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 812/816] net: stmmac: Apply new page pool parameters when SPH is enabled
Date: Wed, 25 Nov 2026 15:39:20 +0100
Message-ID: <20261125143907.965810633@linuxfoundation.org>
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

commit cb6cc8ed77177c7553c2f8ac8605d32de58f43ac upstream.

Commit df542f669307 ("net: stmmac: Switch to zero-copy in
non-XDP RX path") makes DMA write received frame into buffer at offset
of NET_SKB_PAD and sets page pool parameters to sync from offset of
NET_SKB_PAD. But when Header Payload Split is enabled, the header is
written at offset of NET_SKB_PAD, while the payload is written at
offset of zero. Uncorrect offset parameter for the payload breaks dma
coherence [1] since both CPU and DMA touch the page buffer from offset
of zero which is not handled by the page pool sync parameter.

And in case the DMA cannot split the received frame, for example,
a large L2 frame, pp_params.max_len should grow to match the tail
of entire frame.

[1] https://lore.kernel.org/netdev/d465f277-bac7-439f-be1d-9a47dfe2d951@nvidia.com/

Reported-by: Jon Hunter <jonathanh@nvidia.com>
Reported-by: Brad Griffis <bgriffis@nvidia.com>
Suggested-by: Ido Schimmel <idosch@idosch.org>
Fixes: df542f669307 ("net: stmmac: Switch to zero-copy in non-XDP RX path")
Signed-off-by: Furong Xu <0x1207@gmail.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Thierry Reding <treding@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20250207085639.13580-1-0x1207@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2051,6 +2051,11 @@ static int __alloc_dma_rx_desc_resources
 	pp_params.offset = stmmac_rx_offset(priv);
 	pp_params.max_len = STMMAC_MAX_RX_BUF_SIZE(num_pages);
 
+	if (priv->sph) {
+		pp_params.offset = 0;
+		pp_params.max_len += stmmac_rx_offset(priv);
+	}
+
 	rx_q->page_pool = page_pool_create(&pp_params);
 	if (IS_ERR(rx_q->page_pool)) {
 		ret = PTR_ERR(rx_q->page_pool);


