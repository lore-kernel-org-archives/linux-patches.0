Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534656FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDED1C433EF;
	Mon,  3 Apr 2023 14:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532375;
	bh=qiubIwvqJ+FOVR3QFU4MswI3mScH5L+kQPAC5pyQKDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UM1G6tx8S4b0wy7LzOvVHlrVdxudFd0i0J5qZhbfTsYkSu4p/lnPm4bIzUYPV/mwM
	 WJGTUe4/JtZtKzWKNyo9CJk5fUZXR06puAFoj5zpz7SaAlFh0JoSuPiurxE48kPkFo
	 C14oopUqJBZXcWlilSVFW5BpFxED3z61wEtBcmns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 59/99] bnxt_en: Fix typo in PCI id to device description string mapping
Date: Mon,  3 Apr 2023 16:09:22 +0200
Message-Id: <20230403140405.629116241@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 62aad36ed31abc80f35db11e187e690448a79f7d ]

Fix 57502 and 57508 NPAR description string entries.  The typos
caused these devices to not match up with lspci output.

Fixes: 49c98421e6ab ("bnxt_en: Add PCI IDs for 57500 series NPAR devices.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4e98e34fc46b5..4ef90e0cb8f8e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -223,12 +223,12 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0x1750), .driver_data = BCM57508 },
 	{ PCI_VDEVICE(BROADCOM, 0x1751), .driver_data = BCM57504 },
 	{ PCI_VDEVICE(BROADCOM, 0x1752), .driver_data = BCM57502 },
-	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57502_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0x1801), .driver_data = BCM57504_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57502_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57502_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0x1804), .driver_data = BCM57504_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57502_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57508_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0xd802), .driver_data = BCM58802 },
 	{ PCI_VDEVICE(BROADCOM, 0xd804), .driver_data = BCM58804 },
 #ifdef CONFIG_BNXT_SRIOV
-- 
2.39.2



