Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015938;
	b=PU2/aGdLJ/gBNJoey8qZNU1uaQq/I/YoDZDmxwITrxMDuJ8HuZzKwKgykh57+saoNKNW
	 B2DFx8bchuzyY/dUGTZkBRU+43mBgI/WR0TesLPZonz/ezshMlUWYZgPaDs28Kx+pXvWk
	 ZoYGIlwJ83IIsnolyWGli7W/JhDmf3qwEVWXb522yLmTTd3/dSvGDKLWsXjmiDgxwzMVW
	 thbMYwTP/Y3E0mm3OTIdwbTImvLpkwDvPr8qQeZM6b7bSsjjTt5pS3UZhPM921A8gnr1k
	 MpQnAdgI0GHhvBohNYcqxgeXk2WLnec8L40QHYTg7mY208OF8SUJWTf8hoeq6roILSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LSfJ/1t3REIr0gSOlm28twrf8CMf/M8HiqAl8MLD2xg=;
	b=TXUfRlS0ofS5lTe+eGEL73aLcN4emMTEn69BfAZp5cygGizAj00IS5/X5T4HCtZCHYaM
	 70M1C6FaBMD14LLgfRcKScU7VMQ8EkGxH0SBPQbmD/5BlQIPBSn2kidyGvArbZhbAdUIo
	 zGqPc3OZUtDrysLItKvoLKr75mDrzdRS9zLef2E1YTL8cBqm5ItBYMH9VbaxTSDmAPLt8
	 cupmAU/MfeNLuDWdFEeY+J694uEdV/49cdxji7R43EYPCgtQ+5lprNgBzTVIFaLEUpNek
	 jWFN4Cmv3iYuqJ0aZtRqDf7N6CCI/96W2x2olfM6+41VNIlMfv9XDAKCQxRqW1XYAOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OaGoLNRP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E173606A32C;
	Wed, 18 Nov 2026 15:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OaGoLNRP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0064B1F000C4;
	Wed, 18 Nov 2026 15:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015938;
	bh=LSfJ/1t3REIr0gSOlm28twrf8CMf/M8HiqAl8MLD2xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OaGoLNRPVJz4dElaOkG2JIN9zwfDyCzU7kACFQGjFZmNIv/lF8ItEWVqAjg/pjIYR
	 SI/k7090Q7TpdGD9BeddDEJRMIf6jC8Wnu1Yuhbn/c6Gaf3qZ11fRLMt6Kf1e+W2D5
	 8JwQ76m3JW0xOomJOV7djayHvHfSIfIf5Twme5/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0352/2651] PCI: xgene: Use managed clock for PCIe controller
Date: Wed, 18 Nov 2026 15:26:32 +0100
Message-ID: <20261118150300.511882647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 83c9a2930eeca..a5b8bbc04a221 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -320,18 +320,11 @@ static void xgene_pcie_linkup(struct xgene_pcie *port,
 static int xgene_pcie_init_port(struct xgene_pcie *port)
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



