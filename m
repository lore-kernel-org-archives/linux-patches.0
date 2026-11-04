Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831348;
	b=YhVZ1Hv362gt3ZTa+LFq4iSpivGTXYFA6NOVUSNtrbzpArPrNGbejZAkYw6Aq7QzUNsO
	 kmfcEP5Ygyqfixw8BCCIpTz/WoTS0Uf8DNYo9UmFa4QIOTAOCVHGirgb2pMuGGBns9JdL
	 qGWItKFIfLzfqcW01fZxsI6jZa85eobsnpvk/dcs2nAF7Jtusl015qDZwGVWt+TdWhXGQ
	 u+zf3hVtkWrAb5dI2uUbSi/OZXOlWvU9nTrWOJjpD7HbrAIKrTOfcpPGMaIM+Ti52OYpe
	 ADbWATzSY4F93OVBgRVqWGJCpgM/iOUfp9/AuvbjuXq5dMk1D+sG+BqzjnJK+U0L3Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g1IL5uEa2044dNE8seJWbbn7avPVBVCtR2nf1/DlCb8=;
	b=wRfjRAbtnH0COLg+5YOOp+x3DVQASROokcOcjw9Tz7rkjO16bfvp0pmfhLwX7rRa2rJI
	 5hWziXZz2SvWzQWzv23N7LLetnZwHnKaa9HszqaZxMkO/gQ+oPFn8ISvoJlZ00Q+6QIxJ
	 oOYhwCzdH9DTbjmCgcberTjsMzwnMEDehBqOyPn48zJhGzyBLk0jvoEjHpr8c1p+HTwHZ
	 tJYWfsKifFrCTvCzVzoeaRbCFuwzWdSVNMHni4lU3Z6IYgR4JcHoeGJ2yUbefUj9dAGcq
	 6EO8W+sgqFfBHg/R6KxdQL0/uUjOf4Qp/t79hCz1kfQSyIqEE/zI6zvYJQUSXOVRjTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MezXla7X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3889606D80D;
	Wed,  4 Nov 2026 22:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MezXla7X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F46B1F0093A;
	Wed,  4 Nov 2026 22:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831347;
	bh=g1IL5uEa2044dNE8seJWbbn7avPVBVCtR2nf1/DlCb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MezXla7Xtl87YnAKINXpV+KFPpwvM6LQx1UQPfokGhYBBifa3vNBU1Q26nl+EFSII
	 NLsiQpGY3It0OYe5SjKQj432Dkh1ggfVqvvfimyYet6IuvvHkKFzGmP+XE/u3oHbhx
	 cK6lIDVk2gyKa0S7XI8qswvgJpBHS4pbBAw40xT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Peter <mario.peter@leica-geosystems.com>,
	Johan Hovold <johan@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 0632/1005] driver core: take parent lock on deferred probe
Date: Wed,  4 Nov 2026 16:06:05 -0500
Message-ID: <20261104211101.486918770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -151,6 +151,7 @@ struct kobject *virtual_device_parent(vo
 
 int bus_add_device(struct device *dev);
 void bus_probe_device(struct device *dev);
+void bus_probe_device_deferred(struct device *dev);
 void bus_remove_device(struct device *dev);
 void bus_notify(struct device *dev, enum bus_notifier_event value);
 bool bus_is_registered(const struct bus_type *bus);
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -565,13 +565,7 @@ out_put:
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
@@ -591,6 +585,26 @@ void bus_probe_device(struct device *dev
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
@@ -86,8 +86,9 @@ static void deferred_probe_work_func(str
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
@@ -121,7 +122,7 @@ static void deferred_probe_work_func(str
 		device_pm_move_to_tail(dev);
 
 		dev_dbg(dev, "Retrying from deferred list\n");
-		bus_probe_device(dev);
+		bus_probe_device_deferred(dev);
 		mutex_lock(&deferred_probe_mutex);
 
 		put_device(dev);


