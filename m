Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034971;
	b=Nm2Yyn2gBb9Na0xgNR7YmmbTuXDTyxGKqu83/FS/zOocwrur9HrGt+WIJBbyLmCXvUde
	 gkAjAgHmOhVnCNE/mZ2d52fhb1w6+RzgqHhAm1EsDORkUom0+tXQAVTRhrarkhOHqlf+1
	 QzhZDw8H5SQOjTIOkncZLoQhyb/pHl/D3RWTlbxBi9iw/X03L3xyiDUkQ4JcwNj8soZ7M
	 ZoP/XVWVv5NfPycu/Ps3ncgqiRHyIca8zC32+56ntho3kbFbsi3VaqWAAbpKeXHTroSfO
	 NTMafAafP2chfqavKjRIRFwyXlJhXNigm+wb4GpvLJaqPlkptI4QB4S+uqgp6rLldDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IANaCivgTUSEpDkFY8KNnATUoWIqrSxHcQTNvD4lUmk=;
	b=IFgSE/WJev6FqoFAbY2uiPhmsdUhrLdzIDV+g/gOgsH9blS7p26KNy6ZSLFDsA/WzvYN
	 38FAQz0pMmGkn40GI4g353L2cEcFsHbuvCyudVuozD58rQVpASxKhP8APHgoPbsClVWba
	 iTzBfK6e6W4ghlrVac5k5IsnGQ3R4avqfmRsA/GA9g0ZMo+Il4OFtwjr6msGluWkANOaC
	 1BG1x+bdT/yqb4udPtRLKpBx8+lc+s2FSSYlccpAUleRiCQYE/K2tB7NgorRblkXLWNNp
	 3j0TLJ+/JHsohJzr32umhkHBG5cLWUxne/BX5S6qjXg3ztFVwLJtB/lCUnoKM1G4Xlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9goJ6Dm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B27F606A31C;
	Wed, 18 Nov 2026 20:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9goJ6Dm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C518D1F000C6;
	Wed, 18 Nov 2026 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034971;
	bh=IANaCivgTUSEpDkFY8KNnATUoWIqrSxHcQTNvD4lUmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9goJ6Dm57UMjkEHdRMh7ctYg5SlEaJLeWzDf0iFRrBeeYocoNBoQflkmo93rXESB
	 BR94pG9CPzTtX4VUSN9xfmXTSTXyLzeHcvSuAmHffsQtFAKdDLMQeVnIjwk+1clZ3+
	 Xbd4Bl2QheE2MJ43gLAn54SAVef8jGBjPWEVAqFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Peter <mario.peter@leica-geosystems.com>,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 0559/3318] driver core: take parent lock on deferred probe
Date: Wed, 18 Nov 2026 15:19:41 +0100
Message-ID: <20261118150334.124579981@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 4059f8986c8f50102a04335cc1da4921dfd262d8 upstream.

USB interfaces should be probed with the parent USB device lock held,
but this is not honoured when probe is deferred.

Add a new bus_probe_device_deferred() helper to handle deferred probe
where the parent device lock is not held.

Fixes: d1c3414c2a9d ("drivercore: Add driver probe deferral mechanism")
Reported-by: Mario Peter <mario.peter@leica-geosystems.com>
Link: https://lore.kernel.org/20261007131514.1260696-1-mario.peter@leica-geosystems.com
Cc: stable@vger.kernel.org	# 3.4
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20261014133109.1392265-3-johan@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/base.h |    1 +
 drivers/base/bus.c  |   28 +++++++++++++++++++++-------
 drivers/base/dd.c   |    7 ++++---
 3 files changed, 26 insertions(+), 10 deletions(-)

--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -150,6 +150,7 @@ struct kobject *virtual_device_parent(st
 
 int bus_add_device(struct device *dev);
 void bus_probe_device(struct device *dev);
+void bus_probe_device_deferred(struct device *dev);
 void bus_remove_device(struct device *dev);
 void bus_notify(struct device *dev, enum bus_notifier_event value);
 bool bus_is_registered(const struct bus_type *bus);
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -562,13 +562,7 @@ out_put:
 	return error;
 }
 
-/**
- * bus_probe_device - probe drivers for a new device
- * @dev: device to probe
- *
- * - Automatically probe for a driver if the bus allows it.
- */
-void bus_probe_device(struct device *dev)
+static void __bus_probe_device(struct device *dev)
 {
 	struct subsys_private *sp = bus_to_subsys(dev->bus);
 	struct subsys_interface *sif;
@@ -588,6 +582,26 @@ void bus_probe_device(struct device *dev
 }
 
 /**
+ * bus_probe_device - probe drivers for a new device
+ * @dev: device to probe
+ *
+ * - Automatically probe for a driver if the bus allows it.
+ */
+void bus_probe_device(struct device *dev)
+{
+	__bus_probe_device(dev);
+}
+
+void bus_probe_device_deferred(struct device *dev)
+{
+	if (dev->type && dev->type->need_parent_lock)
+		device_lock(dev->parent);
+	__bus_probe_device(dev);
+	if (dev->type && dev->type->need_parent_lock)
+		device_unlock(dev->parent);
+}
+
+/**
  * bus_remove_device - remove device from bus
  * @dev: device to be removed
  *
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -85,8 +85,9 @@ static void deferred_probe_work_func(str
 	/*
 	 * This block processes every device in the deferred 'active' list.
 	 * Each device is removed from the active list and passed to
-	 * bus_probe_device() to re-attempt the probe.  The loop continues
-	 * until every device in the active list is removed and retried.
+	 * bus_probe_device_deferred() to re-attempt the probe.  The loop
+	 * continues until every device in the active list is removed and
+	 * retried.
 	 *
 	 * Note: Once the device is removed from the list and the mutex is
 	 * released, it is possible for the device get freed by another thread
@@ -120,7 +121,7 @@ static void deferred_probe_work_func(str
 		device_pm_move_to_tail(dev);
 
 		dev_dbg(dev, "Retrying from deferred list\n");
-		bus_probe_device(dev);
+		bus_probe_device_deferred(dev);
 		mutex_lock(&deferred_probe_mutex);
 
 		put_device(dev);


