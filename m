Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0D73B4E87;
	Thu, 17 Sep 2026 18:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668583; cv=none; b=Sv+JoJdBTU14Cg1/402JLuHi+44UnzEHHbEZ+H5SQE6rU5GQ+TMLEfONA2FXEme5mXb4u8dK441VsJD8OaOUjhLAobVQG5X0DwgFpXPn/F5s9MT5Rp99UGlM4kZ73OnsRi3cXYIZWNmLUKcV13sjJBrJI9qOa2oYoFGvNQ4ztRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668583; c=relaxed/simple;
	bh=Eg6Xa23VuqtURJtQcQCD/+ra6o7rzLvdqwwmd78iEcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMRPyTSpkJpqJa1GXeSUDTBj7AmJCmDbwpWXWHgRKsFjakjrGGiq2clz4MXRmM8aS1rk/VmsebZ5zQ27nq5W5xygLRdIzKurbxmIH6sdTnUN4bScR1409TM7hensWRo00iA4MbYYM8IjIYg1kbJGd9T+wlGhLdX4Ljc4VScIyLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RD95t9NA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RD95t9NA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE211F000FF;
	Thu, 17 Sep 2026 18:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668582;
	bh=lQGTgACYyJ3cQ9g5gWrvjCWSNrN9lZZcUofyfP/7bX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RD95t9NABCLwlRJfj4BmVwCW/lkcz/wBIdL26dlU/ZxViyBYdtt+frBnnfMqgOxMS
	 5gxlWQH05gCw9sPxIIelWvwkMz8sLn2x5nDaaqWKcfaYPNv7fgh9khvalQFsbiItu4
	 M3cP+jRmN+MfEtrYuq1exxOi7/UM572/QCVEEOek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@google.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Hiago De Franco <hiago.franco@toradex.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Subject: [PATCH 6.12 0474/1102] driver core: Export get_dev_from_fwnode()
Date: Thu, 17 Sep 2026 16:06:57 +0100
Message-ID: <20260917151551.592261226@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 9a4681a485ee1203ac968065490a8eeaa6615503 ]

It has turned out get_dev_from_fwnode() is useful at a few other places
outside of the driver core, as in gpiolib.c for example. Therefore let's
make it available as a common helper function.

Suggested-by: Saravana Kannan <saravanak@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Hiago De Franco <hiago.franco@toradex.com> # Colibri iMX8X
Tested-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com> # TI AM62A,Xilinx ZynqMP ZCU106
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20250701114733.636510-18-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c    | 8 ++++++--
 include/linux/device.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d233a245e19b4..1311a0983af34 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1881,8 +1881,6 @@ static void fw_devlink_unblock_consumers(struct device *dev)
 	device_links_write_unlock();
 }
 
-#define get_dev_from_fwnode(fwnode)	get_device((fwnode)->dev)
-
 static bool fwnode_init_without_drv(struct fwnode_handle *fwnode)
 {
 	struct device *dev;
@@ -5209,6 +5207,12 @@ void device_set_node(struct device *dev, struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(device_set_node);
 
+struct device *get_dev_from_fwnode(struct fwnode_handle *fwnode)
+{
+	return get_device((fwnode)->dev);
+}
+EXPORT_SYMBOL_GPL(get_dev_from_fwnode);
+
 int device_match_name(struct device *dev, const void *name)
 {
 	return sysfs_streq(dev_name(dev), name);
diff --git a/include/linux/device.h b/include/linux/device.h
index 3463dec1b0c31..7969d02fe628d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1138,6 +1138,7 @@ void set_primary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
 void set_secondary_fwnode(struct device *dev, struct fwnode_handle *fwnode);
 void device_set_node(struct device *dev, struct fwnode_handle *fwnode);
 void device_set_of_node_from_dev(struct device *dev, const struct device *dev2);
+struct device *get_dev_from_fwnode(struct fwnode_handle *fwnode);
 
 static inline struct device_node *dev_of_node(struct device *dev)
 {
-- 
2.53.0



