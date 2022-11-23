Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE73F1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442ECC433D7;
	Wed, 23 Nov 2022 09:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196450;
	bh=VNiKRABtIMeIUh7oCOs21KW8F8F7jkA01llco3JUimo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHBOeHnw0WFTcmHhlOrLbcfd/36RgQcVYdIhFPzcyvNxRMI4VnZralt44ZSHpQeIy
	 VX4FHbhGXseaWPPKsBfcM2++uxGCc1xG9bPjKZ1Kp+oIAO87a8oI4xn1XtHDxdoDOW
	 glLNjZFzn1P4p6KDOJXy+ByhDE96jUA9/YWKMrVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Firas Jahjah <firasj@amazon.com>,
	Yossi Leybovich <sleybo@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 033/314] RDMA/efa: Add EFA 0xefa2 PCI ID
Date: Wed, 23 Nov 2022 09:47:58 +0100
Message-Id: <20221123084627.020093092@linuxfoundation.org>
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

From: Michael Margolin <mrgolin@amazon.com>

[ Upstream commit b75927cff13e0b3b652a12da7eb9a012911799e8 ]

Add support for 0xefa2 devices.

Reviewed-by: Firas Jahjah <firasj@amazon.com>
Reviewed-by: Yossi Leybovich <sleybo@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
Link: https://lore.kernel.org/r/20221020151949.1768-1-mrgolin@amazon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 94b94cca4870..15ee92081118 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
 /*
- * Copyright 2018-2021 Amazon.com, Inc. or its affiliates. All rights reserved.
+ * Copyright 2018-2022 Amazon.com, Inc. or its affiliates. All rights reserved.
  */
 
 #include <linux/module.h>
@@ -14,10 +14,12 @@
 
 #define PCI_DEV_ID_EFA0_VF 0xefa0
 #define PCI_DEV_ID_EFA1_VF 0xefa1
+#define PCI_DEV_ID_EFA2_VF 0xefa2
 
 static const struct pci_device_id efa_pci_tbl[] = {
 	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA0_VF) },
 	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA1_VF) },
+	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA2_VF) },
 	{ }
 };
 
-- 
2.35.1



