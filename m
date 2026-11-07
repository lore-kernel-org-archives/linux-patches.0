Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064804;
	b=xJ1gH335t7HUO+U4OdS0Nv23jracNj/6vXdTUTzHaRrWXOTyYJAJoOLY/dUR+eFwBZpQ
	 zDwfyrmb0XLnZ/pfYQriNtm0FZLuLzVQhLB2T3Y329FISB2S0C1GP64c4/U/ioONKIUrc
	 f05fBdvXq0WW3nJSW+ltHiYM3dfJj1CcpkH+I5+Mpt1S8bLKUXVVoHPLhmDJUpbgHFUmM
	 XCzislMhfchx3JU3Ax7xljF7jeB8Qc5wnbLUtPI+T5jTEnirZfKK5V/jHYlAxe6g0b2D5
	 T5ZGv6ar1m+h0prk8QVxk/eJ4BBlERJ9Yvq4vWZXuJ2AFyNKPo3vyb+bG+Psz49oeoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=thipwQvQCPqpVaqpNNm2rmvjRxkbrkQlSkibH7jZn/I=;
	b=u2cjIKgzmiOr9XzAq1H9jsKQgCbH750cAdqINeZdYwr9nWo8S5i20ym6kC/qrvRgoWbC
	 09TzSchWfbeym+aE3eFR8tRQkVUnYTFeBeRUDuXabCA1v7mG637QCFz2CDjmhvtmshTDu
	 19Q4Cl0htawNkrCiI4opwFHvLSQrPzbkVO8vbcL4UJ6UqyOLe2LmACj7zbiIZpNR5ja2s
	 rDfx1e3FpsHKiAZvOex9w70s0PT95r2Z/GB5l3OVJ5lrg00vVj6mrQi+6OG5bCgZYhMKP
	 iPSgUFK6TNip+9wG71bQCgwJ5IptnQUnAvq+eB09cyq23gm9LCHLA6UALRj+lWK+ETA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ayJP4+lk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD24606A33E;
	Sat,  7 Nov 2026 15:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ayJP4+lk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868531F008A1;
	Sat,  7 Nov 2026 15:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064803;
	bh=thipwQvQCPqpVaqpNNm2rmvjRxkbrkQlSkibH7jZn/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ayJP4+lkFzEKp1O3VWY75J1hGUm1cs1XTBFAxH5vjHO2iBHOWR5SCefkX+OxhknCQ
	 RnbJfs6TAe8O7UyAY8ehKc51TTJQYoc/U7Z/wPvRMW3Sgs53v8Q9UXdJCMm1+kT2Pd
	 8JQrhxJqJ4hApvHa1uJ1HcVP+X/QyAcfVJJtdCnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudi Heitbaum <rudi@heitbaum.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0744/1257] PCI: imx6: Avoid dereferencing a NULL clock name
Date: Sat,  7 Nov 2026 08:50:40 -0500
Message-ID: <20261107134959.839177557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rudi Heitbaum <rudi@heitbaum.com>

[ Upstream commit e60d0d4dfddfac3058753a1c2255251401c92dad ]

of_clk_bulk_get() leaves 'clk_bulk_data->id' as NULL for every clock that
has no matching entry in "clock-names", which is legal: a node may list
more "clocks" phandles than it names. Both scans of the bulk array
dereference that id unconditionally, so such a node oopses during probe.

The loop in imx_pcie_probe() has been wrong since it was written. The
loop in imx_setup_phy_mpll() was not: it read a fixed clks[] whose ids
came from the driver's own clk_names[] and were never NULL, and only
became wrong when the driver moved to the bulk array.

Check 'clk_bulk_data->id' before dereferencing it in both.

Fixes: f6a1fdfc78e2 ("PCI: imx6: Use devm_clk_bulk_get_all() to fetch clocks")
Fixes: d8574ce57d76 ("PCI: imx6: Add external reference clock input mode support")
Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Acked-by: Richard Zhu <hongxing.zhu@nxp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/am8iBwJSEhYhWTqk@6cfee64030a6/
Link: https://patch.msgid.link/aqfqE4OLhnN4a1lW@b65e9c1eb12f
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index f7a2eb257c169..785f575e0134e 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -542,7 +542,7 @@ static int imx_setup_phy_mpll(struct imx_pcie *imx_pcie)
 		return 0;
 
 	for (i = 0; i < imx_pcie->num_clks; i++)
-		if (strncmp(clks[i].id, "pcie_phy", 8) == 0)
+		if (clks[i].id && strncmp(clks[i].id, "pcie_phy", 8) == 0)
 			phy_rate = clk_get_rate(clks[i].clk);
 
 	switch (phy_rate) {
@@ -1836,7 +1836,8 @@ static int imx_pcie_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, imx_pcie->num_clks,
 				     "failed to get clocks\n");
 	for (i = 0; i < imx_pcie->num_clks; i++)
-		if (strncmp(imx_pcie->clks[i].id, "extref", 6) == 0)
+		if (imx_pcie->clks[i].id &&
+		    strncmp(imx_pcie->clks[i].id, "extref", 6) == 0)
 			imx_pcie->enable_ext_refclk = true;
 
 	if (imx_check_flag(imx_pcie, IMX_PCIE_FLAG_HAS_PHYDRV)) {
-- 
2.53.0



