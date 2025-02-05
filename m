Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE8E155333;
	Wed,  5 Feb 2025 14:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764234; cv=none; b=XCuq4Ga/vohyKEuS0TDV02Jg8mBEyqAdCeCjLKUk5L3n00QJ54jQCYOtcgjXYU1o63LM1rfKUKp6vzBaqtLaFPp9338B5x0VoPb/UaN3InVpum7+cG+oI0in5B0rYQB54uo/2X4fDtWsymLNEKplNoE1cGAbauLRq+CA5x75/AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764234; c=relaxed/simple;
	bh=sL7mcvsGVo2owI6fekKY/Oxz5YkWltDaa+Yp9Ab5iIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V9Z1jxm2expAyp7XVMQmrPAfL4cMBfAowfAVntYZIlCMQcDMhfMbflI/wIzaYCeVAGTFl/cNaW5MfBFbMJJrgiBSyEFPzborsV6kIvNzHAi7gr3UvlTT57eUAurGRC0h+RF4IlACckq84CINd7dgz/VgfxJ0mln3taO3mEx8uWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FjhgiawM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FjhgiawM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1510C4CED1;
	Wed,  5 Feb 2025 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764234;
	bh=sL7mcvsGVo2owI6fekKY/Oxz5YkWltDaa+Yp9Ab5iIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjhgiawMDmJiTX18vqPANf1LAjQWQ/Y6lCJReZecg55tJkxAVhb9XwHLoXKfFyBw5
	 CG6zon+vuHh+ig2pNPbn+Ri6E9w3r2mzObX8XgGd3jvkluievJSxasPplRaLdt/lW+
	 /XI64NwyyrwignsepMRmGUnCXKXYLRGiXlBjKxnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/590] hwmon: (nct6775): Actually make use of the HWMON_NCT6775 symbol namespace
Date: Wed,  5 Feb 2025 14:37:36 +0100
Message-ID: <20250205134459.122102606@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 2505f87eb3af55f3dd7f57d7cb7783b94b52a2d9 ]

DEFAULT_SYMBOL_NAMESPACE must already be defined when <linux/export.h>
is included. So move the define above the include block.

Fixes: c3963bc0a0cf ("hwmon: (nct6775) Split core and platform driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index c243b51837d2f..fa3351351825b 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -42,6 +42,9 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#undef DEFAULT_SYMBOL_NAMESPACE
+#define DEFAULT_SYMBOL_NAMESPACE "HWMON_NCT6775"
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -56,9 +59,6 @@
 #include "lm75.h"
 #include "nct6775.h"
 
-#undef DEFAULT_SYMBOL_NAMESPACE
-#define DEFAULT_SYMBOL_NAMESPACE "HWMON_NCT6775"
-
 #define USE_ALTERNATE
 
 /* used to set data->name = nct6775_device_names[data->sio_kind] */
-- 
2.39.5



