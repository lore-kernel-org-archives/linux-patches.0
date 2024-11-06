Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA76A1DF252;
	Wed,  6 Nov 2024 12:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895044; cv=none; b=Cpicu4gw3bVdDCjAQOnX8gNLyEaqdiQ58Io0a36Is883R4NLmQ+F9VUKAbhAxWtyAMn4t5e9WEDRTWJiNvQmyKHaVc+32gQuA1Ogzien0xmXwnMerQkUm7pUXTXOqPHl44SJVdSLe+wOOgbAFn/XBRnudwOsqj2O9/CZMVdlCfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895044; c=relaxed/simple;
	bh=5SpH+Qd2jas4j8osRnk+jcGkqaY3bs9eO0bueibvf24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pO27HHNBiVOhTfAnQE9R+gAsL7iRKYaOXOo2Cikghzp4hFDQZ31VIrNFcj5/wxS3KKyDo/BZiHV3unOPH3DrgqARZMS4AsXOeFFAavmD0lT4vk+UzLG8X7ELqt9ulCUGa82hzWJlvt/ZB1mNEeIvmzr0+WYAUSnk7L/DkNJdMiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwOdoeFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwOdoeFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F851C4CECD;
	Wed,  6 Nov 2024 12:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895044;
	bh=5SpH+Qd2jas4j8osRnk+jcGkqaY3bs9eO0bueibvf24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XwOdoeFE6xNEWg9pjuTtMHlZVgcVW/sAGHOxyzZ6A7G0BzCQn9XPM8Ws9GoYvHUfP
	 yzBRpMoNuT4v0/i03Kh76I7bQfSMsNDJd6Eyj4iKNZlZKfourM5swZG5sDWJYIROwr
	 hcGPlxFHsZyIvgiq+Sw6Gr4NPZoG3Z+RL60rl9es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/350] PCI: xilinx-nwl: Fix register misspelling
Date: Wed,  6 Nov 2024 13:00:13 +0100
Message-ID: <20241106120322.996931060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit a437027ae1730b8dc379c75fa0dd7d3036917400 ]

MSIC -> MISC

Fixes: c2a7ff18edcd ("PCI: xilinx-nwl: Expand error logging")
Link: https://lore.kernel.org/r/20240531161337.864994-4-sean.anderson@linux.dev
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-xilinx-nwl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/controller/pcie-xilinx-nwl.c b/drivers/pci/controller/pcie-xilinx-nwl.c
index a86bd9660dae9..4b7b906967582 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -79,8 +79,8 @@
 #define MSGF_MISC_SR_NON_FATAL_DEV	BIT(22)
 #define MSGF_MISC_SR_FATAL_DEV		BIT(23)
 #define MSGF_MISC_SR_LINK_DOWN		BIT(24)
-#define MSGF_MSIC_SR_LINK_AUTO_BWIDTH	BIT(25)
-#define MSGF_MSIC_SR_LINK_BWIDTH	BIT(26)
+#define MSGF_MISC_SR_LINK_AUTO_BWIDTH	BIT(25)
+#define MSGF_MISC_SR_LINK_BWIDTH	BIT(26)
 
 #define MSGF_MISC_SR_MASKALL		(MSGF_MISC_SR_RXMSG_AVAIL | \
 					MSGF_MISC_SR_RXMSG_OVER | \
@@ -95,8 +95,8 @@
 					MSGF_MISC_SR_NON_FATAL_DEV | \
 					MSGF_MISC_SR_FATAL_DEV | \
 					MSGF_MISC_SR_LINK_DOWN | \
-					MSGF_MSIC_SR_LINK_AUTO_BWIDTH | \
-					MSGF_MSIC_SR_LINK_BWIDTH)
+					MSGF_MISC_SR_LINK_AUTO_BWIDTH | \
+					MSGF_MISC_SR_LINK_BWIDTH)
 
 /* Legacy interrupt status mask bits */
 #define MSGF_LEG_SR_INTA		BIT(0)
@@ -308,10 +308,10 @@ static irqreturn_t nwl_pcie_misc_handler(int irq, void *data)
 	if (misc_stat & MSGF_MISC_SR_FATAL_DEV)
 		dev_err(dev, "Fatal Error Detected\n");
 
-	if (misc_stat & MSGF_MSIC_SR_LINK_AUTO_BWIDTH)
+	if (misc_stat & MSGF_MISC_SR_LINK_AUTO_BWIDTH)
 		dev_info(dev, "Link Autonomous Bandwidth Management Status bit set\n");
 
-	if (misc_stat & MSGF_MSIC_SR_LINK_BWIDTH)
+	if (misc_stat & MSGF_MISC_SR_LINK_BWIDTH)
 		dev_info(dev, "Link Bandwidth Management Status bit set\n");
 
 	/* Clear misc interrupt status */
-- 
2.43.0



