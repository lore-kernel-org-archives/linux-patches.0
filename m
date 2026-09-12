Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBA133E35C;
	Sat, 12 Sep 2026 12:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215523; cv=none; b=hwVIACxiXU9kC1DNwCXTdJwimn8x99p9NVOpGmKr35OtEyFLxBigZGCR9KrDXlaH7US2R8o2qUBKBD62TSUvNON6GgB+OLJdNA0hKs42vHul0c2vYOD+PFvS4o9InHs05sf3MY2L0YSKCC0f8xkvSYjLD6Lzbk0SSwkjGF8TOOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215523; c=relaxed/simple;
	bh=CMkRLa2J/LO3op+2KU2nebt0cMB3X0JDAIPiv6l14p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQcetT6+cf/+8Eq6oV0fcqM3lfR51tzkranCMO4Kv+ntGRYZyQkK/gsoep9KeFhCx0hcUtT+v4txHWQrb2bzvlNW/s0Q1q8AOchYNRrt6oLJ3dA5BO2zAq+TdFTTmaCAJaSc3uF/Z2rN/LnCB1F6lgZr3KgZegfs3o80Z9Nfw1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NThKik2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NThKik2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B1F1F000FF;
	Sat, 12 Sep 2026 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215521;
	bh=sM3pEG6vtJcZapCg/BAouU+NapaqjZsKYw7NH4kbEFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NThKik2f3vw09J1HxnPToH8bD0SapLbPCkUMIH98bRqcDhX7dhjyHORnNeZSJbY0w
	 2jH94MDctHYM+mjNw0SAPTQTDkFAAHbk/1X2Vxf4XndtB5EKF7Z26chygDKqWI52El
	 aOJnhInrPZLbnBrAEzfv7bhEShYH0pDViY8ISq7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0548/1376] PCI: xgene: Drop XGENE_PCIE_IP_VER_UNKN
Date: Sat, 12 Sep 2026 08:49:34 +0200
Message-ID: <20260912065619.752548595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1e2ebbfa36d19..16d4fd2364e35 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -53,7 +53,6 @@
 #define XGENE_V1_PCI_EXP_CAP		0x40
 
 /* PCIe IP version */
-#define XGENE_PCIE_IP_VER_UNKN		0
 #define XGENE_PCIE_IP_VER_1		1
 #define XGENE_PCIE_IP_VER_2		2
 
@@ -610,10 +609,7 @@ static int xgene_pcie_probe(struct platform_device *pdev)
 
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



