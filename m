Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C00646;
	Tue,  3 Dec 2024 15:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239097; cv=none; b=dj117S/gEodDwtRsX6v23rRugU9HyWnbrqkcCh1Yw9eOQwccnu0XvM30NlARV6Djh/We4+fZdCAATU+m5vGdxz/UeSQHRfAtedC0Ln4VnnE+FtfE7PIjvx3zKN2W0qCuhIgQ5GvEJ6xPU1qiVOHl0+P3u9OpcD27odbN7js4TPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239097; c=relaxed/simple;
	bh=/a+p0kB74e5P4KezyJErXtX9fjbuQBX8e7Bo3sG4UJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OLulfo1De07XLu671TEwKdn4AS7Kvg6PJhs0rrAsHvQzDGSMEHwWgIBOQ/W3h3VcCs3R0SCD6xnA1Nj9kcYiP2yVqEQShn4AwMF6hdl0HGsjoulXsH84VClvndKBiyoXvuoubdJurQJPrQt6Gt7E79KA6f0PUTdNBl0LZy10zXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMykYWpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMykYWpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEECC4CECF;
	Tue,  3 Dec 2024 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239097;
	bh=/a+p0kB74e5P4KezyJErXtX9fjbuQBX8e7Bo3sG4UJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMykYWpOwTJzwHi27DnG1cJqsNampJ81Tm9ULfKDH8iTvgmZbW7ZdniGLUsQa8esx
	 uJnl1xAnD5xdN0LTR+pMl5RoES+b6UMRzxwUv6SC6eBcN3WYZfYTvuKM3AY53j9Lha
	 lg/uf8sFBwV3gm8psmef61kN4aK5MccBwMq/RxGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	weiyufeng <weiyufeng@kylinos.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 501/817] PCI: cpqphp: Use PCI_POSSIBLE_ERROR() to check config reads
Date: Tue,  3 Dec 2024 15:41:13 +0100
Message-ID: <20241203144015.430419157@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: weiyufeng <weiyufeng@kylinos.cn>

[ Upstream commit 87d5403378cccc557af9e02a8a2c8587ad8b7e9a ]

Use PCI_POSSIBLE_ERROR() to check the response we get when we read data
from hardware.  This unifies PCI error response checking and makes error
checks consistent and easier to find.

Link: https://lore.kernel.org/r/20240806065050.28725-1-412574090@163.com
Signed-off-by: weiyufeng <weiyufeng@kylinos.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: e2226dbc4a49 ("PCI: cpqphp: Fix PCIBIOS_* return value confusion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/cpqphp_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index e9f1fb333a718..718bc6cf12cb3 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -138,7 +138,7 @@ static int PCI_RefinedAccessConfig(struct pci_bus *bus, unsigned int devfn, u8 o
 
 	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &vendID) == -1)
 		return -1;
-	if (vendID == 0xffffffff)
+	if (PCI_POSSIBLE_ERROR(vendID))
 		return -1;
 	return pci_bus_read_config_dword(bus, devfn, offset, value);
 }
@@ -253,7 +253,7 @@ static int PCI_GetBusDevHelper(struct controller *ctrl, u8 *bus_num, u8 *dev_num
 			*dev_num = tdevice;
 			ctrl->pci_bus->number = tbus;
 			pci_bus_read_config_dword(ctrl->pci_bus, *dev_num, PCI_VENDOR_ID, &work);
-			if (!nobridge || (work == 0xffffffff))
+			if (!nobridge || PCI_POSSIBLE_ERROR(work))
 				return 0;
 
 			dbg("bus_num %d devfn %d\n", *bus_num, *dev_num);
-- 
2.43.0



