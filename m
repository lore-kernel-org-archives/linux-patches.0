Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E159443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:27:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B720C433C7;
	Sun, 13 Aug 2023 21:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962036;
	bh=cnmWMrRr6lUCBR/pIbwAV2ET9T95iL1Fg41LRw2lKCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYRKRwvt8cRvTXBkwYg9F7s/fsthuWLPw6+KhpMLH5D0onVbAS5lTrEiwzTPhT3zh
	 uP36Rcz9PR2GYalxfHZTqvjfxsDuJyZcwuByjIwMYybeT791X4K9zrlAJoJ2YRs0wQ
	 /cKwCobmsfO9qtrw8bSVysm3mYvXjQ76cbz2be2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.4 088/206] Revert "PCI: mvebu: Mark driver as BROKEN"
Date: Sun, 13 Aug 2023 23:17:38 +0200
Message-ID: <20230813211727.596879822@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bjorn Helgaas <bhelgaas@google.com>

commit 3bfc37d92687b4b19056998cebc02f94fbc81427 upstream.

b3574f579ece ("PCI: mvebu: Mark driver as BROKEN") made it impossible to
enable the pci-mvebu driver.  The driver does have known problems, but as
Russell and Uwe reported, it does work in some configurations, so removing
it broke some working setups.

Revert b3574f579ece so pci-mvebu is available.

Reported-by: Russell King (Oracle) <linux@armlinux.org.uk>
Link: https://lore.kernel.org/r/ZMzicVQEyHyZzBOc@shell.armlinux.org.uk
Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230804134622.pmbymxtzxj2yfhri@pengutronix.de
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pci/controller/Kconfig
+++ b/drivers/pci/controller/Kconfig
@@ -179,7 +179,6 @@ config PCI_MVEBU
 	depends on MVEBU_MBUS
 	depends on ARM
 	depends on OF
-	depends on BROKEN
 	select PCI_BRIDGE_EMUL
 	help
 	 Add support for Marvell EBU PCIe controller. This PCIe controller


