Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590465;
	b=pP76fMRK6H+NpCkTSOMYILTeOlFgfPAEVb9S/5qDeuSY9beTh7vFZBysBmSATx/d5hGb
	 tegZ8dZL9xuP/YbTOQh0Xj9SghArEmj4g4F5GUk67C7Nq7IbDENFizHYkTFjzcXAXCTCv
	 bJTLrUlKOWzAkD2XDr21WLc6szhAWCx2LhdPnmCB6UfrAIc/hGMgz+eMYVFW7tgFGjFVG
	 YUKmjVTOtaRpKHPRNWzmBfsttgcMRGQlhfou7jlLNzbl0bJd0KA3u699P3swQLUjkq+KP
	 6892bqebT1L4mB4CzmEB1fJ7/zy9cxYr58Yol0aPFh4ehpfHLYDnryYIPVn7sI/snTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z/TC7axv2cwe8koqwfsC5KH2NC+35jXK13t/q9BPCqk=;
	b=4FPr9MEj1noUnaf4+2nTA1cK/MnRBXPzOEZary3kIpQXb+/M1pHOHl5R8kdVNcqZHkBu
	 Tb5Xl6aqv/pG64zDjL1OW1LK5Ti8XFnZUS49Q7yFsc45NYyvJrumVk6QCR9BfLIsP/aIG
	 MgHKisfjy9EWBBIkw7OMlqNXEJN4eHa5fJs6PS9y+eNsVGD11q3UJEPSL9++l3MMBRSnO
	 7a17NP1DcLqMosxRDQZKm2VjIaNn/uy1kz6EA8hCECUtB9Baai300VkSc4adrJGbcLva/
	 /sHIxPvpNePJ79JYQuc+KRX0Hzu1bucthWeNIdT77o0wASKuuvfQxYjIppDe3aO5fbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ec/1107V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED78606B803;
	Fri, 13 Nov 2026 17:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ec/1107V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AABC1F000CF;
	Fri, 13 Nov 2026 17:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590465;
	bh=Z/TC7axv2cwe8koqwfsC5KH2NC+35jXK13t/q9BPCqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ec/1107VgT5+Xwb7OY8jmLl9/2Bv3u9h/q4Xg8UL64NnOtUR2kNtaMFqLwXweDaJA
	 zBlADOLU1jyQUyD8er+TKPLHUoLxSfTMZo7gEZa0dy0Hx9D5M0noDD3SM6LTEGJC9K
	 zZmRHdnM8O5B9QCtMPmi9CVfZ0ETWWNS9+nPwo1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 421/686] nvme-pci: add NVME_QUIRK_DMAPOOL_ALIGN_512 for KIOXIA XG10d
Date: Fri, 13 Nov 2026 10:49:14 -0500
Message-ID: <20261113153835.216338143@linuxfoundation.org>
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
index 6e4261b0a0821..9245fae713210 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3939,6 +3939,8 @@ static const struct pci_device_id nvme_id_table[] = {
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



