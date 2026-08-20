Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6286036A37A;
	Thu, 20 Aug 2026 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238486; cv=none; b=GD9O0y4nMhXzZogjOxjRjylfbbQD4X4b4wtmzclm6UqkPvWN5ymy69GtBUEPUop1q8oobFArT1jF04IbU/mwexc/7xhXQ8i9X59EXB57gVYsaOC0bm8iOdIe10dlu0JRrV3w7pc7gWqqNCmgfL4FnKTyyfJvS82fYmB/hCGElTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238486; c=relaxed/simple;
	bh=pHcng0M03rcYoWMJpDURV9afMMtF5zXEpobXrQDbACY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLTkW5z7SGpRNaX1COagJjAsEg3M08aOQGmeUvb+Hmfe9rEi8b3wJEwIvuVgxWhOXHRC42PdAIrPGFYmcSamP9sa2jifZQMk1dXPdJuA6uphHkMXCBt/WmaK69kI6k/2Y50KSwWaH280IlcYlHAzdfPSZGXcGgMy78jOOmHZ74Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JG+7yU2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JG+7yU2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD73D1F000E9;
	Thu, 20 Aug 2026 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238485;
	bh=P7N2Ry0w1ELGYKUwDc3T7SIpV2AHn5WHGOqA0wK2VMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JG+7yU2q74zP7mrh84sAjOFT5/hkKCkwvh+UrgvXBX5jXIQ7v4h/uxI68buOYDDsn
	 bFcjJu9q8+Z1fp1W5tysH/4h6LVMUoi3iXDr9zObMGK3LyVYdeHJ5LvwFYqqput4+E
	 HIy782YKp/KkUyLO6drKUCc4gG3mdoddVR1GiodU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junzhong Pan <panjunzhong@linux.spacemit.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 164/228] clk: spacemit: k3: fix USB2 bus clock
Date: Thu, 20 Aug 2026 16:55:06 +0200
Message-ID: <20260820145249.664151740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yixun Lan <dlan@kernel.org>

[ Upstream commit 51ed53630915c9cc290036fe4f430849e23bbf8e ]

According to SpacemiT K3's updated docs, the USB2 ahb reset and USB2 bus
clock enable bit was wrongly swapped, the correct one should be:

Register : APMU_USB_CLK_RES_CTRL
bit[1]   : usb2_port_bus_clk_en
bit[0]   : usb2_port_ahb_rstn

Fixes: e371a77255b8 ("clk: spacemit: k3: add the clock tree")
Reported-by: Junzhong Pan <panjunzhong@linux.spacemit.com>
Link: https://patch.msgid.link/20260518-06-clk-reset-usb-fix-v1-1-14fc235e692b@kernel.org
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/spacemit/ccu-k3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/spacemit/ccu-k3.c b/drivers/clk/spacemit/ccu-k3.c
index 1a53b14739fed..e0c5ca3df5824 100644
--- a/drivers/clk/spacemit/ccu-k3.c
+++ b/drivers/clk/spacemit/ccu-k3.c
@@ -777,7 +777,7 @@ static const struct clk_parent_data sdh2_parents[] = {
 CCU_MUX_DIV_GATE_FC_DEFINE(sdh2_clk, sdh2_parents, APMU_SDH2_CLK_RES_CTRL, 8, 3,
 			   BIT(11), 5, 3, BIT(4), 0);
 
-CCU_GATE_DEFINE(usb2_bus_clk, CCU_PARENT_HW(axi_clk), APMU_USB_CLK_RES_CTRL, BIT(0), 0);
+CCU_GATE_DEFINE(usb2_bus_clk, CCU_PARENT_HW(axi_clk), APMU_USB_CLK_RES_CTRL, BIT(1), 0);
 CCU_GATE_DEFINE(usb3_porta_bus_clk, CCU_PARENT_HW(axi_clk), APMU_USB_CLK_RES_CTRL, BIT(4), 0);
 CCU_GATE_DEFINE(usb3_portb_bus_clk, CCU_PARENT_HW(axi_clk), APMU_USB_CLK_RES_CTRL, BIT(8), 0);
 CCU_GATE_DEFINE(usb3_portc_bus_clk, CCU_PARENT_HW(axi_clk), APMU_USB_CLK_RES_CTRL, BIT(12), 0);
-- 
2.53.0



