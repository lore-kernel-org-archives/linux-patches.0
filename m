Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B572DBF75;
	Sat, 12 Sep 2026 12:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214648; cv=none; b=ZVdY5yOktpB8qR57aP9ujaGWh/ppEu3wRCv1d48pnt0mT/5eioGy+z3Nh743ldhXznXHlk3Zwrfdvy/Wg425PzErRFWPF6coccSjcXxYvj5undmoCfYNNqpyV6pIuVclZ9TIUNfp/+16EG33Zs3HHJ+olHKQed9KfVz1Ulmzzas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214648; c=relaxed/simple;
	bh=mq8whePJ4QjCDuiS6aDJniUJR4bB8T1Aln2iXNM95vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC+Cvrm2NEzg3WSc/R5DOwiG5C9ufXWxGUUQKWbDnVhyldaqriWTSzNSiAdvHUCm/wbWEvQzzsq7HBZj0ooBwnR1VhmP2dPWP3nfxGqUTh7khdrJp1qFKPH5eqxsfMoXMz1l7gs2SmIHVD77nolZZJ8Np1/H6gnPWKmVyTMNgU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1W43Pxrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1W43Pxrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BC71F000FF;
	Sat, 12 Sep 2026 12:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214646;
	bh=X6U9q7L6HfrHI/42IU3WWKg4IzjpyjQ+QJK4azrr47M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1W43PxrtJNixDei+3varhtrvDJEayowThPdWy3zQgpMJo38e3IT5zy0+2Ptyu6a5k
	 PdisBvlMzz0w4I1ieJ11a+Dzmic+I3SCjHbXwhxTRsjJsnN+81sLyz/BdqTTZx0MB+
	 6XFYa/yZasbVYx8bOKFm8Wg8GwOIVCZQdoife5Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0368/1376] regulator: tps6594-regulator: Constify struct tps6594_regulator_irq_type
Date: Sat, 12 Sep 2026 08:46:34 +0200
Message-ID: <20260912065615.752120984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c266209eaef4fef863363557817f7d6a68314321 ]

'struct tps6594_regulator_irq_type' are not modified in this driver.

Constifying this structure moves some data to a read-only section, so
increases overall security.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  25645	  14480	     64	  40189	   9cfd	drivers/regulator/tps6594-regulator.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  27949	  12176	     64	  40189	   9cfd	drivers/regulator/tps6594-regulator.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/1446fb1938f3f38115be3e53f5dda3c8bb0ba5a1.1748103005.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 7fd28093b3ef ("regulator: tps6594: Fix device node reference leaks in multiphase loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/tps6594-regulator.c | 60 +++++++++++++--------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/tps6594-regulator.c b/drivers/regulator/tps6594-regulator.c
index ac53792e3fede..0193efb5dffa9 100644
--- a/drivers/regulator/tps6594-regulator.c
+++ b/drivers/regulator/tps6594-regulator.c
@@ -56,7 +56,7 @@ struct tps6594_regulator_irq_type {
 	unsigned long event;
 };
 
-static struct tps6594_regulator_irq_type tps6594_ext_regulator_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps6594_ext_regulator_irq_types[] = {
 	{ TPS6594_IRQ_NAME_VCCA_OV, "VCCA", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 	{ TPS6594_IRQ_NAME_VCCA_UV, "VCCA", "undervoltage", REGULATOR_EVENT_UNDER_VOLTAGE },
 	{ TPS6594_IRQ_NAME_VMON1_OV, "VMON1", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
@@ -69,7 +69,7 @@ static struct tps6594_regulator_irq_type tps6594_ext_regulator_irq_types[] = {
 	  REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 };
 
-static struct tps6594_regulator_irq_type tps65224_ext_regulator_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps65224_ext_regulator_irq_types[] = {
 	{ TPS65224_IRQ_NAME_VCCA_UVOV, "VCCA", "voltage out of range",
 	  REGULATOR_EVENT_REGULATION_OUT },
 	{ TPS65224_IRQ_NAME_VMON1_UVOV, "VMON1", "voltage out of range",
@@ -80,13 +80,13 @@ static struct tps6594_regulator_irq_type tps65224_ext_regulator_irq_types[] = {
 
 struct tps6594_regulator_irq_data {
 	struct device *dev;
-	struct tps6594_regulator_irq_type *type;
+	const struct tps6594_regulator_irq_type *type;
 	struct regulator_dev *rdev;
 };
 
 struct tps6594_ext_regulator_irq_data {
 	struct device *dev;
-	struct tps6594_regulator_irq_type *type;
+	const struct tps6594_regulator_irq_type *type;
 };
 
 #define TPS6594_REGULATOR(_name, _of, _id, _type, _ops, _n, _vr, _vm, _er, \
@@ -262,7 +262,7 @@ static const struct regulator_desc tps65224_buck_regs[] = {
 			  4, 0, 0, NULL, 0, 0),
 };
 
-static struct tps6594_regulator_irq_type tps6594_buck1_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps6594_buck1_irq_types[] = {
 	{ TPS6594_IRQ_NAME_BUCK1_OV, "BUCK1", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 	{ TPS6594_IRQ_NAME_BUCK1_UV, "BUCK1", "undervoltage", REGULATOR_EVENT_UNDER_VOLTAGE },
 	{ TPS6594_IRQ_NAME_BUCK1_SC, "BUCK1", "short circuit", REGULATOR_EVENT_REGULATION_OUT },
@@ -270,7 +270,7 @@ static struct tps6594_regulator_irq_type tps6594_buck1_irq_types[] = {
 	  REGULATOR_EVENT_OVER_CURRENT },
 };
 
-static struct tps6594_regulator_irq_type tps6594_buck2_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps6594_buck2_irq_types[] = {
 	{ TPS6594_IRQ_NAME_BUCK2_OV, "BUCK2", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 	{ TPS6594_IRQ_NAME_BUCK2_UV, "BUCK2", "undervoltage", REGULATOR_EVENT_UNDER_VOLTAGE },
 	{ TPS6594_IRQ_NAME_BUCK2_SC, "BUCK2", "short circuit", REGULATOR_EVENT_REGULATION_OUT },
@@ -278,7 +278,7 @@ static struct tps6594_regulator_irq_type tps6594_buck2_irq_types[] = {
 	  REGULATOR_EVENT_OVER_CURRENT },
 };
 
-static struct tps6594_regulator_irq_type tps6594_buck3_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps6594_buck3_irq_types[] = {
 	{ TPS6594_IRQ_NAME_BUCK3_OV, "BUCK3", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 	{ TPS6594_IRQ_NAME_BUCK3_UV, "BUCK3", "undervoltage", REGULATOR_EVENT_UNDER_VOLTAGE },
 	{ TPS6594_IRQ_NAME_BUCK3_SC, "BUCK3", "short circuit", REGULATOR_EVENT_REGULATION_OUT },
@@ -286,7 +286,7 @@ static struct tps6594_regulator_irq_type tps6594_buck3_irq_types[] = {
 	  REGULATOR_EVENT_OVER_CURRENT },
 };
 
-static struct tps6594_regulator_irq_type tps6594_buck4_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps6594_buck4_irq_types[] = {
 	{ TPS6594_IRQ_NAME_BUCK4_OV, "BUCK4", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 	{ TPS6594_IRQ_NAME_BUCK4_UV, "BUCK4", "undervoltage", REGULATOR_EVENT_UNDER_VOLTAGE },
 	{ TPS6594_IRQ_NAME_BUCK4_SC, "BUCK4", "short circuit", REGULATOR_EVENT_REGULATION_OUT },
@@ -294,7 +294,7 @@ static struct tps6594_regulator_irq_type tps6594_buck4_irq_types[] = {
 	  REGULATOR_EVENT_OVER_CURRENT },
 };
 
-static struct tps6594_regulator_irq_type tps6594_buck5_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps6594_buck5_irq_types[] = {
 	{ TPS6594_IRQ_NAME_BUCK5_OV, "BUCK5", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 	{ TPS6594_IRQ_NAME_BUCK5_UV, "BUCK5", "undervoltage", REGULATOR_EVENT_UNDER_VOLTAGE },
 	{ TPS6594_IRQ_NAME_BUCK5_SC, "BUCK5", "short circuit", REGULATOR_EVENT_REGULATION_OUT },
@@ -302,7 +302,7 @@ static struct tps6594_regulator_irq_type tps6594_buck5_irq_types[] = {
 	  REGULATOR_EVENT_OVER_CURRENT },
 };
 
-static struct tps6594_regulator_irq_type tps6594_ldo1_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps6594_ldo1_irq_types[] = {
 	{ TPS6594_IRQ_NAME_LDO1_OV, "LDO1", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 	{ TPS6594_IRQ_NAME_LDO1_UV, "LDO1", "undervoltage", REGULATOR_EVENT_UNDER_VOLTAGE },
 	{ TPS6594_IRQ_NAME_LDO1_SC, "LDO1", "short circuit", REGULATOR_EVENT_REGULATION_OUT },
@@ -310,7 +310,7 @@ static struct tps6594_regulator_irq_type tps6594_ldo1_irq_types[] = {
 	  REGULATOR_EVENT_OVER_CURRENT },
 };
 
-static struct tps6594_regulator_irq_type tps6594_ldo2_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps6594_ldo2_irq_types[] = {
 	{ TPS6594_IRQ_NAME_LDO2_OV, "LDO2", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 	{ TPS6594_IRQ_NAME_LDO2_UV, "LDO2", "undervoltage", REGULATOR_EVENT_UNDER_VOLTAGE },
 	{ TPS6594_IRQ_NAME_LDO2_SC, "LDO2", "short circuit", REGULATOR_EVENT_REGULATION_OUT },
@@ -318,7 +318,7 @@ static struct tps6594_regulator_irq_type tps6594_ldo2_irq_types[] = {
 	  REGULATOR_EVENT_OVER_CURRENT },
 };
 
-static struct tps6594_regulator_irq_type tps6594_ldo3_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps6594_ldo3_irq_types[] = {
 	{ TPS6594_IRQ_NAME_LDO3_OV, "LDO3", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 	{ TPS6594_IRQ_NAME_LDO3_UV, "LDO3", "undervoltage", REGULATOR_EVENT_UNDER_VOLTAGE },
 	{ TPS6594_IRQ_NAME_LDO3_SC, "LDO3", "short circuit", REGULATOR_EVENT_REGULATION_OUT },
@@ -326,7 +326,7 @@ static struct tps6594_regulator_irq_type tps6594_ldo3_irq_types[] = {
 	  REGULATOR_EVENT_OVER_CURRENT },
 };
 
-static struct tps6594_regulator_irq_type tps6594_ldo4_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps6594_ldo4_irq_types[] = {
 	{ TPS6594_IRQ_NAME_LDO4_OV, "LDO4", "overvoltage", REGULATOR_EVENT_OVER_VOLTAGE_WARN },
 	{ TPS6594_IRQ_NAME_LDO4_UV, "LDO4", "undervoltage", REGULATOR_EVENT_UNDER_VOLTAGE },
 	{ TPS6594_IRQ_NAME_LDO4_SC, "LDO4", "short circuit", REGULATOR_EVENT_REGULATION_OUT },
@@ -334,42 +334,42 @@ static struct tps6594_regulator_irq_type tps6594_ldo4_irq_types[] = {
 	  REGULATOR_EVENT_OVER_CURRENT },
 };
 
-static struct tps6594_regulator_irq_type tps65224_buck1_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps65224_buck1_irq_types[] = {
 	{ TPS65224_IRQ_NAME_BUCK1_UVOV, "BUCK1", "voltage out of range",
 	  REGULATOR_EVENT_REGULATION_OUT },
 };
 
-static struct tps6594_regulator_irq_type tps65224_buck2_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps65224_buck2_irq_types[] = {
 	{ TPS65224_IRQ_NAME_BUCK2_UVOV, "BUCK2", "voltage out of range",
 	  REGULATOR_EVENT_REGULATION_OUT },
 };
 
-static struct tps6594_regulator_irq_type tps65224_buck3_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps65224_buck3_irq_types[] = {
 	{ TPS65224_IRQ_NAME_BUCK3_UVOV, "BUCK3", "voltage out of range",
 	  REGULATOR_EVENT_REGULATION_OUT },
 };
 
-static struct tps6594_regulator_irq_type tps65224_buck4_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps65224_buck4_irq_types[] = {
 	{ TPS65224_IRQ_NAME_BUCK4_UVOV, "BUCK4", "voltage out of range",
 	  REGULATOR_EVENT_REGULATION_OUT },
 };
 
-static struct tps6594_regulator_irq_type tps65224_ldo1_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps65224_ldo1_irq_types[] = {
 	{ TPS65224_IRQ_NAME_LDO1_UVOV, "LDO1", "voltage out of range",
 	  REGULATOR_EVENT_REGULATION_OUT },
 };
 
-static struct tps6594_regulator_irq_type tps65224_ldo2_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps65224_ldo2_irq_types[] = {
 	{ TPS65224_IRQ_NAME_LDO2_UVOV, "LDO2", "voltage out of range",
 	  REGULATOR_EVENT_REGULATION_OUT },
 };
 
-static struct tps6594_regulator_irq_type tps65224_ldo3_irq_types[] = {
+static const struct tps6594_regulator_irq_type tps65224_ldo3_irq_types[] = {
 	{ TPS65224_IRQ_NAME_LDO3_UVOV, "LDO3", "voltage out of range",
 	  REGULATOR_EVENT_REGULATION_OUT },
 };
 
-static struct tps6594_regulator_irq_type *tps6594_bucks_irq_types[] = {
+static const struct tps6594_regulator_irq_type *tps6594_bucks_irq_types[] = {
 	tps6594_buck1_irq_types,
 	tps6594_buck2_irq_types,
 	tps6594_buck3_irq_types,
@@ -377,21 +377,21 @@ static struct tps6594_regulator_irq_type *tps6594_bucks_irq_types[] = {
 	tps6594_buck5_irq_types,
 };
 
-static struct tps6594_regulator_irq_type *tps6594_ldos_irq_types[] = {
+static const struct tps6594_regulator_irq_type *tps6594_ldos_irq_types[] = {
 	tps6594_ldo1_irq_types,
 	tps6594_ldo2_irq_types,
 	tps6594_ldo3_irq_types,
 	tps6594_ldo4_irq_types,
 };
 
-static struct tps6594_regulator_irq_type *tps65224_bucks_irq_types[] = {
+static const struct tps6594_regulator_irq_type *tps65224_bucks_irq_types[] = {
 	tps65224_buck1_irq_types,
 	tps65224_buck2_irq_types,
 	tps65224_buck3_irq_types,
 	tps65224_buck4_irq_types,
 };
 
-static struct tps6594_regulator_irq_type *tps65224_ldos_irq_types[] = {
+static const struct tps6594_regulator_irq_type *tps65224_ldos_irq_types[] = {
 	tps65224_ldo1_irq_types,
 	tps65224_ldo2_irq_types,
 	tps65224_ldo3_irq_types,
@@ -516,11 +516,11 @@ static irqreturn_t tps6594_regulator_irq_handler(int irq, void *data)
 static int tps6594_request_reg_irqs(struct platform_device *pdev,
 				    struct regulator_dev *rdev,
 				    struct tps6594_regulator_irq_data *irq_data,
-				    struct tps6594_regulator_irq_type *regs_irq_types,
+				    const struct tps6594_regulator_irq_type *regs_irq_types,
 				    size_t interrupt_cnt,
 				    int *irq_idx)
 {
-	struct tps6594_regulator_irq_type *irq_type;
+	const struct tps6594_regulator_irq_type *irq_type;
 	struct tps6594 *tps = dev_get_drvdata(pdev->dev.parent);
 	size_t j;
 	int irq;
@@ -558,8 +558,8 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 	struct regulator_config config = {};
 	struct tps6594_regulator_irq_data *irq_data;
 	struct tps6594_ext_regulator_irq_data *irq_ext_reg_data;
-	struct tps6594_regulator_irq_type *irq_type;
-	struct tps6594_regulator_irq_type *irq_types;
+	const struct tps6594_regulator_irq_type *irq_type;
+	const struct tps6594_regulator_irq_type *irq_types;
 	bool buck_configured[BUCK_NB] = { false };
 	bool buck_multi[MULTI_PHASE_NB] = { false };
 
@@ -573,9 +573,9 @@ static int tps6594_regulator_probe(struct platform_device *pdev)
 	unsigned int irq_count;
 	unsigned int multi_phase_cnt;
 	size_t reg_irq_nb;
-	struct tps6594_regulator_irq_type **bucks_irq_types;
+	const struct tps6594_regulator_irq_type **bucks_irq_types;
 	const struct regulator_desc *multi_regs;
-	struct tps6594_regulator_irq_type **ldos_irq_types;
+	const struct tps6594_regulator_irq_type **ldos_irq_types;
 	const struct regulator_desc *ldo_regs;
 	size_t interrupt_count;
 
-- 
2.53.0



