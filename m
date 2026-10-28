Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213334;
	b=OQ2FLFPUJRBjaSmu8xC5n+lHTYKsCxLzX06aJrMvz51u7Lsl3YzPGQeKDapr5u8ACJYB
	 6gQiKHViltRl5dUYj0unQgrEaHNxxEGwWsL61KVoKaalJFyx7jaqqoTReiqvl2kw0hQcB
	 qInAK2+gXkYls9FIfcq3XEw0Vf2bNtEOnMYrgSWbB6x2aZcYaN57t9/OysIwTvdmulfRo
	 IJmg+sYZpTkgK40etvrmRXfLj7T8JHFkoOzdwzE03IQBCtuNkr2DbXHBaZQ4htdUr0dIe
	 AgPhD+NXW3jdGy1ML7gp+kd4IvzShOcq6zlSP3Kor9dD5KPJ5QeSXCazDOvfC9K86DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NRkWUqUCrXXKrC/kG/dJPwNvPuzY4VHCZxgJJM5hk3s=;
	b=EuDAvydXwY2lhidJw7DYvEIdlkuImeKAC8X/i7YEE0+bBUKUtjB93oVlxRF740rLeLAv
	 0noukEV/MDC0kd/+DSvQRdDhkvlOMQmPbsUFADOjJL4PDkJMaxLDON1M/gK7xO2/qMGNv
	 hDGw1gTD0gM8aT4Eb6KyKx7/V1O8CKgmF6iSSN3o14cYQpp4DXCGezsOzVgCF4AJWJRbt
	 HKhX8qmMEb/1ZPLAoscW3LOqE1WhTRntyyYjVYir7/YuNyQ3t0dNn7/dKwUw82wE3xtCX
	 vbLObC/aRdGD68R7Kfb/8ZkSeViV0ErKdxtVbX/YC1f71sSLvdsWJThgKCYf7foZcnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfTfzb+z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EC1606A31A;
	Wed, 28 Oct 2026 18:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vfTfzb+z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947F81F01825;
	Wed, 28 Oct 2026 18:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213334;
	bh=NRkWUqUCrXXKrC/kG/dJPwNvPuzY4VHCZxgJJM5hk3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vfTfzb+zYKbQnmq3popN1Gjy3NAMXcxKu9U3nHuZnwa23uSqc3NRuRWb5slFckT/y
	 j/j//J9nhSd1I14BPudVlOsdqd1ANu8BPloQiYf9L9KXC9yv/EvWi92seJvShdR+Nh
	 LMPoQc/8JSqRQL8JmiK1oUDwmmG/1A4BY1Fsm2aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhishek Ojha <Abhishek.ojha@savoirfairelinux.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0468/1887] regulator: ltc3676: dont read the write-only HRST and CLIRQ registers
Date: Wed, 28 Oct 2026 17:42:44 +0100
Message-ID: <20261028170509.883745400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


