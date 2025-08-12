Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F3B2FD1A4;
	Tue, 12 Aug 2025 18:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024301; cv=none; b=IVY6rse1sAHonOVf/g8jw8oN7bMsI2CbJ97RWpHrijnIltwyt3A+JJ/tjTF0cXmSzNR8dNKiel8FPnl+ugAbkEJSXmcaPwsUcLkkVELz5JQaKkDOheR7gbMJnI3grYWdYCyxUxMm3ZSnjWyRl99VrRjaC0RS6mvz5bmSpCaiFBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024301; c=relaxed/simple;
	bh=g9GlF7MQJZxgxCTYRhNvNh9+H0p+1X4MI0OQ7mjgtPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IN6PYOyOA5h8QRAZXvQvf0aIRD142j+sQckqElkTttrIK0hoGSb78o3kiiGbOWsF1fI8dMrEf1BkCTBcIl/XEl8z6ZUiGMSck+nmNAY5EJ9Ag3e5Yt0ivKHvhSmT4G0DmzSe9hrn6NcToaXrO9VEgBRTO1tTqiYcsKl/zwiJuAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zp80QSJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zp80QSJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51278C4CEF0;
	Tue, 12 Aug 2025 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024301;
	bh=g9GlF7MQJZxgxCTYRhNvNh9+H0p+1X4MI0OQ7mjgtPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zp80QSJAjGei6se7RTwcry6IMHQBvOtiBdYixdNQ96AXpphL+SImS5TL8GPCkUJEb
	 1cohaETmYIctEZBm2wjOCB2QUiBt7x0aicTcyYMauf9y96kakq1HqozqkwR+FIOfJR
	 fpdaO7tjKGUGuI4k20jtSUkbBeoEU2wFmqBuQ2xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 332/627] PCI: Rename PCIE_RESET_CONFIG_DEVICE_WAIT_MS to PCIE_RESET_CONFIG_WAIT_MS
Date: Tue, 12 Aug 2025 19:30:27 +0200
Message-ID: <20250812173431.919586382@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 817f989700fddefa56e5e443e7d138018ca6709d ]

Rename PCIE_RESET_CONFIG_DEVICE_WAIT_MS to PCIE_RESET_CONFIG_WAIT_MS.

Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250625102347.1205584-10-cassel@kernel.org
Stable-dep-of: c7eb9c5e1498 ("PCI: dw-rockchip: Wait PCIE_RESET_CONFIG_WAIT_MS after link-up IRQ")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/plda/pcie-starfive.c | 2 +-
 drivers/pci/pci.h                           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/plda/pcie-starfive.c b/drivers/pci/controller/plda/pcie-starfive.c
index e73c1b7bc8ef..3caf53c6c082 100644
--- a/drivers/pci/controller/plda/pcie-starfive.c
+++ b/drivers/pci/controller/plda/pcie-starfive.c
@@ -368,7 +368,7 @@ static int starfive_pcie_host_init(struct plda_pcie_rp *plda)
 	 * of 100ms following exit from a conventional reset before
 	 * sending a configuration request to the device.
 	 */
-	msleep(PCIE_RESET_CONFIG_DEVICE_WAIT_MS);
+	msleep(PCIE_RESET_CONFIG_WAIT_MS);
 
 	if (starfive_pcie_host_wait_for_link(pcie))
 		dev_info(dev, "port link down\n");
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 12215ee72afb..98d6fccb383e 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -61,7 +61,7 @@ struct pcie_tlp_log;
  *    completes before sending a Configuration Request to the device
  *    immediately below that Port."
  */
-#define PCIE_RESET_CONFIG_DEVICE_WAIT_MS	100
+#define PCIE_RESET_CONFIG_WAIT_MS	100
 
 /* Message Routing (r[2:0]); PCIe r6.0, sec 2.2.8 */
 #define PCIE_MSG_TYPE_R_RC	0
-- 
2.39.5



