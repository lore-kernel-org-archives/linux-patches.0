Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035614;
	b=NJXFtC8zY121q78gKrdYjZAbKJ2cW5tinFCloxE24ww8xhXr+0px5tjDHqPY80MIRVnR
	 ef9tBL/PJQIYaJU9wW+2zy5Myy/uCqJZqkdgween+GO4syyls8LkJ0pflH6G2yiTLtpjI
	 nioOBZnjt5d/DP8TCAl70YdIzgK37bqL6/RW23k7BjEXerwF5vudgWmq7dgkN0fucUGjk
	 oD040maQ3wrzwDqsjO5S1CmYzl5A4hzEANqPudKk8QEPTcvzxXXbypFqvS5Pq74Dfy2v8
	 Djn/nhvDrcZU05z8Ttn/A56JOiyBmGWPU46rFNvmvoOImyZzmJOma9FJxCBOiM/TQug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v9EYp8tpXAS98Al+vnvQBjC0aC0eDcg/3Zz8QvOXTnk=;
	b=o1PzPomtgJLsrMQEb48bSLzXtJ8nGd+IBVoE95z5v0ZV4GDPhU40FBp0RtrlYKvnqUl7
	 AfS0o4H0uoyuQqCbuZEQTjP39TEfiWXH1+Fz4VImcWUWJ3TmpT8Sl+USWYLGXU/edDS4A
	 XZ0ORueudf4LzgkAc5YifKUc8tYnkXtOZExZmr+QdxP0jOP0F86cz2sirWHKEIHdnxm1Y
	 TFnrtzOAYPhDmL9dEuWZ84PCdANuGZGezN7ftMHqOiv6mmKCDGfZpJQhiejJfUJPyebEy
	 e6HydLjYnk7zoitYc0kH52IEcEJR0ZpqviMsrN01bwWfkMotLf85wWouVpE1gn/Fbuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2J9CkqD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36398606A32F;
	Wed, 18 Nov 2026 21:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O2J9CkqD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D18E1F000C6;
	Wed, 18 Nov 2026 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035614;
	bh=v9EYp8tpXAS98Al+vnvQBjC0aC0eDcg/3Zz8QvOXTnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O2J9CkqDw9h73mkPI1JqLhotMDbq/5XNSqZTKtsy4o9ZLsVrUZ5AvQ8FfQlKcpjzb
	 zU/AFOMTS0xRgkjQgLAHDSMIORXvlC7klkDr0pK/+9udUcOrMX8mJBmogIdDHgmbKQ
	 0ibBwmLXVaTQXLmXkAkgsiSr+DQW5MIzxdlKhs0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Liu <vincent.liu@nutanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0766/3318] driver core: Check drivers_autoprobe for all added devices
Date: Wed, 18 Nov 2026 15:23:08 +0100
Message-ID: <20261118150341.715554970@linuxfoundation.org>
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

From: Vincent Liu <vincent.liu@nutanix.com>

[ Upstream commit ea34511aaf755349999a1067b2984a541bee1492 ]

When a device is hot-plugged, the drivers_autoprobe sysfs attribute is
not checked (at least for PCI devices). This means that
drivers_autoprobe is not working as intended, e.g. hot-plugged PCI
devices will still be autoprobed and bound to drivers even with
drivers_autoprobe disabled.

The problem likely started when device_add() was removed from
pci_bus_add_device() in commit 4f535093cf8f ("PCI: Put pci_dev in device
tree as early as possible") which means that the check for
drivers_autoprobe which used to happen in bus_probe_device() is no
longer present (previously bus_add_device() calls bus_probe_device()).
Conveniently, in commit 91703041697c ("PCI: Allow built-in drivers to
use async initial probing") device_attach() was replaced with
device_initial_probe() which faciliates this change to push the check
for drivers_autoprobe into device_initial_probe().

Make sure all devices check drivers_autoprobe by pushing the
drivers_autoprobe check into device_initial_probe(). This will only
affect devices on the PCI bus for now as device_initial_probe() is only
called by pci_bus_add_device() and bus_probe_device(), but
bus_probe_device() already checks for autoprobe, so callers of
bus_probe_device() should not observe changes on autoprobing.
Note also that pushing this check into device_initial_probe() rather
than device_attach() makes it only affect automatic probing of
drivers (e.g. when a device is hot-plugged), userspace can still choose
to manually bind a driver by writing to drivers_probe sysfs attribute,
even with autoprobe disabled.

Any future callers of device_initial_probe() will respect the
drivers_autoprobe sysfs attribute, which is the intended purpose of
drivers_autoprobe.

Signed-off-by: Vincent Liu <vincent.liu@nutanix.com>
Link: https://patch.msgid.link/20251022120740.2476482-1-vincent.liu@nutanix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Apply the bus-side change to the existing shared probe helper, preserving
the deferred-probe parent locking. PCI still calls device_attach(), so
its probe behaviour is unchanged. Retain this change to prepare
device_initial_probe() for the async-attach retry handling.

Stable-dep-of: 187a62f99da2 ("driver core: take parent lock in async device attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/bus.c |  3 +--
 drivers/base/dd.c  | 10 +++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 65c138dc9b3fb..dccfbc5f389bb 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -570,8 +570,7 @@ static void __bus_probe_device(struct device *dev)
 	if (!sp)
 		return;
 
-	if (sp->drivers_autoprobe)
-		device_initial_probe(dev);
+	device_initial_probe(dev);
 
 	mutex_lock(&sp->mutex);
 	list_for_each_entry(sif, &sp->interfaces, node)
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index c6ba7402bd514..4accc885a9d44 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1156,7 +1156,15 @@ EXPORT_SYMBOL_GPL(device_attach);
 
 void device_initial_probe(struct device *dev)
 {
-	__device_attach(dev, true);
+	struct subsys_private *sp = bus_to_subsys(dev->bus);
+
+	if (!sp)
+		return;
+
+	if (sp->drivers_autoprobe)
+		__device_attach(dev, true);
+
+	subsys_put(sp);
 }
 
 /*
-- 
2.53.0



