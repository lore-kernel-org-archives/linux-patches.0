Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38045223339;
	Mon,  2 Jun 2025 14:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873534; cv=none; b=VnpX7+vHJIgdum7v4p74vwqjJNxwRlDrtRrJ06LHNOSfROjoRcr9sLVROvE/FlL7+3AH/rrB70qCO0kdGajiCS/uM7VCidntAeqi+7sUFSrS/yVb7GbrODGNcOCVQZ0ilaI851gwlWb+TH7CtK4eUJuGZ1zJw9vypum+4W0txZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873534; c=relaxed/simple;
	bh=FhMrIv/Oa0+Olqkqpoac/abfPVdf6QvTtinXEsyWcEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nPO6HTuG21OdF9ViVCUGQMHoBpUYw1RAGMYb5A+WA1SS0/MlCabxal0iEUs1XJgf9Nw+t3GbpSgB4Zh2ADIjIUpiSULQtHTY0tpJm6ErRObnxryPaG3xaoCnQzh5vtsnkQn+xBp520jz7+Q7tKTBY/gqN9T4URNZh1RYMS6hWNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fa8dbe/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fa8dbe/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EAEC4CEEB;
	Mon,  2 Jun 2025 14:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873534;
	bh=FhMrIv/Oa0+Olqkqpoac/abfPVdf6QvTtinXEsyWcEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fa8dbe/NGGpEwe319vxpzAr9FM3A/wn2QQJz9PzmI2NkeTrW4Ln6ihozZB3zh7KpF
	 IbEx755ZFq0y9WSrbV9DBWPk2Lhd0CVC1vVzyXndHpqUiVqYRcTRS6xgSqpMZr/Nk/
	 qwpkX9OTyuk57DxbmKcDeuu90GZIJmBrIIcmyWGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanimir Varbanov <svarbanov@suse.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"Ivan T. Ivanov" <iivanov@suse.de>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/444] PCI: brcmstb: Add a softdep to MIP MSI-X driver
Date: Mon,  2 Jun 2025 15:43:54 +0200
Message-ID: <20250602134347.799570987@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Stanimir Varbanov <svarbanov@suse.de>

[ Upstream commit 2294059118c550464dd8906286324d90c33b152b ]

Then the brcmstb PCIe driver and MIP MSI-X interrupt controller
drivers are built as modules there could be a race in probing.

To avoid this, add a softdep to MIP driver to guarantee that
MIP driver will be load first.

Signed-off-by: Stanimir Varbanov <svarbanov@suse.de>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Ivan T. Ivanov <iivanov@suse.de>
Link: https://lore.kernel.org/r/20250224083559.47645-5-svarbanov@suse.de
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 8b88e30db7447..9bcf4c68058eb 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1632,3 +1632,4 @@ module_platform_driver(brcm_pcie_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Broadcom STB PCIe RC driver");
 MODULE_AUTHOR("Broadcom");
+MODULE_SOFTDEP("pre: irq_bcm2712_mip");
-- 
2.39.5



