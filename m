Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F43637883C;
	Thu, 30 Jul 2026 14:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423181; cv=none; b=rEOzo9VIHxMv0W2pHB6b3bg0GkBl0TUbKYDSOReFdriqd2QKFi8X2/p91jz223sQ0nmSdVAr6Tld8VUpDfBocF78kaZNgu/TjPkSllS152CQZ1h3gML2O7Wu6Cn8kPNIncsRR+GmWZULwAJBg16xn5fEnvvfMysPeNylQvNK7Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423181; c=relaxed/simple;
	bh=YRC8IeDQJABlwX2Ly26egH3oAtsAVvq6fFllYRx5zs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuHfG8c/JBf5mZ4ubwk1xWDzOyNl1bvren6tnNile9dtAGySv8w0UNpufPDiXVc2Vm3qfVQdZq+Eu5zlSmmdgOP45OIzCMiBr1KlRefnNa3mi6iagfCrOvkbccWSWx8/rlpTx8G28sIyqmC1nbXfCooO8Ic53XIP8YQRYto01aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2M9tc2A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2M9tc2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A481F000E9;
	Thu, 30 Jul 2026 14:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423179;
	bh=0NXZV4vSrixdiSIdmjzu5DHYMNeSK1+vP4pHfog727w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2M9tc2A/MiK1rPfBeQvT+Mn9lo5dPJSLz58SvfFwtNpOJPAy7eDd+8NV4NMzypZ0
	 mqo4246hzmhgJG64Y1GMg84+uLQ6CNDIMAz3C2NEixonf3DB9RUHWEaj2E2wr1NMFw
	 9lD4evEltb9Xi7uCLsr5xH91DWAaUwayH2h9VhmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.1 692/744] watchdog: s32g_wdt: remove incorrect options in watchdog_info struct
Date: Thu, 30 Jul 2026 16:16:05 +0200
Message-ID: <20260730141458.974872883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit 2b37415618bfc6a83d4aceb00fd8d6491096f2ed upstream.

The s32g_wdt driver uses two incorrect constants in the options field
of its watchdog_info struct. This bit mask should contain WDIOF_*
constants, but the driver uses two WDIOC_* ioctl constants (in addition
to correct WDIOF_* constants). This causes many incorrect bits to be
set in the bit mask. The functionality indicated by these ioctl
constants is supported by all drivers using the watchdog framework, so
this patch simply removes them.

Fixes: bd3f54ec559b ("watchdog: Add the Watchdog Timer for the NXP S32 platform")
Cc: stable@vger.kernel.org # 6.18+
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Acked-by: Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260505024409.60301-1-enelsonmoore@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/s32g_wdt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/watchdog/s32g_wdt.c
+++ b/drivers/watchdog/s32g_wdt.c
@@ -56,8 +56,7 @@ MODULE_PARM_DESC(early_enable,
 
 static const struct watchdog_info s32g_wdt_info = {
 	.identity = "s32g watchdog",
-	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
-	WDIOC_GETTIMEOUT | WDIOC_GETTIMELEFT,
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
 };
 
 static struct s32g_wdt_device *wdd_to_s32g_wdt(struct watchdog_device *wdd)


