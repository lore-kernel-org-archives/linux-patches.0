Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0ED63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26155C4339B;
	Mon, 20 Feb 2023 13:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900840;
	bh=TXbY8fDjGP/B03F/arkzREE5WK0zH8dzFLt0hzG0tD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNFxPqnyorez8s/EkRCqa+GGpy7cm6Q4U+oi8XUMmJIZngIAk8Aht69/cWjjXS4/l
	 rqYiM7m7XXQu8ONa3icBi0acYLvST/x/tVZgMsqP0Fra0nyigwSBJjAoLUNQcevWkd
	 DPF5+8iFOmWyXSGh+tn2v2unbWIbivhtfDoSed3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Gwendal Grignou <gwendal@chromium.org>
Subject: [PATCH 5.4 088/156] nvme-pci: Move enumeration by class to be last in the table
Date: Mon, 20 Feb 2023 14:35:32 +0100
Message-Id: <20230220133606.091480110@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 0b85f59d30b91bd2b93ea7ef0816a4b7e7039e8c upstream.

It's unusual that we have enumeration by class in the middle of the table.
It might potentially be problematic in the future if we add another entry
after it.

So, move class matching entry to be the last in the ID table.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3199,7 +3199,6 @@ static const struct pci_device_id nvme_i
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
-	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
@@ -3209,6 +3208,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_SINGLE_VECTOR |
 				NVME_QUIRK_128_BYTES_SQES |
 				NVME_QUIRK_SHARED_TAGS },
+
+	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, nvme_id_table);


