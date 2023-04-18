Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B762572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB4DC433D2;
	Tue, 18 Apr 2023 12:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821642;
	bh=tA4Tw6Ea+ZlkCbD/ldWcpM2m3bNZNkGF79eHyq/KUBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NT7i8eSk4q1VSKkDhqpGDr/83qmHel6p9fk4gENw8cV1NxkyXTo3ZccpgPNIjwbIa
	 hB9jwa2U9+OFOT3iRL+QWFbcsP4izRZc78gYYAptVG+HTZrKPQvUbgw9uf45RxdJIW
	 rg+YDv7daaOIJkPhMsBE4N00AhGYZEJ+O2Z0P98E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Gruetzmacher <tobias-git@23.gs>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 79/91] nvme-pci: Crucial P2 has bogus namespace ids
Date: Tue, 18 Apr 2023 14:22:23 +0200
Message-Id: <20230418120308.294219156@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tobias Gruetzmacher <tobias-git@23.gs>

[ Upstream commit d6c52fa3e955b97f8eb3ac824d2a3e0af147b3ce ]

This adds a quirk for the Crucial P2.

Signed-off-by: Tobias Gruetzmacher <tobias-git@23.gs>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 74391b3e6985 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 7b0331848664d..4e75d329562fa 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3392,6 +3392,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e49, 0x0041),   /* ZHITAI TiPro7000 NVMe SSD */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0xc0a9, 0x540a),   /* Crucial P2 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.39.2



