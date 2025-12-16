Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E6D34D3BF;
	Tue, 16 Dec 2025 11:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885309; cv=none; b=tDr5Bu8Y9NVAaoTUnydlDUYZOz3vAD8PxT4PyD6BRzJukjUQm1PTi3LgJiSZFgqFFWnJg/Xqr8n3fiqtgN1f+C8VmibR4iFZQKgfrk98NtoXtCnrkxDiedBpNe2P+0RgAeYLgN7WfN/iyWy9AkTdW1+6OPAPtt8TgjjzxvPcY2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885309; c=relaxed/simple;
	bh=ls5doTnkvbiAjnkl1FjUOeI9WsHxYfiptRDsGTURVx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nob6697A93L8DIXZh5doxMel3qU3a/BU8Iumdnw5ZjCwVIBz686fAbvTaZhn8ULK2MsI8q28kRFUGcl4lgT7ufQJbWvXmZty1ZTMsnDI4OZd2PZIfA11Jx8MAKUUO+RlX2PCrk862OHj5P5ds6nWlnZz7tSRJhyvVoqyZNvbJ9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MVg0IBxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MVg0IBxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EBCC4CEF1;
	Tue, 16 Dec 2025 11:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885308;
	bh=ls5doTnkvbiAjnkl1FjUOeI9WsHxYfiptRDsGTURVx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MVg0IBxHaKQcfyac+lVLjpqVhE5Cho+4it3eyZ9eNe8ZvxRWIzc4HHVg3S+ePhPZf
	 qsORtKPPQZ5B6willd7r1inmjB+1uRyh9kS9iDVUAKcV2RX4FradUGd056p5velkbK
	 dLQosNEaNcKI+1HzdrCPnPqm0JsKgmuED1DJmdM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 067/507] PCI: rcar-gen2: Drop ARM dependency from PCI_RCAR_GEN2
Date: Tue, 16 Dec 2025 12:08:28 +0100
Message-ID: <20251216111347.971577808@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit d312742f686582e6457070bcfd24bee8acfdf213 ]

Since the reliance on ARM-specific struct pci_sys_data was removed, this
driver can be compile-tested on other architectures.

While at it, make the help text a bit more generic, as some members of
the R-Car Gen2 family have a different number of internal PCI
controllers.

Fixes: 4a957563fe0231e0 ("PCI: rcar-gen2: Convert to use modern host bridge probe functions")
Suggested-by: Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: add rcar-gen2 to subject]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://patch.msgid.link/00f75d6732eacce93f04ffaeedc415d2db714cd6.1759480426.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/Kconfig | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/controller/Kconfig b/drivers/pci/controller/Kconfig
index 41748d083b933..0452151a7bccc 100644
--- a/drivers/pci/controller/Kconfig
+++ b/drivers/pci/controller/Kconfig
@@ -259,12 +259,11 @@ config PCIE_RCAR_EP
 
 config PCI_RCAR_GEN2
 	bool "Renesas R-Car Gen2 Internal PCI controller"
-	depends on ARCH_RENESAS || COMPILE_TEST
-	depends on ARM
+	depends on (ARCH_RENESAS && ARM) || COMPILE_TEST
 	help
 	  Say Y here if you want internal PCI support on R-Car Gen2 SoC.
-	  There are 3 internal PCI controllers available with a single
-	  built-in EHCI/OHCI host controller present on each one.
+	  Each internal PCI controller contains a single built-in EHCI/OHCI
+	  host controller.
 
 config PCIE_ROCKCHIP
 	bool
-- 
2.51.0



