Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062255;
	b=W64vITUKvaPGrzqFZ1AoeaYGUjcbo6DAE9IejARUy8PnocV/vY2fd46tcoHwIVW/sHzX
	 fh88PjjoshGt15r/hU5sCSc11MnizAlb+pCdYgS9LGR3F9fJeUB2I4tKiXiw4rkynuctd
	 s+JkMv+ZDuPTCL0JuxJ92hWN9jPzTj16xB/uTn41JhpFTWy4QKeV+QIvgty8wjj5RGFcs
	 mIM2Ty4OsM5b60GGQDn29ZiEf5Cdda8rGYsmms0d7pLQTF6BDeBj4X2Gy+rJLPZW4amow
	 cRu3mnzLzIHJcUEjLcOta36rQdYP+YiKHix8qyPCqgy6DgSmebAS65Czh4wfjh9aRbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A16wmHZyguzeJV/5bphAuEucK1UU+UMDSQLzqiHVzNs=;
	b=CIC8McGT0RKm+6GnaCTf+eQcCfPSl8Ez1IIthpmwGUIJ7yLw1tZ6U75BNrHaUKbfwVQF
	 j6tw5MI0JlhiVkG71k0pkBxeX69WJGRjTe1hPqdtiaNb8zDtoXp14iosCVk7LdQaivFj5
	 0/8ADKhPeR0Pm2G7tdsO6YU+PmUwR+PWBlnDac10eCSPKtYiGFpL8lMe711lUHvMqP509
	 W9+1beUrb2yZ77DFcX8QKRLSt9PnNBs1Un4NNIPmwFwsq93EjlLNzUCSNA6lAjRQ54Osg
	 kbhs9TrqTzX/pieIfE9Sj87llDdW0Xo2VnpejST6rWkW8s4HQO7E5UhtPxiTX3DS1+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZOXukKF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717EA606A326;
	Thu, 19 Nov 2026 04:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PZOXukKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80741F000C4;
	Thu, 19 Nov 2026 04:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062255;
	bh=A16wmHZyguzeJV/5bphAuEucK1UU+UMDSQLzqiHVzNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZOXukKFIBS0vlxJ2JsrOSQPLb0Q565eAeiDJGeajnVsNmrCkiWtzyMCqnOINOgLO
	 eHHOe0Yg3hGdDwItDwZ9TRLz75cr4Ra/nUHUfmvPtkMIardBGnwZMCY4gl3IS3Civz
	 Cr4EDBKqlliqqVfDDRc9QNFTzX6gxay1vuVKvPLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 5.10 1845/1848] software node: Handle software node injection to an existing device properly
Date: Wed, 18 Nov 2026 16:04:43 +0100
Message-ID: <20261118150036.788756150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 5dca69e26fe97f17d4a6cbd6872103c868577b14 upstream.

The function software_node_notify() - the function that creates
and removes the symlinks between the node and the device - was
called unconditionally in device_add_software_node() and
device_remove_software_node(), but it needs to be called in
those functions only in the special case where the node is
added to a device that has already been registered.

This fixes NULL pointer dereference that happens if
device_remove_software_node() is used with device that was
never registered.

Fixes: b622b24519f5 ("software node: Allow node addition to already existing device")
Reported-and-tested-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/swnode.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/base/swnode.c
+++ b/drivers/base/swnode.c
@@ -896,7 +896,15 @@ int device_add_software_node(struct devi
 	}
 
 	set_secondary_fwnode(dev, &swnode->fwnode);
-	software_node_notify(dev, KOBJ_ADD);
+
+	/*
+	 * If the device has been fully registered by the time this function is
+	 * called, software_node_notify() must be called separately so that the
+	 * symlinks get created and the reference count of the node is kept in
+	 * balance.
+	 */
+	if (device_is_registered(dev))
+		software_node_notify(dev, KOBJ_ADD);
 
 	return 0;
 }
@@ -916,7 +924,8 @@ void device_remove_software_node(struct
 	if (!swnode)
 		return;
 
-	software_node_notify(dev, KOBJ_REMOVE);
+	if (device_is_registered(dev))
+		software_node_notify(dev, KOBJ_REMOVE);
 	set_secondary_fwnode(dev, NULL);
 	kobject_put(&swnode->kobj);
 }
@@ -933,8 +942,7 @@ int software_node_notify(struct device *
 
 	switch (action) {
 	case KOBJ_ADD:
-		ret = sysfs_create_link_nowarn(&dev->kobj, &swnode->kobj,
-					       "software_node");
+		ret = sysfs_create_link(&dev->kobj, &swnode->kobj, "software_node");
 		if (ret)
 			break;
 


