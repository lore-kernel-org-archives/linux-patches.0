Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023378;
	b=2RUgwI2oYLn+TNyeiqF85hPJYb1i1zOV6x6rJwB5MXxBOmeVQ0NmcwkizQKpkKHVrkrD
	 KR/IdqixjztGi8aYaIJl6zloRCgKywVXYjq/0HHWNGQle+1Lg9Z+YdOLBr79uR49iON45
	 rKRyxdGKULNMfgJODLmzjMAt52W6ppLOSlyCXbUKvGRPi0n2wV4LYO0eKHZLfSnk6ZwX8
	 7CNXOc+X9zwzgFdh8XR/AD3TF8lJZfVEwnxoJRjIiOl5ajFi0Yt0ojgTTnoVOdGwIu2H4
	 XhhKoLTPrSkCQF5oQ2Il7c+KMUdTCpNGVBJJGdxe05poRaLTF2uoDZ/bU9h7Gi0zepg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023378;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BZ7l3+VXDmjrSk9LcTwyQgU9rNTEHlm9KIcXkfcaqSI=;
	b=hKXd+yaUeKYSfaoxohfl6s5uz4yfBhVjPMKG17o4U9a1rXl3d4NW/KAVSEbGSFovoF7R
	 e+lFxubZjT8DazGRk1azzokHytKG/nwHMgMhdloDLe0M7oVFM4RiGt7A6xQ83YlAg+x2b
	 isqjA7RVbBq78IITGqhoICtpHYx40ZhjpuF2iWwqQc+Pk3ImBGXTOYTgCsKOgH7z5E+V2
	 fyCNzClVbgQCbQlr9s8TB/ci67k7kpYhilM26RA76pEQB/kLN1tD22oPyOgxkHTeW6OTe
	 yFC4aUPSTG4k0N1+D9nEI2/QQxtus2Z+M6WL8ueUpB9zaChjuGe+K8I/qkxSzUyYUdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jKO/rrSa";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2E060A2636;
	Wed, 18 Nov 2026 17:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKO/rrSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB131F000CE;
	Wed, 18 Nov 2026 17:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023378;
	bh=BZ7l3+VXDmjrSk9LcTwyQgU9rNTEHlm9KIcXkfcaqSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKO/rrSa/FFREePkJRgXDFUCTk4w+JAdXZ6SKW9kg11/TkRYGyPpNIEUAL97S3XcR
	 2I7e+4seZXX5RXZdikQdQSu5Foe0cLSsL8PY2z1SyIm27woRB6c+/amf//sr4QkuQd
	 3ZY+g7aU8sCraAA4T5FFk8gVUaBW/mMoTt3aLYVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0349/2151] PCI: xgene: Use managed clock for PCIe controller
Date: Wed, 18 Nov 2026 15:34:44 +0100
Message-ID: <20261118150134.814649492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



