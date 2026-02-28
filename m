Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8741439B943
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302510; cv=none; b=SUOHagnLIJfRPx51E+WhhC8t6w2E7Vl1F2uPyzAciIVv3t6o6l4sYIW74k71dRXJiZNuZYf21FFhzNL8c+ydH40zaxiJ20jj2wL3IdnMRZunJ1lROyOdsA7dVVL0IDNt1pG6paz2FG95oJJ0TbT6ONYVd2OAe9ecg43jAGv68dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302510; c=relaxed/simple;
	bh=XeKr5qLiDuJIcKq/JbYsf77v/HH56eG6NOLSWrESaio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEEY/ffcZWvDuNMCBLv/X0zNEB4inEeGUey1QsA8iOi2NkgvrJjtaoVPzYoSSCwilx1ygRQf64ee771J7K0hVaBVY4lsaIl6FeLZV74tkp9KpbGVd6B8YsTSf9OH42vQviWTUW+l1kxEOmXcMuB/xtrobjoibYycxbKVehjV3jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B25ru0z6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B25ru0z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31B4C19425;
	Sat, 28 Feb 2026 18:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302510;
	bh=XeKr5qLiDuJIcKq/JbYsf77v/HH56eG6NOLSWrESaio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B25ru0z6eh6xBVO8r5b6LWqttnsBlCT1mdJEo0TW7DEZMySfAbNTgbvmkty4mYtLb
	 zIR+gdwgkyAHh781+tMf9HQ2ZQGOUvCE+FsU11gSVmPjrmfKapXRuOe4usal+MWqXr
	 IPspIl98ZK3Q5YbP7vxXAMoKK5YWyaaqF2RLJwp1D922AgWI54GRfCAr+D89tgafPl
	 fDhZZr5PdSYhTRS3GIfLqrwixMLLgd9Mqog/bsaWwC+5Ynuy+GmBJj6T4PtYjht6pp
	 dLKZpiE0bj3lSay/7Gt3ZNfff66LD+baPJqvpEd9imMnNCJ4UZzx0hh0ob3bjMwg08
	 Iz2Fw8e2dx0ow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jamie Iles <quic_jiles@quicinc.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/164] i3c: remove i2c board info from i2c_dev_desc
Date: Sat, 28 Feb 2026 13:12:24 -0500
Message-ID: <20260228181505.1600663-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index e2777db13762f..a99c727a23042 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -610,7 +610,7 @@ static void i3c_master_free_i2c_dev(struct i2c_dev_desc *dev)
 
 static struct i2c_dev_desc *
 i3c_master_alloc_i2c_dev(struct i3c_master_controller *master,
-			 const struct i2c_dev_boardinfo *boardinfo)
+			 u16 addr, u8 lvr)
 {
 	struct i2c_dev_desc *dev;
 
@@ -619,9 +619,8 @@ i3c_master_alloc_i2c_dev(struct i3c_master_controller *master,
 		return ERR_PTR(-ENOMEM);
 
 	dev->common.master = master;
-	dev->boardinfo = boardinfo;
-	dev->addr = boardinfo->base.addr;
-	dev->lvr = boardinfo->lvr;
+	dev->addr = addr;
+	dev->lvr = lvr;
 
 	return dev;
 }
@@ -695,7 +694,7 @@ i3c_master_find_i2c_dev_by_addr(const struct i3c_master_controller *master,
 	struct i2c_dev_desc *dev;
 
 	i3c_bus_for_each_i2cdev(&master->bus, dev) {
-		if (dev->boardinfo->base.addr == addr)
+		if (dev->addr == addr)
 			return dev;
 	}
 
@@ -1692,7 +1691,9 @@ static int i3c_master_bus_init(struct i3c_master_controller *master)
 					     i2cboardinfo->base.addr,
 					     I3C_ADDR_SLOT_I2C_DEV);
 
-		i2cdev = i3c_master_alloc_i2c_dev(master, i2cboardinfo);
+		i2cdev = i3c_master_alloc_i2c_dev(master,
+						  i2cboardinfo->base.addr,
+						  i2cboardinfo->lvr);
 		if (IS_ERR(i2cdev)) {
 			ret = PTR_ERR(i2cdev);
 			goto err_detach_devs;
@@ -2178,6 +2179,7 @@ static int i3c_master_i2c_adapter_init(struct i3c_master_controller *master)
 {
 	struct i2c_adapter *adap = i3c_master_to_i2c_adapter(master);
 	struct i2c_dev_desc *i2cdev;
+	struct i2c_dev_boardinfo *i2cboardinfo;
 	int ret;
 
 	adap->dev.parent = master->dev.parent;
@@ -2197,8 +2199,8 @@ static int i3c_master_i2c_adapter_init(struct i3c_master_controller *master)
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
index 9cb39d901cd5f..604a126b78c83 100644
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

