Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062370;
	b=GIjsm+zx1MhIy+M1AjaHSwwf/rUzVGTuFsBkdNmpnmx1djKtuhjZx3u8GIXtcKNAjWLh
	 OYulp/Bs3guwlEQevGfoYl/bH1oS+bPH1HObHE4jvg9ds1qlrQHNP4/aH59dC14JrM/UM
	 NY99CzwWCx8gG4csAgfP/zwt/sLZkrznQVfn3oaq8buf5wnbQmR9EVO/wapM31XCyj8zN
	 +Vxf+ZrAe3TOblCwf5XagLBC9rg2H6FLr/gx4vdZr6wk10XEbETBidts3yJnYBLq/ilrH
	 jZbXksFt+xrQz2V3jjrCcsTEC3082rS8uLSIthodj0UL8tqA0H6t+p8WlGrohtysckw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0KGUfiwTxUon+ZG8YfyVZWeqaV9uJkfxHj31q7vwbVw=;
	b=bwO0cr1/fplziIeE+Mu5B2jxtUcRqQDu9jir8DDCxQcN9XCdpCQlJJhqBbZc/Hj74Sbi
	 gYnkHzoIDdvgbdDeB+Ug59QwZZcTf5xNGQyR6ZvVXY4gPt3MpoYGWd6r9ydSIpp7JqSLP
	 7gOnnhrnXkYaw3xfGyrUuEM+705y3qU/2raCoVWF/GwE/6RfJ6BR5ELjZzd5LKa4cpEi5
	 DMiDPeoBSqGByNbLM8+lFQjf8AquiVCbuuB4nPXkE5iNLbehiNNwsv5ADNcULXV3W8mLB
	 rUIxdAeSiysx7EPdYm3BMn7DWqu4613dFzXNGwMDiJrmnWghw/OYZLsFEezJXpIxiuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoPmGaS2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6532B606D838;
	Sat,  7 Nov 2026 14:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GoPmGaS2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138271F0089F;
	Sat,  7 Nov 2026 14:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062370;
	bh=0KGUfiwTxUon+ZG8YfyVZWeqaV9uJkfxHj31q7vwbVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GoPmGaS2EAuuDdflDftzX6HGOGmSo3cAJJa9RgZLjPv73ttBe6ddDVKBIGeQ3txbj
	 S9RImGSSqePn0mrUVujWicl3J0k8sTajtBU9IZM1ifQRZEZIiAGH5IdnOXCpDYfDnp
	 3uHHTjn3iv2MC6BIFNjhJObLY7e3+bDEVA75flJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stian Halseth <stian@itx.no>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Tony Rodriguez <unixpro1970@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1295/1536] PCI: Set supported_speeds in set_pcie_port_type()
Date: Sat,  7 Nov 2026 08:55:11 -0500
Message-ID: <20261107135034.164128834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stian Halseth <stian@itx.no>

[ Upstream commit 926767a9be8866d26cc27ca46c46c03d921e2193 ]

sparc64 and powerpc create PCI devices from the device tree in
of_create_pci_dev(), which calls set_pcie_port_type() but not
pci_setup_device(). Since d2bd39c0456b, supported_speeds is only set in
pci_setup_device(), so it stays 0 for these devices.

pcie_get_speed_cap() then returns PCI_SPEED_UNKNOWN, the sysfs
'max_link_speed' attribute reads "Unknown", and the failed link retraining
quirk passes PCI_SPEED_UNKNOWN to pcie_set_target_speed(), which warns on a
SPARC T7-1:

  WARNING: drivers/pci/pcie/bwctrl.c:125 at pcie_set_target_speed+0x284/0x2e0

Set supported_speeds in set_pcie_port_type(), which all three paths call.

Fixes: d2bd39c0456b ("PCI: Store all PCIe Supported Link Speeds")
Closes: https://github.com/sparclinux/issues/issues/109
Signed-off-by: Stian Halseth <stian@itx.no>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tony Rodriguez <unixpro1970@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261007131304.309511-1-stian@itx.no
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/probe.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 718293b4bdb98..5ff2ad01235c4 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1596,6 +1596,8 @@ void set_pcie_port_type(struct pci_dev *pdev)
 		pdev->aspm_l1_support = 1;
 #endif
 
+	pdev->supported_speeds = pcie_get_supported_speeds(pdev);
+
 	parent = pci_upstream_bridge(pdev);
 	if (!parent)
 		return;
@@ -1981,9 +1983,6 @@ int pci_setup_device(struct pci_dev *dev)
 
 	set_pcie_untrusted(dev);
 
-	if (pci_is_pcie(dev))
-		dev->supported_speeds = pcie_get_supported_speeds(dev);
-
 	/* "Unknown power state" */
 	dev->current_state = PCI_UNKNOWN;
 
-- 
2.53.0



