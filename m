Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585796;
	b=uebzoAMeH14CGKxzYGCeSjiBAQ+XwXKPKTFO9onl+SG3r9P/2Ud0xA8Wt5mxB+wEwnPg
	 77opNflfr2xczlq4IDf02sVjASPaT8DAUi8A4v8PjB4NovBQpupkshHP4N5CEOJWVpOXk
	 LQAICYyLzIXT8YJb6iRmt8NXAyt9CIuM5vHKMGNgVqQnFxKJdivwt0YXIK3enWxSF7WNq
	 +PXyRmGgd2fdUjTJmmi8NAWjKDm35we74y8ze3NCaoqAscu7aoGs+AsQZRTps1ii/una0
	 pkTy9P4feKTKOfNGcrrzdybrz0CKN1pzWor7bq69GQIufwxamCprYwmWMPWh5zwj79A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EOJSL+asOZ69ABZlo6Cw8DCvEb4YoT2C3mRnfDAfI1Q=;
	b=bKjp28gaA8Zoh8fs4HHsFnyBBZpFAC4lp7jlr92uGryBINtg65c6QQtiWx2EzVUsxnr3
	 3vm3GChoNgbPPnysBRqW2A5vOdLUPC7picA6pTbKRg7L92ouf+enVMhPtr4/SIcDRyxRM
	 SWLGZnl0NL6nX6bnsFrKleMkXNvpIQV0hnJnnC3lGwLgDYZhqx+Piw+Xsr6ac8oYj+8OD
	 UTt1oXiQfNs5wZ7kyJPnzP/zT3jCUGLhWLwUYPrXIJCdwVc8eWlPFg7HJVflZwwu9Nwle
	 37Vrjl90s596KhME/v1xZzbK7sjOWBquuVdH66dcYKmWIgbUn/YRah7N+XNGaTrM45Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvQUFxAl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B890A606EBBE;
	Fri, 13 Nov 2026 16:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fvQUFxAl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6394B1F000C5;
	Fri, 13 Nov 2026 16:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585796;
	bh=EOJSL+asOZ69ABZlo6Cw8DCvEb4YoT2C3mRnfDAfI1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fvQUFxAllWdXiymcq/Qw/ResBaArXSaqQLnhoBh1L4wFy6CktxHpMbhhdQ1nAXE7V
	 nLWOkc7T80oOQk/LhT6WNf/JBmrN6MTJ1F4BheIrS4gWS9qbGNvd7uqA88CXzAP6O/
	 YF4j95AXbhgWvr0r03rlqb5Uz5aKDGi+mFoBZ8Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.3 384/507] nvme-pci: add NVME_QUIRK_DMAPOOL_ALIGN_512 for KIOXIA XG10d
Date: Fri, 13 Nov 2026 10:51:28 -0500
Message-ID: <20261113153809.465024313@linuxfoundation.org>
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

[ Upstream commit c64d9b2c1f4fd1d8fa52dab37b48428a99c4d58d ]

The KIOXIA XG10d reads past the end of a PRP list that completely fills
a 256 byte small pool block. When that block is the last one in its
dmapool page, the read lands on the next page, which usually isn't
mapped. The IOMMU faults it and the controller craps itself:

  arm-smmu-v3 arm-smmu-v3.0.auto: event: F_TRANSLATION client: 0001:09:00.0 sid: 0x20900 ssid: 0x0 iova: 0xff7fe000 ipa: 0x0
  nvme nvme0: controller is down; will reset: CSTS=0xffffffff, PCI_STATUS=0xffff

Filling the block requires a slightly larger write, and those became common
with commit 2e8e30b3cf9f ("Revert "nvme-pci: clamp max_hw_sectors based on
DMA optimized limitation"").

Do what we do for other disks and use 512 byte aligned small pool blocks
for this controller.

Cc: stable@vger.kernel.org # 6.4.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 77317e5d00f9f..b7c5a18b899b9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -4198,6 +4198,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		 .driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1344, 0x6004),	/* Micron 4100AT */
 		.driver_data = NVME_QUIRK_DMAPOOL_ALIGN_512, },
+	{ PCI_DEVICE(0x1e0f, 0x0032),	/* KIOXIA XG10d */
+		.driver_data = NVME_QUIRK_DMAPOOL_ALIGN_512, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1c5c, 0x174a),   /* SK Hynix P31 SSD */
-- 
2.53.0



