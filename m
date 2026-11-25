Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618139;
	b=ow+K+3F5Cq4YQehei/B1XFpTZPbA8cgYbxjADIconb7BdJq0hWFQaDvyJyxp9WA9xpCO
	 Cm+kngmt3GnWzV2fzU+fUD7aMSe1B3pkEFJd9r5U+zVrwGCh+fefi0Ya0qIzlrgdST94T
	 OBsxVq4vv5gBugCjh0/8Xti8EFxzTqg2eK3mzrxqvcl9QUYAgzQGj38n1R5rYUJqUfKlz
	 A0hzSJc144ZSkldAVGnn9il8jApfF9R/NI75P71GJHW+00GOsPq2qMw68dt5JxQV0citW
	 /1mBsSbvz2LWLm8FpqmkBFN5uRpyUTbHX8EfjIp84IMMHY1BS81pCWIvqwklHzPGHdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kdLgMINmQAyMdVbvm14NY6g6g+eLFb5UL+Ivq/MyABA=;
	b=hlWIxrTCft14tkBmEgfPbE9bZmSqxGETA2zcVKzBq0m/GzHFJUiC31JXluTj8bp+Niib
	 W+cMfqswE4jrkRGN7JmI5633XGZwrAECtBhSg91eWRUmMAx5edW1uX5hVI3UB9nwlU7gn
	 8/gTfLb72haKyyhuUHFxM5PkhFOi/dKaLVuh75c/hBLV/nSxPNtFbF/Wz/wN2CGBeupln
	 sZlRXKT8pVwHtpKfri693kFSbQ588ydWVfum9PHxHgbiTx5vsJaeHNumTGms5gWC02kJx
	 WPLUXK9uPIbRF7hobIaZbaDGOAgVP2SyjS1giGKHNiDDYO6yh2x2pQ0GLUlk87zluLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rehQv1Tc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2045B606A31E;
	Wed, 25 Nov 2026 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rehQv1Tc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DA11F000C6;
	Wed, 25 Nov 2026 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618139;
	bh=kdLgMINmQAyMdVbvm14NY6g6g+eLFb5UL+Ivq/MyABA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rehQv1Tc+pEIQCQC7wTgCKoWgkYg15BBKbubIWjsq03eewFbs013/3elhGv+jWye2
	 YfNIUdHPk56RsXx0YlZbgOgFDzA33b/WYf20GUwvC2VOFa45LqMSj1JRl1SX6D0qQP
	 TmDmyP+fGbzSh+BRnYO71FyMVEBgplfvKwxshLRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0185/1005] regulator: mt6363: Use 8-bit register values
Date: Wed, 25 Nov 2026 15:25:23 +0100
Message-ID: <20261125143826.076043712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Alexandre Mergnat <amergnat@baylibre.com>

[ Upstream commit 7318d3833067e4edb7c2a9bc244e8818b1597ff2 ]

The registers are 8 bits wide, but the regulator regmap uses 16-bit
values, so every access also covers the next register. On little-endian
CPUs, each regmap_write() also writes zero to the next register:
disabling VS2 or a VBUCK rail through its clear register 0x212 also
clears the enable bits of VS1, VS3 and three VSRAM rails in 0x213.

Change the regmap values to 8 bits. Store the BUCK and TMA keys as
__le16 so that the low byte goes to the first key register on any CPU,
as it did on little-endian CPUs.

Fixes: 3c36965df808 ("regulator: Add support for MediaTek MT6363 SPMI PMIC Regulators")
Signed-off-by: Alexandre Mergnat <amergnat@baylibre.com>
Link: https://patch.msgid.link/20261102-rgp-67-mt6363-regulator-fixes-v1-1-420789a3113e@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/mt6363-regulator.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/mt6363-regulator.c b/drivers/regulator/mt6363-regulator.c
index e56a2f0dd7778..52220117ce249 100644
--- a/drivers/regulator/mt6363-regulator.c
+++ b/drivers/regulator/mt6363-regulator.c
@@ -384,7 +384,7 @@ static unsigned int mt6363_regulator_get_mode(struct regulator_dev *rdev)
 
 static int mt6363_buck_unlock(struct regmap *map, bool unlock)
 {
-	u16 buf = unlock ? MT6363_BUCK_TOP_UNLOCK_VALUE : 0;
+	__le16 buf = cpu_to_le16(unlock ? MT6363_BUCK_TOP_UNLOCK_VALUE : 0);
 
 	return regmap_bulk_write(map, MT6363_BUCK_TOP_KEY_PROT_LO, &buf, sizeof(buf));
 }
@@ -485,7 +485,8 @@ static int mt6363_regulator_set_load(struct regulator_dev *rdev, int load_uA)
 
 static int mt6363_vemc_set_voltage_sel(struct regulator_dev *rdev, unsigned int sel)
 {
-	const u16 tma_unlock_key = MT6363_TMA_UNLOCK_VALUE;
+	const __le16 tma_unlock_key = cpu_to_le16(MT6363_TMA_UNLOCK_VALUE);
+	const __le16 tma_lock_key = cpu_to_le16(0);
 	const struct regulator_desc *rdesc = rdev->desc;
 	struct regmap *regmap = rdev->regmap;
 	unsigned int range, val;
@@ -542,8 +543,8 @@ static int mt6363_vemc_set_voltage_sel(struct regulator_dev *rdev, unsigned int
 
 lock_tma:
 	/* Unconditionally re-lock TMA */
-	val = 0;
-	regmap_bulk_write(rdev->regmap, MT6363_TOP_TMA_KEY_L, &val, 2);
+	regmap_bulk_write(rdev->regmap, MT6363_TOP_TMA_KEY_L,
+			  &tma_lock_key, sizeof(tma_lock_key));
 
 	return ret;
 }
@@ -814,7 +815,7 @@ static struct regmap *mt6363_spmi_register_regmap(struct device *dev)
 {
 	struct regmap_config mt6363_regmap_config = {
 		.reg_bits = 16,
-		.val_bits = 16,
+		.val_bits = 8,
 		.max_register = 0x1f90,
 		.fast_io = true,
 	};
-- 
2.53.0



