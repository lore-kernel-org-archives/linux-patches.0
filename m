Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045937;
	b=N1w6+FsIRbm22489MXu9hFcRr4aag+nLk7QJccVeyO0Iw0WaE14yJW1cqtnYA+3Taz6e
	 lnBFej5cuk2UXkUSWEbg8EOhZODo9Dm3hRRlbBNuQu/HW3cSFrS4OgmkGSNZ77vLE/KwW
	 7w+XMdmwyhsrJiHh4uAorVQZxfx5Oh/7mX5pWeM6wOhffup47uQx8FUTztV/RhZODY44p
	 fRAvXb6+8JQFkH++pIwW9vvFaRDiH2JdezmsMgMZEnx1h7s3IxciuUNxtLSseCXolr2/9
	 fe/nbje1jxSc/cJmu6G1LHq5frEttyA1oK2EBxnydcHGTGcVXRnh08eA4/VUaRwfSlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i9iCP6puxb1Ipx3uNebTmmEvvkHs9t9OxKe5q+QLvms=;
	b=dlKP4YG0b4/ldvRqVyjY9vV+zOQFvLjZccbO2NWfCgh1Rj2v3vza+hPlKTXEe186ygLq
	 M2BuEuCM6FBgjgSDZrzZVBGTM9WequFvTMkHISBKXXDXQ3MTHRLVdxALDiYgoQavkyGaj
	 KzqMRRgm8+jGBy9frVf4nLYk3G5/nvdgCuOD6DcnmFcz9PmYLie+Jan4Wus9R8i5D6JbJ
	 52vv/+hUxSl3343uhkzbcxtKgC5vDUoVUymdm8k5On5FjCHIKzrDUcRlkmlW/YVBNJ3Xk
	 b81cDcUUSO3tI+nsDs9OQZ1bkcW0OxCcmnHy8tThLeKlijMV+p/x38UHdUObrVl3stA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKS4KnWV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EAF606A320;
	Wed, 18 Nov 2026 23:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lKS4KnWV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93711F000C4;
	Wed, 18 Nov 2026 23:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045937;
	bh=i9iCP6puxb1Ipx3uNebTmmEvvkHs9t9OxKe5q+QLvms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKS4KnWVo1RHLrO0CDpA502kA1vvrr8FSz0JthbUocwQQmD+Nl4IY9F7WiWt89GXQ
	 +Yuzjx2XnqXOiJ+dQOQScitFiBwhVD8NoAJnPCZru3EHClnYE3v1VRks27WUx207fe
	 i86KoBDsUFaqXbBKVXY4sNkRdcEmc5/bIE9moRm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Perlow <jperlow@gmail.com>,
	Aditya Garg <aditya.garg@linux.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1101/2857] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional
Date: Wed, 18 Nov 2026 15:35:35 +0100
Message-ID: <20261118150241.276273876@linuxfoundation.org>
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



