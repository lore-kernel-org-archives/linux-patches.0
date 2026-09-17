Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DAA4DA9A2;
	Thu, 17 Sep 2026 15:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659647; cv=none; b=RDgQRvneZLnR5HgmVpPWaGns2KNxUimbAu4d4KRx847u83fIjl82Bwng/BDm0IwQcwOws7BB+pdbGHL2Ce3tnVRJ2f7J8YTb/SMCpnGyE4LPZDgkbcBehAegJxUlrE0YQu+Tin034wfYcCtNpkOUgrulemNlxXZWd6AQOUDXtLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659647; c=relaxed/simple;
	bh=jkwcsrUWzBlHXKA8iBkH5jFjgs5Q6nelnAz5Jv5EQ2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwptsh2IMO0LLsXE8iRryU/58zdCY5E8MFtoXxQfHlxMENwG4bVhS/UJ2DeTJMr6EToSoRGHxlWnC7XczUchLoQO/gkrmSd3GTmEBNyQk2TLGuiogNVyC9z0Q+Qn3mY1mJfLmkhYuttin2EzzjSt0fGfvZeLNwQAzzGJvrnIxAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LXBi04FT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LXBi04FT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FB71F000FF;
	Thu, 17 Sep 2026 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659640;
	bh=oKSoYtdhhCW44MRgKeE9zYDroVBahAYYaW8YcRZdjr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXBi04FTU/yMld24Huui9RmBP7nuuMHB6QnGQWWfJtWRek0JqEuAGFbE7//3mc9kR
	 n2sZwCKAKiwJAG3wY1e6SoaD+WbtYVHAbpPK5JL/jIY3/DkLvewGZ9eM8Z2tIv3/lb
	 DTlueq/UwnKHpAcoAhSDiAR6u/K39ujtfGDx0tnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 323/733] Documentation/hwmon: Document hwmon_notify_event()
Date: Thu, 17 Sep 2026 16:10:31 +0100
Message-ID: <20260917151359.550190848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b4fffa75c1d6f87e6dc6191dec900f2b5bd23a1c ]

The hwmon core provides hwmon_notify_event() for drivers to report events
such as alarm or fault conditions to userspace via sysfs notifications
and uevents, as well as to the thermal subsystem for temperature sensors.
However, this function is not documented in the hwmon kernel API guide.

Add the function prototype and description of hwmon_notify_event() to
Documentation/hwmon/hwmon-kernel-api.rst.

Cc: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Fixes: 1597b374af222 ("hwmon: Add notification support")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/hwmon-kernel-api.rst | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
index 9fcde32a140df..c3eb433a78f61 100644
--- a/Documentation/hwmon/hwmon-kernel-api.rst
+++ b/Documentation/hwmon/hwmon-kernel-api.rst
@@ -42,6 +42,9 @@ register/unregister functions::
 
   char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
 
+  int hwmon_notify_event(struct device *dev, enum hwmon_sensor_types type,
+			 u32 attr, int channel);
+
   void hwmon_lock(struct device *dev);
   void hwmon_unlock(struct device *dev);
 
@@ -90,6 +93,18 @@ implemented in the driver, or debugfs functions, hwmon_lock() and hwmon_unlock()
 can be used to ensure that calls to those functions are serialized. Those
 functions also support guard() and scoped_guard() variants.
 
+Drivers can call hwmon_notify_event() to notify userspace and the thermal
+subsystem when a hardware monitoring event (such as an alarm or a fault
+condition) occurs or clears. The parameters are the hwmon device, the sensor
+type, the attribute identifier associated with the event (such as
+hwmon_temp_max_alarm or hwmon_fan_fault), and the sensor channel number.
+hwmon_notify_event() generates a sysfs event (calling sysfs_notify()) and a
+udev event with the attribute name passed in the NAME environment property
+(e.g., "NAME=temp1_max_alarm"). If the event is for a temperature sensor and
+the sensor is attached to a thermal zone, it also notifies the thermal
+subsystem to update the thermal zone. hwmon_notify_event() returns 0 on
+success or a negative error code on failure.
+
 Using devm_hwmon_device_register_with_info()
 --------------------------------------------
 
-- 
2.53.0



