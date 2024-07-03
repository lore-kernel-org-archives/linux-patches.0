Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A4513776F;
	Wed,  3 Jul 2024 11:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005424; cv=none; b=BSJRtxHhgitk84xmlzqzU7P3zu9duqqYDCxKAEnOO+L1WOE9vaWE/fM+8JQJsXGedLZGAnj1ITVmxth36OvFMYR/VpFZVnHiCNyuQ+xEWeRojwLgzhuXX6ifwrvFwlk0IMlA9mgG86G7I6CskBhnpy+ocndu3UBm8CWfmh4kons=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005424; c=relaxed/simple;
	bh=6o9Hx8ckKOcm1bUTyrs9nWjqul13zHvykKC2T2ob9zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUI7oZAPTlvGxRnHYnxUDJ557yR6MuwbdDRs/hCQ88pVsI2Vl6XgIts45OGZEUcW+DGGB3dpMcYaK2NzpTWKHEulX6iqSfP2AcqhYzlvNcTE7zRwEeoiJ+ILCwc7TQIGMy5DzeTl5M0jtBQFDkfLdglQQWoYYwtRvvf9RuO+VL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCHlZ0rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCHlZ0rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAD9C2BD10;
	Wed,  3 Jul 2024 11:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005423;
	bh=6o9Hx8ckKOcm1bUTyrs9nWjqul13zHvykKC2T2ob9zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCHlZ0rmfqLnlvpJGE8QgVwoKqM9bj/ZCERXJrxZbUMu080ZUXOxCjQP1cTYlU3X8
	 2FgVJvOE07o7H04WmqwAxTrNJXzgUZcp6C28QmXEFMzS5qzsWYAAMO9bQ+GyY/1QKX
	 Qn4sFJ1JmWW/Is/JN8OhQ1mrocctP+fSvmng1Wns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Carabas <mihai.carabas@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/356] pvpanic: Indentation fixes here and there
Date: Wed,  3 Jul 2024 12:36:21 +0200
Message-ID: <20240703102914.801398464@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 84b0f12a953c4feff9994b1c4583ed18b441f482 ]

1) replace double spaces with single;
2) relax line width limitation a bit.

Reviewed-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210829124354.81653-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: ee59be35d7a8 ("misc/pvpanic-pci: register attributes via pci_driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pvpanic/pvpanic-mmio.c |  7 +++----
 drivers/misc/pvpanic/pvpanic-pci.c  | 12 +++++-------
 drivers/misc/pvpanic/pvpanic.c      | 11 ++++-------
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/misc/pvpanic/pvpanic-mmio.c b/drivers/misc/pvpanic/pvpanic-mmio.c
index 61dbff5f0065c..eb97167c03fb4 100644
--- a/drivers/misc/pvpanic/pvpanic-mmio.c
+++ b/drivers/misc/pvpanic/pvpanic-mmio.c
@@ -24,8 +24,7 @@ MODULE_AUTHOR("Hu Tao <hutao@cn.fujitsu.com>");
 MODULE_DESCRIPTION("pvpanic-mmio device driver");
 MODULE_LICENSE("GPL");
 
-static ssize_t capability_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static ssize_t capability_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct pvpanic_instance *pi = dev_get_drvdata(dev);
 
@@ -33,14 +32,14 @@ static ssize_t capability_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(capability);
 
-static ssize_t events_show(struct device *dev,  struct device_attribute *attr, char *buf)
+static ssize_t events_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct pvpanic_instance *pi = dev_get_drvdata(dev);
 
 	return sysfs_emit(buf, "%x\n", pi->events);
 }
 
-static ssize_t events_store(struct device *dev,  struct device_attribute *attr,
+static ssize_t events_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
 	struct pvpanic_instance *pi = dev_get_drvdata(dev);
diff --git a/drivers/misc/pvpanic/pvpanic-pci.c b/drivers/misc/pvpanic/pvpanic-pci.c
index 7d1220f4c95bc..07eddb5ea30fa 100644
--- a/drivers/misc/pvpanic/pvpanic-pci.c
+++ b/drivers/misc/pvpanic/pvpanic-pci.c
@@ -19,11 +19,10 @@
 #define PCI_DEVICE_ID_REDHAT_PVPANIC     0x0011
 
 MODULE_AUTHOR("Mihai Carabas <mihai.carabas@oracle.com>");
-MODULE_DESCRIPTION("pvpanic device driver ");
+MODULE_DESCRIPTION("pvpanic device driver");
 MODULE_LICENSE("GPL");
 
-static ssize_t capability_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static ssize_t capability_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct pvpanic_instance *pi = dev_get_drvdata(dev);
 
@@ -31,14 +30,14 @@ static ssize_t capability_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(capability);
 
-static ssize_t events_show(struct device *dev,  struct device_attribute *attr, char *buf)
+static ssize_t events_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct pvpanic_instance *pi = dev_get_drvdata(dev);
 
 	return sysfs_emit(buf, "%x\n", pi->events);
 }
 
-static ssize_t events_store(struct device *dev,  struct device_attribute *attr,
+static ssize_t events_store(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
 	struct pvpanic_instance *pi = dev_get_drvdata(dev);
@@ -65,8 +64,7 @@ static struct attribute *pvpanic_pci_dev_attrs[] = {
 };
 ATTRIBUTE_GROUPS(pvpanic_pci_dev);
 
-static int pvpanic_pci_probe(struct pci_dev *pdev,
-			     const struct pci_device_id *ent)
+static int pvpanic_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct pvpanic_instance *pi;
 	void __iomem *base;
diff --git a/drivers/misc/pvpanic/pvpanic.c b/drivers/misc/pvpanic/pvpanic.c
index 477bf9c6b6bc5..049a120063489 100644
--- a/drivers/misc/pvpanic/pvpanic.c
+++ b/drivers/misc/pvpanic/pvpanic.c
@@ -23,7 +23,7 @@
 #include "pvpanic.h"
 
 MODULE_AUTHOR("Mihai Carabas <mihai.carabas@oracle.com>");
-MODULE_DESCRIPTION("pvpanic device driver ");
+MODULE_DESCRIPTION("pvpanic device driver");
 MODULE_LICENSE("GPL");
 
 static struct list_head pvpanic_list;
@@ -45,8 +45,7 @@ pvpanic_send_event(unsigned int event)
 }
 
 static int
-pvpanic_panic_notify(struct notifier_block *nb, unsigned long code,
-		     void *unused)
+pvpanic_panic_notify(struct notifier_block *nb, unsigned long code, void *unused)
 {
 	unsigned int event = PVPANIC_PANICKED;
 
@@ -102,8 +101,7 @@ static int pvpanic_init(void)
 	INIT_LIST_HEAD(&pvpanic_list);
 	spin_lock_init(&pvpanic_lock);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &pvpanic_panic_nb);
+	atomic_notifier_chain_register(&panic_notifier_list, &pvpanic_panic_nb);
 
 	return 0;
 }
@@ -111,8 +109,7 @@ module_init(pvpanic_init);
 
 static void pvpanic_exit(void)
 {
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &pvpanic_panic_nb);
+	atomic_notifier_chain_unregister(&panic_notifier_list, &pvpanic_panic_nb);
 
 }
 module_exit(pvpanic_exit);
-- 
2.43.0



