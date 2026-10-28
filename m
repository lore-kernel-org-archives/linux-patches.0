Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216503;
	b=l8JQWRfMQ3Wm46/cBrqaeT5uXIAxEd+m1TJUbJpoC0DEd/0uoIsFOxTFWr5gJmhJkToH
	 +0EbrvLkjPZD1USPqv0GjmWCAxmW3g7vxCjCzAx5lIIYbgmpYflydXT1YYYWC/GKjqBPZ
	 q1i9E7TQsa5501BhIuru76LQpOicugm9q72bb1j6N5kK0+SsItLnexj+ilG16qq3H4NB2
	 16/nMa4MeLjMza4TkLqHkONjUFY6bLUBosqJLfmxcAHItL8yVjiHp5Frsznf6n0413/4g
	 xLkOto4j8h1OIDfEiaX6pU0y0yJvtKWX1shUlQyCny8TzIKYOtpW1Y0uzA0GCwiisHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J17bVirY4gMKt9aTxwGsphiMZpm6iJwro/YR8Msoqd0=;
	b=htmxow+WiueURdLBWMz8CkHj/LEVpJg57J6CJFaLteu9TTPOC5OZun9zzaUMTJ4tGb2G
	 PpPU/9UdjAQnocWZdRdPaZpvsdySKYmGQViq9kQmfs4kF/NPGKemZ4RM//rm1/QjfGxwT
	 mdY0VJ1Vtp6dNnwV5mY7/TOFEkGDw2Tvkk2LZViyldzAUeEnchL4t2vfQ/8Wsu7j/p7LK
	 mqZZmgv3C4a2kcV9MP5PAM8hM1RtK2tvmL85QbtBYuGgxQz1c/9jW+Owbrx10K85N0pza
	 afaS/zuRkv1nMScbVKj21kh3QkYqWZc2GI4uZ9a1sd9ticnmmYF79tZDbcQ4aeVIZEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXjXFxNE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D31606A31A;
	Wed, 28 Oct 2026 19:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eXjXFxNE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9424D1F01825;
	Wed, 28 Oct 2026 19:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216503;
	bh=J17bVirY4gMKt9aTxwGsphiMZpm6iJwro/YR8Msoqd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eXjXFxNE8sNYtnl3/fIr+QAOA4F88qD4K36c8mhe8lfRfBnlpGQUDDM+rcwF+yyxe
	 0ccO0xPLvEVPzXSbprKUFqsNz64XBHLv7ZKQASGOqXzBEg9bVG8olFDZsA3q4ZzZSq
	 bsHzpikMva3Yk38xoo69eaARKQ9bypnASLozDydc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1579/1887] thermal: hwmon: Remove hwmon class device along with its parent
Date: Wed, 28 Oct 2026 18:01:15 +0100
Message-ID: <20261028170535.400164042@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 2b57e24d34b2dfc43c81942bb359d6315bf302fb ]

The current code creates one hwmon device per thermal zone type and that
device is registered under the first thermal zone of the given type.

That turns out to be problematic when the thermal zone holding the
hwmon device is removed.

For example, say that there are two ACPI thermal zones on a system

 /sys/devices/virtual/thermal/thermal_zone0/
 /sys/devices/virtual/thermal/thermal_zone1/

The current code registers a hwmon class device for thermal_zone0 only:

 /sys/devices/virtual/thermal/thermal_zone0/hwmon0/

because the type is "acpitz" for both of them, but it adds a sysfs
attribute that belongs to thermal_zone1 under it:

 /sys/devices/virtual/thermal/thermal_zone0/hwmon0/temp2_input

There is also

 /sys/devices/virtual/thermal/thermal_zone0/hwmon0/temp1_input

which belongs to thermal_zone0.

When thermal_zone0 is removed, say because the ACPI thermal driver is
unbound from the underlying platform device, thermal_remove_hwmon_sysfs()
skips the removal of hwmon0 because of the temp2_input attribute
belonging to thermal_zone1 which effectively prevents thermal_zone0
removal from making progress.

Address this by making thermal_remove_hwmon_sysfs() remove the entire
hwmon class device interface for the given thermal zone type when the
thermal zone device holding it is removed.

To prevent races with thermal_add_hwmon_sysfs() that may interfere
with this, carry out the entire addition and removal of hwmon sysfs
interfaces for thermal zones under thermal_hwmon_list_lock.

Also adjust the layout of the labels in thermal_add_hwmon_sysfs() to
the current kernel coding style to align with the new "unlock" label.

Link: https://lore.kernel.org/linux-pm/20260402021828.16556-1-liujia6264@gmail.com/
Fixes: f6b6b52ef7a5 ("thermal_hwmon: Pass the originating device down to hwmon_device_register_with_info")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/5094738.GXAFRqVoOG@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/thermal_hwmon.c | 87 +++++++++++++--------------------
 1 file changed, 34 insertions(+), 53 deletions(-)

diff --git a/drivers/thermal/thermal_hwmon.c b/drivers/thermal/thermal_hwmon.c
index 1013e0221e371..8edc59454d629 100644
--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -92,34 +92,12 @@ thermal_hwmon_lookup_by_type(const struct thermal_zone_device *tz)
 	struct thermal_hwmon_device *hwmon;
 	char type[THERMAL_NAME_LENGTH];
 
-	mutex_lock(&thermal_hwmon_list_lock);
 	list_for_each_entry(hwmon, &thermal_hwmon_list, node) {
 		strcpy(type, tz->type);
 		strreplace(type, '-', '_');
-		if (!strcmp(hwmon->type, type)) {
-			mutex_unlock(&thermal_hwmon_list_lock);
+		if (!strcmp(hwmon->type, type))
 			return hwmon;
-		}
 	}
-	mutex_unlock(&thermal_hwmon_list_lock);
-
-	return NULL;
-}
-
-/* Find the temperature input matching a given thermal zone */
-static struct thermal_hwmon_temp *
-thermal_hwmon_lookup_temp(const struct thermal_hwmon_device *hwmon,
-			  const struct thermal_zone_device *tz)
-{
-	struct thermal_hwmon_temp *temp;
-
-	mutex_lock(&thermal_hwmon_list_lock);
-	list_for_each_entry(temp, &hwmon->tz_list, hwmon_node)
-		if (temp->tz == tz) {
-			mutex_unlock(&thermal_hwmon_list_lock);
-			return temp;
-		}
-	mutex_unlock(&thermal_hwmon_list_lock);
 
 	return NULL;
 }
@@ -135,7 +113,9 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	struct thermal_hwmon_device *hwmon;
 	struct thermal_hwmon_temp *temp;
 	int new_hwmon_device = 1;
-	int result;
+	int result = 0;
+
+	mutex_lock(&thermal_hwmon_list_lock);
 
 	hwmon = thermal_hwmon_lookup_by_type(tz);
 	if (hwmon) {
@@ -144,8 +124,10 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	}
 
 	hwmon = kzalloc(sizeof(*hwmon), GFP_KERNEL);
-	if (!hwmon)
-		return -ENOMEM;
+	if (!hwmon) {
+		result = -ENOMEM;
+		goto unlock;
+	}
 
 	INIT_LIST_HEAD(&hwmon->tz_list);
 	strscpy(hwmon->type, tz->type, THERMAL_NAME_LENGTH);
@@ -193,24 +175,24 @@ int thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 		temp->temp_crit_present = true;
 	}
 
-	mutex_lock(&thermal_hwmon_list_lock);
 	if (new_hwmon_device)
 		list_add_tail(&hwmon->node, &thermal_hwmon_list);
 	list_add_tail(&temp->hwmon_node, &hwmon->tz_list);
-	mutex_unlock(&thermal_hwmon_list_lock);
 
-	return 0;
+	goto unlock;
 
- unregister_input:
+unregister_input:
 	device_remove_file(hwmon->device, &temp->temp_input.attr);
- free_temp_mem:
+free_temp_mem:
 	kfree(temp);
- unregister_name:
+unregister_name:
 	if (new_hwmon_device)
 		hwmon_device_unregister(hwmon->device);
- free_mem:
+free_mem:
 	if (new_hwmon_device)
 		kfree(hwmon);
+unlock:
+	mutex_unlock(&thermal_hwmon_list_lock);
 
 	return result;
 }
@@ -218,8 +200,11 @@ EXPORT_SYMBOL_GPL(thermal_add_hwmon_sysfs);
 
 void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 {
+	struct thermal_hwmon_temp *temp, *entry;
 	struct thermal_hwmon_device *hwmon;
-	struct thermal_hwmon_temp *temp;
+	bool unregister;
+
+	guard(mutex)(&thermal_hwmon_list_lock);
 
 	hwmon = thermal_hwmon_lookup_by_type(tz);
 	if (unlikely(!hwmon)) {
@@ -228,29 +213,25 @@ void thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 		return;
 	}
 
-	temp = thermal_hwmon_lookup_temp(hwmon, tz);
-	if (unlikely(!temp)) {
-		/* Should never happen... */
-		dev_dbg(&tz->device, "temperature input lookup failed!\n");
-		return;
-	}
+	unregister = hwmon->device->parent == &tz->device;
 
-	device_remove_file(hwmon->device, &temp->temp_input.attr);
-	if (temp->temp_crit_present)
-		device_remove_file(hwmon->device, &temp->temp_crit.attr);
+	list_for_each_entry_safe_reverse(temp, entry, &hwmon->tz_list, hwmon_node) {
+		if (!unregister && temp->tz != tz)
+			continue;
 
-	mutex_lock(&thermal_hwmon_list_lock);
-	list_del(&temp->hwmon_node);
-	kfree(temp);
-	if (!list_empty(&hwmon->tz_list)) {
-		mutex_unlock(&thermal_hwmon_list_lock);
-		return;
+		device_remove_file(hwmon->device, &temp->temp_input.attr);
+		if (temp->temp_crit_present)
+			device_remove_file(hwmon->device, &temp->temp_crit.attr);
+
+		list_del(&temp->hwmon_node);
+		kfree(temp);
 	}
-	list_del(&hwmon->node);
-	mutex_unlock(&thermal_hwmon_list_lock);
 
-	hwmon_device_unregister(hwmon->device);
-	kfree(hwmon);
+	if (unregister) {
+		list_del(&hwmon->node);
+		hwmon_device_unregister(hwmon->device);
+		kfree(hwmon);
+	}
 }
 EXPORT_SYMBOL_GPL(thermal_remove_hwmon_sysfs);
 
-- 
2.53.0



