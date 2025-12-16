Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC5C362141;
	Tue, 16 Dec 2025 12:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886929; cv=none; b=QNWEu4huadGgHbwjjZjquX61A3A7GQVBDa65gGFcrfaA30d5PwHxiOKtTlkeDZEfKSYMd7SBUmREe17qdsR/AAxaoqQOG6aZNZY0PMqsSN+6PUYe4a1dO6Q9CKN/fFQP3UQ+KshTsw1hZ4f/9G1eUxD2+h3RTG5rYKaNuE2tZ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886929; c=relaxed/simple;
	bh=kCYMumJIq85k5Mg92uLC2gmGEEHPzjqVmnhHAS0j8K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KsFKaQGVLA6pxeL+l4oQAwJXth4NUZ0PSraY1io56OCSuRx8hm+zt7li6yvwWSdh6leNqsP02FNMH4OiSO98mT9WeEmZLSY6mL7HuIEAzXa9LhjenFAufmvGq1wyzdop7CvUyHackrRSAlr6M92QbG99I5s+nCS1dbz3qXe33EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spbgSd0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spbgSd0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C908C4CEF1;
	Tue, 16 Dec 2025 12:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886929;
	bh=kCYMumJIq85k5Mg92uLC2gmGEEHPzjqVmnhHAS0j8K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spbgSd0BkyC2xCCi44rYEMc7IU2tXz5k6Vw+HU9axIf9Rnbmmq3NmuQQ3Jw7FY/ob
	 PgLCAqjVngIMraoyJ5lnZVEOTGj27lec+0FVHHJhVz6X3JpyO1RERdaEMx3oIB/y2P
	 0jDbxf6MyhN4wCgPlZVRyE2WAqR7yAvpMbmq1BjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/614] PCI: rcar-gen2: Drop ARM dependency from PCI_RCAR_GEN2
Date: Tue, 16 Dec 2025 12:07:23 +0100
Message-ID: <20251216111404.070521518@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



