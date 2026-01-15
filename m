Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF554C81;
	Thu, 15 Jan 2026 17:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497687; cv=none; b=koP9bdW1lmuJty+6fl805wTE8beN8Tluo6YCZZGIX8fyFTvwEY1nbeiFeVdywX2FO/ingIwaZiLlOYcLmlZWJOCPRO3P1b21+euHaBy2hhhvcc19TEKLyaUSGXjDtOepQXuMMkaLU7U/3On8tYD1HQF1h/fXtIdKZB2A07fnwz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497687; c=relaxed/simple;
	bh=AHUY62AhcsNu5zYeHSFs9vewAx0yE3uZe6UtRbihgrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCl8kknm+/85huzs0KWHXWlr0ZbV4HJ0xhTbaDVRrGOHaDe8ywi64Ejtu1AGBnVDri0kM8B9bdiIscYlnKgZPldgBRhrw+Hx71o8I2nJOX0OUQ5/co0K0BPMO/G+2bgheJNw+LBR/vATVGIg8qKfOnjyxpjBoGZM+x1KA1AKvz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HxYk0l/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HxYk0l/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C181C116D0;
	Thu, 15 Jan 2026 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497687;
	bh=AHUY62AhcsNu5zYeHSFs9vewAx0yE3uZe6UtRbihgrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxYk0l/54nNVIzuFueogY9DV0rrh+WgDbEJJBDNKGe9UHyQF2lEq5cv3PvTLob9Yk
	 rXTFwkRD/KcgSHlYh4NX7h0vTpT/5gdEYhoOg8+OJpDt5SRbOPCngvhlLA7SYcV7q8
	 YzEzEfaXD9VhRifegoz3w9e5w+5W09rE9gIrI3xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/554] PCI: dwc: Fix wrong PORT_LOGIC_LTSSM_STATE_MASK definition
Date: Thu, 15 Jan 2026 17:43:21 +0100
Message-ID: <20260115164251.138049514@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit bcc9a4a0bca3aee4303fa4a20302e57b24ac8f68 ]

As per DesignWare Cores PCI Express Controller Databook, section 5.50,
SII: Debug Signals, cxpl_debug_info[63:0]:

  [5:0] smlh_ltssm_state: LTSSM current state. Encoding is same as the
  dedicated smlh_ltssm_state output.

The mask should be 6 bits, from 0 to 5. Hence, fix the mask definition.

Fixes: 23fe5bd4be90 ("PCI: keystone: Cleanup ks_pcie_link_up()")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/1763122140-203068-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-designware.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware.h b/drivers/pci/controller/dwc/pcie-designware.h
index 8ba2392926346..5960ae40b0f2d 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -52,7 +52,7 @@
 #define PORT_LINK_MODE_8_LANES		PORT_LINK_MODE(0xf)
 
 #define PCIE_PORT_DEBUG0		0x728
-#define PORT_LOGIC_LTSSM_STATE_MASK	0x1f
+#define PORT_LOGIC_LTSSM_STATE_MASK	0x3f
 #define PORT_LOGIC_LTSSM_STATE_L0	0x11
 #define PCIE_PORT_DEBUG1		0x72C
 #define PCIE_PORT_DEBUG1_LINK_UP		BIT(4)
-- 
2.51.0



