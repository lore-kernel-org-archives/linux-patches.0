Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDB71DFDB3;
	Wed,  6 Nov 2024 13:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898174; cv=none; b=q4vLxfQ/zXw74BuzP+C0WrRf70A6EnCZEzzjeKM+0u7A1iQQYQGXGS+vDLTKxeXoXU4xcDsM4xOar0L3zZzZ/blRD4sEc182BhI63JA83wdJk2x1SFJUxwPcnAfXXO1heGljFE/oSKlkz5rCKhF0/mgYkX/TKpe+74rPs6wDF5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898174; c=relaxed/simple;
	bh=5NVY1auTOeO5nsPHo08mgivQykgXdGXVdV9Cq0WJ7EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7w+MH8AYWDVH33xSIvf5VYgmbKYJ5UNBIF4u0rJ00BRbRkHAGLTMWePHOifjrqpM/JPv9vYpXt8+lioW2r8iyp7ga/N+kULp1zMK7kDN/03mwozmNy/tSbWVvzwg09AyqW9DsZijYAOLN0hIPrUo4h46TotWo7IAzO/9y5VJbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EzNvb+pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EzNvb+pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC59C4CECD;
	Wed,  6 Nov 2024 13:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898173;
	bh=5NVY1auTOeO5nsPHo08mgivQykgXdGXVdV9Cq0WJ7EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EzNvb+pzUFq0CFczeZmy1P6y6FdtTnQgDMbJqd6sDbrU64Uoc6586W9nnNeBILLLh
	 7Io3gNK8kAY5pyU6G2nfIYEsWuon3TOeS87IurMMvMCynb48E6XBUpXp8jysBdfgHJ
	 poeYuDmcT/ErNthCqfQSdDOdgfRplq0PDnE+L7rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/462] PCI: xilinx-nwl: Fix register misspelling
Date: Wed,  6 Nov 2024 13:00:05 +0100
Message-ID: <20241106120334.271409390@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 11b046b20b92a..539bf53beb654 100644
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



