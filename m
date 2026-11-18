Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058783;
	b=T+MZf7F7UUmOEXO+1e0gktkj8DifPj2K1mzwhXoX045PixfDeT/tP88wP5s3DKt9PnFX
	 FmRVfeN4eVCdSNNeTXwj/30JB2Ux2/GuDqDDdEDPWDBq92NdYBM6HZC3E2VhmjESW/HUD
	 RhJuFlY6mv+EtGG8b/RbYUQ3ClkPx9kjavz2Z1IK50EJ6BJBffZMhPEf6rkCWpV7/01Bv
	 4RP0V8AIPls5gfWaSQYON/w7n39i8XF+4AIldx8htYjjp9JIrBGbaaZ6NrvVydwwFJfoC
	 sWyugJNBXZz7oFkIF6lVEZorf0nFwR125Jvt4MoBoThO4r5HsDXfp0AbIv3NIrqez0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dY6Or9rrPaSZl3vYbf/jW4VXkvAsnQoU3as+2MQMcCE=;
	b=Gj/cnyWEDOzQB8sZULYaHybde7BBEK886wy7P7FgfZNep2VaWnrVyHFmw2mtg/UT6cMV
	 H6h/hQ024Dzi6c2qmn45QljQNKq2D/KPT8GWj49Ryqqln7YLGrkypEvw7YNGpIn/juOJP
	 o3ppW+Z3uIos2upC6GMOdhkMbMpQVM+bdT7KFdrpoTLdWOoJXMOAJb73bNljVRceculR4
	 lX6qCYlQpsS0BZTxHg92INRN3IjzVWMMoYUZthxm4ps0Ip2uJuYI4tMCi2attdoKZm+yX
	 idGrnrOk+BFRq+T0ICYJVOeyw0Sn88a+E1yUNJ6iYK4KpRe2xHEt9I1QFA/Aq0qDxwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QREVsqTp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4900D606A320;
	Thu, 19 Nov 2026 03:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QREVsqTp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913971F000C4;
	Thu, 19 Nov 2026 03:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058783;
	bh=dY6Or9rrPaSZl3vYbf/jW4VXkvAsnQoU3as+2MQMcCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QREVsqTpJnB+EximlJihTYtLlJ+BYpJe/01DBjEDam8B+8GY3wrsXDAZ5gaZzXHuu
	 wOaiu/ayV6xOqSzY7kU4YCCBovFi1pASrqFSg5HGao2gkl8LN961lToMHGTEu2/WQd
	 uLb8ZQzeyvSjleothjI9EiwmNJyAdh27AXWe87Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Perlow <jperlow@gmail.com>,
	Aditya Garg <aditya.garg@linux.dev>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0608/1848] wifi: brcmfmac: map msgbuf RX packet IDs bidirectional
Date: Wed, 18 Nov 2026 15:44:06 +0100
Message-ID: <20261118145940.788984692@linuxfoundation.org>
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



