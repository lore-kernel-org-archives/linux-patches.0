Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1550E19BC9
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B333C433EF;
	Wed,  7 Jun 2023 20:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170560;
	bh=Ao7IWSDk1SN50uAgnaH1kOq9uEhjM14rY4f3Ua53Xi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vx4Bac7AUbUj/Bmpc2TC0e/ZG5LWdl2vp0webqjO6roDW/rkeDGewl0a/zpSX01iM
	 dDnhGeXvgC+40wFWz9NRfQ1J3pHPNaINm9IuIj0GuRdR0XgiBlM91ID7c+7mUE73Ij
	 c2rEZpGmTjqyj2b1Wrg6shUUJKTKfJqWyMk+B2gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Smith <dansmith@ds.gy>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/225] nvme-pci: Add quirk for Teamgroup MP33 SSD
Date: Wed,  7 Jun 2023 22:15:25 +0200
Message-ID: <20230607200918.690104503@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Smith <dansmith@ds.gy>

[ Upstream commit 0649728123cf6a5518e154b4e1735fc85ea4f55c ]

Add a quirk for Teamgroup MP33 that reports duplicate ids for disk.

Signed-off-by: Daniel Smith <dansmith@ds.gy>
[kch: patch formatting]
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
Tested-by: Daniel Smith <dansmith@ds.gy>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 1ec0ca40604aa..ba4903c86f7ff 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3558,6 +3558,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4b, 0x1602), /* HS-SSD-FUTURE 2048G  */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x10ec, 0x5765), /* TEAMGROUP MP33 2TB SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.39.2



