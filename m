Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590756;
	b=VGX1PfvEm8N/GT6pT+ZX39OKyV9r3cycija3oUY91aXXc3iNmMyq5XUI9hp4l+RmPAZN
	 fAqhozIMAmApKVj+MePXEOet5ttTdaHs51Z1voFtCLiHqpysEhVxcAjz8L7LmydSMRMl8
	 SyzfWzPeZR9KLpM30VxGdfNi1/jPQMkpXpjUPvashG3DsYjjUjVbtCXaPt57jUzcv+rcx
	 uKT9eKJjdt56/NdRz2dNox5Qi50edcdHA9Chh/jeaIO3SGuMsR+jyrbf9jZgiHRwliG5U
	 r/L0wCPm2ZFiMW0tQTMNdUAFglUQBEomUAccE9xqUx9gaNTLmHlsBP7KFV9IYW6bNTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rrQcgQOx50k0WjJmcPMsAvdiKZ3eHOGfAYRd+05hLkI=;
	b=hEozn2X2/RvOo3ySBrNcKz4SbOBFS0VXLiqzFuDFTWUgBO1RMTiqmlc+XUmyJG3Zn/99
	 tUim1G0qJQLOofK8z1hNcnVtFFeOXLL7XUoUHloTMYUwiwHZJb89paiRHAlHHWtluhl8P
	 M7ZVZT8x4P5Ea+WlPPuguySuPBB2hGvkO2T9hBpIfHvQ5Y3KT8r6I4M6XADwFWBUhZDAw
	 zEfdwsvlQVehSEDCQBMIx9s1YnYejnIJ3kZNhpIATquEl5hPGZY5QBTQKqzDypsM25PlA
	 vZ9JpEhpWvvZ4EBFqMOgk0pjd/7Ra28ziVUfndCH5PST09Cs0DieWNVNAxSjKC1RTFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JPXc+tpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DEB606E20A;
	Fri, 13 Nov 2026 17:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JPXc+tpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C341F000C7;
	Fri, 13 Nov 2026 17:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590756;
	bh=rrQcgQOx50k0WjJmcPMsAvdiKZ3eHOGfAYRd+05hLkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPXc+tpeuMtsx3yhaa1py8TKxCSVFhocJGvyvxoNZPn2S57NfkPheDCcywjJpkBTm
	 T5Ss+wPxdREaC7/eW0VVAAzyQgJZwPp2epBHkRhLO/1cRmtgKr9Klp9K7xVI5uPi5P
	 TFdS9Qsg4onPbjLKLEbMV4KO5Xx0YOtES4os3zgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rudi Heitbaum <rudi@heitbaum.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 657/686] PCI: imx6: Avoid dereferencing a NULL clock name
Date: Fri, 13 Nov 2026 10:53:10 -0500
Message-ID: <20261113153843.997930608@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Omitted the extref clock-name guard because the corresponding scan is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index de09cc2a63112..4235f1fb7b337 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -540,7 +540,7 @@ static int imx_setup_phy_mpll(struct imx_pcie *imx_pcie)
 		return 0;
 
 	for (i = 0; i < imx_pcie->num_clks; i++)
-		if (strncmp(clks[i].id, "pcie_phy", 8) == 0)
+		if (clks[i].id && strncmp(clks[i].id, "pcie_phy", 8) == 0)
 			phy_rate = clk_get_rate(clks[i].clk);
 
 	switch (phy_rate) {
-- 
2.53.0



