Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048076;
	b=2GFsFtLI1ONKEiP7Mj/8jbqSpjHYozZe4OlNiRSFK3Q9I+BAPImFN6o6HafffU/WWbrt
	 VHqjW1q41i4JpmLVrzPg9rXeRAw74E2r1qw8Kk3XfohOQ2oFj6ZEzRx7lgMKfvTzQb/d5
	 LsA+bhETxN1HFJf1fFNp8e3AeTqydtBlmzzf83CLjd7sK8ztyc5n0by8GpzvUjfVMGviv
	 /xl1iXVn7VH0uFPFh0L1rstT3VCzUTgLCyUTzCmnOrXZUKVIpnOv465lP7g6q0ikT/aQN
	 phW9pX2Ws5VFMDvmlx/Q8bnVrPoiVt37uCHd/QBINfVp69c+iSWZfpeM07gv0Al9M4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048076;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6Kos45h9dEYbZKnNv6wFut7r3+Kkft02Hl0v5fSmCI=;
	b=qLI3OJZIyJGq7BcIRSRPUEKNv6bB9Lu1qTiZKuzX7P0Vz7z19Z7oby5JDSt1FGfFXXNc
	 2fZUOnUmhlfRuVgfS1Dc6aRXcBmIM1zVqqDgT+78uwaToB+1yhj/1R+PgeQzTLCADFZQA
	 JwT/AD7+MeL4+qevOMpavo8lkYdUJu2FldA0dYVe3CLlg4+YAkmwXMjtd4zpmsE/PdEL0
	 iw8QhEH8/iANEGqZzesM+JOgJAfsqJzantn6qImuY3WWRMuEG4PuLgHp5k50ZhIr5pV0Z
	 ZrhtXnsqPTAmI+MwKo76uyC35EFhKD0xKi8RX2ABdRyWXKzqNpIsITxyODtHhkYv/Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NThrHx1y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9D5606A31C;
	Thu, 19 Nov 2026 00:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NThrHx1y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC83D1F000C4;
	Thu, 19 Nov 2026 00:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048076;
	bh=H6Kos45h9dEYbZKnNv6wFut7r3+Kkft02Hl0v5fSmCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NThrHx1yJ51nfMIBPOIW0sQ01AWlQEDgDYYvR+TsfSSnnL0JQT2VHIB5Df1Kr3smO
	 Z+Z3vViBlsm9+wUB/dEke8lGyUgenCWlpXoMKkpbCKLXYv5GT9VeSFPjvPEHdyGzCw
	 e4DNJEDmTdd3z2aipYzeMqrB16+RGSJ5r4p1Bg3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1867/2857] PCI: xgene: Use managed clock for PCIe controller
Date: Wed, 18 Nov 2026 15:48:21 +0100
Message-ID: <20261118150308.459637217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit b9022584ebbae81f7bbe4a61bd1df0d0a95e1a99 ]

xgene_pcie_init_port() obtains and enables the controller clock manually.
When xgene_pcie_setup() or pci_host_probe() fails, probe returns without
disabling, unpreparing, or releasing the clock. A failed enable also leaves
the clk_get() reference unreleased.

Use devm_clk_get_enabled() so the clock is unwound automatically on probe
failure and device removal.

Fixes: 5f6b6ccdbe1c ("PCI: xgene: Add APM X-Gene PCIe driver")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260802221146.573233-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-xgene.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index d1773a4d77d7c..67304c4d0f84d 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -322,18 +322,11 @@ static void xgene_pcie_linkup(struct xgene_pcie *port,
 static int xgene_pcie_init_port(struct xgene_pcie *port)
 {
 	struct device *dev = port->dev;
-	int rc;
 
-	port->clk = clk_get(dev, NULL);
+	port->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(port->clk)) {
 		dev_err(dev, "clock not available\n");
-		return -ENODEV;
-	}
-
-	rc = clk_prepare_enable(port->clk);
-	if (rc) {
-		dev_err(dev, "clock enable failed\n");
-		return rc;
+		return PTR_ERR(port->clk);
 	}
 
 	return 0;
-- 
2.53.0



