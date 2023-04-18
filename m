Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682EC2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0941C433EF;
	Tue, 18 Apr 2023 12:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821693;
	bh=epGCnMW6sFgCVMSCvbx6Bowa59U1HV4C68pnSn33TrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbzYN4ZueZp2HRdt3kXDNM76fLAaamw2e6T/wY3qEbN7l1gaP7efIOYhkgeiqmzoW
	 UMnNkRrRvOnhtIoaFQ3RAa+DbBDIRNcDHH+tSsr2wz2jD45BtjmVDpP1/Drvg/i20+
	 j9VXvQrm6PThbI/FXZSehvDBuCt/5o7VvgsTt6Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Reiter <stefan@pimaker.at>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 77/91] nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG GAMMIX S50
Date: Tue, 18 Apr 2023 14:22:21 +0200
Message-Id: <20230418120308.235538074@linuxfoundation.org>
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

From: Stefan Reiter <stefan@pimaker.at>

[ Upstream commit 3765fad508964f433ac111c127d6bedd19bdfa04 ]

ADATA XPG GAMMIX S50 drives report bogus eui64 values that appear to
be the same across drives in one system. Quirk them out so they are
not marked as "non globally unique" duplicates.

Signed-off-by: Stefan Reiter <stefan@pimaker.at>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 74391b3e6985 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 6539332b42b31..e0f0c9aa9391a 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3388,6 +3388,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1202),   /* MAXIO MAP1202 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1cc1, 0x5350),   /* ADATA XPG GAMMIX S50 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.39.2



