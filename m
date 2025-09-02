Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7252F30EF65;
	Tue,  2 Sep 2025 13:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820089; cv=none; b=EF0OM8yYVRWWZzoKlNDvkftbh8KHYUWXVYCZo9rkkSPCVYYp5itix95bKD8l+ygHHXTgLpxm08M1cKSjrz1278xDsKeTg4nQknWPHUCoSF7+HMafb45VgUgK5RByS4Pexk8vDaw7lrCnf8Uy2ozi4j1WaiZNlr57DMC9TUVCC4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820089; c=relaxed/simple;
	bh=NqQ8qHflVPj5ZIaAl/hbLpig0ifObEIGGXp9s8GRTjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3rA2m/KxSNAfxI/z+7e6sPODaLdSsmy+iWKt73+fSClDJE52a2qhD/zkQCJIw8NAIovCGDMOiPCE+WefNfE6LyVWZk9TnJM2DsukNBQ1MebconhgUcw7vwQKwk1HiNluArhj1HapphbHEgV65oZN7ASSIhgmAtL/OTizRoR+fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivV4pR8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivV4pR8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79547C4CEED;
	Tue,  2 Sep 2025 13:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820088;
	bh=NqQ8qHflVPj5ZIaAl/hbLpig0ifObEIGGXp9s8GRTjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivV4pR8Yyr1gy5YNEIXwITkbM2cQQs4niOw2jpZc4i7Zted82x5e1Ghfz2U/Jku6P
	 81uN+amWpDVX9lZ4CS4PyUBfvonDVX5JwNi+UNwvZpVgRDpZLMYBcOuQ60tlal2DP/
	 Z1QYhRrZ3YRn2CmQNHQ17F7GIsbuYPFYXi6CtuwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <helgaas@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>
Subject: [PATCH 6.12 90/95] PCI: Rename PCIE_RESET_CONFIG_DEVICE_WAIT_MS to PCIE_RESET_CONFIG_WAIT_MS
Date: Tue,  2 Sep 2025 15:21:06 +0200
Message-ID: <20250902131943.057232083@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

commit 817f989700fddefa56e5e443e7d138018ca6709d upstream.

Rename PCIE_RESET_CONFIG_DEVICE_WAIT_MS to PCIE_RESET_CONFIG_WAIT_MS.

Suggested-by: Bjorn Helgaas <helgaas@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20250625102347.1205584-10-cassel@kernel.org
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/plda/pcie-starfive.c |    2 +-
 drivers/pci/pci.h                           |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/controller/plda/pcie-starfive.c
+++ b/drivers/pci/controller/plda/pcie-starfive.c
@@ -368,7 +368,7 @@ static int starfive_pcie_host_init(struc
 	 * of 100ms following exit from a conventional reset before
 	 * sending a configuration request to the device.
 	 */
-	msleep(PCIE_RESET_CONFIG_DEVICE_WAIT_MS);
+	msleep(PCIE_RESET_CONFIG_WAIT_MS);
 
 	if (starfive_pcie_host_wait_for_link(pcie))
 		dev_info(dev, "port link down\n");
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -57,7 +57,7 @@
  *    completes before sending a Configuration Request to the device
  *    immediately below that Port."
  */
-#define PCIE_RESET_CONFIG_DEVICE_WAIT_MS	100
+#define PCIE_RESET_CONFIG_WAIT_MS	100
 
 /* Message Routing (r[2:0]); PCIe r6.0, sec 2.2.8 */
 #define PCIE_MSG_TYPE_R_RC	0


