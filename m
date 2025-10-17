Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABF53370FA;
	Fri, 17 Oct 2025 15:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713965; cv=none; b=tHd9SJz+5O3w1uV+ktjs6S3yQ/8XN5FVmjLZfAfMEarj/Ge7QNWPaOP2sB8zceNFFNNw2bgNF2BU+Y+pKPReyFZtW7TACtfd8avvxQnkqQugmdMwDRBmtN/q6PtislpIY82H2neusUNGuVje0mu/E4KBrtHP3kwi6yk6WWMJQ/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713965; c=relaxed/simple;
	bh=veubsG0v8Ee0KhDu03uZtTFolSsEvyaZVlLZe8GFDiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qtOBBG4tIFIgnb9vVLeOvH01rpUPoOrjum7TCS2jIS7uj7rXFpql7KXyRHqR9hJBGnUMxpe8T7NFJZmummJV8ltDKKRJSrZk5eZMhiymcJQCdIrEQQz59UBPQ5vPS9duvfUC+dV9yCbBHOfGDygPEq3LTBZDT/aXrH8i12SfqZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tg9N2dzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tg9N2dzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 203F8C4CEE7;
	Fri, 17 Oct 2025 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713965;
	bh=veubsG0v8Ee0KhDu03uZtTFolSsEvyaZVlLZe8GFDiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tg9N2dznV0b3Hd3fyAp/Jmh4aV+TIMLzrGK5XlOMVawaEt5Oq2mIJmHAeIQd1gRty
	 uTViREGOtOhqK4nr2gPJySLJdgw644+PrMcxBYkUy+GZ5OW2MBBtfP/XZA0GJJyos8
	 Tn7t9HQ1ismNjAvui+SMQTPdXZfwSN8aEgOHz92g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/201] ACPI: battery: Check for error code from devm_mutex_init() call
Date: Fri, 17 Oct 2025 16:54:01 +0200
Message-ID: <20251017145141.367650146@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 815daedc318b2f9f1b956d0631377619a0d69d96 ]

Even if it's not critical, the avoidance of checking the error code
from devm_mutex_init() call today diminishes the point of using devm
variant of it. Tomorrow it may even leak something. Add the missed
check.

Fixes: 0710c1ce5045 ("ACPI: battery: initialize mutexes through devm_ APIs")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20241030162754.2110946-1-andriy.shevchenko@linux.intel.com
[ rjw: Added 2 empty code lines ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 399dbcadc01e ("ACPI: battery: Add synchronization between interface updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/battery.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -1210,8 +1210,14 @@ static int acpi_battery_add(struct acpi_
 	strcpy(acpi_device_name(device), ACPI_BATTERY_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
 	device->driver_data = battery;
-	devm_mutex_init(&device->dev, &battery->lock);
-	devm_mutex_init(&device->dev, &battery->sysfs_lock);
+	result = devm_mutex_init(&device->dev, &battery->lock);
+	if (result)
+		return result;
+
+	result = devm_mutex_init(&device->dev, &battery->sysfs_lock);
+	if (result)
+		return result;
+
 	if (acpi_has_method(battery->device->handle, "_BIX"))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
 


