Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C503340A79
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301056; cv=none; b=RLUkHFEfHQj84t+AxdQMhNIKNge9axgoDPrhIKwOAdqwhvwJGZJV/5iYnr+JfJqV0LtPSMeELrh13UDoxT6OPPp4o0c/YHPeg1uMAc6RfPfJUV+tpQtvU1P7JA/C8WTQM1Z0TrOpPcA0Hh1txwqyH0DSEU5Ph5UWN9FJo4oYBY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301056; c=relaxed/simple;
	bh=HF6QJLMj4durEMEEyikGQooFujvgeRlZgDckJosIKhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0ksqKwHDVn4BT6hWTGURQR1aj4DsN6/+m24QGxEDIuRcN1wI6EcYlTG4DdFYEI4sV7ivmWoXxzz1ngYvncrGuT2TEHszN04Q39CHbJl9BcFHIHlcF1UP6elY1rSjJU1XBG5tpOOCuZ0IGy5X0GXGAp6jKca/KeSo28s55uqQqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsLAU5dI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsLAU5dI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58D6C116D0;
	Sat, 28 Feb 2026 17:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301056;
	bh=HF6QJLMj4durEMEEyikGQooFujvgeRlZgDckJosIKhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsLAU5dI5065UQjUCtmI3E0jamz5+E5sT/7EBoghpw/pgZypkT7oH6aSR+Fvas/R3
	 D2fYQChKpLc0FYktI5pMfQx3p4ST9NkCFwnbTgkXTBEJbYvJEuE8b0D5MSRXp/32PM
	 C1i98SPA8MT7Jv//y4hbyaSjSHddQMkBRYUQNflT9mqT6tQQET3/J6Gb4b8af8tKK7
	 zqbjjwfQyuHOoIbMB6Jr2kQib6yaNRSfkTSs/PxSKFCGLlNs/3dLb14JzLAYFuhJNA
	 YFInqgL5Bo2QtF1EIOKIGQuYQrGGP530fudo2bdWoso/hg/3CuxtBqe4ZfhT7LmofI
	 OneyHF+3OpvdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anj Duvnjak <avian@extremenerds.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 197/752] hwmon: (nct6683) Add customer ID for ASRock Z590 Taichi
Date: Sat, 28 Feb 2026 12:38:28 -0500
Message-ID: <20260228174750.1542406-197-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Anj Duvnjak <avian@extremenerds.net>

[ Upstream commit c0fa7879c9850bd4597740a79d4fac5ebfcf69cc ]

Add support for customer ID 0x1621 found on ASRock Z590 Taichi
boards using the Nuvoton NCT6686D embedded controller.

This allows the driver to instantiate without requiring the
force=1 module parameter.

Tested on two separate ASRock Z590 Taichi boards, both with
EC firmware version 1.0 build 01/25/21.

Signed-off-by: Anj Duvnjak <avian@extremenerds.net>
Link: https://lore.kernel.org/r/20251222220942.10762-1-avian@extremenerds.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/nct6683.rst | 1 +
 drivers/hwmon/nct6683.c         | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/hwmon/nct6683.rst b/Documentation/hwmon/nct6683.rst
index 3e549ba95a15a..45eec9dd349aa 100644
--- a/Documentation/hwmon/nct6683.rst
+++ b/Documentation/hwmon/nct6683.rst
@@ -65,6 +65,7 @@ AMD BC-250			NCT6686D EC firmware version 1.0 build 07/28/21
 ASRock X570			NCT6683D EC firmware version 1.0 build 06/28/19
 ASRock X670E			NCT6686D EC firmware version 1.0 build 05/19/22
 ASRock B650 Steel Legend WiFi	NCT6686D EC firmware version 1.0 build 11/09/23
+ASRock Z590 Taichi		NCT6686D EC firmware version 1.0 build 01/25/21
 MSI B550			NCT6687D EC firmware version 1.0 build 05/07/20
 MSI X670-P			NCT6687D EC firmware version 0.0 build 09/27/22
 MSI X870E			NCT6687D EC firmware version 0.0 build 11/13/24
diff --git a/drivers/hwmon/nct6683.c b/drivers/hwmon/nct6683.c
index 6cda35388b24c..4a83804140386 100644
--- a/drivers/hwmon/nct6683.c
+++ b/drivers/hwmon/nct6683.c
@@ -181,6 +181,7 @@ superio_exit(int ioreg)
 #define NCT6683_CUSTOMER_ID_ASROCK2	0xe1b
 #define NCT6683_CUSTOMER_ID_ASROCK3	0x1631
 #define NCT6683_CUSTOMER_ID_ASROCK4	0x163e
+#define NCT6683_CUSTOMER_ID_ASROCK5	0x1621
 
 #define NCT6683_REG_BUILD_YEAR		0x604
 #define NCT6683_REG_BUILD_MONTH		0x605
@@ -1242,6 +1243,8 @@ static int nct6683_probe(struct platform_device *pdev)
 		break;
 	case NCT6683_CUSTOMER_ID_ASROCK4:
 		break;
+	case NCT6683_CUSTOMER_ID_ASROCK5:
+		break;
 	default:
 		if (!force)
 			return -ENODEV;
-- 
2.51.0

