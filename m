Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF04123816E;
	Mon,  2 Jun 2025 15:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876824; cv=none; b=bj+v+E7sSmjQGzkE6po3+RgCO1gSFXuQecCR8wKlcGh84maRplGDdgjTRSOj76cK1YzVeAsC+g6DVUYcid4yEAxywW11NhMjn3y13ikGC3DqUbzGDY8k43TfMdObMG4p1HfQJLajX4PsiYT8LvPI8fWvAydU22WOxGBwpDql/go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876824; c=relaxed/simple;
	bh=Y75Asei4oKxSiu57+ehWbPjG8R0MvcoPbfVYH6kl8vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDJn7WU4Ioivqo/f0e2B5Fb1xvAvzkD4NW892FF9DC3ZlWSn3C6Xn8cGp/G0xRwwV+N4nKzjZsLakNN12Y5e56FB0n9PSgJ/U0s6pD4zePtGbwppAipvcYpAeoNeixypIALMmVJQAp1dPDrIT0gbsbq49vlkLZkzrDjS/+w0O6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXTzjOF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXTzjOF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D37C4CEEB;
	Mon,  2 Jun 2025 15:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876823;
	bh=Y75Asei4oKxSiu57+ehWbPjG8R0MvcoPbfVYH6kl8vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXTzjOF2NRRBlpwL+PlAOxgtTdEvHMD9Hpr3gTrpboGcm2IbntyFISZLtyPNsFcz3
	 1hRUiTTDh/q8C4QWeBsPxdKF5TEH4gFMlyXXlSxR0iGk3murfkB6MLzKonfaFhFXXr
	 TtaVtx5FRhR33d8cVLoEIlJLJqE6WNEYbZHnd1DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 086/325] hwmon: (dell-smm) Increment the number of fans
Date: Mon,  2 Jun 2025 15:46:02 +0200
Message-ID: <20250602134323.277012043@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kurt Borja <kuurtb@gmail.com>

[ Upstream commit dbcfcb239b3b452ef8782842c36fb17dd1b9092f ]

Some Alienware laptops that support the SMM interface, may have up to 4
fans.

Tested on an Alienware x15 r1.

Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250304055249.51940-2-kuurtb@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/dell-smm-hwmon.rst | 14 +++++++-------
 drivers/hwmon/dell-smm-hwmon.c         |  5 ++++-
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/Documentation/hwmon/dell-smm-hwmon.rst b/Documentation/hwmon/dell-smm-hwmon.rst
index d8f1d6859b964..1c12fbba440bc 100644
--- a/Documentation/hwmon/dell-smm-hwmon.rst
+++ b/Documentation/hwmon/dell-smm-hwmon.rst
@@ -32,12 +32,12 @@ Temperature sensors and fans can be queried and set via the standard
 =============================== ======= =======================================
 Name				Perm	Description
 =============================== ======= =======================================
-fan[1-3]_input                  RO      Fan speed in RPM.
-fan[1-3]_label                  RO      Fan label.
-fan[1-3]_min                    RO      Minimal Fan speed in RPM
-fan[1-3]_max                    RO      Maximal Fan speed in RPM
-fan[1-3]_target                 RO      Expected Fan speed in RPM
-pwm[1-3]                        RW      Control the fan PWM duty-cycle.
+fan[1-4]_input                  RO      Fan speed in RPM.
+fan[1-4]_label                  RO      Fan label.
+fan[1-4]_min                    RO      Minimal Fan speed in RPM
+fan[1-4]_max                    RO      Maximal Fan speed in RPM
+fan[1-4]_target                 RO      Expected Fan speed in RPM
+pwm[1-4]                        RW      Control the fan PWM duty-cycle.
 pwm1_enable                     WO      Enable or disable automatic BIOS fan
                                         control (not supported on all laptops,
                                         see below for details).
@@ -93,7 +93,7 @@ Again, when you find new codes, we'd be happy to have your patches!
 ---------------------------
 
 The driver also exports the fans as thermal cooling devices with
-``type`` set to ``dell-smm-fan[1-3]``. This allows for easy fan control
+``type`` set to ``dell-smm-fan[1-4]``. This allows for easy fan control
 using one of the thermal governors.
 
 Module parameters
diff --git a/drivers/hwmon/dell-smm-hwmon.c b/drivers/hwmon/dell-smm-hwmon.c
index 1572b54160158..dbcb8f362061d 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -67,7 +67,7 @@
 #define I8K_POWER_BATTERY	0x01
 
 #define DELL_SMM_NO_TEMP	10
-#define DELL_SMM_NO_FANS	3
+#define DELL_SMM_NO_FANS	4
 
 struct dell_smm_data {
 	struct mutex i8k_mutex; /* lock for sensors writes */
@@ -940,11 +940,14 @@ static const struct hwmon_channel_info *dell_smm_info[] = {
 			   HWMON_F_INPUT | HWMON_F_LABEL | HWMON_F_MIN | HWMON_F_MAX |
 			   HWMON_F_TARGET,
 			   HWMON_F_INPUT | HWMON_F_LABEL | HWMON_F_MIN | HWMON_F_MAX |
+			   HWMON_F_TARGET,
+			   HWMON_F_INPUT | HWMON_F_LABEL | HWMON_F_MIN | HWMON_F_MAX |
 			   HWMON_F_TARGET
 			   ),
 	HWMON_CHANNEL_INFO(pwm,
 			   HWMON_PWM_INPUT | HWMON_PWM_ENABLE,
 			   HWMON_PWM_INPUT,
+			   HWMON_PWM_INPUT,
 			   HWMON_PWM_INPUT
 			   ),
 	NULL
-- 
2.39.5



