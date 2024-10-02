Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505CE1D26F9;
	Wed,  2 Oct 2024 14:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879954; cv=none; b=usORysxm9loiwJBEE8QlZIj52xOtd3b02oBMcisg1K3IeYC94GwtEftDpc2S7/4sDf8GorzjhaLb1HghNUiaQ9kuVyO585MzM8nQUUWOkqYzkoul0v7CT6jaii8h1RnRVqcVu8lGpBuWXk6EUH+uesk73CXldiYQ6OtXpfhFkOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879954; c=relaxed/simple;
	bh=RIZ4eXFo734jjH6u5r7qtJfoNGnKcKjRF+684pLAs8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0bFcMy2xo/iEzNUu18h961SLV3KzwLp8Wd6NLYKSGBv6VfXrAF7cDXmmbIpAgLKlN5wZ9frsCpLAPeJrNJKuF2xiM1cKq7lCSdJonz7GG9J79WKCUBE/Ksl58508GlFp/ixXkYE/zmTJYIU1uhiSTUMrA9XU5VACbVcOkZsXD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9JfAwZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9JfAwZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F22C4CEC2;
	Wed,  2 Oct 2024 14:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879954;
	bh=RIZ4eXFo734jjH6u5r7qtJfoNGnKcKjRF+684pLAs8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9JfAwZHjamJP8smtGV68SIDaq7OolBrBfH1TDwpByNTmBpvad8ol+IGeun0nRKww
	 Kfnyh5pGbjcMNFaslbCaHqW8nrFP2uw8sEAJYQbdy5sPM6gRQlSySAftl6Z4UtlsAA
	 9rNXAiMq6lGL76ItYqGqTQhkQc0O1PNKQsPapXRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/538] PCI: xilinx-nwl: Fix register misspelling
Date: Wed,  2 Oct 2024 14:58:52 +0200
Message-ID: <20241002125803.823411973@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 176686bdb15c1..7cf05431d54bc 100644
--- a/drivers/pci/controller/pcie-xilinx-nwl.c
+++ b/drivers/pci/controller/pcie-xilinx-nwl.c
@@ -80,8 +80,8 @@
 #define MSGF_MISC_SR_NON_FATAL_DEV	BIT(22)
 #define MSGF_MISC_SR_FATAL_DEV		BIT(23)
 #define MSGF_MISC_SR_LINK_DOWN		BIT(24)
-#define MSGF_MSIC_SR_LINK_AUTO_BWIDTH	BIT(25)
-#define MSGF_MSIC_SR_LINK_BWIDTH	BIT(26)
+#define MSGF_MISC_SR_LINK_AUTO_BWIDTH	BIT(25)
+#define MSGF_MISC_SR_LINK_BWIDTH	BIT(26)
 
 #define MSGF_MISC_SR_MASKALL		(MSGF_MISC_SR_RXMSG_AVAIL | \
 					MSGF_MISC_SR_RXMSG_OVER | \
@@ -96,8 +96,8 @@
 					MSGF_MISC_SR_NON_FATAL_DEV | \
 					MSGF_MISC_SR_FATAL_DEV | \
 					MSGF_MISC_SR_LINK_DOWN | \
-					MSGF_MSIC_SR_LINK_AUTO_BWIDTH | \
-					MSGF_MSIC_SR_LINK_BWIDTH)
+					MSGF_MISC_SR_LINK_AUTO_BWIDTH | \
+					MSGF_MISC_SR_LINK_BWIDTH)
 
 /* Legacy interrupt status mask bits */
 #define MSGF_LEG_SR_INTA		BIT(0)
@@ -301,10 +301,10 @@ static irqreturn_t nwl_pcie_misc_handler(int irq, void *data)
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



