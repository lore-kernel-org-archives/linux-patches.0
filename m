Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061830;
	b=bR+odAAPj9aO638I6hr6f5Id5Lm5Bxrn9RZLmCFFw3fqtYPJ1YhYpGbskR7ZOK6wfVTj
	 plbXTjOMIeBfx4X/sMxJ9aCKqf2S2wNm1AsSlJnDrnF0wTFmJngCa3cZAyFcN+1AvD0Q4
	 oA8Flz912DezM9A8dQZFrl4xmgfeUBqW+GqV8Axo8+rRT9LMv4HO2S4hlplwh0UWmE3qu
	 3TJTRZfV8nE4ybPqK7B85v8yjhtzX/tJAUStVO2haBmZ19qVSultXW8WoRxq1wVm+sijg
	 wTgszcctb13vPgBPoddoII4uxBVleBvLq8T2mrPJjunI/uIEjiTw5Ja+lY7geJ1zzqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jMa+/+lma61HXhz1lmq23iQR4XewKZ3T0K6fC3oUWBI=;
	b=ziPhEBwIzZZsUCYxyRWV4SeCeCGSTFEnren9WdMhfRg8HfERaTli29ybR7Ph3FgrymfR
	 KMQ2T5eQZhCqJOKOD2hM8wwkvcpDk9PMy9gTV3ocWPednLdZUisGWtQ4lJgtfNOty1tFH
	 AFfv/p9FGwJzfZo5ThSXkHJgeme3EtKifEy0dblsoodP/VDH85NSn0xDZrEy7Bd0Rpsz+
	 HAZzesuqlHpMUrUEUbuWgoMAZ1MuxjGZnTOfEc6LWqfUWo2m/Hq5AsrGLJAqYpLtXkCGo
	 ucxjeZOmQDFTSGYxq+rJAivWqSjeoFlEqJpQdPt6w105RU55TLxaD8YkwcbVWTU/Rmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcKQwZea;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84641606A326;
	Sat,  7 Nov 2026 14:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lcKQwZea
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335281F0089F;
	Sat,  7 Nov 2026 14:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061830;
	bh=jMa+/+lma61HXhz1lmq23iQR4XewKZ3T0K6fC3oUWBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcKQwZeaWto3q1qS48WlIlSQ78zf1lbdqkg7dk1Yxv1Z9ib7xB++oYYkJt6Vnplxy
	 1xtWfnxQQT6Q7BWSsCSbKkEZcDzRsTrDP4xT7Yh87Y2H7x6E/mCRq3jmxFRTwmKs4B
	 5mtpOkV21v4ptSZWo5Nw4PWbZJV18QVn76FLCu8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Liu <vincent.liu@nutanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0852/1536] driver core: Check drivers_autoprobe for all added devices
Date: Sat,  7 Nov 2026 08:47:48 -0500
Message-ID: <20261107135021.478546646@linuxfoundation.org>
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

Adapt the bus-side change to __bus_probe_device(), which is shared by
the normal and deferred probe entry points. Preserve the deferred probe
wrapper and its parent locking.

Retain this change to provide the device_initial_probe() layout needed
by the asynchronous attach parent-lock fix. PCI still calls
device_attach() directly, so this change does not alter PCI probing.

Stable-dep-of: 187a62f99da2 ("driver core: take parent lock in async device attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/bus.c |  3 +--
 drivers/base/dd.c  | 10 +++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index e0afc8e371438..36383037f2dd2 100644
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
index 9d1e231d41f53..57aa8d8b00428 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1155,7 +1155,15 @@ EXPORT_SYMBOL_GPL(device_attach);
 
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



