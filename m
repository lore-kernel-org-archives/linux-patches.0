Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1389331A6E;
	Sat, 12 Sep 2026 16:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229576; cv=none; b=cP3xy8R8hoT1y7jbcT7253TUqnLseP++lP1ZsadePSGzt3AapqQzVtLJ3heD8fy4z1afRQcZw5xWdIyj7Gqa0Ob8DK1USArgd77RIowFiFjPTb7GZW5yuPIuER2JXV/VI5xEk4b/mFhRKpB5di1Fk+Lv3o7u4DnE7Ki6qWbhREM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229576; c=relaxed/simple;
	bh=6gA98YgahtZtYg32Y6+WnMWCkQaTtW7tQuvc+V/j8NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eg/yRaVTN/5t9YBCkqNWDPjycq6lk3YecqYb50j0KRJHsnHT3Qdwv6TqyQ5xFzIbUkDuWiiOMN37ApebstF2M6KAxqzSyPod/9RZLEuQA6WbnJVskYgiOVZ0uOZCl4ifAUIh0nitxxzSzFwpKfqAgnRcEz9VVdkd/a0Y+RjMVxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9j8ogfT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9j8ogfT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3171F000FF;
	Sat, 12 Sep 2026 16:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229575;
	bh=xLZjSFHfJwyrJ/+AO368wLVBuoY1J77h18V9k9+v9jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9j8ogfTBBLrROYZGa6MIv1T9gx5LrsanwV0ktPN+f6Tat7q/SDeg6kfflKY5UwSz
	 CLjGwefgzZQzOx0Kvnnr+pxCnwE/v+rx9jGVA5PpQuZxGQTBlY1Q+iJA+IaUtvx5tR
	 DtXRUOKVITmEFrwvuNAWestve9aZ9G03PvXmHUCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0618/1191] PCI: xgene: Drop XGENE_PCIE_IP_VER_UNKN
Date: Sat, 12 Sep 2026 08:55:46 +0200
Message-ID: <20260912065602.133104086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 549d3bd6d1c27..049881a96cf44 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -54,7 +54,6 @@
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



