Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061475;
	b=LDuKJbBhRZy8ZL28+bGRBj6F4Xf+vQmhzwo3I93FjRZ4oeAvn97nO8NKZgmH+9caM/gx
	 2oBHHqOCIZbV2pKrPEQ6qt4R3nESQZYsd0c3R3sDXApS2r/yBPJyeKmU9b7U2X7NvacyU
	 rrR//rSO+GtHnLnk9QMsU0m9o0o2CixRh/HELrTDJ0T7uz0IPIBjLemSNEK9G78pD8HaN
	 LJSBZdpwCoEpOdK5WlPQ/akb3SwapCIO9RVg36QNY2/rVAb+pELcBmG59rRJQMJKBJ0Jb
	 r+KPM+9cils/OiR9qhiGQS9lhu7Ezc/yVDDwDnU28hD4C46MrK01RmkarWQaAARhY8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6tpL0kQ9obi8KivG84nQnoSug7VQ+i+JQBFYsv89RJ4=;
	b=L9wsb52M01rbPvlfZviWmyC+MBzfMdcrsooXc/4kwPBQn9n7GGS64PfMEKG+otYBFdAc
	 bRB4ae1PJ2lgYBHBp9HBw8KTmIeu9HqQ0rI3akIRYpEtQk7KZD0qe8JdRJEyUijhbcItk
	 jHHf1UxcrOFFFQgZF1Vjbi7OA6ChDuw7FqTo6wb3XACwZ6I/XKySoJjMe2nWmvZAsM1R1
	 0R71DLt4TPd3xGi5O1C1/7pd99q9t0TcvKnDtMJSfcTOIegJyV/vm5m1972dIoOC1Zfw5
	 chKTBOREhmhFK5F44g0JPlaZJiDvH1Q4BksaJMIX832pI+e1/aU/OscCa16OQUk01zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QUU7pXh1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11331606A326;
	Sat,  7 Nov 2026 14:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QUU7pXh1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCF61F0089F;
	Sat,  7 Nov 2026 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061474;
	bh=6tpL0kQ9obi8KivG84nQnoSug7VQ+i+JQBFYsv89RJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUU7pXh14WS2Jn53JG7M8T/NougVLQ1gYzVScbaW85mbYlivMnvmaRzbGLCZOSx2k
	 iLiWiNfnuv7uYqfkC/6EeDjnKba77srcoqOO46+hajUBcAx0nPkenaNhx0xPwyfnUP
	 Rgvv32hGp5y/tksX7LqRrQrfBoJ7y2daKz0q0lZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Peter <mario.peter@leica-geosystems.com>,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 0574/1536] driver core: take parent lock on deferred probe
Date: Sat,  7 Nov 2026 08:43:10 -0500
Message-ID: <20261107135013.686496461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,6 +150,7 @@ struct kobject *virtual_device_parent(vo
 
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


