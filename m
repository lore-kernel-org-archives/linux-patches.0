Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFF8355031;
	Tue,  6 Jan 2026 17:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721722; cv=none; b=bntyaFWb0YZ00wTX/gTEQJgsToqdIlN6XOCEfSUvQ7O+0/N2wv4Fz4uNxuNmt5rkj3R30+KBv4AXEEN9SxTLkZQinHeW6qBj09eAeE2xQS6SQ85eIGYpP7UauOtMOvXAGQa87ISf8XZqwH7A+iwdpCpNIllc1459N2j963GvKco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721722; c=relaxed/simple;
	bh=ciZsVo4fL67vM4yuiR3DFLcph5s+IXz36GJDCR8BlTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wy+NzY9hUu+69GPhcOOwGEG8R+KF/cL3iVadRYCn/2VGOWA4pbxVSaAMeIszc0+3MgQV2/O6LZ795RB0oR31y7ZQQdIlqZ616oNAAyijvxaap5/Sqm4wBo/C+dx2PTTErDidd1JYzYvb3qaPiK9EbbRprIjhnseygw8b+eU/I6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYwcno3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYwcno3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCB7C16AAE;
	Tue,  6 Jan 2026 17:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721721;
	bh=ciZsVo4fL67vM4yuiR3DFLcph5s+IXz36GJDCR8BlTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYwcno3rat6bRMXpl58Sn9i4y2wxlH3q9U9dXie6VCl1lLOGDEvvARTpRO6mPd8K1
	 vy+elkrtEfnWdxJ8yqdBF/YMDsnuTCpmLFchhXTBV4aVgmtZTvf7NVmKnKIZVl+hqD
	 5FNeK5gTnAfNq1VWSf3MTQ5k+8RN4CfWtL8P5YbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 051/312] net: mdio: rtl9300: use scoped for loops
Date: Tue,  6 Jan 2026 18:02:05 +0100
Message-ID: <20260106170549.700641987@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a4f800c4487dc5d6fcc28da89c7cc3c187ccc731 ]

Currently in the return path, fwnode_handle_put calls are missing. Just use
_scoped to avoid the issue.

Fixes: 24e31e474769 ("net: mdio: Add RTL9300 MDIO driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20251217210153.14641-1-rosenp@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-realtek-rtl9300.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/mdio/mdio-realtek-rtl9300.c b/drivers/net/mdio/mdio-realtek-rtl9300.c
index 33694c3ff9a7..405a07075dd1 100644
--- a/drivers/net/mdio/mdio-realtek-rtl9300.c
+++ b/drivers/net/mdio/mdio-realtek-rtl9300.c
@@ -354,7 +354,6 @@ static int rtl9300_mdiobus_probe_one(struct device *dev, struct rtl9300_mdio_pri
 				     struct fwnode_handle *node)
 {
 	struct rtl9300_mdio_chan *chan;
-	struct fwnode_handle *child;
 	struct mii_bus *bus;
 	u32 mdio_bus;
 	int err;
@@ -371,7 +370,7 @@ static int rtl9300_mdiobus_probe_one(struct device *dev, struct rtl9300_mdio_pri
 	 * compatible = "ethernet-phy-ieee802.3-c45". This does mean we can't
 	 * support both c45 and c22 on the same MDIO bus.
 	 */
-	fwnode_for_each_child_node(node, child)
+	fwnode_for_each_child_node_scoped(node, child)
 		if (fwnode_device_is_compatible(child, "ethernet-phy-ieee802.3-c45"))
 			priv->smi_bus_is_c45[mdio_bus] = true;
 
@@ -409,7 +408,6 @@ static int rtl9300_mdiobus_map_ports(struct device *dev)
 {
 	struct rtl9300_mdio_priv *priv = dev_get_drvdata(dev);
 	struct device *parent = dev->parent;
-	struct fwnode_handle *port;
 	int err;
 
 	struct fwnode_handle *ports __free(fwnode_handle) =
@@ -418,7 +416,7 @@ static int rtl9300_mdiobus_map_ports(struct device *dev)
 		return dev_err_probe(dev, -EINVAL, "%pfwP missing ethernet-ports\n",
 				     dev_fwnode(parent));
 
-	fwnode_for_each_child_node(ports, port) {
+	fwnode_for_each_child_node_scoped(ports, port) {
 		struct device_node *mdio_dn;
 		u32 addr;
 		u32 bus;
-- 
2.51.0



