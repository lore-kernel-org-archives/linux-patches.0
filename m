Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A5A2F7449;
	Tue, 12 Aug 2025 17:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021390; cv=none; b=kCxdNawkUrf0dR7PLk4cM/YZjNKkNMt9oq2vgNr4qjWn1qIpPWcveO3Jb6jnBmSiKya0ERtH7/YrjgG1BPnYaP7dz/xUU2Av5RwC7di8m/bCVzQ38Ln6IRfRs3jDenkNi/8NQjzKL/ZGOXcW4GJEf7oKdKzQ3vl6xjxvmD80rjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021390; c=relaxed/simple;
	bh=nhEt7OrlNAfhjCTAysMP2zYQsi2bYwIjt8+0sCT5M3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seBQ5Su2m5zwV2fYPtPTy6lhf+0bz7iPQMKfld+4p9zOQ9au0lnXpKbZ3kplZnD7CPZwwVKAMyI29YYgMkj903rw+kJotGdEq7UOSODH1KeVIRUspidDeYSRp2tbrpcB/R2HPGjF4ai6GWrU4cjhystSUm0iZbvXdGpjLfRpwe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJ1ksHnm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJ1ksHnm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC28C4CEF0;
	Tue, 12 Aug 2025 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021389;
	bh=nhEt7OrlNAfhjCTAysMP2zYQsi2bYwIjt8+0sCT5M3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJ1ksHnmnLghVm6LQShgiKxe6Mgs3aCJ9p4OOyNaFLKmOlvfljT6nFF6b/8FzC9TO
	 VK5u3psqfQIVrs6T6assp0ROvKzBLpPdZFI7cEZfWUlH9ez9gRyNHWciNngMxatWaB
	 md6HLlpnH8Pp/zL4fXjrhHP8rPhJvS398EoRUdH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/262] PCI: rockchip-host: Fix "Unexpected Completion" log message
Date: Tue, 12 Aug 2025 19:28:15 +0200
Message-ID: <20250812172957.646647421@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index afbbdccd195d..6ff20d585396 100644
--- a/drivers/pci/controller/pcie-rockchip-host.c
+++ b/drivers/pci/controller/pcie-rockchip-host.c
@@ -436,7 +436,7 @@ static irqreturn_t rockchip_pcie_subsys_irq_handler(int irq, void *arg)
 			dev_dbg(dev, "malformed TLP received from the link\n");
 
 		if (sub_reg & PCIE_CORE_INT_UCR)
-			dev_dbg(dev, "malformed TLP received from the link\n");
+			dev_dbg(dev, "Unexpected Completion received from the link\n");
 
 		if (sub_reg & PCIE_CORE_INT_FCE)
 			dev_dbg(dev, "an error was observed in the flow control advertisements from the other side\n");
-- 
2.39.5



