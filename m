Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037235;
	b=twqA5BXOJ/bVOPkJBsOBJIL7gLT05mPStK3kF97ze3w7QU3Pzi2vH38im6q/omOjwYt1
	 jHZ4H5s/12QYEFDnaUgIONG5AN4I4j59oz/CTWAJ8tul7VrRC+GB/8EnJinlYkCZFHVYW
	 PLIUBvuVvqCFkUVQe9Yu1Rnm50N7f7ckeVnjz9SDx8IyU61wXfyQEViWsC5HmM/4B/OhO
	 YFQnoERVzUrfT3YKZ6v9ZJlH93jxB/HnoLP25DCCj/oAMOS7J2LKM+hMhFePOhoDOSKy5
	 PFljnmFUrg3dE4aZlFmEJF/wbDzQSpxbieUbgX7Zuz8MoNQfqQG6ceRlPTT+3pejUPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nHsOI6JQMpzYxkb1Jdm5EjltjkFdmEN5mkVJVikdiKI=;
	b=2CnPeQc1bN5d2P8aOkEqAbe7teSGHhhDzgU3XpKvmt5FOprM2+aCOHa2MzRY7ZtP0y9o
	 ij3cE9PswwDJvTigI7vle/rL3x2GlUsXdo4pOAtqVPbvOjeXcNMB2Bpp3A38A7iXB6WvO
	 PcIvxYCuYv7eCWUGlH6ZTft7EdV1+MZMA0evZ6jE1uTK9eNEvptAnsVUMX80fCFDJiYDu
	 34mitDM/dimj/wrySDS7wr7AfHS4QZH+NYvoSymT5+ORFajjxLC0znODwAFzLbuFgc3VR
	 GYRgZ+768TUYQ4CWF36msH60FxE+12pIwLc4SiqIjBIrf3R0Pq0wSMlJwTv3ZRVXccQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z1iXlA3w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E05606A325;
	Wed, 18 Nov 2026 21:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z1iXlA3w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099FE1F000C4;
	Wed, 18 Nov 2026 21:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037234;
	bh=nHsOI6JQMpzYxkb1Jdm5EjltjkFdmEN5mkVJVikdiKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1iXlA3w/3eq6tmayBqz48Yh1I7CPiV/kdLqQVVswJrAS/Bg2zH4zAOeCfBr58fJ2
	 SStaOl8x1WuVz1ZmvZJhL79B0MZqCdlf06At7TjeMZelY0D+r2HzlN5zUq0k3m6gb6
	 XJtPB4on0R63OmCgbcc1d0xx3RdHmbmmLMYd/L5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Perlow <jperlow@gmail.com>,
	Aditya Garg <aditya.garg@linux.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1295/3318] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional
Date: Wed, 18 Nov 2026 15:31:57 +0100
Message-ID: <20261118150359.117843440@linuxfoundation.org>
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



