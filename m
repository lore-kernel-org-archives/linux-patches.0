Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213203A2AE5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302661; cv=none; b=iEzvU8VxqDT+CqigaScpamxwK5rNkYD91JnQ3Q0fXK5+h3xmfZLC1mldOxuxkXE0vJk2vtNVIfSHeJyHqzrdlPk4k2bEoCVrCPg7oQqnuhS7KUV9+30a8NeuCN/v2OLu32vlCNuJgUfgUW4mvF/ZCSJZUIw8CJGpWPl3bv22fV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302661; c=relaxed/simple;
	bh=UDEyFlivhUecmQe0RayNBPT3GrAuP9N8B9dDpL3O5jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZG5Wlfja/u4iR2VS5Z1NPoAITRRebaCZ/ffeZrCVQUr0qpc+imVThscQaGMVvapqrUeVVE/TDtMvL693s3QBqwCiVxXxeQevJh7YySofqpN20UuuGKI2n3y7SRFbmx7krMX09fqXfDZHEgaaqbj1In8VlN/+VmH17PG27/3SR6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QG5nO1ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QG5nO1ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F80C19423;
	Sat, 28 Feb 2026 18:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302661;
	bh=UDEyFlivhUecmQe0RayNBPT3GrAuP9N8B9dDpL3O5jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QG5nO1tyjWA5mOdF4Rd9c5L44fTlcUT1Y/8RIKGr+BGOanjoWF/qwC5Xg9jVjR886
	 nxtx6Q+a7CZfWbK40rqw1Nn/r4cwJ7oQoVJNxmRqMgaJgqLGR2cBQsjk03gsut/Fog
	 IsaAnUCHW6diTMVNTKj1qrszEf1tv18DcRgkaqHktgazNtZyIbijoKghkN/KV5s1fA
	 HTXO49it+pWEHBzZ0z9hacoWOyTyI21Yi9pZnr7Q0LVH6A3zDOxflU91M67z3TFkbK
	 IUFNsYY15PifSvB+2QZLWdQTUd5dGcDCGMtDjGVVq4vK0weACKUw0NBTvF0ZteVJh2
	 s1htJknwrLshQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jamie Iles <quic_jiles@quicinc.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/147] i3c: remove i2c board info from i2c_dev_desc
Date: Sat, 28 Feb 2026 13:15:13 -0500
Message-ID: <20260228181736.1605592-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jamie Iles <quic_jiles@quicinc.com>

[ Upstream commit 31b9887c7258ca47d9c665a80f19f006c86756b1 ]

I2C board info is only required during adapter setup so there is no
requirement to keeping a pointer to it once running.  To support dynamic
device addition we can't rely on board info - user-space creation
through sysfs won't have a boardinfo.

Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220117174816.1963463-2-quic_jiles@quicinc.com
Stable-dep-of: 3502cea99c7c ("i3c: Move device name assignment after i3c_bus_init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c       | 18 ++++++++++--------
 include/linux/i3c/master.h |  1 -
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index aff869854ef06..1f4a7902ec4ea 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -656,7 +656,7 @@ static void i3c_master_free_i2c_dev(struct i2c_dev_desc *dev)
 
 static struct i2c_dev_desc *
 i3c_master_alloc_i2c_dev(struct i3c_master_controller *master,
-			 const struct i2c_dev_boardinfo *boardinfo)
+			 u16 addr, u8 lvr)
 {
 	struct i2c_dev_desc *dev;
 
@@ -665,9 +665,8 @@ i3c_master_alloc_i2c_dev(struct i3c_master_controller *master,
 		return ERR_PTR(-ENOMEM);
 
 	dev->common.master = master;
-	dev->boardinfo = boardinfo;
-	dev->addr = boardinfo->base.addr;
-	dev->lvr = boardinfo->lvr;
+	dev->addr = addr;
+	dev->lvr = lvr;
 
 	return dev;
 }
@@ -741,7 +740,7 @@ i3c_master_find_i2c_dev_by_addr(const struct i3c_master_controller *master,
 	struct i2c_dev_desc *dev;
 
 	i3c_bus_for_each_i2cdev(&master->bus, dev) {
-		if (dev->boardinfo->base.addr == addr)
+		if (dev->addr == addr)
 			return dev;
 	}
 
@@ -1731,7 +1730,9 @@ static int i3c_master_bus_init(struct i3c_master_controller *master)
 					     i2cboardinfo->base.addr,
 					     I3C_ADDR_SLOT_I2C_DEV);
 
-		i2cdev = i3c_master_alloc_i2c_dev(master, i2cboardinfo);
+		i2cdev = i3c_master_alloc_i2c_dev(master,
+						  i2cboardinfo->base.addr,
+						  i2cboardinfo->lvr);
 		if (IS_ERR(i2cdev)) {
 			ret = PTR_ERR(i2cdev);
 			goto err_detach_devs;
@@ -2220,6 +2221,7 @@ static int i3c_master_i2c_adapter_init(struct i3c_master_controller *master)
 {
 	struct i2c_adapter *adap = i3c_master_to_i2c_adapter(master);
 	struct i2c_dev_desc *i2cdev;
+	struct i2c_dev_boardinfo *i2cboardinfo;
 	int ret;
 
 	adap->dev.parent = master->dev.parent;
@@ -2239,8 +2241,8 @@ static int i3c_master_i2c_adapter_init(struct i3c_master_controller *master)
 	 * We silently ignore failures here. The bus should keep working
 	 * correctly even if one or more i2c devices are not registered.
 	 */
-	i3c_bus_for_each_i2cdev(&master->bus, i2cdev)
-		i2cdev->dev = i2c_new_client_device(adap, &i2cdev->boardinfo->base);
+	list_for_each_entry(i2cboardinfo, &master->boardinfo.i2c, node)
+		i2cdev->dev = i2c_new_client_device(adap, &i2cboardinfo->base);
 
 	return 0;
 }
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index ea3781d730064..b31170e37655f 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -85,7 +85,6 @@ struct i2c_dev_boardinfo {
  */
 struct i2c_dev_desc {
 	struct i3c_i2c_dev_desc common;
-	const struct i2c_dev_boardinfo *boardinfo;
 	struct i2c_client *dev;
 	u16 addr;
 	u8 lvr;
-- 
2.51.0

