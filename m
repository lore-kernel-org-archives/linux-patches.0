Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C11A31B10B;
	Tue, 16 Dec 2025 11:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884526; cv=none; b=ilQvN9zy8UUJ1YmEmbZvbWbdT+gAMpLv54oQN6crU+YoMSyy22ZscLNsNXO37tnjnOwJSy+QxflplsMSzo9gL9H2Va/L8Z0+iWPzjuJzd+9QPgNs6mUBSlvG8TwSRdtZx+CNdfd3nwy2dgRbNecJxp+8D6++N226bP+rsxO/yAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884526; c=relaxed/simple;
	bh=+ruGJgTGQuz6YjZzMrP1Por1v5XqtoRqVKgcBWeT4I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hf5C4O+ea14HDV/YrU1SGyxdylHyVHzX6xsROpP67a9sH4hz+d3mC8QIGRY2ysrMHZEtsaV1B+83dWVHhcJYktozKUDXiCqT7fs7Uph0lSR6cr2TzqTJAjb9JsYOgYVP8resw+7I+xOZOFyG/n+x8E8ODedt+24xAIskq+o6j5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rB/91b++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rB/91b++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAD6C4CEF1;
	Tue, 16 Dec 2025 11:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884526;
	bh=+ruGJgTGQuz6YjZzMrP1Por1v5XqtoRqVKgcBWeT4I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rB/91b++UzRVpZAIejOLdzkSEkI2u+k0ThKkHxFwARpN7EzUXGtEk+rhw8ipzJQP9
	 DSUcxwr0X4qhzDneJRwX7pkbnVN7KEQEd9ShGNI7xYsj8ViztXaSEv/qoxqo6qBN09
	 836kOfNZ33er8oY5GqOvxPUMm6GXUQT1enyEaosc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 221/354] PCI: dwc: Fix wrong PORT_LOGIC_LTSSM_STATE_MASK definition
Date: Tue, 16 Dec 2025 12:13:08 +0100
Message-ID: <20251216111328.925252384@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 347ab74ac35aa..0fad7751490f5 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -97,7 +97,7 @@
 #define PORT_LANE_SKEW_INSERT_MASK	GENMASK(23, 0)
 
 #define PCIE_PORT_DEBUG0		0x728
-#define PORT_LOGIC_LTSSM_STATE_MASK	0x1f
+#define PORT_LOGIC_LTSSM_STATE_MASK	0x3f
 #define PORT_LOGIC_LTSSM_STATE_L0	0x11
 #define PCIE_PORT_DEBUG1		0x72C
 #define PCIE_PORT_DEBUG1_LINK_UP		BIT(4)
-- 
2.51.0



