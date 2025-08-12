Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D742F83CB;
	Tue, 12 Aug 2025 17:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020637; cv=none; b=DegrpeM5tvd5QalQ5SWmL4Rf2+Ueu/nspMa8XrcLRejYHmk0wX9vTTGoxqb7aPpb2OqNIC1MTggIpertv0wbJLXQoXXc1oV9b00QK7thNdoOp4gOPA8KbJfVuzZu/5Q5+iqEIc5DaQbrtKJS5ZF7WhFOY/25Oig7QO8l3GpwEb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020637; c=relaxed/simple;
	bh=sHY4UqfVBbJCX+qDAzeSDAFbW7XESKFT57gA/o8ud2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcKOZIskF7eXaoMeSpPmki1qk4iHFAjPnDVQqQPzE+NFa5wcDMqzwYg6pvA4Ybgh/0jBFYjXpMe+JPc5+fF260IsHP4o8wFbRSfR/ah89zrk6qzhMlUQaGLUdP8hyocLcPQpgJAase3cQoKkwTLK6lr2qqeh11v9hr0n9xgGBSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwvX0DDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwvX0DDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B90AC4CEF6;
	Tue, 12 Aug 2025 17:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020637;
	bh=sHY4UqfVBbJCX+qDAzeSDAFbW7XESKFT57gA/o8ud2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwvX0DDW2hF3VyK12DxNA+yubC0cRWJrxByCJ1FwnBhDHsZmsCE4/wTWTtOvTn8ZT
	 pQaW6ewSyW7cPS+2oucCcnf5Cerf4T8fu7ohhElzEl+elULm2wakyHjvqHHyoj0dCl
	 WRsJGypOqWHypnbDK4UVSGTL4WL32TiY0l8qjqoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/253] PCI: rockchip-host: Fix "Unexpected Completion" log message
Date: Tue, 12 Aug 2025 19:28:47 +0200
Message-ID: <20250812172954.606584347@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7352b5ff8d35..bd982390e04c 100644
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



