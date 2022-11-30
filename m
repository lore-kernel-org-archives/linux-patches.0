Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5979279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A435DC433C1;
	Wed, 30 Nov 2022 18:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833286;
	bh=Dx/JRLHBnP/KP931JmuIqKXx4TjyT17GNgZETmUH2oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQAA/p+BCNDmc+1bFlG5tGFq4iYCLHUOfzM21TFHwpY1mcluUc71FoQcU0jkTJKxR
	 qzdca74WJR6j51pHGpVIjBo/GSAkq+n+KbthycNFC9jQBa8Dm8vTCeJapgS3oNCAF2
	 YM+0XrpUOTwLwZYdjYL2tTdbfsX2+62gcsz5YxKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Savernik <l.savernik@aon.at>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/206] nvme: add a bogus subsystem NQN quirk for Micron MTFDKBA2T0TFH
Date: Wed, 30 Nov 2022 19:21:07 +0100
Message-Id: <20221130180533.386128055@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Savernik <l.savernik@aon.at>

[ Upstream commit 41f38043f884c66af4114a7109cf540d6222f450 ]

The Micron MTFDKBA2T0TFH device reports the same subsysem NQN for
all devices.  Add a quick to ignore it.

Signed-off-by: Leo Savernik <l.savernik@aon.at>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: d5ceb4d1c507 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for Micron Nitro")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e9f3701dda3f..4fa2955dbf6c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3351,6 +3351,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1cc1, 0x8201),   /* ADATA SX8200PNP 512GB */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	 { PCI_DEVICE(0x1344, 0x5407), /* Micron Technology Inc NVMe SSD */
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x15b7, 0x2001),   /*  Sandisk Skyhawk */
-- 
2.35.1



