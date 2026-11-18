Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034926;
	b=1E74pNYJvBCamh26ixtAeDGbs1HG1T3d2XcB7oOvOjAKp4TAPiYiEVLR9oKdhS7sUkcU
	 xSLsjzvy87STE8yy18177Dk3Y3oFE0m+CcuGGDkk4QbcTwJFwvrm48epKa7Kk065ByILC
	 +EttzvscsGq/u0CVnwveyioKhhSE2PmgQKO3JRrGjOjpo2PcKyX9qBxf8NGPl8m7R4tKo
	 +h9EdcofE/2Ol7pYIK62ANPHA5mjWgvrcCVDC+B9TogMeTKqYXianmSFxTSo9qQ8t1ynm
	 oDAt83YPtDiqPvWAzRGic3ec0Wg/UXWAY4FPz/4tzGBJ7R9HtfLSK28pFncasjXL/Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQA3rcd5MfoqyFyRBBvSKUe6EyurfZRPhAp7NtFNAS8=;
	b=uCOxO/XgF2zQI+LinRk195jylGWrssPwIQruvfC72Je/pOwBW/0Nw/5IbcSVgnlumeCJ
	 In7476CtxBYCr6xV7VRCCtkyjvwVri1qAXjFOeyuXpJJ8+jbIGvUlzVkvixQzAn0SYL80
	 PPbQGOyPZaLdnW04zmMaypBjCWUBRQjd/WBpVNJdes/SaPkOX+LcjOqgeW3kRDilE161S
	 HOZU+xA6xvLsWX9nJlL1JX5lpjZkD2176iJY2kG1ifFiGKAbb2MCRRkUPW0tb/7iMVdYd
	 Y+O3oLvhd8mfgMnx3PWq51R4Z4C/l48FQEa4VpB339GV8NO6CV4Jh1YWAcLZLEQ/Z6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZDl4V3d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA3F606A31C;
	Wed, 18 Nov 2026 20:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZDl4V3d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762E31F000C4;
	Wed, 18 Nov 2026 20:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034926;
	bh=IQA3rcd5MfoqyFyRBBvSKUe6EyurfZRPhAp7NtFNAS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZDl4V3dknDJCq2I9Ivana7OLIlCrtXy8CZoJqhvpCAZA5k8bei2V11QdZGFGjRv6
	 s64tc1eS/bmYxYQvfNUgRPyH0YViXochdTZoOpJIkefF+SD6A6jDE5fJINSedEs8Dg
	 LVa2IR/huGhBCE9knfPJ/aiuYrnYQXyl/QY10D+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Zekun <zhangzekun11@huawei.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0483/3318] ata: libahci_platform: Simplify code with for_each_child_of_node_scoped()
Date: Wed, 18 Nov 2026 15:18:25 +0100
Message-ID: <20261118150331.453689793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1153b9f7ff12a..91d44302eac92 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -419,7 +419,6 @@ static int ahci_platform_get_regulator(struct ahci_host_priv *hpriv, u32 port,
 static int ahci_platform_get_firmware(struct ahci_host_priv *hpriv,
 				      struct device *dev)
 {
-	struct device_node *child;
 	u32 port;
 
 	if (!of_property_read_u32(dev->of_node, "hba-cap", &hpriv->saved_cap))
@@ -428,14 +427,12 @@ static int ahci_platform_get_firmware(struct ahci_host_priv *hpriv,
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
@@ -483,7 +480,6 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 	int child_nodes, rc = -ENOMEM, enabled_ports = 0;
 	struct device *dev = &pdev->dev;
 	struct ahci_host_priv *hpriv;
-	struct device_node *child;
 	u32 mask_port_map = 0;
 	u32 max_port;
 
@@ -605,7 +601,7 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 	}
 
 	if (child_nodes) {
-		for_each_child_of_node(dev->of_node, child) {
+		for_each_child_of_node_scoped(dev->of_node, child) {
 			u32 port;
 			struct platform_device *port_dev __maybe_unused;
 
@@ -614,7 +610,6 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
 
 			if (of_property_read_u32(child, "reg", &port)) {
 				rc = -EINVAL;
-				of_node_put(child);
 				goto err_out;
 			}
 
@@ -632,18 +627,14 @@ struct ahci_host_priv *ahci_platform_get_resources(struct platform_device *pdev,
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



