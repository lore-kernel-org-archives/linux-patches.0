Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048227;
	b=LHUSYfSk60NKx6btQnxEyNZmsnRRrV1OLYQW0VJ5+jK3PE8I0/iDaHuKURaKxtfmPzuH
	 SuIy9woNBYYaQHALPmsqr+Q7TGScnTdgR3oFf3suaHHaoj/oYPqJRdUShwZ68isd1d/c6
	 7wyRAepKXxYFQQ9UQ/nVUK6oxIz5ejjcBRTGPIQuBkgD3v6/p/oJcrom3skHLC1lApqzD
	 cNjpAE8ASdAPS0g80HNzZxDJ+EA9blu4UTCLnFsjgk1UUAdOdX2kp1KRzqcl5eVUgGIra
	 haMgwO9G+j6lU8nTu7jg/j/bzNnAXysRsAI6TzY+BG4ETJoRlyRs90Lfx0dwmgRWQJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mGHq/MT+23xxaIChVU++AvC259tWwXipVlLjbCToDBU=;
	b=Vt/hDQWS803uxi9G06XhuN3M7qv7fXKO0cDdTA1Z2PZBXpogIrXjrjjxswFxgjywdQ+2
	 Z1CHVzWpEJIIKz7bghqQIEuWX60nfhXteMMO8a8fElmZKGDmZJ3xOnRzFKNev+qPc/aVv
	 9Kg8advrKFk6+tZsN/ctbdmMQMzmvidk/vMxF9H2eOL/eM9y2D27YO6G2hSX5r2nH76Ay
	 tXEYdVhknPRgGOm/uVSKPTfzuT5jwdIBYMT0T8/iEVVPc2xsEuL12u5sflxAHrsEH4EQr
	 7wlVMwkkm/HAo/O77x0kGwYoKW/nZ4L9K9sKOI6JQW8S7fyRpjZOc+ICYZm5JpOYAqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bk0d/xAP";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024EF606A33D;
	Thu, 19 Nov 2026 00:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bk0d/xAP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 289F31F000C6;
	Thu, 19 Nov 2026 00:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048226;
	bh=mGHq/MT+23xxaIChVU++AvC259tWwXipVlLjbCToDBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bk0d/xAPj3ecrnOsv336ZAh6FmLdYjc+5cPlBVOvCaMOvbWs4z5rGQTT/Z9H3Xhos
	 Zkladxu1xKMsyRXxD/zCv33JV1iuJKenUDwZvTWCvssVTzSJgdBJa5/a10me4aDv1r
	 Jsj/CLs3Rgv58HStPCS7fvZWB02GwGW77uDAfxdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1919/2857] regulator: Unify "negative error number" terminology in comments
Date: Wed, 18 Nov 2026 15:49:13 +0100
Message-ID: <20261118150310.308270413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 98ce82a52886edd5197e903cb2b56f21bf3b0781 ]

Previous commits cleaning up kerneldoc used the term "negative error
number" to refer to error condition return values. Update remaining
instances of other terminology such as "error code" or "errno" as
well so the whole regulator subsystem is unified.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20240829085131.1361701-11-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 51d6888b51e0 ("regulator: qcom-rpmh: Fix the return value in rpmh_regulator_vrm_get_optimum_mode() kernel-doc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c                |  2 +-
 drivers/regulator/devres.c              | 18 +++++++++---------
 drivers/regulator/fixed.c               |  2 +-
 drivers/regulator/irq_helpers.c         |  2 +-
 drivers/regulator/max77802-regulator.c  |  4 ++--
 drivers/regulator/qcom-rpmh-regulator.c |  6 +++---
 drivers/regulator/qcom_smd-regulator.c  |  2 +-
 7 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 372208ce19fcf..07c097a1206a5 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3403,7 +3403,7 @@ EXPORT_SYMBOL_GPL(regulator_get_regmap);
  * for example.
  *
  * On success, the output parameters @vsel_reg and @vsel_mask are filled in
- * and 0 is returned, otherwise a negative errno is returned.
+ * and 0 is returned, otherwise a negative error number is returned.
  */
 int regulator_get_hardware_vsel_register(struct regulator *regulator,
 					 unsigned *vsel_reg,
diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
index 7111c46e9de13..1b893cdd1aad6 100644
--- a/drivers/regulator/devres.c
+++ b/drivers/regulator/devres.c
@@ -163,7 +163,7 @@ EXPORT_SYMBOL_GPL(devm_regulator_get_optional);
  * In cases where the supply is not strictly required, callers can check for
  * -ENODEV error and handle it accordingly.
  *
- * Returns: voltage in microvolts on success, or an error code on failure.
+ * Returns: voltage in microvolts on success, or an negative error number on failure.
  */
 int devm_regulator_get_enable_read_voltage(struct device *dev, const char *id)
 {
@@ -174,8 +174,8 @@ int devm_regulator_get_enable_read_voltage(struct device *dev, const char *id)
 	 * Since we need a real voltage, we use devm_regulator_get_optional()
 	 * rather than getting a dummy regulator with devm_regulator_get() and
 	 * then letting regulator_get_voltage() fail with -EINVAL. This way, the
-	 * caller can handle the -ENODEV error code if needed instead of the
-	 * ambiguous -EINVAL.
+	 * caller can handle the -ENODEV negative error number if needed instead
+	 * of the ambiguous -EINVAL.
 	 */
 	r = devm_regulator_get_optional(dev, id);
 	if (IS_ERR(r))
@@ -276,7 +276,7 @@ static int _devm_regulator_bulk_get(struct device *dev, int num_consumers,
  * @num_consumers: number of consumers to register
  * @consumers:     configuration of consumers; clients are stored here.
  *
- * @return 0 on success, an errno on failure.
+ * @return 0 on success, a negative error number on failure.
  *
  * This helper function allows drivers to get several regulator
  * consumers in one operation with management, the regulators will
@@ -299,7 +299,7 @@ EXPORT_SYMBOL_GPL(devm_regulator_bulk_get);
  * @num_consumers: number of consumers to register
  * @consumers:     configuration of consumers; clients are stored here.
  *
- * @return 0 on success, an errno on failure.
+ * @return 0 on success, a negative error number on failure.
  *
  * This helper function allows drivers to exclusively get several
  * regulator consumers in one operation with management, the regulators
@@ -326,7 +326,7 @@ EXPORT_SYMBOL_GPL(devm_regulator_bulk_get_exclusive);
  * This is a convenience function to allow bulk regulator configuration
  * to be stored "static const" in files.
  *
- * Return: 0 on success, an errno on failure.
+ * Return: 0 on success, a negative error number on failure.
  */
 int devm_regulator_bulk_get_const(struct device *dev, int num_consumers,
 				  const struct regulator_bulk_data *in_consumers,
@@ -393,7 +393,7 @@ static void devm_regulator_bulk_disable(void *res)
  * @num_consumers: number of consumers to register
  * @id:            list of supply names or regulator IDs
  *
- * @return 0 on success, an errno on failure.
+ * @return 0 on success, a negative error number on failure.
  *
  * This helper function allows drivers to get several regulator
  * consumers in one operation with management, the regulators will
@@ -574,7 +574,7 @@ static void devm_regulator_unregister_supply_alias(struct device *dev,
  *             lookup the supply
  * @num_id:    number of aliases to register
  *
- * @return 0 on success, an errno on failure.
+ * @return 0 on success, a negative error number on failure.
  *
  * This helper function allows drivers to register several supply
  * aliases in one operation, the aliases will be automatically
@@ -726,7 +726,7 @@ static void regulator_irq_helper_drop(void *res)
  *			IRQ.
  * @rdev_amount:	Amount of regulators associated with this IRQ.
  *
- * Return: handle to irq_helper or an ERR_PTR() encoded error code.
+ * Return: handle to irq_helper or an ERR_PTR() encoded negative error number.
  */
 void *devm_regulator_irq_helper(struct device *dev,
 				const struct regulator_irq_desc *d, int irq,
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 35ee43bf275ba..74b5d10226953 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -131,7 +131,7 @@ static irqreturn_t reg_fixed_under_voltage_irq_handler(int irq, void *data)
  * If it's an optional IRQ and not found, it returns 0.
  * Otherwise, it attempts to request the threaded IRQ.
  *
- * Return: 0 on success, or error code on failure.
+ * Return: 0 on success, or a negative error number on failure.
  */
 static int reg_fixed_get_irqs(struct device *dev,
 			      struct fixed_voltage_data *priv)
diff --git a/drivers/regulator/irq_helpers.c b/drivers/regulator/irq_helpers.c
index 5ab1a0befe12f..ba07a7016a272 100644
--- a/drivers/regulator/irq_helpers.c
+++ b/drivers/regulator/irq_helpers.c
@@ -333,7 +333,7 @@ static void init_rdev_errors(struct regulator_irq *h)
  *			IRQ.
  * @rdev_amount:	Amount of regulators associated with this IRQ.
  *
- * Return: handle to irq_helper or an ERR_PTR() encoded error code.
+ * Return: handle to irq_helper or an ERR_PTR() encoded negative error number.
  */
 void *regulator_irq_helper(struct device *dev,
 			   const struct regulator_irq_desc *d, int irq,
diff --git a/drivers/regulator/max77802-regulator.c b/drivers/regulator/max77802-regulator.c
index befe5f319819b..55b3dbb53da76 100644
--- a/drivers/regulator/max77802-regulator.c
+++ b/drivers/regulator/max77802-regulator.c
@@ -160,8 +160,8 @@ static unsigned max77802_get_mode(struct regulator_dev *rdev)
  * Enable Control Logic3 by PWRREQ (LDO 3)
  *
  * If setting the regulator mode fails, the function only warns but does
- * not return an error code to avoid the regulator core to stop setting
- * the operating mode for the remaining regulators.
+ * not return a negative error number to avoid the regulator core to stop
+ * setting the operating mode for the remaining regulators.
  */
 static int max77802_set_suspend_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index d05f65fa261bd..b7c168972e48d 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -158,7 +158,7 @@ struct rpmh_vreg_init_data {
  * @wait_for_ack:	Boolean indicating if execution must wait until the
  *			request has been acknowledged as complete
  *
- * Return: 0 on success, errno on failure
+ * Return: 0 on success, or a negative error number on failure
  */
 static int rpmh_regulator_send_request(struct rpmh_vreg *vreg,
 			struct tcs_cmd *cmd, bool wait_for_ack)
@@ -317,7 +317,7 @@ static unsigned int rpmh_regulator_vrm_get_mode(struct regulator_dev *rdev)
  * This function is used in the regulator_ops for VRM type RPMh regulator
  * devices.
  *
- * Return: 0 on success, errno on failure
+ * Return: 0 on success, or a negative error number on failure
  */
 static unsigned int rpmh_regulator_vrm_get_optimum_mode(
 	struct regulator_dev *rdev, int input_uV, int output_uV, int load_uA)
@@ -409,7 +409,7 @@ static const struct regulator_ops rpmh_regulator_xob_ops = {
  * @pmic_rpmh_data:	Pointer to a null-terminated array of rpmh-regulator
  *			resources defined for the top level PMIC device
  *
- * Return: 0 on success, errno on failure
+ * Return: 0 on success, or a negative error number on failure
  */
 static int rpmh_regulator_init_vreg(struct rpmh_vreg *vreg, struct device *dev,
 			struct device_node *node, const char *pmic_id,
diff --git a/drivers/regulator/qcom_smd-regulator.c b/drivers/regulator/qcom_smd-regulator.c
index f98168d58dce9..c51223c5ed087 100644
--- a/drivers/regulator/qcom_smd-regulator.c
+++ b/drivers/regulator/qcom_smd-regulator.c
@@ -1320,7 +1320,7 @@ MODULE_DEVICE_TABLE(of, rpm_of_match);
  * @pmic_rpm_data:	Pointer to a null-terminated array of qcom_smd-regulator
  *			resources defined for the top level PMIC device
  *
- * Return: 0 on success, errno on failure
+ * Return: 0 on success, or a negative error number on failure
  */
 static int rpm_regulator_init_vreg(struct qcom_rpm_reg *vreg, struct device *dev,
 				   struct device_node *node, struct qcom_smd_rpm *rpm,
-- 
2.53.0



