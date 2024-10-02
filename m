Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B491D551;
	Wed,  2 Oct 2024 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879938; cv=none; b=GySMKXO3YqKqMNS8h+JIA4A+TsuU6MD4jJsFdzJZUGHl07tDBUsm13oa1SB6amN7xUvW6DfUKrw9oqdTWezQC8nAqMRV6KSx2mH9Jrrlh8Q60BYOpkZcyww8TUpKLA1HAqkSql/+L8XyNRqqegvbBj2XfREi8dHUtobrmex6fJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879938; c=relaxed/simple;
	bh=sOKlZHknhgJC0IDmMmSmlrmwqb9/XGDX5hak9teD3FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfP3NCVOP8vyG864xhcENzJBr/28333ZiEj2XxmZqktU/x1x8ZWIrd07ZKehE9ULTk9d9NZMRgEK7OssWX10swlkDGMv9dFlU/J+ppoA2bm/SEZCECSA95bW9iv4oamwn4S5seK5GyRQNHMpUGtwIHvP1LRe32vP3jpIuCO0Sj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpdf43vQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpdf43vQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755FBC4CEC2;
	Wed,  2 Oct 2024 14:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879937;
	bh=sOKlZHknhgJC0IDmMmSmlrmwqb9/XGDX5hak9teD3FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gpdf43vQhT3Hfqb/lq3spD8Bq60N6SvRxju3MjZ4D/EdAiQrJBtjKwfDZXQoNIk6w
	 Z6gMPDXrIBngyO19/dyQdcjoPK9e01lv548jftYMAwB9uh1bI1dUEdgMsk9s5JgHkr
	 etsmMnwJq6VTzbQ6/JhFWpSzy3h4wnbvC8xdh6jA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 289/538] leds: pca995x: Use device_for_each_child_node() to access device child nodes
Date: Wed,  2 Oct 2024 14:58:48 +0200
Message-ID: <20241002125803.663527959@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 6eefd65ba6ae29ab801f6461e59c10f93dd496f8 ]

The iterated nodes are direct children of the device node, and the
`device_for_each_child_node()` macro accounts for child node
availability.

`fwnode_for_each_available_child_node()` is meant to access the child
nodes of an fwnode, and therefore not direct child nodes of the device
node.

Use `device_for_each_child_node()` to indicate device's direct child
nodes.

Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240805-device_for_each_child_node-available-v3-2-48243a4aa5c0@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 82c5ada1f9d0 ("leds: pca995x: Fix device child node usage in pca995x_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-pca995x.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-pca995x.c b/drivers/leds/leds-pca995x.c
index 686b77772ccec..83bc9669544c3 100644
--- a/drivers/leds/leds-pca995x.c
+++ b/drivers/leds/leds-pca995x.c
@@ -120,7 +120,7 @@ static const struct regmap_config pca995x_regmap = {
 static int pca995x_probe(struct i2c_client *client)
 {
 	struct fwnode_handle *led_fwnodes[PCA995X_MAX_OUTPUTS] = { 0 };
-	struct fwnode_handle *np, *child;
+	struct fwnode_handle *child;
 	struct device *dev = &client->dev;
 	const struct pca995x_chipdef *chipdef;
 	struct pca995x_chip *chip;
@@ -129,8 +129,7 @@ static int pca995x_probe(struct i2c_client *client)
 
 	chipdef = device_get_match_data(&client->dev);
 
-	np = dev_fwnode(dev);
-	if (!np)
+	if (!dev_fwnode(dev))
 		return -ENODEV;
 
 	chip = devm_kzalloc(dev, sizeof(*chip), GFP_KERNEL);
@@ -144,17 +143,13 @@ static int pca995x_probe(struct i2c_client *client)
 
 	i2c_set_clientdata(client, chip);
 
-	fwnode_for_each_available_child_node(np, child) {
+	device_for_each_child_node(dev, child) {
 		ret = fwnode_property_read_u32(child, "reg", &reg);
-		if (ret) {
-			fwnode_handle_put(child);
+		if (ret)
 			return ret;
-		}
 
-		if (reg < 0 || reg >= PCA995X_MAX_OUTPUTS || led_fwnodes[reg]) {
-			fwnode_handle_put(child);
+		if (reg < 0 || reg >= PCA995X_MAX_OUTPUTS || led_fwnodes[reg])
 			return -EINVAL;
-		}
 
 		led = &chip->leds[reg];
 		led_fwnodes[reg] = child;
-- 
2.43.0



