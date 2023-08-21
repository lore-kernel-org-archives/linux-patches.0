Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0348D1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F81CC433C7;
	Mon, 21 Aug 2023 20:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648199;
	bh=yN4jA6qeCAQHi+iVZZsIBQa5UK13ee8OgGN9MAI2eIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJChXBs1U0wkd7Klh8BotnSkFJWOdH+3SKKHCo5uIwaLamtHaH8Qts5vsS+dCEWhF
	 gr5IqENCipMb4igOSdG6BvXUj+SIb7QY+fPrFFS0jaWmAZOxZCYr6NRMQYng/Y1oVa
	 LGiJJKfbSAPTof4vQJMiWpnjM8erV26+spDwxrlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuechao Zhao <yuechao.zhao@advantech.com.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 063/234] watchdog: sp5100_tco: support Hygon FCH/SCH (Server Controller Hub)
Date: Mon, 21 Aug 2023 21:40:26 +0200
Message-ID: <20230821194131.556495076@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuechao Zhao <yuechao.zhao@advantech.com.cn>

[ Upstream commit 009637de1f65cff452ad49554d1e8ef9fda99e43 ]

Add PCI_VENDOR_ID_HYGON(Hygon vendor id [0x1d94]) in this driver

Signed-off-by: Yuechao Zhao <yuechao.zhao@advantech.com.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lkml.kernel.org/r/20230612031907.796461-1-a345351830@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/sp5100_tco.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 14f8d8d90920f..2bd3dc25cb030 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -96,7 +96,7 @@ static enum tco_reg_layout tco_reg_layout(struct pci_dev *dev)
 	    sp5100_tco_pci->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS &&
 	    sp5100_tco_pci->revision >= AMD_ZEN_SMBUS_PCI_REV) {
 		return efch_mmio;
-	} else if (dev->vendor == PCI_VENDOR_ID_AMD &&
+	} else if ((dev->vendor == PCI_VENDOR_ID_AMD || dev->vendor == PCI_VENDOR_ID_HYGON) &&
 	    ((dev->device == PCI_DEVICE_ID_AMD_HUDSON2_SMBUS &&
 	     dev->revision >= 0x41) ||
 	    (dev->device == PCI_DEVICE_ID_AMD_KERNCZ_SMBUS &&
@@ -579,6 +579,8 @@ static const struct pci_device_id sp5100_tco_pci_tbl[] = {
 	  PCI_ANY_ID, },
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_KERNCZ_SMBUS, PCI_ANY_ID,
 	  PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_HYGON, PCI_DEVICE_ID_AMD_KERNCZ_SMBUS, PCI_ANY_ID,
+	  PCI_ANY_ID, },
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, sp5100_tco_pci_tbl);
-- 
2.40.1



