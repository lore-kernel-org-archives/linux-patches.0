Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016887;
	b=vpYjP/PKClg+Qg5icfSIl5ZMs/J8J1egUJ8zr1DlgFpHk4d1DA9ZMsuMKxFnu7ENfpCf
	 LXx3hiDNkeo7d2xbEu2Od/pVUqX+z4Akh10gL1s4wxxqFm9s3qI63jN0D1VUgZiTNh2Oo
	 dfJPHRaNVu373NCTRl6UxEXyhRr+veL8jD3lMWlPH8xph6JfarpPGdj0RZj+yHvX+r9AC
	 JADv8mW+1qXwXTQqyd4y8Z26QopcvHw/xpjw3jJEXIAyco1BSW0h9B2UHlVNLJ/RLhgXk
	 RVspxhl6COtDEjU+U8sO8tLfTX2/t7bZ57AXQAKxbdr9rz5lMyRFXJsvZd7b0JNnAzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V1szGEtw24n0dCdfIRvti9un+OcOz7ZnZXVfIsLGR0E=;
	b=a0hHfZOkycw+k3kipCSYrJHbMUciWTA9/llLn5wUo15/hwKEuYvA+lBDEXNtlDJnNDLs
	 D8Do2aPJow+jmEUc7ItDhvzh639d+5i3PVA2GklqolcOQCfbZ1qTqcvvnIhVoM85sfvpF
	 x3QoVD44F4ctJmIMKjdU2T+F4/XRzx6UViHjSQkD+mbsXlZUcxXd/WQE7nueoytX4dm68
	 igcA/Mu0HKUgzz9E/qf9YqnMYUFkZ/uF+0wDHzgwQ877BB2qMuj4dW0S22DkjtNVAhGTb
	 kqcNqq5rUMoh3O7Dfe6WnJkl/gxIo6ZlmsLUPCSH6jLr0Z9CBwTNDv607xTD0Iu0pqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NeOGrwoS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877FB606A32A;
	Wed, 18 Nov 2026 15:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NeOGrwoS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8622F1F000C4;
	Wed, 18 Nov 2026 15:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016887;
	bh=V1szGEtw24n0dCdfIRvti9un+OcOz7ZnZXVfIsLGR0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NeOGrwoSZAG/2EpcKmUwmUM9cFwVSQssM3RnCvfPsE/QCX6DIWTOc8D6f0r8All42
	 OOyCVma+kVOhX2SmLn5+FkUhoY+TKAowuhclmCsKLsZur3xW2MzrSlyZyQSiDGxzau
	 yi5/QsQd5PS63UUx0hjtHrelELEa97M4lDxRR8Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0651/2651] leds: st1202: Name pattern index variables consistently
Date: Wed, 18 Nov 2026 15:31:31 +0100
Message-ID: <20261118150311.123579213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit 0aed225f40613253617ad30a57492043a3448938 ]

The driver already names pattern indices "pattern" in the signatures of
st1202_pwm_pattern_write() and st1202_duration_pattern_write(), and
st1202_blink_set() follows the same convention. The remaining loops
abbreviate it to "patt", which matches nothing else in the file.

Rename those loop variables to "pattern". In st1202_led_pattern_set()
that name is taken by the array of pattern steps, so rename the
parameter to "patterns", which also reflects better that it is an array.

Two st1202_pwm_pattern_write() calls exceed 100 columns with the longer
name and are wrapped accordingly.

No functional change.

Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB8497AD614B8686BBDA654674C5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 82f8b88d6ac2 ("leds: st1202: Scale pattern brightness to the 12-bit PWM range")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index b34c41d58e44e..4ef1cdc86de34 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -175,8 +175,8 @@ static void st1202_brightness_set(struct led_classdev *led_cdev,
 
 	guard(mutex)(&chip->lock);
 
-	for (int patt = 0; patt < ST1202_MAX_PATTERNS; patt++)
-		st1202_pwm_pattern_write(chip, led->led_num, patt, ST1202_PATTERN_PWM_FULL);
+	for (int pattern = 0; pattern < ST1202_MAX_PATTERNS; pattern++)
+		st1202_pwm_pattern_write(chip, led->led_num, pattern, ST1202_PATTERN_PWM_FULL);
 	st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, value);
 	__st1202_channel_set(chip, led->led_num, !!value);
 }
@@ -213,12 +213,13 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 	if (ret != 0)
 		return ret;
 
-	for (int patt = 0; patt < ST1202_MAX_PATTERNS; patt++) {
-		ret = st1202_pwm_pattern_write(chip, led->led_num, patt, ST1202_PATTERN_PWM_FULL);
+	for (int pattern = 0; pattern < ST1202_MAX_PATTERNS; pattern++) {
+		ret = st1202_pwm_pattern_write(chip, led->led_num, pattern,
+						ST1202_PATTERN_PWM_FULL);
 		if (ret != 0)
 			return ret;
 
-		ret = st1202_write_reg(chip, ST1202_PATTERN_DUR + patt, 0);
+		ret = st1202_write_reg(chip, ST1202_PATTERN_DUR + pattern, 0);
 		if (ret != 0)
 			return ret;
 	}
@@ -227,7 +228,7 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 }
 
 static int st1202_led_pattern_set(struct led_classdev *ldev,
-				struct led_pattern *pattern,
+				struct led_pattern *patterns,
 				u32 len, int repeat)
 {
 	struct st1202_led *led = cdev_to_st1202_led(ldev);
@@ -237,9 +238,9 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 	if (len > ST1202_MAX_PATTERNS)
 		return -EINVAL;
 
-	for (int patt = 0; patt < len; patt++) {
-		if (pattern[patt].delta_t < ST1202_MILLIS_PATTERN_DUR_MIN ||
-				pattern[patt].delta_t > ST1202_MILLIS_PATTERN_DUR_MAX)
+	for (int pattern = 0; pattern < len; pattern++) {
+		if (patterns[pattern].delta_t < ST1202_MILLIS_PATTERN_DUR_MIN ||
+				patterns[pattern].delta_t > ST1202_MILLIS_PATTERN_DUR_MAX)
 			return -EINVAL;
 	}
 
@@ -249,12 +250,13 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 	if (ret != 0)
 		return ret;
 
-	for (int patt = 0; patt < len; patt++) {
-		ret = st1202_pwm_pattern_write(chip, led->led_num, patt, pattern[patt].brightness);
+	for (int pattern = 0; pattern < len; pattern++) {
+		ret = st1202_pwm_pattern_write(chip, led->led_num, pattern,
+						patterns[pattern].brightness);
 		if (ret != 0)
 			return ret;
 
-		ret = st1202_duration_pattern_write(chip, patt, pattern[patt].delta_t);
+		ret = st1202_duration_pattern_write(chip, pattern, patterns[pattern].delta_t);
 		if (ret != 0)
 			return ret;
 	}
-- 
2.53.0



