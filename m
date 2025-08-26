Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE5D2F49EA;
	Tue, 26 Aug 2025 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215868; cv=none; b=ez8pjgTRIERSnYHNGLE1k3zE/bNYw8hAYnGC6g1wMSxOmNhZZ421tlpsNjEtzz11SIn4u15II7XwE0XAdNNlyhML5RCOktQgOyxKxOGA0s0nJrlX1LutS3wZAy3diButlnUS4VOLITYy92AzzYfAm5b1rpVi6ey1SOBTqpiWKIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215868; c=relaxed/simple;
	bh=sZ7RrW9BsfNUXIRy0hxkVWlWyqxaRAP5YCVtq5G8ucY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3m8jb966sTI21OAEy4BxyfRFn+dHfaCdJ8CuuhHC560hH5fSL+sptEAGR2P7VgMOVdg+znRipTrStm+DGE49bSgenXQvi6+CX5UyzJD4SZVYNAMaHqLaVRfD9AXYJvIdss3k6PcU23AFZ6ONFiHpHfK/AxjbhjE/wAqdeMYcWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbdDv8b/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbdDv8b/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FAFC4CEF1;
	Tue, 26 Aug 2025 13:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215868;
	bh=sZ7RrW9BsfNUXIRy0hxkVWlWyqxaRAP5YCVtq5G8ucY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XbdDv8b/5NanYJHLv+NBWn2EVTgzKF36vRZTdVsdq2vWjtZ2PjRZrxpTcyY4cp5f9
	 WbBSsXXwMZ7kb+PxPjt5icPwhCJiDjbxmbkTiTyY5ynXALQivzxbDyG7zSvGFxrXZX
	 psiBv7HPP5p2Ii4/OLCeUyr3UKx9oGTE9+jM6r/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/644] PCI: rockchip-host: Fix "Unexpected Completion" log message
Date: Tue, 26 Aug 2025 13:04:16 +0200
Message-ID: <20250826110950.568889055@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c52316d0bfd2..9e9e90e7c0fe 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -441,7 +441,7 @@ static irqreturn_t rockchip_pcie_subsys_irq_handler(int irq, void *arg)
 			dev_dbg(dev, "malformed TLP received from the link\n");
 
 		if (sub_reg & PCIE_CORE_INT_UCR)
-			dev_dbg(dev, "malformed TLP received from the link\n");
+			dev_dbg(dev, "Unexpected Completion received from the link\n");
 
 		if (sub_reg & PCIE_CORE_INT_FCE)
 			dev_dbg(dev, "an error was observed in the flow control advertisements from the other side\n");
-- 
2.39.5



