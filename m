Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044067;
	b=Wq8VTHI1SZyQmh12Y2TY/OUb7uJQXzNoWRJxNN02YwYq1wOwToLrBunjK3I4wneMam6q
	 LRg5wTJ1IhmYFrJGLrayUccJbMBAA6IUUzpIjcclngWf5HtLGhlgQbomIYF4nHpJrC/XJ
	 7qVjIxHXupvLx0mwp5ak24TEcRNd55YG3vu7peocvo4HdZWCTZJ2QECMVXmfP+h4JteQv
	 7cEj+Oj6ccYe1Qayd03gFAczYADoAB2ZNsiTzAVOC2GO9iWGBYiKqk7NguQCGPyUQRNhS
	 gpKiPJREDay1bHPoDT+rwP2vDOx3TVQErkMlaaDvUV844c/K9nPaABBbZYHCB8BTNAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EyikLTlhkm0m6XiB0aNry0hQ5I+KOX+CYN+iV3cwSJI=;
	b=e0W6JEbw8Eul0if2fx1BNCiMtIdufZHIQ1hFBu5ZbwPE4xo84OUwG+7yrM3B5+1XDjDB
	 833lNO5FbooCNxtPXweJC9f4dBfuJxbhtt5Z1E9xfqkRlyInPiIlpxV5/DrWYJEiemQ4r
	 zWtpPatcFNQT4K9TLDJfsgmsE9PafbNfL9zJcpEemZ6tFbCgZBGUBxp1acZZ94aJvIrUs
	 YFrIHTQ9DdiIUpyPLaDG5SCcLazC4A9tMIFSJ1cYfp26ZLweYulcJ0kAH809ssGu/eHUN
	 1N7hEdtQd/SsEGdTb1Len4gIT4JmdknlGflvFGmevc1C+eN64gl0/c3WiiF37ahrcaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCG22PNM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EEF606A325;
	Wed, 18 Nov 2026 23:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCG22PNM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E72E1F000C4;
	Wed, 18 Nov 2026 23:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044066;
	bh=EyikLTlhkm0m6XiB0aNry0hQ5I+KOX+CYN+iV3cwSJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCG22PNMLcPkO1CCv+EyU598CZUjsyvPlrORcxAlSSQcAgGUfHT8dPDbNrw1/tJeE
	 d+o5mvxUUeSbd2AO0xaet8LRC1zCdLRyewctmoeO4ToC0/ZaTOdOGDIRH80eOmnbIs
	 CHDFgJKtgyBWv7wEh+/TgdFRcoLZDBTLkGbVxfKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0435/2857] ata: libahci_platform: Simplify code with for_each_child_of_node_scoped()
Date: Wed, 18 Nov 2026 15:24:29 +0100
Message-ID: <20261118150217.044565910@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Zekun <zhangzekun11@huawei.com>

[ Upstream commit aa3ca1faf3222af7aaa194a910995820135fc54e ]

for_each_child_of_node_scoped() can put the device_node automatically.
So let's use it to make the code simpler by avoiding the need to
explicitly call of_node_put().

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
Link: https://lore.kernel.org/r/20240810023426.110624-1-zhangzekun11@huawei.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Stable-dep-of: 0d1cb83337f1 ("ata: libahci_platform: Fix device reference leak in ahci_platform_get_resources()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libahci_platform.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index d4fccc0625800..50aaa82d4971a 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -418,7 +418,6 @@ static int ahci_platform_get_regulator(struct ahci_host_priv *hpriv, u32 port,
 static int ahci_platform_get_firmware(struct ahci_host_priv *hpriv,
 				      struct device *dev)
 {
-	struct device_node *child;
 	u32 port;
 
 	if (!of_property_read_u32(dev->of_node, "hba-cap", &hpriv->saved_cap))
@@ -427,14 +426,12 @@ static int ahci_platform_get_firmware(struct ahci_host_priv *hpriv,
 	of_property_read_u32(dev->of_node,
 			     "ports-implemented", &hpriv->saved_port_map);
 
-	for_each_child_of_node(dev->of_node, child) {
+	for_each_child_of_node_scoped(dev->of_node, child) {
 		if (!of_device_is_available(child))
 			continue;
 
-		if (of_property_read_u32(child, "reg", &port)) {
-			of_node_put(child);
+		if (of_property_read_u32(child, "reg", &port))
 			return -EINVAL;
-		}
 
 		if (!of_property_read_u32(child, "hba-port-cap", &hpriv->saved_port_cap[port]))
 			hpriv->saved_port_cap[port] &= PORT_CMD_CAP;
@@ -482,7 +479,6 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 	int child_nodes, rc = -ENOMEM, enabled_ports = 0;
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
-	struct device_node *child;
 	u32 mask_port_map = 0;
 	u32 max_port;
 
@@ -604,7 +600,7 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 	}
 
 	if (child_nodes) {
-		for_each_child_of_node(dev->of_node, child) {
+		for_each_child_of_node_scoped(dev->of_node, child) {
 			u32 port;
 			struct platform_device *port_dev __maybe_unused;
 
@@ -613,7 +609,6 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 
 			if (of_property_read_u32(child, "reg", &port)) {
 				rc = -EINVAL;
-				of_node_put(child);
 				goto err_out;
 			}
 
@@ -631,18 +626,14 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 			if (port_dev) {
 				rc = ahci_platform_get_regulator(hpriv, port,
 								&port_dev->dev);
-				if (rc == -EPROBE_DEFER) {
-					of_node_put(child);
+				if (rc == -EPROBE_DEFER)
 					goto err_out;
-				}
 			}
 #endif
 
 			rc = ahci_platform_get_phy(hpriv, port, dev, child);
-			if (rc) {
-				of_node_put(child);
+			if (rc)
 				goto err_out;
-			}
 
 			enabled_ports++;
 		}
-- 
2.53.0



