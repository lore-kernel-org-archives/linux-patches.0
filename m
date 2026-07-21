Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244A6471272;
	Tue, 21 Jul 2026 18:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657414; cv=none; b=ZjohN4CLlK9OUHW9cUEAxnl0gjjRbkWjR4Jjq7EkNRFPWLQ0NQMVZa9Df2sdNfd4bUrisu8W30vTQg/DpBVfTegyEb9MmsTvJ0VbVgWwpzXdJg/xqrpdWE4CNEU+xKRMxdaMy6/D0YlnjDrOC70kG73sZN6F0x13E8+RcmlU+8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657414; c=relaxed/simple;
	bh=u4+UW/ekpqzGuS7LXg+3QYZ9G8JV0hfluZ3b7ctNTf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2bOe6B1KIaQMJGGNbFZG3zDKZB7B797giaVFU8Jjyj8ASSaM6WPObkKwGbZtRPsDR5LYEbFFXI2EL5XXfeVjS3i3XYRtsbVfinvuGneCuNWWVA6iiQFVi4f91tVcyqfRcRnZpjp3ysYCfnOIQHsrC5wECneoAzSEov+bC3eik4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAFAhWAf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAFAhWAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CD31F000E9;
	Tue, 21 Jul 2026 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657412;
	bh=6RYL0G/q4/gOts1/6Xt5khhXI0B6h5bOgDF7btIpiRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KAFAhWAfd75hhSESm2nioIeMDJd0S6+H+FtOw8+skVNY0oWV7cJdrVNW+xqnewlUN
	 Y5c6hgSBKkK52F8Mt9uempoHcXJHLY4FsAqvnQivk8xpKgdVocWOz9idRhiinpB9r6
	 Y9koJJIZa0vWna8y9JBDPsU+3tO0tLqjUavaJ/Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0756/1611] i3c: add sysfs entry and attribute for Device NACK Retry count
Date: Tue, 21 Jul 2026 17:14:32 +0200
Message-ID: <20260721152532.381713303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>

[ Upstream commit b58f47eb392680d4c6626c8b3b1fcf6412a0a02c ]

Document sysfs attribute dev_nack_retry_cnt that controls the number of
automatic retries performed by the I3C controller when a target device
returns a NACK

Add a `dev_nack_retry_count` sysfs attribute to allow reading and updating
the device NACK retry count. A new `dev_nack_retry_count` field and an
optional `set_dev_nack_retry()` callback are added to
i3c_master_controller. The attribute is created only when the callback is
implemented.

Updates are applied under the I3C bus maintenance lock to ensure safe
hardware reconfiguration.

Signed-off-by: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/3c4b5082bde64024fc383c44bebeef89ad3c7ed3.1765529948.git.adrianhoyin.ng@altera.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 3f79dac3ea1c ("i3c: master: Defer new-device registration out of DAA caller context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/ABI/testing/sysfs-bus-i3c | 11 +++++++
 drivers/i3c/master.c                    | 39 +++++++++++++++++++++++++
 include/linux/i3c/master.h              |  6 ++++
 3 files changed, 56 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-i3c b/Documentation/ABI/testing/sysfs-bus-i3c
index c812ab180ff40c..c1e048957a0103 100644
--- a/Documentation/ABI/testing/sysfs-bus-i3c
+++ b/Documentation/ABI/testing/sysfs-bus-i3c
@@ -161,3 +161,14 @@ Contact:	linux-i3c@vger.kernel.org
 Description:
 		These directories are just symbolic links to
 		/sys/bus/i3c/devices/i3c-<bus-id>/<bus-id>-<device-pid>.
+
+What:		/sys/bus/i3c/devices/i3c-<bus-id>/<bus-id>-<device-pid>/dev_nack_retry_count
+KernelVersion:  6.18
+Contact:	linux-i3c@vger.kernel.org
+Description:
+		Expose the dev_nak_retry_count which controls the number of
+		automatic retries that will be performed by the controller when
+		the target device returns a NACK response. A value of 0 disables
+		the automatic retries. Exist only when I3C constroller supports
+		this retry on nack feature.
+
diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 776b0ec3abe2c1..49b947f9512478 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -686,6 +686,39 @@ static ssize_t hotjoin_show(struct device *dev, struct device_attribute *da, cha
 
 static DEVICE_ATTR_RW(hotjoin);
 
+static ssize_t dev_nack_retry_count_show(struct device *dev,
+					 struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%u\n", dev_to_i3cmaster(dev)->dev_nack_retry_count);
+}
+
+static ssize_t dev_nack_retry_count_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct i3c_bus *i3cbus = dev_to_i3cbus(dev);
+	struct i3c_master_controller *master = dev_to_i3cmaster(dev);
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	i3c_bus_maintenance_lock(i3cbus);
+	ret = master->ops->set_dev_nack_retry(master, val);
+	i3c_bus_maintenance_unlock(i3cbus);
+
+	if (ret)
+		return ret;
+
+	master->dev_nack_retry_count = val;
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(dev_nack_retry_count);
+
 static struct attribute *i3c_masterdev_attrs[] = {
 	&dev_attr_mode.attr,
 	&dev_attr_current_master.attr,
@@ -2964,6 +2997,9 @@ int i3c_master_register(struct i3c_master_controller *master,
 	i3c_master_register_new_i3c_devs(master);
 	i3c_bus_normaluse_unlock(&master->bus);
 
+	if (master->ops->set_dev_nack_retry)
+		device_create_file(&master->dev, &dev_attr_dev_nack_retry_count);
+
 	return 0;
 
 err_del_dev:
@@ -2989,6 +3025,9 @@ void i3c_master_unregister(struct i3c_master_controller *master)
 {
 	i3c_bus_notify(&master->bus, I3C_NOTIFY_BUS_REMOVE);
 
+	if (master->ops->set_dev_nack_retry)
+		device_remove_file(&master->dev, &dev_attr_dev_nack_retry_count);
+
 	i3c_master_i2c_adapter_cleanup(master);
 	i3c_master_unregister_i3c_devs(master);
 	i3c_master_bus_cleanup(master);
diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index cfe0285a5c381d..abe0a134465e62 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -462,6 +462,8 @@ struct i3c_bus {
  * @enable_hotjoin: enable hot join event detect.
  * @disable_hotjoin: disable hot join event detect.
  * @set_speed: adjust I3C open drain mode timing.
+ * @set_dev_nack_retry: configure device NACK retry count for the master
+ *                      controller.
  */
 struct i3c_master_controller_ops {
 	int (*bus_init)(struct i3c_master_controller *master);
@@ -491,6 +493,8 @@ struct i3c_master_controller_ops {
 	int (*enable_hotjoin)(struct i3c_master_controller *master);
 	int (*disable_hotjoin)(struct i3c_master_controller *master);
 	int (*set_speed)(struct i3c_master_controller *master, enum i3c_open_drain_speed speed);
+	int (*set_dev_nack_retry)(struct i3c_master_controller *master,
+				  unsigned long dev_nack_retry_cnt);
 };
 
 /**
@@ -514,6 +518,7 @@ struct i3c_master_controller_ops {
  *	in a thread context. Typical examples are Hot Join processing which
  *	requires taking the bus lock in maintenance, which in turn, can only
  *	be done from a sleep-able context
+ * @dev_nack_retry_count: retry count when slave device nack
  *
  * A &struct i3c_master_controller has to be registered to the I3C subsystem
  * through i3c_master_register(). None of &struct i3c_master_controller fields
@@ -534,6 +539,7 @@ struct i3c_master_controller {
 	} boardinfo;
 	struct i3c_bus bus;
 	struct workqueue_struct *wq;
+	unsigned int dev_nack_retry_count;
 };
 
 /**
-- 
2.53.0



