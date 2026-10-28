Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212260;
	b=tNbIMfORXvsfVTmYbrxbhUJWZ06B02KHRLwsMbcpuxSEaqzCUsCc6P/BxQgOLu7zbV8f
	 IfxNegS1t/yULuP+3AKIfqXcPXmOS7J+I7pb+bIt7cJLuDblgiUuTKYAPbLjbybt0ZLRV
	 pXq0BOKMJGlbOwkky8XOGrzeIMPisV/HzhX0MDY4f7hUm5uz0327ECgz4KSWcHzwMjGhd
	 DMZW/81eNAM36YtjPXZeloexzH4VEN6gVcMsfmEQUvNzqEG/Vg3mMr4RlAAjQ13ADiaJ9
	 KnZjtNAS0TOdqnyTaFE3dh7piw4+/uXRDeEWbdfD6LfC3mH3OzG9sI8wTf7rB6Bc/dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SCxmg0JLIEwV4z4NG+tRqcLF7Q/WdAmxKAMZHJT6LJ4=;
	b=17l5bg2+E4z2CKwD/swcLNQza+UdoYSOcbvBs8P1kclRahURpT+j12hfmTywAHGn7tXK
	 JbpaUUPX0g+Iln01FYPPKKkHrrQgX1QUARL7FzZHykTr3WZwQ4Z9wLepiVgHcdfzzTzoP
	 MFvXVs/H+ILVBw/H/5HK/9SW1ZiU4iD6NNSwijz/DGzbE2IepmknnlZEqGO9wz5MItCXv
	 aTYqwiQRu9W/PnNmk/nYNScKk4up6qA8ILPOHW+5cvVj+MFr5PVRGBWLIxOgetLCF8yeT
	 UqBXK8WXa9Ns2xaARoRXEUIEMtVF46ChAXJopAVK0wGBFQVpAE/+2PqqEkKcvp8WO+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="c/U5OBW7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E46A606A31C;
	Wed, 28 Oct 2026 18:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c/U5OBW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0781F01825;
	Wed, 28 Oct 2026 18:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212260;
	bh=SCxmg0JLIEwV4z4NG+tRqcLF7Q/WdAmxKAMZHJT6LJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/U5OBW7tXL7GAYgAGK/iMpoTLD50atH9KWD1e03Ley3xLX2/0VOh9/zvq3A0J/Bn
	 9Byt7sfTz5fHFvbyY0x0KdSRZx+uk0tcq4CKD6wlq8U9NozFok+8tG3WoJuVRMSnXx
	 nw8irnu33TqdQF0wzHpIkcknAXDy3b6UbpMTCfk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0093/1887] i3c: master: Fix use-after-free of master->this
Date: Wed, 28 Oct 2026 17:36:29 +0100
Message-ID: <20261028170501.349773936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit feb0ed76601f3c2f91f08688c5a7d8b9d382f720 ]

sysfs attribute callbacks for the master controller device dereference
master->this.  However, master->this is freed in
i3c_master_detach_free_devs() before the master device itself is
released.

As a result, sysfs accesses can dereference a freed master->this
pointer, leading to a use-after-free.

Keep master->this alive until i3c_masterdev_release(), which is called
after the master device and its sysfs state are being torn down. Do not
free master->this as part of the normal device detach path.

On the error path in i3c_master_set_info(), reset master->this and
bus.cur_master to NULL before freeing the allocated device.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260807145638.168865-5-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
[ retained of_node_put(dev->of_node) instead of upstream’s fwnode_handle_put(dev->fwnode). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index d0f5ae21ea1f3..cbc3f2d24b618 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -667,6 +667,11 @@ static struct attribute *i3c_masterdev_attrs[] = {
 };
 ATTRIBUTE_GROUPS(i3c_masterdev);
 
+static void i3c_master_free_i3c_dev(struct i3c_dev_desc *dev)
+{
+	kfree(dev);
+}
+
 static void i3c_masterdev_release(struct device *dev)
 {
 	struct i3c_master_controller *master = dev_to_i3cmaster(dev);
@@ -679,6 +684,8 @@ static void i3c_masterdev_release(struct device *dev)
 	i3c_bus_cleanup(bus);
 
 	of_node_put(dev->of_node);
+
+	i3c_master_free_i3c_dev(master->this);
 }
 
 static const struct device_type i3c_masterdev_type = {
@@ -866,11 +873,6 @@ static void i3c_device_release(struct device *dev)
 	kfree(i3cdev);
 }
 
-static void i3c_master_free_i3c_dev(struct i3c_dev_desc *dev)
-{
-	kfree(dev);
-}
-
 static struct i3c_dev_desc *
 i3c_master_alloc_i3c_dev(struct i3c_master_controller *master,
 			 const struct i3c_device_info *info)
@@ -1738,6 +1740,8 @@ int i3c_master_set_info(struct i3c_master_controller *master,
 	return 0;
 
 err_free_dev:
+	master->bus.cur_master = NULL;
+	master->this = NULL;
 	i3c_master_free_i3c_dev(i3cdev);
 
 	return ret;
@@ -1758,7 +1762,8 @@ static void i3c_master_detach_free_devs(struct i3c_master_controller *master)
 					i3cdev->boardinfo->init_dyn_addr,
 					I3C_ADDR_SLOT_FREE);
 
-		i3c_master_free_i3c_dev(i3cdev);
+		if (i3cdev != master->this)
+			i3c_master_free_i3c_dev(i3cdev);
 	}
 
 	list_for_each_entry_safe(i2cdev, i2ctmp, &master->bus.devs.i2c,
-- 
2.53.0



