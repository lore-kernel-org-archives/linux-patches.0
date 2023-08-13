Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109259446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439E5C433C8;
	Sun, 13 Aug 2023 21:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962472;
	bh=gSrfnqz/OjqO75BDBSotY+LJ7X7F2I4cnsVPdRlBE58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6ijhxxRHs4bzSp+wjvyCalg6h4ycxBPPLYsAaMlAsnaMDq2iHsxQCS3rJLFYb020
	 4j546bu7zDGP4js+tDHreaTZhHszCDJdZP0lbcTP3kmo7/V/2T2TyVI5BaenivlLTJ
	 zwQONreyGC9VZ+1D3rwAinSwhi6ZH6hXjDqlwCU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	August Wikerfors <git@augustwikerfors.se>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 024/149] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung PM9B1 256G and 512G
Date: Sun, 13 Aug 2023 23:17:49 +0200
Message-ID: <20230813211719.522079303@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: August Wikerfors <git@augustwikerfors.se>

commit 688b419c57c13637d95d7879e165fff3dec581eb upstream.

The Samsung PM9B1 512G SSD found in some Lenovo Yoga 7 14ARB7 laptop units
reports eui as 0001000200030004 when resuming from s2idle, causing the
device to be removed with this error in dmesg:

nvme nvme0: identifiers changed for nsid 1

To fix this, add a quirk to ignore namespace identifiers for this device.

Signed-off-by: August Wikerfors <git@augustwikerfors.se>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3504,7 +3504,8 @@ static const struct pci_device_id nvme_i
 	{ PCI_DEVICE(0x1d97, 0x2263),   /* SPCC */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x144d, 0xa80b),   /* Samsung PM9B1 256G and 512G */
-		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES |
+				NVME_QUIRK_BOGUS_NID, },
 	{ PCI_DEVICE(0x144d, 0xa809),   /* Samsung MZALQ256HBJD 256G */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1cc4, 0x6303),   /* UMIS RPJTJ512MGE1QDY 512G */


