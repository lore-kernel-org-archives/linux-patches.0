Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016907;
	b=SP5iP7z56/DPXRcxslLn4Kjm63dIuXxP4kkJcBgyR1zju3cZIqZCfZrP2U48S4zeZeys
	 +1ju40hfpyXuPy23Bs9PtgiQcCl5SbQF8ij44XwOQg5Bo6gdqEf0Z4tVPRfVfdx7YkcdY
	 yGiKPRGfnpTUEdwtOlw0oR8dNsYfO9jIFJnFRTNeHU74SZFHG/gkdGZQ495ZFmykppK6O
	 UhsXmF7tOW1UhMl8cQajBc/4vJ5zTo5qDKmuBW9VyPyoeHf1vUcF8Htpm6gshYZYAZ+KM
	 z99hHDHfdRmFeDEQuqoA1AtWwU8VLrmbUXXYUVFKWvBME/A9EZuSzQiQsoWisbpp4rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016907;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MxmZQAtLGahriwA0xT0TtUJFr50y2O6AYZZUr+4IGog=;
	b=K/yDcJ9XkfNCZG2lUqF5RS5u81LGYZ69mV0N/LL2XnhsLiUSS3/FH1bq+BKXvhbc9k4x
	 P7Df9HshdqK0T0T/LsKMAkKXyZr1Rv9DtzTMwx1P6vSjLgWRM/YWgQnsAuzoPlMcZsFGB
	 ZvGZFQyJ5/vYIPaVP9wsI9gGvEayHCj8Nikb9NbxZh2WKXQu6pcusDiA2pyQMEZI7ezlN
	 p03G9sAJrnEt96vjtPIFD2T52F4zVLN5oCRtqydws5QWMas9iVfa2w0B6Mr1wLdVQqQ2C
	 Gk4hv9YdRpc85mrVRJmF6jahZyXfdiQ8gJs1eWRpZYbNe/GuzDibx1bS/amEzOg2iEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8LWYa3m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD6B606A320;
	Wed, 18 Nov 2026 15:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8LWYa3m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7145D1F000C4;
	Wed, 18 Nov 2026 15:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016907;
	bh=MxmZQAtLGahriwA0xT0TtUJFr50y2O6AYZZUr+4IGog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8LWYa3mHurUg/my7JHYCmcW0nBdth1xQmAmFGGcOT0kNluWICw4QV5cQvavaTWxo
	 sW5e2vlFrbgD7vddpifcmZk87V9HQ0KC4TrhxHfUDtrvSz/u3KbbL86X+jIInFTUft
	 +tbDE5ZJPYdt2U/IsO9nC1XkOqsWxxLiIb1Wkj78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0654/2651] leds: st1202: Spell out the phase-shift configuration bit
Date: Wed, 18 Nov 2026 15:31:34 +0100
Message-ID: <20261118150311.233218302@linuxfoundation.org>
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

[ Upstream commit 7520fc78c52ea55c2c83d0ecc11ab2355a753b7f ]

ST1202_CONFIG_REG_SHFT is abbreviated to the point of being unreadable
and, unlike the neighbouring PATS and PATSR bits, carries no comment
explaining what it controls.

Rename it to ST1202_CONFIG_REG_PHASE_SHIFT and document it in the same
style as the other configuration bits, retaining the datasheet name in
the comment so it remains searchable.

The longer name no longer fits the existing layout in
st1202_led_pattern_set(), where the continuation line was already 106
columns wide. Re-wrap that register write to match the layout
st1202_blink_set() uses for the same operation and drop the redundant
parentheses around the bit mask.

No functional change.

Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB849716E21E082D3B93B5B683C5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 878eec1475e7 ("leds: st1202: Program the channel current for hardware patterns")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 2f202e74ffa38..ac94afb2ce87f 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -24,7 +24,8 @@
 #define ST1202_CONFIG_REG_PATS             BIT(7)
 /* PATSR: Pattern sequence runs (self-clear when sequence is finished) */
 #define ST1202_CONFIG_REG_PATSR            BIT(6)
-#define ST1202_CONFIG_REG_SHFT             BIT(3)
+/* SHFT: Phase-shift delay enable */
+#define ST1202_CONFIG_REG_PHASE_SHIFT      BIT(3)
 #define ST1202_DEV_ENABLE                  0x01
 #define ST1202_DEV_ENABLE_ON               BIT(0)
 #define ST1202_DEV_ENABLE_RESET            BIT(7)
@@ -220,7 +221,7 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 
 	guard(mutex)(&chip->lock);
 
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret != 0)
 		return ret;
 
@@ -260,7 +261,7 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 
 	guard(mutex)(&chip->lock);
 
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret != 0)
 		return ret;
 
@@ -290,8 +291,9 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 	if (ret != 0)
 		return ret;
 
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, (ST1202_CONFIG_REG_PATSR |
-							ST1202_CONFIG_REG_PATS | ST1202_CONFIG_REG_SHFT));
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG,
+				ST1202_CONFIG_REG_PATSR | ST1202_CONFIG_REG_PATS |
+				ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret != 0)
 		return ret;
 
@@ -321,7 +323,7 @@ static int st1202_blink_set(struct led_classdev *led_cdev,
 
 	guard(mutex)(&chip->lock);
 
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret)
 		return ret;
 
@@ -375,7 +377,7 @@ static int st1202_blink_set(struct led_classdev *led_cdev,
 
 	ret = st1202_write_reg(chip, ST1202_CONFIG_REG,
 				ST1202_CONFIG_REG_PATSR | ST1202_CONFIG_REG_PATS |
-				ST1202_CONFIG_REG_SHFT);
+				ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret)
 		return ret;
 
@@ -441,7 +443,7 @@ static int st1202_setup(struct st1202_chip *chip)
 		return ret;
 
 	/* Enable phase-shift delay feature */
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret < 0)
 		return ret;
 
-- 
2.53.0



