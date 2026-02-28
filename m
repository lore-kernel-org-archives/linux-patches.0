Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CEA3314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301179; cv=none; b=bRbzVFyMtPPllJIQNsoD6tZrKTzxw3mQK7zlrP0l2VxPh7JpnuWjGeo5K6lp/AaxnXfYv05SkYRmbwaPepeaFq6tRpnQ9lq2Hc9R0L5tEoeegKrhVRJArdizsUvm0VbEpNjFcY9QdTAFGZME0sFXZ/z0/LJ1S2TDQk3znVDg94E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301179; c=relaxed/simple;
	bh=VVnje+7+SfWBlrdLKBwQdRyCvKyAE8CdhiGHg4l/OXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWsUx+xX2AdERq9qQeCVNRurjQv+a37D+OnBjsKoFXVgbJHUrvH5gPlG5QJP4O+270c+AI5lxfXUp0L1tLzoW4GvLDRWrDdOX1z3C8Tnf3Y/Eo2xwmW1QophHv+PKkXBaA/02cjdmxw5DF569Lf8HgFoAE6n71aBYPmCSQQ805s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kioGAmg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kioGAmg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B53FC116D0;
	Sat, 28 Feb 2026 17:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301178;
	bh=VVnje+7+SfWBlrdLKBwQdRyCvKyAE8CdhiGHg4l/OXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kioGAmg1+rtEWEtaz3CRl40CQ/SRmXheFi+YgEQoWq23r4hkZZq3pt01ONuDIqtN4
	 55WgH2X5cS6/QzWfYUWAc/dnElT+R+X5asYqkZdH8CT15xsQQF9fhSRs4hVUCB4qrT
	 MHjMpqVOxGYlX0hlZj6R2CICNL0axJd7mf8xtdkzqBPiWq5n3RbPqkieCejmXDaSag
	 GRshCirTtV83KsLcNH+iBTwdgR3R+LiCWHWtEB/a2XzFJzljdufwawUIg/VVEAetkL
	 RZPC4Z9um6N4TXBvWo4wlILiavH4f09MwQRrkkxXPDSRK5Xt4gGMcbasoB+Bfcpmy9
	 /S3aSM69T2TJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Ren=C3=A9=20Rebe?= <rene@exactco.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 347/752] fix it87_wdt early reboot by reporting running timer
Date: Sat, 28 Feb 2026 12:40:58 -0500
Message-ID: <20260228174750.1542406-347-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: René Rebe <rene@exactco.de>

[ Upstream commit 88b2ab346436f799b99894a3e9518a3ffa344524 ]

Some products, such as the Ugreen DXP4800 Plus NAS, ship with the it87
wdt enabled by the firmware and a broken BIOS option that does not
allow to change the time or turn it off. As this makes installing
Linux rather difficult, change the it87_wdt to report it running to
the watchdog core.

Signed-off-by: René Rebe <rene@exactco.de>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/it87_wdt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index 3b8488c86a2f3..1d9f8591f38d8 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -188,6 +188,12 @@ static void _wdt_update_timeout(unsigned int t)
 		superio_outb(t >> 8, WDTVALMSB);
 }
 
+/* Internal function, should be called after superio_select(GPIO) */
+static bool _wdt_running(void)
+{
+	return superio_inb(WDTVALLSB) || (max_units > 255 && superio_inb(WDTVALMSB));
+}
+
 static int wdt_update_timeout(unsigned int t)
 {
 	int ret;
@@ -374,6 +380,12 @@ static int __init it87_wdt_init(void)
 		}
 	}
 
+	/* wdt already left running by firmware? */
+	if (_wdt_running()) {
+		pr_info("Left running by firmware.\n");
+		set_bit(WDOG_HW_RUNNING, &wdt_dev.status);
+	}
+
 	superio_exit();
 
 	if (timeout < 1 || timeout > max_units * 60) {
-- 
2.51.0

