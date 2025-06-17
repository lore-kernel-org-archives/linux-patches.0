Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE504235071;
	Tue, 17 Jun 2025 16:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177221; cv=none; b=XqakCP1nn9Ii5a0baby6U3sghvyYHj3k2J2WGb8qUoFGnYu3NWCEN9ATRIEGVauNRc8zksorYxRXZfXvPSc4m3hbn8HjobF87X+u6BVOXAQyvQVtFhgXHDlJl08vduoRXSt7PpdyPPCQ/BNuCeSmr/AjGBh5lFx719WPvQTr7vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177221; c=relaxed/simple;
	bh=iGmbV3QRCoCJXo+u+37xJ1IW2iSD4ar4pLo/6yUS02E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=klFlKQwnNIEdy+SkKa7wbrGDh2/7EXB6xwuacug99DNpukMDQUyDCOXM0Zu4h0yXx7zAyWbbbuH3jdrligseWagDHkxpElAF9GPAhICUAPsxX6D8tyB4tweOWrgISiS4uY0Kfpjg/J1dmqjq2zYOGHb10ra0pMEDPznYnRNX/Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcB2nvPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcB2nvPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE4DC4CEE3;
	Tue, 17 Jun 2025 16:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177221;
	bh=iGmbV3QRCoCJXo+u+37xJ1IW2iSD4ar4pLo/6yUS02E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcB2nvPga/WMFMouSWYAKQxzf/APGBL7UyWmH6BsRHn4qSYcMRmwg/XikY7yD/Gkv
	 gWQkYsl45eCYkvvNQj+4HasxZfyXWEeWjiTlPv5spSIquAVlYu2627qhUILuAUZ/Te
	 bN5jD3gweYCoKY/CZKSCl2EXB5ByzkYOwhkOQ+gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 309/512] PCI: Print the actual delay time in pci_bridge_wait_for_secondary_bus()
Date: Tue, 17 Jun 2025 17:24:35 +0200
Message-ID: <20250617152432.126492462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

[ Upstream commit d24eba726aadf8778f2907dd42281c6380b0ccaa ]

Print the delay amount that pcie_wait_for_link_delay() is invoked with
instead of the hardcoded 1000ms value in the debug info print.

Fixes: 7b3ba09febf4 ("PCI/PM: Shorten pci_bridge_wait_for_secondary_bus() wait time for slow links")
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/20250414001505.21243-2-wilfred.opensource@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 25c07af1686b9..7ca5422feb2d4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4945,7 +4945,7 @@ int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type)
 		delay);
 	if (!pcie_wait_for_link_delay(dev, true, delay)) {
 		/* Did not train, no need to wait any further */
-		pci_info(dev, "Data Link Layer Link Active not set in 1000 msec\n");
+		pci_info(dev, "Data Link Layer Link Active not set in %d msec\n", delay);
 		return -ENOTTY;
 	}
 
-- 
2.39.5



