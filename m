Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0881ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079C8C433C8;
	Tue, 25 Jul 2023 11:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284573;
	bh=4OOsQUp3bPzcAklVGfXwhL/65/jhre1NfMusWXH1HiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMu1aHQHvhSvmxRWo49M1v2Zvkv9bdMV5mhrKEiIb0i5EZ3MDf6V2Nri3ftSmSjTo
	 v4QK1gm3RR4KL9VAFGGcB6UHnEWRBMM0OE7kITvwtjZEJ/0jbTHlH0AQwr1dDVoPPQ
	 oFqg4f9N/Kk7GwUGwjPQ0xrnfBFrPhGFE+DSsJ18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Rick Wertenbroek <rick.wertenbroek@gmail.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 5.10 403/509] PCI: rockchip: Set address alignment for endpoint mode
Date: Tue, 25 Jul 2023 12:45:42 +0200
Message-ID: <20230725104612.182875795@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <dlemoal@kernel.org>

commit 7e6689b34a815bd379dfdbe9855d36f395ef056c upstream.

The address translation unit of the rockchip EP controller does not use
the lower 8 bits of a PCIe-space address to map local memory. Thus we
must set the align feature field to 256 to let the user know about this
constraint.

Link: https://lore.kernel.org/r/20230418074700.1083505-12-rick.wertenbroek@gmail.com
Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -485,6 +485,7 @@ static const struct pci_epc_features roc
 	.linkup_notifier = false,
 	.msi_capable = true,
 	.msix_capable = false,
+	.align = 256,
 };
 
 static const struct pci_epc_features*


