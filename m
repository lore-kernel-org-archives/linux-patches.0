Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027521;
	b=jn4N85lo3XNKKoreh89hO/qD8W2XlAFPsy5zYjC2fOvUnxjgQZHOhqynY2rZ1enKWqJb
	 VvwXUc6F89G0M9hNrvBSocK9A13f1Otnt7U1xvvikugANdIRqvCDQGsGNQkIHtGzyGeik
	 DnpYs7bvxkDlnpCdCcsC3A+Bh9+3Guzaz6hfjwpJAmVvzAnniDsHibJKr5QK71mHXESjw
	 AKC/VeW938akr/2AFoEoEf7GtFShXMPT/GxsD50Vg+FMmXyIvkGUQ+rxt9rNq2UB6pUDW
	 fHSNZpIrLKYw70YJ4ZDB07MdUKhndpoUwsbXkVm7YnAWVKL0agit/QW/eBb1mJ4FTLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZxGWqKeLzVBB7FBVcZSvEq1LJjIBwS61eDuFHufLRr4=;
	b=qb9t65hW6WLqwYiflI4mh7LUMbWkaJ26FeGwEsrQRLrp86I+lAuTocN6eed6qFuJB5Po
	 zqf8/F3W+l/krRYfWt5g/5JDbGXVtcH9z0iROFhDt5+3Ef4u6LF0Gx8224w2FwDYtKV3T
	 AMWyZVp1qNiK6+/ddXaMAtwWltdSYyjTR5qV6tx2tsQxA3yyFXQNVgahQCPORQGUMcS4+
	 vq+7NK36AJ86wZYiZPMPCF/pivNqqLdw9QWkSH4yxTi56al9e+yfI2uGCbz5en3g7Kh6D
	 wbEcQC8sBCbIHAg3gzryap57vVlfCQ2stgLjZzlAykcy+NcFAMNQhnwKRBIGLeBorGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxwLByuk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8F260A2611;
	Wed, 18 Nov 2026 18:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxwLByuk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973CF1F000C4;
	Wed, 18 Nov 2026 18:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027521;
	bh=ZxGWqKeLzVBB7FBVcZSvEq1LJjIBwS61eDuFHufLRr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxwLByukRl9K3pLOv4ChRmImXAE5ZkJuZI10cmyW/97ELurVCj+qRBs5mKwKu5L29
	 FL95WoCitnKZh5ByC3wkX8r+3PQtk7SgfMwr0IKBVHZ8Q7UCJMZq9tfBdjUu/AhzdQ
	 6W0xHoqa1NoIdnjyOuKX0FDz2lpNA3BLTmy0SxuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1817/2151] net: bcmasp: unmap previous DMA mappings on TX map failure
Date: Wed, 18 Nov 2026 15:59:12 +0100
Message-ID: <20261118150227.998230817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit a3cf9877558ab2c51182af558815dde64fc17cb9 ]

When mapping an skb with fragments for transmission in bcmasp_xmit(),
if mapping fails on fragment i > 0, the error handler calls
bcmasp_clean_txcb() for previous iterations j < i. However,
bcmasp_clean_txcb() only zeroes the control block fields without
unmapping the DMA buffers, leaking the DMA mappings allocated for the
head and earlier fragments.

Call dma_unmap_single() before calling bcmasp_clean_txcb() in the error
cleanup loop.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-3-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index d4de48c3132a3..515404f94eabb 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -317,6 +317,11 @@ static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
 			intf->mib.tx_dma_failed++;
 			spb_index = intf->tx_spb_index;
 			for (j = 0; j < i; j++) {
+				txcb = &intf->tx_cbs[spb_index];
+				dma_unmap_single(kdev,
+						 dma_unmap_addr(txcb, dma_addr),
+						 dma_unmap_len(txcb, dma_len),
+						 DMA_TO_DEVICE);
 				bcmasp_clean_txcb(intf, spb_index);
 				spb_index = incr_ring(spb_index,
 						      DESC_RING_COUNT);
-- 
2.53.0



