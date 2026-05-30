Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B4729E11A;
	Sat, 30 May 2026 18:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166489; cv=none; b=Ot1eH77OHhlMAaK4LHc+vf0EiGLgPCVKpLWVnnh0/D+K+7oBfZqo/mM0RdvNKSD/A2DwizAEByxL0MKu2uBtiGTOakWbTlOETy1Vx4H8UBfJRKJrsTiDVWwCOJLPVj+2TtpvD9RwfmfmBQPGZz3EkHuq5+3no/Jmc+QjYfWSxaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166489; c=relaxed/simple;
	bh=gHqL4UZPaRSu9rdPzxwAkHQpkBGjOk30uALMkXCpMBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2wMpStCtg0iJtLD4qVIshrjbn8Mxp02940+Gy++5x1RrOE1BewDrJvP01a3GQu0Hce0lV/d+kornRlPQJOfmd6RSa9ipxQUxT+qImNDpmDDEfNsc9CETTvIn4f0BDTlQwJJ4BZCjt+9CyO3WbgA5izO8IFrOVEkSWkNPWjSeIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s47RDN0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s47RDN0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64491F00893;
	Sat, 30 May 2026 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166488;
	bh=/NEXSC4StEb+AjGslFxLJInxweUwgokZg06Uu4rI/F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s47RDN0Ie0S3fak5EjRSe/tJPhOfKg/5OkjUPMaPMA0T+gS64bQzpko+u3EQqPF8j
	 13liO1yt6SUDU1/nrPb8Ez0AXtTgWSeDQwQy6smHnM6e1kOLJpf52C98uJwd5+SIL0
	 T6UUlIUKiiNu3Yz2GqChi+dntdzvwjVDFcZ1HvXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 387/589] driver core: Move dev_err_probe() to where it belogs
Date: Sat, 30 May 2026 18:04:28 +0200
Message-ID: <20260530160234.971847685@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6f009559ee540..6a6a6baa10bac 100644
--- a/include/linux/dev_printk.h
+++ b/include/linux/dev_printk.h
@@ -242,4 +242,6 @@ do {									\
 	WARN_ONCE(condition, "%s %s: " format, \
 			dev_driver_string(dev), dev_name(dev), ## arg)
 
+__printf(3, 4) int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
+
 #endif /* _DEVICE_PRINTK_H_ */
diff --git a/include/linux/device.h b/include/linux/device.h
index 11709e3ee811f..77d6493c26a48 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1032,8 +1032,6 @@ void device_links_supplier_sync_state_pause(void);
 void device_links_supplier_sync_state_resume(void);
 void device_link_wait_removal(void);
 
-__printf(3, 4) int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
-
 /* Create alias, so I can be autoloaded. */
 #define MODULE_ALIAS_CHARDEV(major,minor) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
-- 
2.53.0



