Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FE01C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31409C433D6;
	Wed, 23 Nov 2022 09:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197207;
	bh=f7+Y1Su60DadOx7Yi1gZDAeMDqMViqK9sVmIWtyRw4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXXzcenLt+VuGZKa1ZcLZFBQZs0fxBcaFLaCdgVBvhof3qaGQ57eJMfajIFvunitW
	 q26WAaiIFlUd3immtnKWwZHblho4EtA+x/jdUVCzf3k29jt001jU0bm12E4NUisIdD
	 UUuG21KMuIPyBBhia3zDQCSLyQSAhI+v60jMqI3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiago Dias Ferreira <tiagodfer@gmail.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.0 228/314] nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV7000
Date: Wed, 23 Nov 2022 09:51:13 +0100
Message-Id: <20221123084635.848969886@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tiago Dias Ferreira <tiagodfer@gmail.com>

commit 8d6e38f636ac063e8062a21e7616f7d9bf0df5d8 upstream.

Added a quirk to fix the Netac NV7000 SSD reporting duplicate NGUIDs.

Cc: <stable@vger.kernel.org>
Signed-off-by: Tiago Dias Ferreira <tiagodfer@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3520,6 +3520,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x2646, 0x501E),   /* KINGSTON OM3PGP4xxxxQ OS21011 NVMe SSD */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x1f40, 0x5236),   /* Netac Technologies Co. NV7000 NVMe SSD */
+		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1001),   /* MAXIO MAP1001 */
 		.driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1e4B, 0x1002),   /* MAXIO MAP1002 */


