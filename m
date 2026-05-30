Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F36332EA7;
	Sat, 30 May 2026 17:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161584; cv=none; b=cEuxmrXyynja2RyuxQmbLQwvDrvXA/T1zADo3M026F75ceYabY99AIM/AfoUfqJmETfrxFHbiw3Pod9ildM4NoUHYoIzr5G/TI2zDxHKZRWO4q2quGlvlJVXSlNTpGkWr831rw7uC9LUtp4b1dSsKziqLvgmDiBpbBVh6JJxhp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161584; c=relaxed/simple;
	bh=+YpRsJ3u3Yqg/UdO7V8CPcGuhNNZZFb0LHV6uZhzkVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQVPlvse8YYIx/1lNXLOqMkp/P3NcMXQmCw+fJhzSuRNfoxLQu+Bzxc/93x/nwoggvRfNy67jHncVbMxa/xW7n/qO9M5b85Ux8t6gN9YjWGy3+UTGX4Gnsi9Kbtv74gCPIN0rC/OjqcnelJrqaCzUonmFaeTLfOyBYr2SUtgU60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyz8x+Cg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyz8x+Cg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2C01F00893;
	Sat, 30 May 2026 17:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161583;
	bh=fePezc/4xaStN1uQ3XH6Wjd6Mwqbv9Li6GgjY81q+qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lyz8x+CgIgRpx38evBIUEs34RfdV++Y/xatbK3Bq0t3QN8zA9K1L6x+LfFnhVEy4b
	 rBI5G5Yc6r0qeVwPXzPh2Owkfn/S3fpHPFhZ+avyUZmfB3m/w5n6N9g2IIPDfYSHlC
	 9cvS9aQaibO8QDll4SRNX25OGd3kWdSVUQQnTWuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 636/969] driver core: Move dev_err_probe() to where it belogs
Date: Sat, 30 May 2026 18:02:40 +0200
Message-ID: <20260530160318.015412968@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9e0cace7a6254070159ebd86497eadc29ea307ca ]

dev_err_probe() belongs to the printing API, hence
move the definition from device.h to dev_printk.h.

There is no change to the callers at all, since:
1) implementation is located in the same core.c;
2) dev_printk.h is guaranteed to be included by device.h.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20230721131309.16821-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 797cc011ae02 ("backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dev_printk.h | 2 ++
 include/linux/device.h     | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/dev_printk.h b/include/linux/dev_printk.h
index 65eec5be8ccb9..ae80a303c216b 100644
--- a/include/linux/dev_printk.h
+++ b/include/linux/dev_printk.h
@@ -275,4 +275,6 @@ do {									\
 	WARN_ONCE(condition, "%s %s: " format, \
 			dev_driver_string(dev), dev_name(dev), ## arg)
 
+__printf(3, 4) int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+
 #endif /* _DEVICE_PRINTK_H_ */
diff --git a/include/linux/device.h b/include/linux/device.h
index 428c96ce6b4c4..e642b366aa380 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1149,8 +1149,6 @@ void device_links_supplier_sync_state_pause(void);
 void device_links_supplier_sync_state_resume(void);
 void device_link_wait_removal(void);
 
-__printf(3, 4) int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
-
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
-- 
2.53.0



