Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037843;
	b=QPV3zeEMtg00YrS4MGaFJtyAAf2kcjP/JqhgTCdSt/j9mpQGYvTUi0VBowPNrwz6dzVo
	 iSf5+YRq5n4iyV+cuAZ3KZZIxJ1oEZUI2jNaQPzCHUXuClEhlQXvYeSUiyBluYiBxIjMm
	 y4f1Uk6KwIU6X+8nIALmpsZDY7UCuAEHrt3vQ5FzoqZaxkqyIddIxVg8R0Asvv7LApVEb
	 SO7sJQQgJenVf3TkkyQ7iWEgma8UteDwyBC5/IJq2j7w0NwilLgOb9jsljgNqKwQIUgaV
	 bn688h3Q4DRVoM4l3l9jBE25l1IVxVvIOZ4Zk/wHzN2cZyyhIMMOgpTsRzGWf+vNz5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fzXLei0qQJsH7NplUIEAkYTdTLb5GRvntqimVsvEtJ4=;
	b=O4ecoapvkicS75oza98+nhnf2NVp6vlLIdyNVjjRn1s48Ji5//HPaeQkcFoLiFTmAV8H
	 kYT3WeYDxHCgj0gO+BoWmxYdeUp6tF/yyM09oRIl7bENAGncZCxnfZJmFzUtlhFtNykvj
	 Wy2HwpsRFFY/ctN5K179jpKqS0XiHmOeAJtIWVrdRtje5SzIVQtulq6ZkU7V0zw/nGGTj
	 2b75ukJZFmfzKyHTwMa5BfHB0o7M8lYtAueLLKjvJmEpoxtJv6DfS9ABbh4CYkQDg0vX7
	 /Bf1+7A7MGqdbIp+jKD7pnBqkhNmRqZEPm7Bacf5SC/rZL2lFg/+IS96Bq31lfzr0lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ttu6cxv2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B36B606A31C;
	Wed, 18 Nov 2026 21:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ttu6cxv2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923811F000C4;
	Wed, 18 Nov 2026 21:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037843;
	bh=fzXLei0qQJsH7NplUIEAkYTdTLb5GRvntqimVsvEtJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ttu6cxv27qyW5EftX1JP1uXzjzshi9pTG2jqgnSmcsHWVq9ijQLj+jq+qE0BtAQtm
	 M3h6CllRhu5htsu4hsEtgTBr5VuzqfLaT90+oD6awXj+lswD8b3nNSWoEkmbUvpLJZ
	 dab2fqYRKO7iFQIVd1OkKesVdcFRPh58L+yz1cIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 1537/3318] nvme-pci: add NVME_QUIRK_DMAPOOL_ALIGN_512 for KIOXIA XG10d
Date: Wed, 18 Nov 2026 15:35:59 +0100
Message-ID: <20261118150407.084653359@linuxfoundation.org>
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
index 33069ab67b8ea..931645a1a60ec 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3558,6 +3558,8 @@ static const struct pci_device_id nvme_id_table[] = {
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



