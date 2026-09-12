Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBC932A3DA;
	Sat, 12 Sep 2026 14:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223292; cv=none; b=D1U35lotZHKGQYmVE2i5TKCaIECGdxuoMSCrC1AkkzYmqshWJfBx1KaJYnvxDsgor1Km/Vp3DQQw8voEPFBI9d8q2z8CHao6WRsWqOZR2sWGZAT5ab41P1fbBbRmrr/XbPFu1YnYnQ+rupcSJBagFaQlJCZabBjfjN57RxA0MjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223292; c=relaxed/simple;
	bh=r7PRdTehMZeiF4oKem4rqyLA8iYMi61Z++jT4j4fEzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/OV04p9gS/d1fl+nP3pXKnddKM2xDPV9h2icW2vOCc7V3j2mggDrcNt9sqS/Ezl5vJ1Yj8G3Bq1JqTC3kmjleo9//GRTfEGtnqUoFO86UT0i7c9mjShr1S50lFC3caJbYhSejxj+CCNJWHBrnzAjdNP4cNNiqoZvS8YNqMUNXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiP2ngcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiP2ngcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BF71F000FF;
	Sat, 12 Sep 2026 14:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223291;
	bh=/oFhrYCpdE7/IJ+NssjXS1dcMbgAkyi3KZYjEJKl0Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RiP2ngcqu7/nY25sFs0mwpyv/oDnv2bcDDTTvtUEDJre+Gfvl7MqBgxHhPg313eb8
	 mYtaPYGq0Smlrev/cZzltAHeRezitNz6abeuTjfd0ouZJZSVqlbuAoBfxrGTLqVd7n
	 iv70uBiwcT3DaFk4pcGnMVwQXY9OCSnJsFX4aoOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0759/1424] PCI: xgene: Drop XGENE_PCIE_IP_VER_UNKN
Date: Sat, 12 Sep 2026 08:53:11 +0200
Message-ID: <20260912065624.294472476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit fddf72ed7b52c91da37fe5f1d4faed11251b714f ]

XGENE_PCIE_IP_VER_UNKN is only refered to when probing for the
original XGene PCIe implementation, and get immediately overridden
if the device has the "apm,xgene-pcie" compatible string.

Given that the only way to get there is by finding this very string in
the DT, it is obvious that we will always overwrite the version with
XGENE_PCIE_IP_VER_1.

Drop the whole thing.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20250708173404.1278635-5-maz@kernel.org
Stable-dep-of: 4869db344e76 ("PCI: xgene: Drop unnecessary OF node reference")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-xgene.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index 887b4941ff32f..cf89b799e0b9f 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -53,7 +53,6 @@
 #define XGENE_V1_PCI_EXP_CAP		0x40
 
 /* PCIe IP version */
-#define XGENE_PCIE_IP_VER_UNKN		0
 #define XGENE_PCIE_IP_VER_1		1
 #define XGENE_PCIE_IP_VER_2		2
 
@@ -609,10 +608,7 @@ static int xgene_pcie_probe(struct platform_device *pdev)
 
 	port->node = of_node_get(dn);
 	port->dev = dev;
-
-	port->version = XGENE_PCIE_IP_VER_UNKN;
-	if (of_device_is_compatible(port->node, "apm,xgene-pcie"))
-		port->version = XGENE_PCIE_IP_VER_1;
+	port->version = XGENE_PCIE_IP_VER_1;
 
 	ret = xgene_pcie_map_reg(port, pdev);
 	if (ret)
-- 
2.53.0



