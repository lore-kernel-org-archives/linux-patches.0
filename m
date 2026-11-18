Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024071;
	b=0gEb0t0mMvQADsI/1kNW3PIkiFKi8UN2KTiWX4S3FBHhK2SXYXTumElmTM/juzkKZh9a
	 heT6fKz6DJjufXLndgt2fBgvGxXpIrzJxt2rv+QE6Ax5LNYqjrLidCj3ok22VX0Pqz5YU
	 Wck0tKimpyhETy5RcZ3+Hnvl64fqGHCxDtxLhHshrcJ9WhslZ3EYf5kLrh7F2PzphdRIJ
	 bOjCkL0cBD8pChlVcGSZvS6bnCO2AntOXIHPLrbAamBewTgnxNWZAJnZcuJTrYORbaR/x
	 mgfTXFrDXln3/1K5POgvUOXMKgNmr3/Y0HEgNmerzDW3XBcOclCr8y6Jcjaz2JXs0nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VpKbDn+meFcKgL1aDPjaA9K/4LCkETszkPshQ2WRU8U=;
	b=FgYBFj7jdQTc9lV9XzjL3sq4R50wflLPlqkiTvfcU9C2nXHNcGjPhqRtDtp/r0NP0yiM
	 hO24He7m+Px7sFxnPZAWTL1jcUezPkVbCXAsN5Jug3/XOHyW/W8HD6C4OuvwgeiopzLlw
	 iyMBZ56bgXfiYAtwXI8NGSOTZQjip6hQwMez8zz06o5ILVIqafbYTNw46x1QY++o6mZl2
	 yOo4HkOEoOqTTGKFvjXPIiJQ+fjCG4xK7HSz4kXHNQK4nOlnB1YofRvE2/FknTZVcSqlp
	 nOqXS5osUeZe8L8jrZkukh/YuXPPAD9EzcIXaSqOV/mAoa28lbr/wFN44iqhwGitTTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NilElzKF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84482606A31C;
	Wed, 18 Nov 2026 17:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NilElzKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AAF1F000C4;
	Wed, 18 Nov 2026 17:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024071;
	bh=VpKbDn+meFcKgL1aDPjaA9K/4LCkETszkPshQ2WRU8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NilElzKFcypZInuhzEOIUDKDjZIt5647O6CBnbJ5f+Fzg+vQDXWyaSYLg2yhZxHQI
	 Ydj+1Y81+8IIa2zhhc8PXe64RjHUQCbf9+ddk8VDR7Thu3f90VXpOGClEi0gIraBIN
	 pBidUrJVCUIu85AchlPIjAinO1ntvhY5bdHLj4Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0594/2151] leds: st1202: Spell out the phase-shift configuration bit
Date: Wed, 18 Nov 2026 15:38:49 +0100
Message-ID: <20261118150143.593166261@linuxfoundation.org>
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
index f1abb37520188..135fe0b0f3a5e 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -25,7 +25,8 @@
 #define ST1202_CONFIG_REG_PATS             BIT(7)
 /* PATSR: Pattern sequence runs (self-clear when sequence is finished) */
 #define ST1202_CONFIG_REG_PATSR            BIT(6)
-#define ST1202_CONFIG_REG_SHFT             BIT(3)
+/* SHFT: Phase-shift delay enable */
+#define ST1202_CONFIG_REG_PHASE_SHIFT      BIT(3)
 #define ST1202_DEV_ENABLE                  0x01
 #define ST1202_DEV_ENABLE_ON               BIT(0)
 #define ST1202_DEV_ENABLE_RESET            BIT(7)
@@ -221,7 +222,7 @@ static int st1202_led_pattern_clear(struct led_classdev *ldev)
 
 	guard(mutex)(&chip->lock);
 
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret != 0)
 		return ret;
 
@@ -261,7 +262,7 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 
 	guard(mutex)(&chip->lock);
 
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret != 0)
 		return ret;
 
@@ -291,8 +292,9 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 	if (ret != 0)
 		return ret;
 
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, (ST1202_CONFIG_REG_PATSR |
-							ST1202_CONFIG_REG_PATS | ST1202_CONFIG_REG_SHFT));
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG,
+				ST1202_CONFIG_REG_PATSR | ST1202_CONFIG_REG_PATS |
+				ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret != 0)
 		return ret;
 
@@ -322,7 +324,7 @@ static int st1202_blink_set(struct led_classdev *led_cdev,
 
 	guard(mutex)(&chip->lock);
 
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret)
 		return ret;
 
@@ -376,7 +378,7 @@ static int st1202_blink_set(struct led_classdev *led_cdev,
 
 	ret = st1202_write_reg(chip, ST1202_CONFIG_REG,
 				ST1202_CONFIG_REG_PATSR | ST1202_CONFIG_REG_PATS |
-				ST1202_CONFIG_REG_SHFT);
+				ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret)
 		return ret;
 
@@ -442,7 +444,7 @@ static int st1202_setup(struct st1202_chip *chip)
 		return ret;
 
 	/* Enable phase-shift delay feature */
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_SHFT);
+	ret = st1202_write_reg(chip, ST1202_CONFIG_REG, ST1202_CONFIG_REG_PHASE_SHIFT);
 	if (ret < 0)
 		return ret;
 
-- 
2.53.0



