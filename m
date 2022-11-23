Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415D71C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7815C433B5;
	Wed, 23 Nov 2022 09:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197204;
	bh=NZ9Inb07yjO1KPDxMKA60xvWbluxDgPha8pzpTQYxKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kPJgmgTBrtXgPA/R9w53MShwjjivNPf93LqkuUorwq4afosffuj5NgKux4xRTKQe
	 yiQmx/F8TkLy9eIn4r1CxgNllUQBJ5LSx8PnBTgMfFj6Yebn8Q29zwOherKBfxxrcM
	 wc3o2i3kaetToNz7MWkk23CN6F+AYaBtLJZKUUcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.0 227/314] nvme-pci: add NVME_QUIRK_BOGUS_NID for Micron Nitro
Date: Wed, 23 Nov 2022 09:51:12 +0100
Message-Id: <20221123084635.808188017@linuxfoundation.org>
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

From: Bean Huo <beanhuo@micron.com>

commit d5ceb4d1c50786d21de3d4b06c3f43109ec56dd8 upstream.

Added a quirk to fix Micron Nitro NVMe reporting duplicate NGUIDs.

Cc: <stable@vger.kernel.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3488,6 +3488,8 @@ static const struct pci_device_id nvme_i
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	 { PCI_DEVICE(0x1344, 0x5407), /* Micron Technology Inc NVMe SSD */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN },
+	 { PCI_DEVICE(0x1344, 0x6001),   /* Micron Nitro NVMe */
+		 .driver_data = NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1c5c, 0x174a),   /* SK Hynix P31 SSD */


