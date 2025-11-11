Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0312561A7;
	Tue, 11 Nov 2025 01:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822858; cv=none; b=JvOXXkC4iOp0Yd+4mkANOuPoswaa1yNdvOxCztEycjjCisBaTUHG2rWRde17MIYxk7E1veRCopkgpJhUSwHnTSS8yoR123s4ta72BcSu8CmqFZkxmAQAQACwk6Z+QX22/B5YuGYQgJttEL1oMOACz3zFwbI3/rhkhd1pDByNJmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822858; c=relaxed/simple;
	bh=x/G3BlYRxLbXUK+iRXl+mOHZfPg56RAe4dyKOxkhJIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhrxeFKAKkYzYackpbIUysQ1QMqzcWuTfNsVbujVdwuY0eVLCH2WO7SMsjA4mLjnKUAJSQgsxdcrVvDQjK5zFsUKmc4JEcNpD0zia+91xPBNx5/K3AizAHFZSZBnvdS6KMTxDNn4JqaaRRAgM58IQyEZIbKezBGhZbAn3q0n4EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V5CTgRcg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V5CTgRcg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEE2C4CEF5;
	Tue, 11 Nov 2025 01:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822857;
	bh=x/G3BlYRxLbXUK+iRXl+mOHZfPg56RAe4dyKOxkhJIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5CTgRcg2ZPOKFfgy6BafcyNtgw+3i+bO+Nf7YsfiOSdNp17DkP46hy4H2d62sCze
	 z8JFimxBIbRBdg2YCEYUANUTXK3paTEx6qRlfeZUfzreRP1zDfAzA5W7QSlGdhPsiE
	 JbcRultQKVJTH/EiPUobnk09SNggsWjTxZN1HSIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 184/849] i3c: mipi-i3c-hci-pci: Add support for Intel Wildcat Lake-U I3C
Date: Tue, 11 Nov 2025 09:35:54 +0900
Message-ID: <20251111004540.877143476@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit d515503f3c8a8475b2f78782534aad09722904e1 ]

Add I3C controller PCI IDs on Intel Wildcat Lake-U.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250808131732.1213227-1-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
index c6c3a3ec11eae..08e6cbdf89cea 100644
--- a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
+++ b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
@@ -124,6 +124,9 @@ static void mipi_i3c_hci_pci_remove(struct pci_dev *pci)
 }
 
 static const struct pci_device_id mipi_i3c_hci_pci_devices[] = {
+	/* Wildcat Lake-U */
+	{ PCI_VDEVICE(INTEL, 0x4d7c), (kernel_ulong_t)&intel_info},
+	{ PCI_VDEVICE(INTEL, 0x4d6f), (kernel_ulong_t)&intel_info},
 	/* Panther Lake-H */
 	{ PCI_VDEVICE(INTEL, 0xe37c), (kernel_ulong_t)&intel_info},
 	{ PCI_VDEVICE(INTEL, 0xe36f), (kernel_ulong_t)&intel_info},
-- 
2.51.0



