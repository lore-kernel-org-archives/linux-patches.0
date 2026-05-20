Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCB235201E;
	Wed, 20 May 2026 16:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295567; cv=none; b=DNUmKvv3enzjYo+qHAkhNIfJHMaG+S2fEgc/E+OiqjMZIYWCsKix187Q5Jl+6iZKAq1Jx5Lx6yrYl0agAexDhxJAFAmiGnhrYvwvem1E8bFtNlW4WBDfl+9aueuF1/iSfHiRfdOuHGMjoCL1CXY4OBJmTmmezDmCRB8YZdJDbos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295567; c=relaxed/simple;
	bh=noYx8xkQAFI0yN3dCadOfNp5D5rEr1CNcbTyhS9pQKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/1/NYDSknsj4RwcU830XFEHuaAnd/zbk3eComUfuOqn+5ckftGyZZiMVZLEXsDTVSlddBygS4xXzB3AkjVNNrkTpi3XZn4eUGLS9oKjvdUFxejaHG8dEk3ui27EoB9DbftPhTRDDuEcj/evQu5jkS6PnANCwWZenyN0dMgCIi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VG5zk/G/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VG5zk/G/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6981F000E9;
	Wed, 20 May 2026 16:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295566;
	bh=J5JNCyEHw+KJ8azBWYuIKDJhmM5W/yg4Hmi2aqdQU4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VG5zk/G/8IRdWSs4rrmu5sytYuQyItJ6fiC+sGQGWkE90JWHwlfHCwwLC0YPNwR1o
	 SHp9xNeX00AseejkSmOE7GKKQgP34ah9h0+D8WESb2m7HI+1lcOE2+GTAvmP/pHGkF
	 xHRm18b6BokQ3DxISzV575kuwHJl5x6Zin+zBXP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Yao Zi <me@ziyao.cc>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Han Gao <gaohan@iscas.ac.cn>,
	Chen Wang <unicorn_wang@outlook.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0431/1146] PCI: sg2042: Avoid L0s and L1 on Sophgo 2042 PCIe Root Ports
Date: Wed, 20 May 2026 18:11:21 +0200
Message-ID: <20260520162157.945199734@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <me@ziyao.cc>

[ Upstream commit 988ef706cdd8a72e61dd90c0d0554eec4df7594a ]

Since commit f3ac2ff14834 ("PCI/ASPM: Enable all ClockPM and ASPM states
for devicetree platforms") force enables ASPM on all device tree platforms,
the SG2042 Root Ports are breaking as they advertise L0s and L1
capabilities without supporting them.

Set ASPM quirks to disable the L0s and L1 capabilities for the Root Ports
so that these broken link states won't be enabled.

Fixes: 4e27aca4881a ("riscv: sophgo: dts: add PCIe controllers for SG2042")
Co-developed-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Signed-off-by: Yao Zi <me@ziyao.cc>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Han Gao <gaohan@iscas.ac.cn>
Tested-by: Chen Wang <unicorn_wang@outlook.com> # Pioneerbox
Reviewed-by: Chen Wang <unicorn_wang@outlook.com>
Link: https://patch.msgid.link/20260405154154.46829-3-me@ziyao.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-sg2042.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/cadence/pcie-sg2042.c b/drivers/pci/controller/cadence/pcie-sg2042.c
index 0c50c74d03eeb..4a2af4d0713e6 100644
--- a/drivers/pci/controller/cadence/pcie-sg2042.c
+++ b/drivers/pci/controller/cadence/pcie-sg2042.c
@@ -48,6 +48,8 @@ static int sg2042_pcie_probe(struct platform_device *pdev)
 	bridge->child_ops = &sg2042_pcie_child_ops;
 
 	rc = pci_host_bridge_priv(bridge);
+	rc->quirk_broken_aspm_l0s = 1;
+	rc->quirk_broken_aspm_l1 = 1;
 	pcie = &rc->pcie;
 	pcie->dev = dev;
 
-- 
2.53.0



