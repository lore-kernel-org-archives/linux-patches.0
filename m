Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A433E1B87E9;
	Tue, 12 Aug 2025 19:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026170; cv=none; b=VJtYDmzA0BCCoVdsZAxvVcf72UCFtHfEbRmYnHBzb8f/9UlA7k/U2AaAb6BFbUhe2kmOm8Sqr3bBeKF1Atlu4I3Lh5S9QoxIqVFfm7Lb4aT9dGpmyTdL1EYb4lKWrTwaBP+FGufGFSw+K/7dMJXUcEr358rZ6OxDIQu3HmvNY/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026170; c=relaxed/simple;
	bh=2/42NQt7Cbny/HftkHJbd8nfppWZolhy+jLCxzqwY5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDM3sIUm1ER2M/Vg9x4BRmr2VPLD8akSHWoJbTvatppYx0DnNrIAteZAoY3LnF9Yl/PXEKTuoNkT4UJLxcB0x+uK9BE0/OHcADdxeiUP8PQaBCOOGL7IJh35JTJv1LtwAdr3BcO5XcauV328deMjDBBNZ8wJdnB75EJqjlWQK3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRzdYnlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRzdYnlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CEC7C4CEF0;
	Tue, 12 Aug 2025 19:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026170;
	bh=2/42NQt7Cbny/HftkHJbd8nfppWZolhy+jLCxzqwY5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRzdYnlw5X0XQvEgl+hlaVkAZf9Boal1GfQ2QRx4MIkxQOCoRV9TaBpSTGVd5Y8Nu
	 15JryBl/KqtZ04cTAnR+BuCSxLCCahJy6RLIJV5Tf0+yF+TVKCYXYob83X8DK2qHJY
	 kaSxhCcBo44mZ/4O6VnCm4mLYtCQ8tkZoLbn/IP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 224/480] PCI: rockchip-host: Fix "Unexpected Completion" log message
Date: Tue, 12 Aug 2025 19:47:12 +0200
Message-ID: <20250812174406.685614406@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit fcc5f586c4edbcc10de23fb9b8c0972a84e945cd ]

Fix the debug message for the PCIE_CORE_INT_UCR interrupt to clearly
indicate "Unexpected Completion" instead of a duplicate "malformed TLP"
message.

Fixes: e77f847df54c ("PCI: rockchip: Add Rockchip PCIe controller support")
Signed-off-by: Hans Zhang <18255117159@163.com>
[mani: added fixes tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Acked-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/20250607160201.807043-2-18255117159@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rockchip-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rockchip-host.c b/drivers/pci/controller/pcie-rockchip-host.c
index 6a46be17aa91..2804980bab86 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -439,7 +439,7 @@ static irqreturn_t rockchip_pcie_subsys_irq_handler(int irq, void *arg)
 			dev_dbg(dev, "malformed TLP received from the link\n");
 
 		if (sub_reg & PCIE_CORE_INT_UCR)
-			dev_dbg(dev, "malformed TLP received from the link\n");
+			dev_dbg(dev, "Unexpected Completion received from the link\n");
 
 		if (sub_reg & PCIE_CORE_INT_FCE)
 			dev_dbg(dev, "an error was observed in the flow control advertisements from the other side\n");
-- 
2.39.5



