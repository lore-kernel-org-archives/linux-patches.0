Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217381;
	b=HymkhWyX5qrcG/PXUtU4SqxWb7CfODgupAvP3gx0OHJpgdIEM/gn/lz7Oz5t2oyFS3Nn
	 oT/eMCfrEeAWX3IcVZtE3+CywztzhlTJLaVr1fuI7DzKRSBNxJQybhAX8egY02HBWNTtF
	 1zjJXzyGPntIIBgv8C0LgEJEkHF/gMzuAfTAX9rFTk8wVgWZ5RWJA1gpBkT7z2+WOwpyd
	 xZvreAKypw6Ce02UPH3gnDSsZLecHtKbPNHaOcjiyu7s015A6G/40rLd1vvyIsnTeKdw+
	 gfL81vBs9NGipqIwbQDZZztq6cSX79epuzRIWlq+myC8U2yCcOd6EnoRRIyZWEvXGCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I9rGo/2W1f8BwwIX/sA8xBTbFy/w/Ty2qAu6JZoYAyw=;
	b=AOd2oYpWRfncMGafFJzZSLIj1ao6SEOAvqrv5nJIowOzvmRCcC8E5/w7HhVAqU1yppro
	 6bbKVvvANFPsfbAoZDoDDmUEVJzoFQq8mmQKgxccPZNK5ukM5bYKdisT26x/wNLypI+9X
	 6NIcfh5meNN1yY9FJ4U4NyzY/FjlD+pDLCTlXlzAM3c59J7xEQI09+bOXJgb7dDtyMSKL
	 05LPNrUxUxg2XLgmuaqL88hnqp9UWDTBsul1ITlbnYaPg7+RkE6Yi2QqVEj3fTg+hnHC2
	 tbHkRm9I/A2VpmzI3HKnyz5pEumxDIcYddwA5Ev4jeB1UjmQPxAp6vKGavZjN+4B/qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUxowJTJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CB2606A321;
	Wed, 28 Oct 2026 19:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUxowJTJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16BEB1F01825;
	Wed, 28 Oct 2026 19:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217380;
	bh=I9rGo/2W1f8BwwIX/sA8xBTbFy/w/Ty2qAu6JZoYAyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUxowJTJRVQAJ9TF+t+ZDBhq5tmkIYawE/7l36k2VWqo5KWg5Ng6DmtEr6mNUk+3P
	 6XCom/hIehCH6G7hZbB2OOt6nFx8PKRqNdWqTNPx+2Qgq3Ckt9WX6al4ad45yhFJL/
	 ILtPtIyXA4Qt61vtFU+QhKyeYQ+q9M1UMi107uqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1840/1887] firmware: arm_scmi: Add multiple protocols registration support
Date: Wed, 28 Oct 2026 18:05:36 +0100
Message-ID: <20261028170541.320726443@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 2858f6e5f06440d6b9e9c3f57bc68915344830a9 ]

Add the capability for a SCMI driver to register to the core SCMI stack
with multiple SCMI protocols. In such a case the SCMI driver probe
function will end up being called once for each registered protocol
which have been also found as implemented on the platform.

This is especially useful in testing scenarios.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20231221151129.325749-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 9f7cd6a62aa7 ("firmware: arm_scmi: Unrequest devices if driver registration fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 3fcc46423d42c..8ef893957ef2e 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -134,6 +134,17 @@ static int scmi_protocol_device_request(const struct scmi_device_id *id_table)
 	return ret;
 }
 
+static int scmi_protocol_table_register(const struct scmi_device_id *id_table)
+{
+	int ret = 0;
+	const struct scmi_device_id *entry;
+
+	for (entry = id_table; entry->name && ret == 0; entry++)
+		ret = scmi_protocol_device_request(entry);
+
+	return ret;
+}
+
 /**
  * scmi_protocol_device_unrequest  - Helper to unrequest a device
  *
@@ -179,6 +190,15 @@ static void scmi_protocol_device_unrequest(const struct scmi_device_id *id_table
 	mutex_unlock(&scmi_requested_devices_mtx);
 }
 
+static void
+scmi_protocol_table_unregister(const struct scmi_device_id *id_table)
+{
+	const struct scmi_device_id *entry;
+
+	for (entry = id_table; entry->name; entry++)
+		scmi_protocol_device_unrequest(entry);
+}
+
 static const struct scmi_device_id *
 scmi_dev_match_id(struct scmi_device *scmi_dev, struct scmi_driver *scmi_drv)
 {
@@ -273,7 +293,7 @@ int scmi_driver_register(struct scmi_driver *driver, struct module *owner,
 	if (!driver->probe)
 		return -EINVAL;
 
-	retval = scmi_protocol_device_request(driver->id_table);
+	retval = scmi_protocol_table_register(driver->id_table);
 	if (retval)
 		return retval;
 
@@ -293,7 +313,7 @@ EXPORT_SYMBOL_GPL(scmi_driver_register);
 void scmi_driver_unregister(struct scmi_driver *driver)
 {
 	driver_unregister(&driver->driver);
-	scmi_protocol_device_unrequest(driver->id_table);
+	scmi_protocol_table_unregister(driver->id_table);
 }
 EXPORT_SYMBOL_GPL(scmi_driver_unregister);
 
-- 
2.53.0



