Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1AA1D0E3D;
	Wed,  2 Oct 2024 14:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878314; cv=none; b=WxM8v9UHTLfoqoVpeRFelF4RaqiI5IINW7Q0HLL6Ziiy2Z2unE5/p+QfU7x51qxwicJrQ+hma5IVXbJllwZ2W0oJjG0FDvk+JQbq8Px2UrSVfW/KikFkvkPwFuVjqbEDaSgjLl7aROJwaBtitRA0e4CyrH0DvgVbqzO03GiJilo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878314; c=relaxed/simple;
	bh=oEaeWxlDZ07sES7lIeSBn/4K8sFq4M2UXe61wSo9hKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKMOhHnPPf6TCBLSLUXt0QYQllMVkdiq4DXOUf+5uHUaf3OpjHQJBJRsn+ZSFgbk8izGw9AeHzDaxSDldMudfj/nT1kXOEaN4vpVAWlVj4QdqCuUvDf6eZFQAqMrESYneS7AbD9acKu28AkzwLNY4hgMpKuu6OwMoTz1r/LU7YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exW+wV9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exW+wV9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B67C4CEC2;
	Wed,  2 Oct 2024 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878314;
	bh=oEaeWxlDZ07sES7lIeSBn/4K8sFq4M2UXe61wSo9hKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exW+wV9/ZYheq3Wqaw+pZGo+OnJuM5ZvIMcbSqeMVxiMWxgIBymuTYWOlBAICr+NE
	 GG/jTd0upagebtooYr+ZQ8DCrI3e8eALfkY12Xk6u/yuYJvAEQbcauNhkYC+ljCNYw
	 p5z2EjmAPrOy6VQASPgLIoNAWzxBkJKKwZ6Oz2FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 340/634] leds: pca995x: Use device_for_each_child_node() to access device child nodes
Date: Wed,  2 Oct 2024 14:57:20 +0200
Message-ID: <20241002125824.523431246@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



