Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2489C446AC;
	Mon,  1 Apr 2024 16:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988727; cv=none; b=o7kTsbg7nTylzd2ob/VZ/ITBd1WjXdStUorVOQe1W95nM07KEbbAE+JafJCmbb6T/F88qlZywZ3D/ZUL41Z4qBz9+Hl3v4ca+M0W9wfp2n5m0x0gDf+fR/CIBhnZRD8lN8C0hPRHJXYQR//H38+r8TNdYSsTLagrxH7SeZtoUmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988727; c=relaxed/simple;
	bh=gs5GfjUdHZHwLMHRsfY3PGk6PYzlh34SlOyHVYx8qPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5o6zy5wVjvbGhHbyVRHGiMMhJw9HakiIpEMSTjJyE/r5tJRGinJ7zDjd/mZIluN8Tb2bWeYznTjET4DZcHmXEDJ/FkluQjRCodpeaeUk+HXaeJ6Ly+NRQxDjkq05OMS1Zv5tTh7M6+8l42h7+5dMZ9wJAfXhThgNDIJFogBzR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIuuMHTr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIuuMHTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3E8C433C7;
	Mon,  1 Apr 2024 16:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988727;
	bh=gs5GfjUdHZHwLMHRsfY3PGk6PYzlh34SlOyHVYx8qPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIuuMHTrOBq/AuR2bztYLSc2DsUTWVy87Kt54KdWdehA+oG0EKXCoQZYd0Jr9o9YF
	 3Iq4b4zprLiBtOW5fkGR9iTTEAmPWKHhmg4hs83acXzDvFlfj5AdpINvcA6V8EFpIk
	 H3EAF4VDwnuWY+dQybduBWDv44hjWt8RSmG5r/eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.7 271/432] mei: me: add arrow lake point S DID
Date: Mon,  1 Apr 2024 17:44:18 +0200
Message-ID: <20240401152601.259406520@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 7a9b9012043e126f6d6f4683e67409312d1b707b upstream.

Add Arrow Lake S device id.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240211103912.117105-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -112,6 +112,7 @@
 #define MEI_DEV_ID_RPL_S      0x7A68  /* Raptor Lake Point S */
 
 #define MEI_DEV_ID_MTL_M      0x7E70  /* Meteor Lake Point M */
+#define MEI_DEV_ID_ARL_S      0x7F68  /* Arrow Lake Point S */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -119,6 +119,7 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


