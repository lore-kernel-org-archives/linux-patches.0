Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28DB148314;
	Fri,  6 Dec 2024 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497682; cv=none; b=fdaRVjpWD6Gng/O8bFe9ae9x89rvLg52E51TlQA8GVt2I9zxXaP8jyb2TBOUwnSF1cbghiDCebMEM7zgTSFpBxxcikWSxhMO26Qq8mnNIZ0/KukjuqXY9lac16cAG0edO1XHWcap1Hs8zcWu33wp3h5k82nC4WHdmmWfMmtPVow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497682; c=relaxed/simple;
	bh=40yOOPQMqOBNOPbiRH/Cvn78zy5XQbkLUreIQcoTNLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cjeYk44h81FMkpc54ut6/q847JTFJABqmmkY5av4i4q4zHkOuUwtOg+/Rm9RGdkCKfI6LE5vutg7vhIq7pHkslUB2tUSHZZQPRZ1qiAUT+6JSpsnZxBxkxvdH5OAqi5Rz7awhdCe0QZa9fSPQL11TC8PnmLaRQhwAhNlhykMCWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AErHQAA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AErHQAA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBC6C4CEDC;
	Fri,  6 Dec 2024 15:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497682;
	bh=40yOOPQMqOBNOPbiRH/Cvn78zy5XQbkLUreIQcoTNLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AErHQAA36h4khEb1v6kBiEuqzeGUdIqC10Qxbf5H9eUqiH48ZorrviBXG+WE+pbwf
	 KesaqkboJs6fqzAJ/ChttDwhncrwecCsEc8vQqazfCjzU+gwiEGZNIwMMRYfJifegN
	 XcChVMUCeb0tR4QHBSPS8Z7nF/Cn7tZvra98LIUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 362/676] PCI: cadence: Set cdns_pcie_host_init() global
Date: Fri,  6 Dec 2024 15:33:01 +0100
Message-ID: <20241206143707.486513390@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Thomas Richard <thomas.richard@bootlin.com>

[ Upstream commit 063c938928dc80c2bfd66f34df48344db22e009b ]

During the resume sequence of the host, cdns_pcie_host_init() needs to be
called, so set it global.

The dev function parameter is removed, as it isn't used.

Link: https://lore.kernel.org/linux-pci/20240102-j7200-pcie-s2r-v7-2-a2f9156da6c3@bootlin.com
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Stable-dep-of: 22a9120479a4 ("PCI: j721e: Deassert PERST# after a delay of PCIE_T_PVPERL_MS milliseconds")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence-host.c | 5 ++---
 drivers/pci/controller/cadence/pcie-cadence.h      | 6 ++++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-host.c b/drivers/pci/controller/cadence/pcie-cadence-host.c
index 93d9922730af5..8af95e9da7cec 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -485,8 +485,7 @@ static int cdns_pcie_host_init_address_translation(struct cdns_pcie_rc *rc)
 	return cdns_pcie_host_map_dma_ranges(rc);
 }
 
-static int cdns_pcie_host_init(struct device *dev,
-			       struct cdns_pcie_rc *rc)
+int cdns_pcie_host_init(struct cdns_pcie_rc *rc)
 {
 	int err;
 
@@ -564,7 +563,7 @@ int cdns_pcie_host_setup(struct cdns_pcie_rc *rc)
 	for (bar = RP_BAR0; bar <= RP_NO_BAR; bar++)
 		rc->avail_ib_bar[bar] = true;
 
-	ret = cdns_pcie_host_init(dev, rc);
+	ret = cdns_pcie_host_init(rc);
 	if (ret)
 		return ret;
 
diff --git a/drivers/pci/controller/cadence/pcie-cadence.h b/drivers/pci/controller/cadence/pcie-cadence.h
index 4c687aeb810e8..d55dfd173f228 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -516,6 +516,7 @@ static inline bool cdns_pcie_link_up(struct cdns_pcie *pcie)
 
 #ifdef CONFIG_PCIE_CADENCE_HOST
 int cdns_pcie_host_link_setup(struct cdns_pcie_rc *rc);
+int cdns_pcie_host_init(struct cdns_pcie_rc *rc);
 int cdns_pcie_host_setup(struct cdns_pcie_rc *rc);
 void __iomem *cdns_pci_map_bus(struct pci_bus *bus, unsigned int devfn,
 			       int where);
@@ -525,6 +526,11 @@ static inline int cdns_pcie_host_link_setup(struct cdns_pcie_rc *rc)
 	return 0;
 }
 
+static inline int cdns_pcie_host_init(struct cdns_pcie_rc *rc)
+{
+	return 0;
+}
+
 static inline int cdns_pcie_host_setup(struct cdns_pcie_rc *rc)
 {
 	return 0;
-- 
2.43.0



