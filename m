Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09DE3090C7;
	Mon, 13 Oct 2025 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369441; cv=none; b=SbQ2bsZblCUxg0xHoopYr/+gJzQwLxH96IjWq/DiuQDvqcAAzNV/xpTFNZCAFt3wQ3SSdctiAE5rEXu1nyPPCdJDBR6nY3s5xXI1Wkoj0wBc0sfyveOTFy35ywjBI7IdT1G85YFVxvhkt/km16bJ7v86MpoyB65NObxnvTkL3tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369441; c=relaxed/simple;
	bh=a9V3mCyTnwjfRZDVuLF2N/3vcCo7eBySlfBPjMBBJLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6BDcbrCupRLcBNW4vKd5AXRTPMG1wrNMUAUrbW+M4X9xgqrnjr17tS3Kt1ohc2b3MM/ol8p5z51trMMyglIGji231gn0TF1IURRviQSqMhQhzvh+OtD39ZgSyJ1mnpG8q0tgSEfVYf/n5Fw4ycWAn4oc6Ts/4EtGt7p47fSDWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vldIE8o/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vldIE8o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE26C4CEE7;
	Mon, 13 Oct 2025 15:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369441;
	bh=a9V3mCyTnwjfRZDVuLF2N/3vcCo7eBySlfBPjMBBJLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vldIE8o/d+ZlT45WADAmyCzUlQA6qm6yrxrZvvOEXLLsBJEDb+PAjK+1X0ki8Qaox
	 uLMf6P7VX+wjiqxeVD6jwYl6HWJAoo1i5O1oNBCLQUuT8CjNlyaZvFP7BT+WINqnbE
	 UaCqajziRXRqbLXzOuO4yqcadyTvXnnP9rf5OhmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Igor Pylypiv <ipylypiv@google.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 248/563] scsi: pm80xx: Use dev_parent_is_expander() helper
Date: Mon, 13 Oct 2025 16:41:49 +0200
Message-ID: <20251013144420.267720020@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 35e388696c3f3b6bf70e2010873c5e0c1d37d579 ]

Make use of the dev_parent_is_expander() helper.

Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250814173215.1765055-19-cassel@kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ad70c6bc776b ("scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an expander")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 8 +++-----
 drivers/scsi/pm8001/pm8001_sas.c | 5 ++---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++-----
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 42a4eeac24c94..fb4913547b00f 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2163,8 +2163,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	/* Print sas address of IO failed device */
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
 		(status != IO_UNDERFLOW)) {
-		if (!((t->dev->parent) &&
-			(dev_is_expander(t->dev->parent->dev_type)))) {
+		if (!dev_parent_is_expander(t->dev)) {
 			for (i = 0, j = 4; j <= 7 && i <= 3; i++, j++)
 				sata_addr_low[i] = pm8001_ha->sas_addr[j];
 			for (i = 0, j = 0; j <= 3 && i <= 3; i++, j++)
@@ -4168,7 +4167,6 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	u16 firstBurstSize = 0;
 	u16 ITNT = 2000;
 	struct domain_device *dev = pm8001_dev->sas_device;
-	struct domain_device *parent_dev = dev->parent;
 	struct pm8001_port *port = dev->port->lldd_port;
 
 	memset(&payload, 0, sizeof(payload));
@@ -4186,8 +4184,8 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
-		phy_id = parent_dev->ex_dev.ex_phy->phy_id;
+	if (dev_parent_is_expander(dev))
+		phy_id = dev->parent->ex_dev.ex_phy->phy_id;
 	else
 		phy_id = pm8001_dev->attached_phy;
 	opc = OPC_INB_REG_DEV;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 3e1dac4b820fe..2bdeace6c6bfe 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -700,7 +700,7 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
 	dev->lldd_dev = pm8001_device;
 	pm8001_device->dev_type = dev->dev_type;
 	pm8001_device->dcompletion = &completion;
-	if (parent_dev && dev_is_expander(parent_dev->dev_type)) {
+	if (dev_parent_is_expander(dev)) {
 		int phy_id;
 
 		phy_id = sas_find_attached_phy_id(&parent_dev->ex_dev, dev);
@@ -749,7 +749,6 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 	unsigned long flags = 0;
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
-	struct domain_device *parent_dev = dev->parent;
 
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
@@ -771,7 +770,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 		 * The phy array only contains local phys. Thus, we cannot clear
 		 * phy_attached for a device behind an expander.
 		 */
-		if (!(parent_dev && dev_is_expander(parent_dev->dev_type)))
+		if (!dev_parent_is_expander(dev))
 			pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index c1bae995a4128..546d0d26f7a17 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2340,8 +2340,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha,
 	/* Print sas address of IO failed device */
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
 		(status != IO_UNDERFLOW)) {
-		if (!((t->dev->parent) &&
-			(dev_is_expander(t->dev->parent->dev_type)))) {
+		if (!dev_parent_is_expander(t->dev)) {
 			for (i = 0, j = 4; i <= 3 && j <= 7; i++, j++)
 				sata_addr_low[i] = pm8001_ha->sas_addr[j];
 			for (i = 0, j = 0; i <= 3 && j <= 3; i++, j++)
@@ -4780,7 +4779,6 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	u16 firstBurstSize = 0;
 	u16 ITNT = 2000;
 	struct domain_device *dev = pm8001_dev->sas_device;
-	struct domain_device *parent_dev = dev->parent;
 	struct pm8001_port *port = dev->port->lldd_port;
 
 	memset(&payload, 0, sizeof(payload));
@@ -4799,8 +4797,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 			dev_is_expander(pm8001_dev->dev_type))
 			stp_sspsmp_sata = 0x01; /*ssp or smp*/
 	}
-	if (parent_dev && dev_is_expander(parent_dev->dev_type))
-		phy_id = parent_dev->ex_dev.ex_phy->phy_id;
+	if (dev_parent_is_expander(dev))
+		phy_id = dev->parent->ex_dev.ex_phy->phy_id;
 	else
 		phy_id = pm8001_dev->attached_phy;
 
-- 
2.51.0



