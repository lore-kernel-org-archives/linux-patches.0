Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590189;
	b=NuOZEIjgBprwYJYLArpycpTdQMzRInK2toSkacTwJJEWtErpXqfOJzJV14tkBLweQEjl
	 rH9x8qsKaCMqY/HZQGWsbA8KK7bDnp/GH2hw8trBGrDpLvc5xDVIiuxXXZUKqQSxDx725
	 IrReo9x3RIiPJPe5nDYiZ7rCBu5AuH6wwuY8Z/7TUhGn+Gkdz2yeaV3+LMS2VOkcbO1CU
	 R7X26Ibg5gRHxXSvvJFXkg9CAhAoGgUW7TbpAR9eTUfVZM0KEnD4dUHJh18ZYX+2u6Je6
	 7JOZ/n9Px/DkBhVI3WXmjecLGHGtwckJrB4cTQzxEdEfuIVo6RvHfjS4POn2nePrOUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SH1k2pGZ2nAdzvrIwVLEnGimThRoW681XQgDwsUARno=;
	b=jHcl2z8JhyeyaOH6unlRwlnXVimX/9KfCuHpSPJUYgKY34cpL21g/IZ2unU6SozhfpmE
	 7tvkAJK54FWHWoM7lckzu0CHbEIcmcjZWFHmYZZkVa3YNhaII2R0MoLrm77B8/LcdAH6o
	 ITQwq0kkbWlQxzlqD6FeTnPWcMSPkxHCHT9vCmRMFo65aZjsBYZtR/rOoC+aOjHBgZd8X
	 hfQu6gqHwfO+c0kyfcjBa2yfi1UucAPaCay6+hnqJunufUR303BWVTrSLP1kh8vRatXtL
	 Msbbp4q3CVo8fJMSNf0P3rINsjvB4z+wc61f19gKYZyJ6RutTnoWxfF2f2n8ztElBrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+m7yPUS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5896074B15;
	Fri, 13 Nov 2026 17:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+m7yPUS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663061F000C5;
	Fri, 13 Nov 2026 17:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590189;
	bh=SH1k2pGZ2nAdzvrIwVLEnGimThRoW681XQgDwsUARno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+m7yPUSDX4rhwyivaliixqPJtTtQN9gpFwJR5U8xoRz80RhqC+7UD4LBziyi6JTH
	 oATMe7rUi3AHxcUGJsDD18eJFeCx0dOTBGCBMn0X5dcNty5d8dFKnLM44R2RkkRbYM
	 mpdUHqDMcCNq+WyJhdmna7+ecGdgpvDf0fJpvQZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Perlow <jperlow@gmail.com>,
	Aditya Garg <aditya.garg@linux.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 198/686] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional
Date: Fri, 13 Nov 2026 10:45:31 -0500
Message-ID: <20261113153827.742661930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Perlow <jperlow@gmail.com>

[ Upstream commit 7ed5dce55fa8393972b1bf2bf5af1c818c5e7dc2 ]

Commit f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf
packet IDs") maps the RX packet ID buffers DMA_FROM_DEVICE. The
BCM4364 firmware also reads posted RX buffers, so with VT-d
translation enabled every such read faults ("PTE Read access is not
set") and the firmware crashes and resets in a loop.

Map the RX pool DMA_BIDIRECTIONAL again, as before that commit. TX
keeps DMA_TO_DEVICE.

Fixes: f0ba5fd51ff2 ("wifi: brcmfmac: Set DMA direction for msgbuf packet IDs")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Perlow <jperlow@gmail.com>
Signed-off-by: Aditya Garg <aditya.garg@linux.dev>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20261021172238.10004-1-aditya.garg@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index f850e64108c41..24f083f42bb75 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1639,7 +1639,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	if (!msgbuf->tx_pktids)
 		goto fail;
 	msgbuf->rx_pktids = brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
-						     DMA_FROM_DEVICE);
+						     DMA_BIDIRECTIONAL);
 	if (!msgbuf->rx_pktids)
 		goto fail;
 
-- 
2.53.0



