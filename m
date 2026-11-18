Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061184;
	b=pEJsJ7gKKUe5K0OXngEqYWI/x6NZX8QJZiGy3ft7LtJ5YRAlLgXimgHsLnl0BFrIO5WD
	 5UpDvSdUUeRYmC0x2SvoL//KjhJtRHPSubqJqMH7WIPtzQbl4id1z3H55SY7nZp28tS+2
	 bn2P1iBo1pPTTzK8tjw5yGtneOnrmvpI65+kE0I6E6KcVImcDztg+zybFEAs1ZyTIgkQj
	 IzkYtV/t5sV61ADvbDaVcmLuJqscUPIkdu2VGs3lRcPqBF4SJ8mrXBwsZ7gnedm+QFr6C
	 zDRyqFLb+q51F0FwFYSlARGbOZlmNAfFIty3PSIcVBPiCbUMbaJ9760FH0gDMrl/saQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YAUOlyQoTYbXUduLZDpHMa1zt1Zyw65Z1MgQpL8NWB4=;
	b=Ad+wSKmpRHBlZSI3eLoS8nYY/BIgABsLNVRLCYKQTbA4l/fkpqqdgZq1aKzfdf8LO1jF
	 uxN+QjAYbLpI7voriUPrkZmYRnfZNvXQAhsYyI1gKrjLIfZuaJgAEd8TFeGGWvSrTc/3L
	 6fxFImGJAMEe871zE+AglHCldKRdBwHCocZ2EjGJNOcv6h28R4RXwtWvj5j6GHXQ2RsWo
	 iNdX5DZJJHKKfmt3qqhzJPuCjpkYhapDcLqQka2JOmipme1yfsUXZRtF+LTbRsew82Ygf
	 qvuZkhXnFue9bCKXwFEWBdpKwZDkVifIu7xHUC98lWR8SUArjBefov62lKDU0GgDpIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFpcA5d1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCBD606A32A;
	Thu, 19 Nov 2026 04:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFpcA5d1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3ABC1F000C4;
	Thu, 19 Nov 2026 04:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061184;
	bh=YAUOlyQoTYbXUduLZDpHMa1zt1Zyw65Z1MgQpL8NWB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFpcA5d12POxvFfld41qyVnys5OucIqXr1pQKiUXkn3TsWWpzmCupoycmLn9thdPW
	 Mkvz4k/JFhNUFMChIbIwJQoOHHlguxi/P88A1ioyyy57TsAAA2uoIfLPXc+IjMI5Db
	 Zngm1a2xoSDHPrw8FF5gPsxgNasG31btYuTWBjNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Lee Jones <lee.jones@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1460/1848] power: ab8500: Require device tree
Date: Wed, 18 Nov 2026 15:58:18 +0100
Message-ID: <20261118150020.481063540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 53207aa1a73e3e52b14c432b04d342c2b3af2e1c ]

The core AB8500 driver and the whole platform is completely
dependent on being probed from device tree so remove the
non-DT probe paths.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Stable-dep-of: 1098c619ce75 ("power: supply: ab8500_charger: Handle detection errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/Kconfig           |  2 +-
 drivers/power/supply/ab8500_btemp.c    | 10 ++++------
 drivers/power/supply/ab8500_charger.c  | 15 ++++++---------
 drivers/power/supply/ab8500_fg.c       | 10 ++++------
 drivers/power/supply/abx500_chargalg.c | 10 ++++------
 5 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/drivers/power/supply/Kconfig b/drivers/power/supply/Kconfig
index 0aa46b4510177..fc0b1f636a259 100644
--- a/drivers/power/supply/Kconfig
+++ b/drivers/power/supply/Kconfig
@@ -678,7 +678,7 @@ config BATTERY_GAUGE_LTC2941
 
 config AB8500_BM
 	bool "AB8500 Battery Management Driver"
-	depends on AB8500_CORE && AB8500_GPADC && (IIO = y)
+	depends on AB8500_CORE && AB8500_GPADC && (IIO = y) && OF
 	help
 	  Say Y to include support for AB8500 battery management.
 
diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index ce99b7289fbd7..da197f55b1f25 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -996,12 +996,10 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 	}
 	di->bm = plat;
 
-	if (np) {
-		ret = ab8500_bm_of_probe(dev, np, di->bm);
-		if (ret) {
-			dev_err(dev, "failed to get battery information\n");
-			return ret;
-		}
+	ret = ab8500_bm_of_probe(dev, np, di->bm);
+	if (ret) {
+		dev_err(dev, "failed to get battery information\n");
+		return ret;
 	}
 
 	/* get parent data */
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 2c8ea8d833e74..c6eb90b870878 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3376,15 +3376,12 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 	}
 	di->bm = plat;
 
-	if (np) {
-		ret = ab8500_bm_of_probe(dev, np, di->bm);
-		if (ret) {
-			dev_err(dev, "failed to get battery information\n");
-			return ret;
-		}
-		di->autopower_cfg = of_property_read_bool(np, "autopower_cfg");
-	} else
-		di->autopower_cfg = false;
+	ret = ab8500_bm_of_probe(dev, np, di->bm);
+	if (ret) {
+		dev_err(dev, "failed to get battery information\n");
+		return ret;
+	}
+	di->autopower_cfg = of_property_read_bool(np, "autopower_cfg");
 
 	/* get parent data */
 	di->dev = dev;
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index e289e6cad777c..df416afd3225a 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3050,12 +3050,10 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	}
 	di->bm = plat;
 
-	if (np) {
-		ret = ab8500_bm_of_probe(dev, np, di->bm);
-		if (ret) {
-			dev_err(dev, "failed to get battery information\n");
-			return ret;
-		}
+	ret = ab8500_bm_of_probe(dev, np, di->bm);
+	if (ret) {
+		dev_err(dev, "failed to get battery information\n");
+		return ret;
 	}
 
 	mutex_init(&di->cc_lock);
diff --git a/drivers/power/supply/abx500_chargalg.c b/drivers/power/supply/abx500_chargalg.c
index a9d84d845f24e..591ddd2987a3f 100644
--- a/drivers/power/supply/abx500_chargalg.c
+++ b/drivers/power/supply/abx500_chargalg.c
@@ -1997,12 +1997,10 @@ static int abx500_chargalg_probe(struct platform_device *pdev)
 	}
 	di->bm = plat;
 
-	if (np) {
-		ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
-		if (ret) {
-			dev_err(&pdev->dev, "failed to get battery information\n");
-			return ret;
-		}
+	ret = ab8500_bm_of_probe(&pdev->dev, np, di->bm);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to get battery information\n");
+		return ret;
 	}
 
 	/* get device struct and parent */
-- 
2.53.0



