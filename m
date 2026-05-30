Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26CD3AC0FA;
	Sat, 30 May 2026 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164331; cv=none; b=LL2fCoKl7XcEiEfq5Zs7DEXTyzZKEBLEjzZzwInn8ThgUh2khSKRsW+tKTrvAU7ftiEHLxMLPxhNoGQD9ti+1e4Z2eZnDUkdHmUgl4pz8raIvIlhikuIvl9zLaEY1NJdJtCYcQ6ptvADMwXq+t+JG86wpCpDQ8Lrvz/3XO3Lkzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164331; c=relaxed/simple;
	bh=ZfkSe/WXmIrM5x7uT+M7zMFEDUuXzwslcuvxYPmLSRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0vyD8uQU0XkbPIAOOf2Uu4QpqQ57e4j/3pRxoGTpTlbXdyNEimT4I9bunaayjfaoyuTytcNAh9XeJ2qlHEWJqjbz9YE0nYylHlz8PjtzE7UCBZd6i/I5I8AbNh8ux7d4IDlsP54g3Yn5Lsb9Ch1QqPbbldoWWR7SQEv4B9S620=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5bAZBRt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5bAZBRt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08831F00893;
	Sat, 30 May 2026 18:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164330;
	bh=2aOrTfaUHZrclItKxsqrr1DAOSHly11yx8cnV7mMKro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5bAZBRt2AiUZzEhkJvb4RAYKBO4pAjwAJZjvPnxMyfTYJjsgjuukAKNQHkOWE0QY
	 I1ghXdr29d8rKIc6djNZmtob0SipMyOo0lJwgMmM08PHl/svPFT5fwgTzH5S24aHtU
	 ivr7uDGcMD9l+4yQUunTJiKNKDS6dhMdaXjS+H+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 521/776] driver core: Move dev_err_probe() to where it belogs
Date: Sat, 30 May 2026 18:03:55 +0200
Message-ID: <20260530160253.698238524@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 97fb43c6d919d..2c16bc2149c20 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1030,8 +1030,6 @@ void device_links_supplier_sync_state_pause(void);
 void device_links_supplier_sync_state_resume(void);
 void device_link_wait_removal(void);
 
-__printf(3, 4) int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
-
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
-- 
2.53.0



