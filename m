Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC7B1D0789;
	Wed,  2 Oct 2024 13:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876235; cv=none; b=Ey7AiXVFXRtmMLRLqijHfA+bUgSw7mh5YhhMqyLnF4MB+kvofT85AHC4EMv0UkcHfWpEqFeYzbI8ADBb20/hU8kKWcXCF8Rj1veQ7HgIW0iqNU+DS7wq+U9SG+lhUTTJoLwjChoI1fcBCXDrJM0YPQBz2c/mndTiXjkwGNZnsGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876235; c=relaxed/simple;
	bh=eeaGWtJHGHdTOgfG2qw2r47YjLDZI2jqk50prF9MRp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q3LQFOXGB/x4mBcJnFedlK+6pfo0lVd5ZW9k9Tw3lDqHgfCVbPHbR9+JrlfIwyvePFdQx1Ulbwp9JTg6/31ylB11f4wBi72t8D5+RqMVrWH5TJHtrC0gfxd35lX21JPBT6G60AtxNpEueZ8tj9RwKb6+bd6nUUFBB0JJzgnf6DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVLhDDds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVLhDDds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851E2C4CED2;
	Wed,  2 Oct 2024 13:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876234;
	bh=eeaGWtJHGHdTOgfG2qw2r47YjLDZI2jqk50prF9MRp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVLhDDds3SP4fdw5GZbZXqNhxLnflakq4FNBiLKlVtKctiSt+DjmgwfW4ZjjWQMGa
	 y72CHa3ne3crBGNu+VfzK2rHCszjsL4VuaNR/Hs/fl2y2+4OwZF7rM1V8ffPI4UaXC
	 sVB7XydhYEIBKAp6fvoh2pYaxeqjyAlTKxeuPAEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 374/695] leds: pca995x: Use device_for_each_child_node() to access device child nodes
Date: Wed,  2 Oct 2024 14:56:12 +0200
Message-ID: <20241002125837.389313047@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 78215dff14997..a5b32eaba7248 100644
--- a/drivers/leds/leds-pca995x.c
+++ b/drivers/leds/leds-pca995x.c
@@ -102,7 +102,7 @@ static const struct regmap_config pca995x_regmap = {
 static int pca995x_probe(struct i2c_client *client)
 {
 	struct fwnode_handle *led_fwnodes[PCA995X_MAX_OUTPUTS] = { 0 };
-	struct fwnode_handle *np, *child;
+	struct fwnode_handle *child;
 	struct device *dev = &client->dev;
 	struct pca995x_chip *chip;
 	struct pca995x_led *led;
@@ -110,8 +110,7 @@ static int pca995x_probe(struct i2c_client *client)
 
 	btype = (unsigned long)device_get_match_data(&client->dev);
 
-	np = dev_fwnode(dev);
-	if (!np)
+	if (!dev_fwnode(dev))
 		return -ENODEV;
 
 	chip = devm_kzalloc(dev, sizeof(*chip), GFP_KERNEL);
@@ -125,17 +124,13 @@ static int pca995x_probe(struct i2c_client *client)
 
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



