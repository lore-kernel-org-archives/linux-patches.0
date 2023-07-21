Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC04520F98
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB4FC433C8;
	Fri, 21 Jul 2023 19:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966821;
	bh=4OOsQUp3bPzcAklVGfXwhL/65/jhre1NfMusWXH1HiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aB2yX2IcjU4xnLzylXX0ioevN67ewplkhvf4vDpW9k4W1EXWNhICbI1aexSuxNF+u
	 HCB/dj1sWbe8Co9JyKts0n/2ef1QoBkhXCGwNEZBig9PRg6aS5Y8pvWPyLJF01LkE0
	 /hJlMEF9iQ9HDbsv6AnPkbClCHhDJDsvjSPRn36Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Rick Wertenbroek <rick.wertenbroek@gmail.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH 5.15 480/532] PCI: rockchip: Set address alignment for endpoint mode
Date: Fri, 21 Jul 2023 18:06:24 +0200
Message-ID: <20230721160640.544264046@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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


