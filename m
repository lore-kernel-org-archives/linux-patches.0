Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F66979C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BD7C433D6;
	Wed, 30 Nov 2022 18:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833235;
	bh=+5UgjmHzDMCUgjCTNTZ9rCitNZotq/ZNj2ltOhrj0UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVRh9Lmon2JzdrFBwZ+lKBellrUQ31zjCPGyUWsuti8fPheFAoaQP9QXZ4FJwNwek
	 0IfySwqjnn/d4c2rBj91vDFyA2ULtOebxWno+zFE40R2oe4a9EFKO64+k2SY75hgLS
	 /vGsxzCewuK/aigD302jMdMvgoDzrdibRrc/RBG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arman Hajishafieha <arman.hajishafieha@hotmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 017/206] nvme-pci: disable namespace identifiers for the MAXIO MAP1001
Date: Wed, 30 Nov 2022 19:21:09 +0100
Message-Id: <20221130180533.435872651@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 70ce3455345d056b5fc427c3bb4a3ff4d126b6d5 ]

The MAXIO MAP1001 controllers reports completely bogus Namespace
identifiers that even change after suspend cycles.  Disable using
the Identifiers entirely.

Reported-by: Arman Hajishafieha <arman.hajishafieha@hotmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Arman Hajishafieha <arman.hajishafieha@hotmail.com>
Stable-dep-of: 8d6e38f636ac ("nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV7000")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 278302771841..66e252af9218 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3365,6 +3365,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
+	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1002),   /* MAXIO MAP1002 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1202),   /* MAXIO MAP1202 */
-- 
2.35.1



