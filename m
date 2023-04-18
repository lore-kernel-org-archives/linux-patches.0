Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1B72572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F6FC433EF;
	Tue, 18 Apr 2023 12:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821648;
	bh=aqoVOBLFiDb8wOzpHvZKDjKnkUUNR2bQyHm2iNktGZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s19PypT73Z7eAbVv3i+zri5GQGLqPU+ufxIG3WDkX1nmTdPtj6aJA/zJ50YmT9/R6
	 DOF9wyWZ8BVMGLtDbyRMI6fYUqAm1/sb08qrQWiGSJD4e5Ny1zOUUTYv+IR0zPeG47
	 pA2IokV72ZoKlaN4OCSKUqoff4JtKXlK3OxYKxCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhijit <abhijit@abhijittomar.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 81/91] nvme-pci: add NVME_QUIRK_BOGUS_NID for Lexar NM760
Date: Tue, 18 Apr 2023 14:22:25 +0200
Message-Id: <20230418120308.367421414@linuxfoundation.org>
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

From: Abhijit <abhijit@abhijittomar.com>

[ Upstream commit 80b2624094c8d369a3c6eab515e8f1564d2e5db2 ]

Add a quirk to fix Lexar NM760 SSD drives reporting duplicate nsids.

Signed-off-by: Abhijit <abhijit@abhijittomar.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 74391b3e6985 ("nvme-pci: add NVME_QUIRK_BOGUS_NID for T-FORCE Z330 SSD")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4023cce17cf8b..308dda1e4cb58 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3396,6 +3396,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1d97, 0x2263), /* Lexar NM610 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1d97, 0x2269), /* Lexar NM760 */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.39.2



