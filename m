Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3C5194A45;
	Tue, 27 May 2025 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366905; cv=none; b=JSr+BUvX7Q3vOJTjGGlmT+M0PHtVuXa3IlgmdDeplMn1MLGJCPsC/reNtJhONStYaXJXpPZLutbkhmGtsYUft8SDUc2zsUIRdrGt/9KXUm+64PhWrVPRO6rkNjvJtHkUTmhbFNwpsKvwQ31uBUv7mSQmjpOWmhX2x66jRReRvGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366905; c=relaxed/simple;
	bh=PDvX7ZCJpS80Krai38yB9E1PCZW2z3DqApsZj07otGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iX3S72frudzHAAnH1JsvAi5GJuPsvBpenealOnon82JRYKjF6XNhfDMlEso7SbNkytP6MADdIGoaDcIiJhzpxZ5trfMsoWfim7q7iGl87uepr4HQ7hnpDkuYDBhw320/ZqF0Orh3CKFLFXesBcGOJ4Y514Cc7wrgzc87o820FGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RGQDEKC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RGQDEKC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690BDC4CEE9;
	Tue, 27 May 2025 17:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366904;
	bh=PDvX7ZCJpS80Krai38yB9E1PCZW2z3DqApsZj07otGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RGQDEKC0RPX5i+ytvfQSOiLMsKhDIdeFiq9aMCFgGnoGfy9SYVUigEq233/TurTEi
	 seuXw3CIgq67/iksu0vcTFkg0YWLBrSjaskHi63PCjTmmq41XIwEWdDV0UmDg79aNq
	 R+c4DTjh036AKS6YCzycMx+ToCxUGaX3cVNSTE2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 213/783] hwmon: (dell-smm) Increment the number of fans
Date: Tue, 27 May 2025 18:20:10 +0200
Message-ID: <20250527162521.806166021@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 74905675d71f9..5a4edb6565cf9 100644
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
index cd00adaad1b41..79e5606e6d2f8 100644
--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -73,7 +73,7 @@
 #define DELL_SMM_LEGACY_EXECUTE	0x1
 
 #define DELL_SMM_NO_TEMP	10
-#define DELL_SMM_NO_FANS	3
+#define DELL_SMM_NO_FANS	4
 
 struct smm_regs {
 	unsigned int eax;
@@ -1074,11 +1074,14 @@ static const struct hwmon_channel_info * const dell_smm_info[] = {
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



