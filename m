Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211433;
	b=KoALXuvhMueYR1A01THdQagZwl0wULvxIJTELpkRAavU7d+0r9x6tCN9pBxt6A5r/O6+
	 ZL6qssPPJSLWmBVRqHpFRoM/5CkVOzUGkJ2x7oLaySLAWs7nL5366BJ9mNptgegxurwAU
	 EYBVHZaPWrLwdkjeD60K0PVhJGTt+eZA4M4aV5+Onr78wIe5DujZqSyMWB8KOz6HBYqzu
	 wiJV/4RzK8w1bvJaralMXpgqCihovPCjWzc23wN/WXu6vHCkuzETCkwEIaMr0jGikO0PM
	 bjejyVaHco2f9awNUOHCqApUAcmpCOD7DcemttyBlssTmRE1G7A3cElq/9Soewl0W+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wib2m3Lpesib/L/gG4et9Don/FDNldjzfRy8f1W4+20=;
	b=5a+S2AzwroIngUXDlAQLtmzRZ1belcESRhIkBBGezIZ3N7BJUoy5Jk1mqpFZpeEkQGdh
	 UGEeLFWWPUxmnAXhat7LQXl3h2VTBf75xVmCYDFdk8ptQtM1AewFu5U9qTHB5WdV1E/sB
	 kTG+hL6KW7wPDnLzILJxUN97rd1+R/S/OHI4NdbTPCY3EwIumuNotO/510MZcHNF1b6Qv
	 5C2X/taAXYlk1rM9G8o7e2sJ4VSyBADHHRxd+VdCcxWzU1BGWGvDZH1Zy5zSqMpfien+7
	 JmXzj0H1DVbW1hCOzkEWELi6OZlsQ05/aEnr4Gc5cPFZBB6W7Y+K7cy9ipwvUFXASPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u+ffmqj/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56869606A327;
	Wed, 28 Oct 2026 18:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u+ffmqj/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E801F01825;
	Wed, 28 Oct 2026 18:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211433;
	bh=wib2m3Lpesib/L/gG4et9Don/FDNldjzfRy8f1W4+20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+ffmqj/5/fILajVLKYMPxkUA0CK/FF3jn1f9xRWJ5CALV5us9XoOFGnL2iqXYg4K
	 5cFHZ5mkSy9aRsGJ9lVm2xtQzrKjWsAJAHE6X+N11+tcViu+KZcWWCq73m8p/OrGnp
	 VJtGabbO5ohwQ6Yu0HnNpmogygfFZCKwNrRZTxpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 377/571] regulator: ltc3676: dont read the write-only HRST and CLIRQ registers
Date: Wed, 28 Oct 2026 17:58:44 +0100
Message-ID: <20261028170016.957877962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>

commit 28c2388ee24cdbefbcc458fa41ef7bffaaa1cc83 upstream.

HRST (0x1e) and CLIRQ (0x1f) are write-only command strobes. Writing HRST
triggers a hard reset of the chip and writing CLIRQ clears the interrupt;
reading them returns nothing useful, and the read itself fires the command.

The result is that a plain register dump resets the board:

  cat /sys/kernel/debug/regmap/2-003c/registers

walks every readable register, hits HRST, and the board reboots.

Split the callback back in two so HRST and CLIRQ stay writable but are no
longer readable. The readable range is left unchanged
(LTC3676_BUCK1 ... LTC3676_IRQSTAT).

Fixes: 37b918a034fe ("regulator: Add LTC3676 support")
Cc: stable@vger.kernel.org
Signed-off-by: Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>
Link: https://patch.msgid.link/20260902010701.3360310-1-Abhishek.ojha@savoirfairelinux.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/ltc3676.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/regulator/ltc3676.c
+++ b/drivers/regulator/ltc3676.c
@@ -232,7 +232,7 @@ static const struct regulator_desc ltc36
 	LTC3676_FIXED_REG(LDO4, ldo4, LDOB, 2),
 };
 
-static bool ltc3676_readable_writeable_reg(struct device *dev, unsigned int reg)
+static bool ltc3676_writeable_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case LTC3676_BUCK1 ... LTC3676_IRQSTAT:
@@ -243,6 +243,15 @@ static bool ltc3676_readable_writeable_r
 	return false;
 }
 
+static bool ltc3676_readable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case LTC3676_BUCK1 ... LTC3676_IRQSTAT:
+		return true;
+	}
+	return false;
+}
+
 static bool ltc3676_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
@@ -255,8 +264,8 @@ static bool ltc3676_volatile_reg(struct
 static const struct regmap_config ltc3676_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
-	.writeable_reg = ltc3676_readable_writeable_reg,
-	.readable_reg = ltc3676_readable_writeable_reg,
+	.writeable_reg = ltc3676_writeable_reg,
+	.readable_reg = ltc3676_readable_reg,
 	.volatile_reg = ltc3676_volatile_reg,
 	.max_register = LTC3676_CLIRQ,
 	.use_single_read = true,


