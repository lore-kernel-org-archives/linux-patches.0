Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B2A2135A0;
	Tue, 17 Jun 2025 16:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178598; cv=none; b=GPHZLd41xqSmU87hI7idzqFvqpMxTtmFdpVoLbGsiY9QqwtonNzhJ9tKO9Wbo8RyuXtb5+JwHTHQ0puxRouSoLM8nkJ/M3ZigYGxcYorQs74ykfDWERxH2G4jChQ3NUz7kVzW3dISAOlNEVNaChgyUjeX0DM+JxdiePn6HbcMxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178598; c=relaxed/simple;
	bh=Oo80URvaSgBkFWSqPOHKy/Zw7o3SHoJv4yo65cgFkvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JRMB+m4z1QQm+HtCzp5robiimWhUOCUIuQPCEH3fqdj4bM7kmISfwLRdB9KOLk1FCRQLgL/c8fTGqOTxuESmYjNUOY+vL4Ey8MhI1YQYOR8JSJ62yJQGZNJUdrXajjSKFCWjfOfTVEpVMnzK5TEuuygdH8w8vfCo2mUZc+B2aIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wi0ejpSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wi0ejpSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4ECC4CEE3;
	Tue, 17 Jun 2025 16:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178598;
	bh=Oo80URvaSgBkFWSqPOHKy/Zw7o3SHoJv4yo65cgFkvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wi0ejpSdRpbAsVpygA4ms0zBfWkl2pXNdxy3c/UhMAky3B+AXVpnW9iZVKhmrP0sN
	 Mow5j7jXk4ak8mJfXqnvV8YH3lP/gCXO1MHdkZrBcqkBV4yv9AawZAL8/A/qBgGE1n
	 +1QqupH48uQs8/xiVWATZSjju1EVJuOGYZ2OU2B8=
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
Subject: [PATCH 6.15 495/780] PCI: Print the actual delay time in pci_bridge_wait_for_secondary_bus()
Date: Tue, 17 Jun 2025 17:23:23 +0200
Message-ID: <20250617152511.652788611@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index e77d5b53c0cec..4d84ed4124844 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4954,7 +4954,7 @@ int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type)
 		delay);
 	if (!pcie_wait_for_link_delay(dev, true, delay)) {
 		/* Did not train, no need to wait any further */
-		pci_info(dev, "Data Link Layer Link Active not set in 1000 msec\n");
+		pci_info(dev, "Data Link Layer Link Active not set in %d msec\n", delay);
 		return -ENOTTY;
 	}
 
-- 
2.39.5



