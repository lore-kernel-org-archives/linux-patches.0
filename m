Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A3C33C511;
	Fri,  9 Jan 2026 11:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959871; cv=none; b=BuHb2E5D2a5sLaaslXQD32iAGS9F1/37YdXA/DyNHx/TSDncpxvTRmwD+W7OO68o5H4d0KpnasVN/R8skTimSf1CNHoOm5Q9GowbXfupIybgrdycQ1Y+YM/vCZ3Os2U0iIzNhAdGPeiziKRZ5qxTqY48FdJauClu0VqjioLDlcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959871; c=relaxed/simple;
	bh=c3kb3XkYpZTT6WZ3LTJiT4Hhlfp7OSkFdRm8EKONDM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrzySJ7G2pCxZF2WdDOR1KzieAbNfknJmsGix5iWnhxqVPvTDbdpsYYRpWLt8gP5IwwkBEucNeoD5TK1EIPFGKebjG7S/7h4lOAgMr5hdxH4AjeNYXWe9Cbl2MjlEcs1lJtsPORgM//NpLGh8o1N+0Lb2sij+fDtFL84FJMU698=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r2RK1Wg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r2RK1Wg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C52C4CEF1;
	Fri,  9 Jan 2026 11:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959871;
	bh=c3kb3XkYpZTT6WZ3LTJiT4Hhlfp7OSkFdRm8EKONDM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2RK1Wg0Y7evLPdO8tSsxBu39OoL+MFGa+slyv8RtMtjHG98RWM6GS2DuaObOR9Az
	 3lUopaDOcR+WPEXdU4acjvo0yJsxgT4TRtnZa3WaQ0Ds2L1PaptrImqEVJKuexB+a2
	 ycUxIMqEbzu863KJIVAIjZQBqDrDk+fWGELi0GTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/737] PCI: dwc: Fix wrong PORT_LOGIC_LTSSM_STATE_MASK definition
Date: Fri,  9 Jan 2026 12:35:43 +0100
Message-ID: <20260109112141.674545520@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ef0b2efa9f93e..fec9473869bce 100644
--- a/drivers/pci/controller/dwc/pcie-designware.h
+++ b/drivers/pci/controller/dwc/pcie-designware.h
@@ -92,7 +92,7 @@
 #define PORT_LINK_MODE_8_LANES		PORT_LINK_MODE(0xf)
 
 #define PCIE_PORT_DEBUG0		0x728
-#define PORT_LOGIC_LTSSM_STATE_MASK	0x1f
+#define PORT_LOGIC_LTSSM_STATE_MASK	0x3f
 #define PORT_LOGIC_LTSSM_STATE_L0	0x11
 #define PCIE_PORT_DEBUG1		0x72C
 #define PCIE_PORT_DEBUG1_LINK_UP		BIT(4)
-- 
2.51.0



