Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F0F33372B;
	Fri,  9 Jan 2026 12:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961817; cv=none; b=gSGqtD+7+haZiVAQdQvduvw/eNmbAtBwG2NRm2OAnfd7FHGnKUfcJE2eK/qFDLZU65InVMmNQRpCpevPJY/b8/EL5YJmEQKugsxh8I4KlLhJh3ku8oASxg+YzaZgumZyzdGPHCqds+CbBOiLBG7DL6RAgF3izfc6lLHVW8qsaR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961817; c=relaxed/simple;
	bh=uIQvD/X+Y4m8BipTsKferoGIk1T8yck1RgGZAYMyqwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jn6/w2cLgJJhPZ8a+IIYwJQxiFGGwJqgYUiXLZq+98pw3wKAYoBWdpDIxi+LR6mqiHuuOUD0/tDppClODBroiOLhCco0O0hkv0xKE3qcZrTWtWPRjIKTLLIHwzyEC4qaCUDJtf/bvQW/RVjPg9xGpRI2D1LRazqFi2ZgwvWn2nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaE4fhDX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaE4fhDX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2589C4CEF1;
	Fri,  9 Jan 2026 12:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961817;
	bh=uIQvD/X+Y4m8BipTsKferoGIk1T8yck1RgGZAYMyqwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaE4fhDXG49OyaDRIOEORWjJ6QtzRKcr1dRo28PGvyDq56dmTYE/Jz1M8jW2ujKRA
	 MjXu576cq07WCHzBy0sZwEJceSrPgdwxAgAUGWlj8HV9NmPTzRuz0NJ4rghOt/ZRC7
	 /1ry8o+bNtof2DFRF52tz0ROZZQ5qDh5JsGDCVBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/634] PCI: dwc: Fix wrong PORT_LOGIC_LTSSM_STATE_MASK definition
Date: Fri,  9 Jan 2026 12:37:05 +0100
Message-ID: <20260109112122.986013589@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a871ae7eb59ec..44254f31b5ac1 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -75,7 +75,7 @@
 #define PORT_LINK_MODE_8_LANES		PORT_LINK_MODE(0xf)
 
 #define PCIE_PORT_DEBUG0		0x728
-#define PORT_LOGIC_LTSSM_STATE_MASK	0x1f
+#define PORT_LOGIC_LTSSM_STATE_MASK	0x3f
 #define PORT_LOGIC_LTSSM_STATE_L0	0x11
 #define PCIE_PORT_DEBUG1		0x72C
 #define PCIE_PORT_DEBUG1_LINK_UP		BIT(4)
-- 
2.51.0



