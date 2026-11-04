Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831949;
	b=Tpc4+ftp9/scBlmYyhl2gWuaWraSm5aCZtHSeuUMAcTheLF7dj1Kj6dwF6K4131OMSU4
	 IctUiGRhp+SyI1+7VtyMwVDtXTll3OwLmVFBDCRyHjgIGo//q1jSiAz+SlTZOAzdQ1qwk
	 QS4po0mnwHz9vvcspAZrjc0mfCk5ma57+0nujR9dP3dnMHZmIwL7oXx2F2otnlo/vuyl9
	 R4H0kUGG49pYkYvOKIArj5RorbIy+iGK1Xd/Bs50Erz0ElCIv72X8Enfa9aBGFXrGoz6K
	 4n2ChrCih6gPXMY2MTEL9sjq3GIyYXIQiVDtcKt5f/Ow/A1ALGpFuX9rSONx6OkvGEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MPRqr61wwNGLDRLfaxYp54Mhy+7GYD99ygKmoP5PFY4=;
	b=3ttkCrX0buyVGDhlwaAugSaO7di/jQXdalUi1VzqpNIfQo2HULSQVxLSDmgiIcaDde8K
	 EvLdMvcRGgWO/anrfP5/98zrTJoBJG6SDJ3yOf17na/NpGB6U38u+PeH6+/W6Sax9xdzo
	 c+H6MNX9l67CmbrBrhOMNw5DoYsMIE90NUOLMH2m5VyJsBDiM3fQzFCzeheipgxOcXytS
	 BwfukajQZWwMgxVRm2vmqAM7zD75YbW8VZTt7JZmE5j4Dkb6xaZRhj00KlNd/xxvK1jvv
	 BxcfgeolnnECYnPBt2iBNKHb8HrWr+HohcBjtOjiSIBNSI9MPvldSPjBKTTTrOrpzAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k81aUZ2p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A536D606A870;
	Wed,  4 Nov 2026 22:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k81aUZ2p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA021F00A18;
	Wed,  4 Nov 2026 22:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831948;
	bh=MPRqr61wwNGLDRLfaxYp54Mhy+7GYD99ygKmoP5PFY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k81aUZ2peJr9c/0g+E3LfvbOxYM/LDST8liNxIXPe3IFJ3crkG7A+mTuGn0fuWJPy
	 DFQst5PoWab3Ex2HRvME7XhC4nxXCD7ZFMtZAIsiJindDQPL5LmKBDejQXUyACBRlf
	 uW0neNkjwcBVIMbgSVENcP2SS0xhLNk21Qxs8894=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Liu <vincent.liu@nutanix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0984/1005] driver core: Check drivers_autoprobe for all added devices
Date: Wed,  4 Nov 2026 16:11:57 -0500
Message-ID: <20261104211110.606382408@linuxfoundation.org>
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
Stable-dep-of: 187a62f99da2 ("driver core: take parent lock in async device attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/bus.c |    3 +--
 drivers/base/dd.c  |   10 +++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -573,8 +573,7 @@ static void __bus_probe_device(struct de
 	if (!sp)
 		return;
 
-	if (sp->drivers_autoprobe)
-		device_initial_probe(dev);
+	device_initial_probe(dev);
 
 	mutex_lock(&sp->mutex);
 	list_for_each_entry(sif, &sp->interfaces, node)
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1157,7 +1157,15 @@ EXPORT_SYMBOL_GPL(device_attach);
 
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


