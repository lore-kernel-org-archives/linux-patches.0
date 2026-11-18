Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052971;
	b=uZFGNLZ7WYL2HEQjuxnPvaI4v7ej0eLiTkfsYf2T3t2OOuEPTT+N+GMJHlch3JoImAjr
	 /Hy7Mm72I4z/tAsdh39pGmV7c1Ps/uzuxIGhiXZD3PMkd5TunFB31R4HC/Vw6JGo/zoqo
	 F9yTt5WRGG3hUG3vTW/ElzqxcWF5GwPIs3y/0aoT+Ir5yEn7W2PPwDt8tBmkJCujwfyBT
	 AE0YI5n9lABIt6GdMl4ZOorFdAgQhqguXCQwo5ugrGHB8YGVoGr3EnqPXo9Y+tgyAZrQX
	 g+wipbpCbivxyONfUlk2x+UGWy60haIqsAwFJBIa+Gt6KHO1oCII8K4p0VjDFYIuVIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mWUwIKDsUlKh7F1jIx3qrCVnd0PnX3KnmmHZviC9CHw=;
	b=uRI4L9jLXacuVcRALwx7WUFUwqyP90sP6A0njalswGNWwm3jDomNGsr7AMf0oMGix40K
	 yRD52soOAcFKvNQVFxwgTOpjCfmT1snwn8lyVjJ03ZNzph3QBaZqHlgddCVDI02AQzhSW
	 UQ4fYcPjPGOSoitU+omtTS6QMAHUSh59Qm2fKpDmVn0jCQBRLgWCWIO+8CZR6SZnKnKWa
	 /PHxBY8/FJKYqAG+hU+RsD+aWd1l0uqIsRC0M7mSIdCi2aorBAgpGNqU1m4KxOEs6DPgM
	 cn0Wga4CvPWYwl8yRCDKe55z9WQ0yFVSfkpvdqSBkwMdSTTM3CkM+T9x05DblqWOE+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Na1O5gNN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65253606A32A;
	Thu, 19 Nov 2026 01:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Na1O5gNN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AF01F000C4;
	Thu, 19 Nov 2026 01:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052971;
	bh=mWUwIKDsUlKh7F1jIx3qrCVnd0PnX3KnmmHZviC9CHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Na1O5gNN1aEA2sYMgaSyZj5H++Lh5dCWBEakQO6uCNfh6SnTqWIqjohMnXfZqbEYN
	 +mJlkx8NQB086C4oh0oolQdo5MH9wZAZmEHUvDnIagIXr4G/rCS4LEfEvaPWW1DgfK
	 QABVv8+fJdVBGquf3a6AeSt6wSsu/tbFuceRV/XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Perlow <jperlow@gmail.com>,
	Aditya Garg <aditya.garg@linux.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0753/2214] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional
Date: Wed, 18 Nov 2026 15:40:29 +0100
Message-ID: <20261118150041.878130119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f578ac00e5d1c..611c7a8f13785 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -1617,7 +1617,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	if (!msgbuf->tx_pktids)
 		goto fail;
 	msgbuf->rx_pktids = brcmf_msgbuf_init_pktids(NR_RX_PKTIDS,
-						     DMA_FROM_DEVICE);
+						     DMA_BIDIRECTIONAL);
 	if (!msgbuf->rx_pktids)
 		goto fail;
 
-- 
2.53.0



