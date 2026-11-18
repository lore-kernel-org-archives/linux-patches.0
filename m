Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060455;
	b=KKpourMX6gGE49/rpEIchLZFjHIs27USagTKlVdj6IGK6RcGQE6azuHeNGm2H7YKl6l6
	 au5mMRLejiv+u3GDHfGETFgL+Y7gFfM0qInlahufeY6Jz5aB44BTI3/z4Ru5SKFqxiiyL
	 UBRBgNn8hGEY473Z3A3zpbrssQ1I6pVnR/+W/5ppBBZdpe+hnq8UFrnBl2Gx71p9pmYac
	 HSLfVem9S0T915SLDQBKrghgfxLlvZRexzeZ3OYLBNtNdwtg2y6L9OhFn2DoxWiCEUqJR
	 a8KUwXTiFnxONfPlcYdlJFNZL1fyGu6OJ95qF5lFaQ8OXf6qL/DE1Cld2ONstSEEOZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZDvzKn9fW3occxNZ9oNhyPhksk31OZuEB6E3z27j4p4=;
	b=nn1/JGAbUOoshGOhMAOEyqoELFGM6cuDYtFjl1/WNK7V43ggJtruqvT3yZj1YeW8u0QG
	 73vs8Ri3DlRSKZVQvCpm33sTFpZz4+QWIcSQ51s69fumPpxJBdt5z02myagz5gqVRl5BW
	 wDHleNPEEGnIf8D5OQmA0X63cB18ECoSLq4+/fLA6K4rLiWEQbCzaBeS17J21CR6rHA2s
	 hyjnpwxmeW9VHYz5QiyKs+yRewINf9bcQ9EDrlYrN1IDNinW91a/++cdbEIfLrnnK3tPn
	 YjSf9Z8bjwLEOu4x1/gE00ePbTMyX3iypfA0zKQW5H+w5f/6jqQs6wPI1H5MLZrS0yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NQR/cdKe";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2561C606A325;
	Thu, 19 Nov 2026 03:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQR/cdKe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC711F000C4;
	Thu, 19 Nov 2026 03:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060455;
	bh=ZDvzKn9fW3occxNZ9oNhyPhksk31OZuEB6E3z27j4p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQR/cdKeSV+dx9HD9nBL+SzGv0iBZ9EcxqB5Phn5e/SORGoTTkMr7UtU2vxxaRgyz
	 0D4DACjCotSz18zd7EzygX6BITryh4g+KFjJI2bp3xHaEF+sNDZWDOgA3sLCq6iNE1
	 w9BAoavUoBt+QwgXHLNOSfu3SdSymCghuGx/4O7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1206/1848] PCI: xgene: Use managed clock for PCIe controller
Date: Wed, 18 Nov 2026 15:54:04 +0100
Message-ID: <20261118150010.501972061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit b9022584ebbae81f7bbe4a61bd1df0d0a95e1a99 ]

xgene_pcie_init_port() obtains and enables the controller clock manually.
When xgene_pcie_setup() or pci_host_probe() fails, probe returns without
disabling, unpreparing, or releasing the clock. A failed enable also leaves
the clk_get() reference unreleased.

Use devm_clk_get_enabled() so the clock is unwound automatically on probe
failure and device removal.

Fixes: 5f6b6ccdbe1c ("PCI: xgene: Add APM X-Gene PCIe driver")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260802221146.573233-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-xgene.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index e1c2daa50b498..4b299fb5ab944 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -327,18 +327,11 @@ static void xgene_pcie_linkup(struct xgene_pcie_port *port,
 static int xgene_pcie_init_port(struct xgene_pcie_port *port)
 {
 	struct device *dev = port->dev;
-	int rc;
 
-	port->clk = clk_get(dev, NULL);
+	port->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(port->clk)) {
 		dev_err(dev, "clock not available\n");
-		return -ENODEV;
-	}
-
-	rc = clk_prepare_enable(port->clk);
-	if (rc) {
-		dev_err(dev, "clock enable failed\n");
-		return rc;
+		return PTR_ERR(port->clk);
 	}
 
 	return 0;
-- 
2.53.0



