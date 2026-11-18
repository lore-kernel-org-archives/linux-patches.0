Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024063;
	b=ivRaG69jHfFH+t100zlWg543/ZqqGmjTSK/bY0gdoAm4Om9/JePDZ5LvFFivt48iE6Ed
	 5K0i7+2+LCTLihhjNb48zPRUoWrQSEs8hgGtqm5NLCWy6rdRM1OduShs5hvkwybYNBdBH
	 R6IzdZZLcXLi6yH3rURTw47RMEvOcZtzTdePL6pjnPVWaGU0GrVD/jlYeWAuPR67X7QRu
	 yPCz6lT6QBqBC/MDpHBa03MpyXBRSwn3lbvSqo/ZPq//8w+GAy7yd6853ThZApaIGB0V/
	 9b/tTiW5/9E2zLBJHvQDgykN+V8Kt3XSj+7SA8Yuvdx4Zq7mFlb5Q8e6xo/blTiQVRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xUX6BrLP2aZ4no6Es/LShX5kr+V25d7s9DDWsWUCjGo=;
	b=TG9ChoIkv/t2RcaEL25q8H7rBKSr1UxR/PiY+z9G9aKU5EGd6cIg618qthTLAK8kFqMw
	 9WKnOcw/Yhq3n+QsmZ3YP1mk7eIbdt6Ufl1Uh8ceX3n3C/sVcFcaKYavQZDfj4+o0W9R6
	 IdLJsbsfByvqiV/Va34deOl9YFHKrxopTUO0BxXNgcau+MU3VkAMvqjCipRqOe69nNmP9
	 P1Uh2IaN4cr/yiyUNlrfgVBifrVmm5buXX0D0FwlLb9G2tGMAfk2AHIKUBTaV33jvZhOm
	 vkIqSVnHiCEFOlHw8ZcZh73gvuhItXTqPpkIk/qIvAs/vlWZtQrK5o2FCGfXJ1CxEWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uzD+5bBI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E95606A31C;
	Wed, 18 Nov 2026 17:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uzD+5bBI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754011F000C4;
	Wed, 18 Nov 2026 17:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024063;
	bh=xUX6BrLP2aZ4no6Es/LShX5kr+V25d7s9DDWsWUCjGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uzD+5bBIjzLmgY2aIyblnugO2OL1qgO4qXR7KQEWNMw8cgTtw2HhCiyLh/yGAoRpP
	 bGmGwS43M2tlXB6MNaeN2sFVP4vEJEGAhBArp8K3cBTgXa+QpDiRpWFFD9gIhaBaep
	 cAJrfdJt+TUbtxe6yEHWGM9lSyjrunHtv934DiLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0591/2151] leds: st1202: Name pattern index variables consistently
Date: Wed, 18 Nov 2026 15:38:46 +0100
Message-ID: <20261118150143.486134032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a9e616b7be66e..b567f97a313c0 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -176,8 +176,8 @@ static void st1202_brightness_set(struct led_classdev *led_cdev,
 
 	guard(mutex)(&chip->lock);
 
-	for (int patt = 0; patt < ST1202_MAX_PATTERNS; patt++)
-		st1202_pwm_pattern_write(chip, led->led_num, patt, ST1202_PATTERN_PWM_FULL);
+	for (int pattern = 0; pattern < ST1202_MAX_PATTERNS; pattern++)
+		st1202_pwm_pattern_write(chip, led->led_num, pattern, ST1202_PATTERN_PWM_FULL);
 	st1202_write_reg(chip, ST1202_ILED_REG0 + led->led_num, value);
 	__st1202_channel_set(chip, led->led_num, !!value);
 }
@@ -214,12 +214,13 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
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
@@ -228,7 +229,7 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 }
 
 static int st1202_led_pattern_set(struct led_classdev *ldev,
-				struct led_pattern *pattern,
+				struct led_pattern *patterns,
 				u32 len, int repeat)
 {
 	struct st1202_led *led = cdev_to_st1202_led(ldev);
@@ -238,9 +239,9 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
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
 
@@ -250,12 +251,13 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
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



