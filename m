Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA943233EE;
	Tue, 16 Dec 2025 11:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883982; cv=none; b=gZrXwnu7NT+gni67sNY3Ls/lWfOv0PiqbIufXa5RyuHKQPILL4Gd2oIqo05siodfcqrKK+e3EucRf+1S+2Jybu+veiIEGLF3XTnYESWL1wu74BMJtwMBAuoc/zfafJb6I2NUcS7HRvd7Mx4qblp15ErIIN34vPNCylY5up4LVmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883982; c=relaxed/simple;
	bh=SaPs8BsPlIsJ6bBiYLb3Dix3cdHTeaVcyvLSKocgUJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QFbmpHdjgwg3HPcXOiWbvw2n6qpCOLta9ov2wOA8nwmmQSXeovxxU2z7DTQhbv8XG4eBt3hCFD9x6PzDxnd6nt+bN1/OAACfG/OrujXaO/zMOIcLNv3IqmSqt4oNfv0SWkzycurSqbhhHzKXKkEW1mctKJqA9M50YbjGnZORECo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s94pXcmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s94pXcmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C99C4CEF1;
	Tue, 16 Dec 2025 11:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883982;
	bh=SaPs8BsPlIsJ6bBiYLb3Dix3cdHTeaVcyvLSKocgUJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s94pXcmdaN/Jfb4li7HDnrYm0+JLaq/weSYCpLbUTPpZ51kzF8hMSbGwiRgbeIlhD
	 vsh3nZrzCQhxFNjjX6dRk9CayrfLtIN2kI9EwQYS/9HtE6C/zbETusxtTSXiQ/k/CK
	 t/XAsnLnJDZiJnZX1afn+AnxpdUXW8TjQ0wh8ZX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilpo Jarvinen <ilpo.jarvinen@linux.intel.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/354] PCI: rcar-gen2: Drop ARM dependency from PCI_RCAR_GEN2
Date: Tue, 16 Dec 2025 12:10:23 +0100
Message-ID: <20251216111322.948245084@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9800b76810540..481acb03af80d 100644
--- a/drivers/pci/controller/Kconfig
+++ b/drivers/pci/controller/Kconfig
@@ -249,12 +249,11 @@ config PCIE_RCAR_EP
 
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



