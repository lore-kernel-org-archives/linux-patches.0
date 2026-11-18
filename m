Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021286;
	b=jjnu8KiyaKgXxnd+wKNCqlXvMGyOun48HY13LMf/NRhYWlVP85kkKGy22vRQlJB3HlFQ
	 k54WxrxvOqeevhfWmhyoFqVXYWLOb0UgzsJ+2Xq8w7HvMI0qiH/1lfjzmRI2583OX6ulx
	 q9JH2xOp5giAjGCF+dKDd73TJmfDlGj3E3XIbOGuiIKB7yIoYJAtRGUCiUBSWxIurdMoh
	 lHYGFK3/vfYTutDQ41Cy0Sqv+hYhVr0TLftdSCgsVdhznky6FhVKRNddl20EaP6dYX587
	 qPFeuQsvSkRlDfE9Y0+wvyLankcVz4M3yLP7zvwCQxyi1hlRxm1KWaGh+ik0LCHGQpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P5sRUdmM2pmhoc/6gesnO+K+ApAJaVfMRqUoEcqsTPM=;
	b=wg0VVqfx/ViJbjEnl+UT7X+ryZkYvrrCOB6+ZQZAOTUX8kGRocU7L7XUhOeKEbA0j4H9
	 NWlRJKg13pOv0YY3roxS5C2NkuRjW03wwyvsBBSB2y4fAeGZ/xvJsGKVhR2IwSu96DoMk
	 Y1a36jW+z6gZ34AK/FT0eSYhmX5vFYjCkuUBMvLliL45Hp7w9L1yoF6gYtyVp5W7NKQIr
	 K/m9zuN/T2GJCZ7gDS+aG8DSAYn/Jv1Ex5S4JA3+2in6gWht7vu6tTl54aq/qsI6j07TL
	 BIomSTy9Raaqv0gtduPsT69/yrSjmdAkftg2olNQoEeIZQP4/9WQMp/BaOOYOtH5B9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0PscZX+N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6B1606A320;
	Wed, 18 Nov 2026 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0PscZX+N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432791F000C4;
	Wed, 18 Nov 2026 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021286;
	bh=P5sRUdmM2pmhoc/6gesnO+K+ApAJaVfMRqUoEcqsTPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PscZX+NzuHJV4AHK/xupEjPakV3Fj5SiA/j4k4i6y26HfAQmHXc/3HNBVDlOChEA
	 6rD6golUS0fy3h21luAwMdy3MnypnuxOCYcZkVIn2zjaJ5A76I84Pc8PcGz3olsrjV
	 a+lZoF0bW9Iieux9YqBWe1MrrKFwh4qvV7sYyd60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2253/2651] net: bcmasp: unmap previous DMA mappings on TX map failure
Date: Wed, 18 Nov 2026 15:58:13 +0100
Message-ID: <20261118150406.547851239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index f2176ef3a127b..9ad5a982542f5 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -285,6 +285,11 @@ static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
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



