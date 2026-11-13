Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585393;
	b=SOfj2rgxRsIeFIzOIWrb/HcySfysW/l6xFgHLxZHdOFvJTdWs1WfkueM9WHhPY2xE+ve
	 GSelaYZvhla9EwMQ+oFOtbsD8YzBWgT5HXQCEF6+VvHEH96aekUAGsMp3Sc7WEtkfsAVh
	 /tdokFo3ePNMWpPUVWExqip8r8NubcgOZpc3ST9vhfU3pN0n2iBOEeqWefuBConj2CRwP
	 L+MtF4GxWyQA+FGk4ODtfFSfmCdrUhNrsDQvoe1GihRfGAo7ISM/VBfwg8aSwroSFkvnN
	 cnGbTR3LN2UfMl+jRuOtFGwH2ybrnChdjyM+K5+3eqpr3jFD7ICWitoQQDFlcWf8bKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6zHs89ji0aKaVDweHDK2wuIuIjEP9bj7SRQbnNV3kvU=;
	b=JPm1P8fpKKO933FcJAOAX0aDeRLFekqZuGL/07kXMr5t/5ShZaho+cxwIJq2Rk409ihQ
	 O/19UpB17NQsKaKOIE0/hUt9ElADSxkaPpkT2xjEWYJOoRbsOZ9O//tE/HM0MEkr1zrus
	 YO9Xx9lbBgbcQ0NW4sHuPWYa5kyxvVp8BY2uHTcH5wmTY25qCHix9P92rxyylx3A05Nbl
	 z9IKholJ5ykdXI8CsCMCIUZ2NMZZy0ELxN8u4oi86mcZLHVwZJ9LpGfK1MT8FEtZLnf0g
	 iAuFHX+iCt6kKjSslOjwLhUqg3+tZKbGLJWMXRgP53X45a6lJv1jiM7OrMbNnWrDJ/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q5+3tplG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6B86070FE4;
	Fri, 13 Nov 2026 15:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q5+3tplG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AFC1F000D0;
	Fri, 13 Nov 2026 15:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585393;
	bh=6zHs89ji0aKaVDweHDK2wuIuIjEP9bj7SRQbnNV3kvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5+3tplGoy4tvChkZQVpDMkUlnvHmatDPUaUWWYguwQ0omdG+Ab0zcBHyAaFqiNwe
	 TlLW4qPVlasSmFrEUNvbSTUZ5JMJn4CnjWbPBfDcNk5sYHly8YZ2TEvS8/qrFJnWk4
	 0fMpoeJsZQtSnV+ExeqNco2Yx+PJEJAssEGp1LKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Perlow <jperlow@gmail.com>,
	Aditya Garg <aditya.garg@linux.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 065/507] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional
Date: Fri, 13 Nov 2026 10:46:09 -0500
Message-ID: <20261113153755.740970246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 069ba7016654e..ff47d4827722e 100644
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



