Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624383;
	b=ECx5wYtf/O7VeDISJ2hy+8dyE79dniFfonU1D1RfPWidZ+xNPnXMLSQM5Kw4Q4zk4V3u
	 2vrIlcKyrl8QRrYR4ruByIc1wPoYuPId0m8K2tRKrXE6gf3gWh93sASN3XCNpIENwlFv5
	 kO6CH5CygdIjtukHJw7B9RAfeK2/oX+0/YR348thxTelFwH4FnUGxVgO3gufy1HXJJq4w
	 UjPNlWen/8qtYK30mZE+ApjvzYt90FVMMeu3j19wbFOJ1c2PjmdKO795oDTwrmkOXGF1P
	 iq4xbUoD8H2OPFuQNlCVETPIT9WKf0O4qHgjx5LzSexwUb+po/Rjo99SoSqTr3Z6ZMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O5YSkS83cWG9Um4XDHJzcpaConCeo6akvlzNHaEIYJE=;
	b=jp8OXx1HA6vTh0wy8+M7IFc2Dd+7RzG7Nh1/EuOktHBeui9eHx7buJGEDs15KhJpIMrj
	 4KcQ4CHsQX5XnW/xb3fxQXC53V07X5YfQIi9KNvvLTgEBvuC0627SHfl86WDxiNxRGbMc
	 Wy2jlpwAk/t/u6opw5SXOfaFsn89NwJ9GpKwFm2KoHmOo+bghhCSasMTBzpe01TvgeUkP
	 m3blLqHWUuLDrkYC1d5b/HDVxCpLUJdof5HzPxz61jDvPNH22qhpdntn+WWRkkjd+oAsO
	 d7KZ63cd5uAZdkrGwxK7HzvVyTYTGIJaaZw483zYCDsbnOJoCw04WgSxmpiAUf6pPiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CDH/Itc/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B6F60A2601;
	Wed, 25 Nov 2026 16:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CDH/Itc/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ED61F01567;
	Wed, 25 Nov 2026 16:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624382;
	bh=O5YSkS83cWG9Um4XDHJzcpaConCeo6akvlzNHaEIYJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDH/Itc/YpyJmn/rlcf6FndUxfDfhE762XC8unxpM/DdH7rXk/tGPKm2gxIoVnUwO
	 n5wV3cFi8VtD8oYiJ7SJayTouAR77ktKUb+OEZgBvIboLje14kQe4JGqWe7NRRzOgD
	 Gl97O/sYf73gha2OJ83Ti/r3pj0ENAAPv0+7Rt1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/816] power: sequencing: qcom-wcn: improve support for wcn6855
Date: Wed, 25 Nov 2026 15:28:41 +0100
Message-ID: <20261125143853.196644491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit bd4c8bafcf50b6bd415c8bf04e98ebfba78071f9 ]

WCN6855 (also known as QCA6490) is similar to the already supported
QCA6390 but takes in two more supplies so add a new vregs list for it.

On sm8450-hdk it also requires a short assert of the xo-clk pin so add
handling for it in a dedicated unit.

As we now have a separate set of targets for this variant, store the
pointer to the targets struct associated with a model in the device
match data.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241018-sc8280xp-pwrseq-v6-2-8da8310d9564@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: bd60a639b621 ("power: sequencing: qcom-wcn: increase WCN7850 power-up delay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/pwrseq-qcom-wcn.c | 101 ++++++++++++++++++++-
 1 file changed, 98 insertions(+), 3 deletions(-)

diff --git a/drivers/power/sequencing/pwrseq-qcom-wcn.c b/drivers/power/sequencing/pwrseq-qcom-wcn.c
index 4fa129877d7e4..682a9beac69eb 100644
--- a/drivers/power/sequencing/pwrseq-qcom-wcn.c
+++ b/drivers/power/sequencing/pwrseq-qcom-wcn.c
@@ -22,6 +22,7 @@ struct pwrseq_qcom_wcn_pdata {
 	size_t num_vregs;
 	unsigned int pwup_delay_ms;
 	unsigned int gpio_enable_delay_ms;
+	const struct pwrseq_target_data **targets;
 };
 
 struct pwrseq_qcom_wcn_ctx {
@@ -31,6 +32,7 @@ struct pwrseq_qcom_wcn_ctx {
 	struct regulator_bulk_data *regs;
 	struct gpio_desc *bt_gpio;
 	struct gpio_desc *wlan_gpio;
+	struct gpio_desc *xo_clk_gpio;
 	struct clk *clk;
 	unsigned long last_gpio_enable_jf;
 };
@@ -98,6 +100,33 @@ static const struct pwrseq_unit_data *pwrseq_qcom_wcn_unit_deps[] = {
 	NULL
 };
 
+static int pwrseq_qcom_wcn6855_clk_assert(struct pwrseq_device *pwrseq)
+{
+	struct pwrseq_qcom_wcn_ctx *ctx = pwrseq_device_get_drvdata(pwrseq);
+
+	if (!ctx->xo_clk_gpio)
+		return 0;
+
+	msleep(1);
+
+	gpiod_set_value_cansleep(ctx->xo_clk_gpio, 1);
+	usleep_range(100, 200);
+
+	return 0;
+}
+
+static const struct pwrseq_unit_data pwrseq_qcom_wcn6855_xo_clk_assert = {
+	.name = "xo-clk-assert",
+	.enable = pwrseq_qcom_wcn6855_clk_assert,
+};
+
+static const struct pwrseq_unit_data *pwrseq_qcom_wcn6855_unit_deps[] = {
+	&pwrseq_qcom_wcn_vregs_unit_data,
+	&pwrseq_qcom_wcn_clk_unit_data,
+	&pwrseq_qcom_wcn6855_xo_clk_assert,
+	NULL
+};
+
 static int pwrseq_qcom_wcn_bt_enable(struct pwrseq_device *pwrseq)
 {
 	struct pwrseq_qcom_wcn_ctx *ctx = pwrseq_device_get_drvdata(pwrseq);
@@ -125,6 +154,13 @@ static const struct pwrseq_unit_data pwrseq_qcom_wcn_bt_unit_data = {
 	.disable = pwrseq_qcom_wcn_bt_disable,
 };
 
+static const struct pwrseq_unit_data pwrseq_qcom_wcn6855_bt_unit_data = {
+	.name = "wlan-enable",
+	.deps = pwrseq_qcom_wcn6855_unit_deps,
+	.enable = pwrseq_qcom_wcn_bt_enable,
+	.disable = pwrseq_qcom_wcn_bt_disable,
+};
+
 static int pwrseq_qcom_wcn_wlan_enable(struct pwrseq_device *pwrseq)
 {
 	struct pwrseq_qcom_wcn_ctx *ctx = pwrseq_device_get_drvdata(pwrseq);
@@ -152,6 +188,13 @@ static const struct pwrseq_unit_data pwrseq_qcom_wcn_wlan_unit_data = {
 	.disable = pwrseq_qcom_wcn_wlan_disable,
 };
 
+static const struct pwrseq_unit_data pwrseq_qcom_wcn6855_wlan_unit_data = {
+	.name = "wlan-enable",
+	.deps = pwrseq_qcom_wcn6855_unit_deps,
+	.enable = pwrseq_qcom_wcn_wlan_enable,
+	.disable = pwrseq_qcom_wcn_wlan_disable,
+};
+
 static int pwrseq_qcom_wcn_pwup_delay(struct pwrseq_device *pwrseq)
 {
 	struct pwrseq_qcom_wcn_ctx *ctx = pwrseq_device_get_drvdata(pwrseq);
@@ -162,6 +205,18 @@ static int pwrseq_qcom_wcn_pwup_delay(struct pwrseq_device *pwrseq)
 	return 0;
 }
 
+static int pwrseq_qcom_wcn6855_xo_clk_deassert(struct pwrseq_device *pwrseq)
+{
+	struct pwrseq_qcom_wcn_ctx *ctx = pwrseq_device_get_drvdata(pwrseq);
+
+	if (ctx->xo_clk_gpio) {
+		usleep_range(2000, 5000);
+		gpiod_set_value_cansleep(ctx->xo_clk_gpio, 0);
+	}
+
+	return pwrseq_qcom_wcn_pwup_delay(pwrseq);
+}
+
 static const struct pwrseq_target_data pwrseq_qcom_wcn_bt_target_data = {
 	.name = "bluetooth",
 	.unit = &pwrseq_qcom_wcn_bt_unit_data,
@@ -174,12 +229,30 @@ static const struct pwrseq_target_data pwrseq_qcom_wcn_wlan_target_data = {
 	.post_enable = pwrseq_qcom_wcn_pwup_delay,
 };
 
+static const struct pwrseq_target_data pwrseq_qcom_wcn6855_bt_target_data = {
+	.name = "bluetooth",
+	.unit = &pwrseq_qcom_wcn6855_bt_unit_data,
+	.post_enable = pwrseq_qcom_wcn6855_xo_clk_deassert,
+};
+
+static const struct pwrseq_target_data pwrseq_qcom_wcn6855_wlan_target_data = {
+	.name = "wlan",
+	.unit = &pwrseq_qcom_wcn6855_wlan_unit_data,
+	.post_enable = pwrseq_qcom_wcn6855_xo_clk_deassert,
+};
+
 static const struct pwrseq_target_data *pwrseq_qcom_wcn_targets[] = {
 	&pwrseq_qcom_wcn_bt_target_data,
 	&pwrseq_qcom_wcn_wlan_target_data,
 	NULL
 };
 
+static const struct pwrseq_target_data *pwrseq_qcom_wcn6855_targets[] = {
+	&pwrseq_qcom_wcn6855_bt_target_data,
+	&pwrseq_qcom_wcn6855_wlan_target_data,
+	NULL
+};
+
 static const char *const pwrseq_qca6390_vregs[] = {
 	"vddio",
 	"vddaon",
@@ -196,13 +269,28 @@ static const struct pwrseq_qcom_wcn_pdata pwrseq_qca6390_of_data = {
 	.num_vregs = ARRAY_SIZE(pwrseq_qca6390_vregs),
 	.pwup_delay_ms = 60,
 	.gpio_enable_delay_ms = 100,
+	.targets = pwrseq_qcom_wcn_targets,
+};
+
+static const char *const pwrseq_wcn6855_vregs[] = {
+	"vddio",
+	"vddaon",
+	"vddpmu",
+	"vddpmumx",
+	"vddpmucx",
+	"vddrfa0p95",
+	"vddrfa1p3",
+	"vddrfa1p9",
+	"vddpcie1p3",
+	"vddpcie1p9",
 };
 
 static const struct pwrseq_qcom_wcn_pdata pwrseq_wcn6855_of_data = {
-	.vregs = pwrseq_qca6390_vregs,
-	.num_vregs = ARRAY_SIZE(pwrseq_qca6390_vregs),
+	.vregs = pwrseq_wcn6855_vregs,
+	.num_vregs = ARRAY_SIZE(pwrseq_wcn6855_vregs),
 	.pwup_delay_ms = 50,
 	.gpio_enable_delay_ms = 5,
+	.targets = pwrseq_qcom_wcn6855_targets,
 };
 
 static const char *const pwrseq_wcn7850_vregs[] = {
@@ -219,6 +307,7 @@ static const struct pwrseq_qcom_wcn_pdata pwrseq_wcn7850_of_data = {
 	.vregs = pwrseq_wcn7850_vregs,
 	.num_vregs = ARRAY_SIZE(pwrseq_wcn7850_vregs),
 	.pwup_delay_ms = 50,
+	.targets = pwrseq_qcom_wcn_targets,
 };
 
 static int pwrseq_qcom_wcn_match(struct pwrseq_device *pwrseq,
@@ -295,6 +384,12 @@ static int pwrseq_qcom_wcn_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(ctx->wlan_gpio),
 				     "Failed to get the WLAN enable GPIO\n");
 
+	ctx->xo_clk_gpio = devm_gpiod_get_optional(dev, "xo-clk",
+						   GPIOD_OUT_LOW);
+	if (IS_ERR(ctx->xo_clk_gpio))
+		return dev_err_probe(dev, PTR_ERR(ctx->xo_clk_gpio),
+				     "Failed to get the XO_CLK GPIO\n");
+
 	/*
 	 * Set direction to output but keep the current value in order to not
 	 * disable the WLAN module accidentally if it's already powered on.
@@ -313,7 +408,7 @@ static int pwrseq_qcom_wcn_probe(struct platform_device *pdev)
 	config.owner = THIS_MODULE;
 	config.drvdata = ctx;
 	config.match = pwrseq_qcom_wcn_match;
-	config.targets = pwrseq_qcom_wcn_targets;
+	config.targets = ctx->pdata->targets;
 
 	ctx->pwrseq = devm_pwrseq_device_register(dev, &config);
 	if (IS_ERR(ctx->pwrseq))
-- 
2.53.0



