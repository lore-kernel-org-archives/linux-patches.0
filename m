Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A75E33C52A;
	Fri,  9 Jan 2026 11:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959607; cv=none; b=atCdFZktPvP+YMJJ1PCXE4/DiFUcjTvFV84Kh8fdZakV71gccbtVrjAtqQuQwi0L4HORV0gD6ugfD36MKQjvyl0VTYBTUm7Ia3b1b10QVhJmRvEGJzeznD8umCPULz/ghcrCuQ9uXIEpT7zbUeKbhAtEgH5uiGDkE0fNbX8W+ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959607; c=relaxed/simple;
	bh=RnFfg3PZZFKaZS1sU+CUZwUQdWF3BPNBshvHLJ3ff/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DFrUzhPiyyBTTa0Obq0VyfGXLYBw4SDRjy30WSzfJlz6gs4U6jqhnLjKPXJ6Aosagt5A/r/gQVLNBNTYKPSwu5+5VJHfkOaV+IhqsL1gI2DNd55kKUy/s32zaQcVykh7ZZURWQTqJMdKEcdItC/eeovrwTM39eFRzlvRbnPrHaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkIsGzxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkIsGzxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92847C16AAE;
	Fri,  9 Jan 2026 11:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959606;
	bh=RnFfg3PZZFKaZS1sU+CUZwUQdWF3BPNBshvHLJ3ff/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkIsGzxWYEnb4LjOMo7NFtlCtccdkGxqjpx80JcG4RNpHtSMpRS1EaQtltoMiKuRy
	 n3HdBN2nZEiH1degjmKb2n4Q/JOslp36cmlRR/T2VVQQQVRV27gVhoFYJwIiTm2GUK
	 AjpXnhCqZKN0W7MmYOe2YkYzYM1Gn/fv6YiD4Zvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/737] PCI: rcar-gen2: Drop ARM dependency from PCI_RCAR_GEN2
Date: Fri,  9 Jan 2026 12:33:37 +0100
Message-ID: <20260109112136.929330115@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c0c3f28249907..7736817d5daba 100644
--- a/drivers/pci/controller/Kconfig
+++ b/drivers/pci/controller/Kconfig
@@ -257,12 +257,11 @@ config PCIE_RCAR_EP
 
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



