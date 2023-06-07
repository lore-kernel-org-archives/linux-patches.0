Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E947A10FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69014C4339B;
	Wed,  7 Jun 2023 20:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169519;
	bh=VFjO42l3luArZ4psdOiK4HwyLgEcsNzr91BCbnzwSXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jH/NzojfrsW/C7xupM6dj1niUkAimGDo4mnpOxaMvYw84OFxqXELfmP4S3tIiUjXm
	 K13HBSZNLHdzbobkCndVIV2rw09nVywYEpgNOPXtjTjYrs2qKLdEeQOZALJ2Jx904c
	 8GSZ9Hmkl76tVpqnXpdMCPGqYzGFIprsM/pAFXjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey God <andreygod83@protonmail.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 112/286] nvme-pci: add NVME_QUIRK_BOGUS_NID for HS-SSD-FUTURE 2048G
Date: Wed,  7 Jun 2023 22:13:31 +0200
Message-ID: <20230607200926.741831975@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 1616d6c3717bae9041a4240d381ec56ccdaafedc ]

Add a quirk to fix HS-SSD-FUTURE 2048G SSD drives reporting duplicate
nsids.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217384
Reported-by: Andrey God <andreygod83@protonmail.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index cd7873de31215..bbf96567365cd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3445,6 +3445,8 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x10ec, 0x5763), /* TEAMGROUP T-FORCE CARDEA ZERO Z330 SSD */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
+	{ PCI_DEVICE(0x1e4b, 0x1602), /* HS-SSD-FUTURE 2048G  */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0061),
 		.driver_data = NVME_QUIRK_DMA_ADDRESS_BITS_48, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMAZON, 0x0065),
-- 
2.39.2



