Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22C32D7BF;
	Tue,  3 Dec 2024 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239137; cv=none; b=AU3Vg9fWvVjUocVfJLFZ10CFV37raGC0P766Xa5zkwLIp4gmGGxMcsc7t8XfJO5S2WTc0oTgmcQNkpoJEQy/H30Ivkv8wZQbsFM55M2kddxEaQ3D5ORs8r1pno6V21+aXQ5DzOX+6xy15U27nxjdc+6a92V2LHX4nsKDV0SOg0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239137; c=relaxed/simple;
	bh=TPLC7YUa7g19iE9zFvz6LbG8juoE58rpMGIK//dOXZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c2ViERHUndjo6SXEErSWov6TP4DlQD+JtbW30e8isTZ/wrz402noMptHd1A1+VPaYZR8uzkenlilvg6wCAqus6zqLm4wQYPOI3AJgKhuKT39RJ9ygdIyAzDR6jmpbQCwA3dUdTK4UZH+Pg0rXXyH/zdFlBb+KTo85xBUfHK1wy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAAn05Ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAAn05Ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38500C4CECF;
	Tue,  3 Dec 2024 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239137;
	bh=TPLC7YUa7g19iE9zFvz6LbG8juoE58rpMGIK//dOXZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZAAn05Ei/KCcGIl05PKpZqTwvqTyDQ0ecrpUeEsmQ4ibPt5SNDYE5ZFq41zgImCW6
	 w/VjaFT50Ja13iMCXBh2DcDq6T3RuDVtCXLS28EQZML9kUQtLpdVDLClSY+T3YbnXx
	 hR7WZr5ZIq+orhh4vRm51/hNg0sm8674bllKo0Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 516/817] PCI: cadence: Set cdns_pcie_host_init() global
Date: Tue,  3 Dec 2024 15:41:28 +0100
Message-ID: <20241203144016.037324488@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 1d37d5f9f811c..bb215aeebf20a 100644
--- a/drivers/pci/controller/cadence/pcie-cadence.h
+++ b/drivers/pci/controller/cadence/pcie-cadence.h
@@ -522,6 +522,7 @@ static inline bool cdns_pcie_link_up(struct cdns_pcie *pcie)
 
 #ifdef CONFIG_PCIE_CADENCE_HOST
 int cdns_pcie_host_link_setup(struct cdns_pcie_rc *rc);
+int cdns_pcie_host_init(struct cdns_pcie_rc *rc);
 int cdns_pcie_host_setup(struct cdns_pcie_rc *rc);
 void __iomem *cdns_pci_map_bus(struct pci_bus *bus, unsigned int devfn,
 			       int where);
@@ -531,6 +532,11 @@ static inline int cdns_pcie_host_link_setup(struct cdns_pcie_rc *rc)
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



