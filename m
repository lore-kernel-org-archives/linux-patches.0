Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63063D53C;
	Thu, 22 Aug 2024 00:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724286276; cv=none; b=ntwsVCWm+g28h35TOKUkRQFj5WXBo69eKJgmbhAtNurzXOS8Lz+pwLJh/Trpd7jk3BCDPjM5/oN4OhMcO0bOMcrlgsGmPCQOT+Pe2Qis1PdQ/7rLDh09FAumIpwOPvWMDIXHfguMeZ6KJ9WUmwhawxb2NQZZRHcUZhIHqQOYGxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724286276; c=relaxed/simple;
	bh=G78oCu1oc8+Jy6f6JroyLd5bXTCa6AtZ4SGFSMEYqNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIlbNxATwF00vqhPTGZTwvWtHVFtJd0lgkySOtJKmUSJ/csdz9nt3VSiim2D8gz7ECWW/bLLtgJOPLpVFnpsi4XCwvf4uv+StSMpWjGheqQqzDQgEXrURVueDyezzezrYx8zhzlgrEVSs5B13+zKTwN+zwOSnb7swNdB2rSKBbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0VOMoEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0VOMoEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0ABFC4AF15;
	Thu, 22 Aug 2024 00:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724286276;
	bh=G78oCu1oc8+Jy6f6JroyLd5bXTCa6AtZ4SGFSMEYqNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0VOMoEHD3YKzKXdkQ7oPtudBj1oXEMO47AT+ZDPW2VGyzAT/T6GMbnHzqfA4FagK
	 Qjwo4ZaIwb96tFoCK2+oFh7zx3j+/BIQ3D2+v0zyU9mh5q2mqWIEQeENkm/E8vM4KW
	 Q1/9c02TetGP4VXXpOdbE82gsdzf6vNEh1zfLUOoV6rpK3XTlJR9MIyMoCE/ukQNOG
	 bQa+k+vJZ6I9NZQ7MsedL6nZ2Gg6ox1fGILncjo6Qsg1G8vHgUUPbe3Cp+BhsHOGah
	 DMBPfRabPHirtbFqbenwMLP1BvLKh0JS3WWLo7Ys6ehCPxpInQyGuNJmDBZ+iBqk/o
	 06GTzrrX2ammA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	kunit-dev@googlegroups.com,
	Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 3/3] clk: test: Add KUnit tests for clock-assigned-rates{-u64} DT properties
Date: Wed, 21 Aug 2024 17:24:30 -0700
Message-ID: <20240822002433.1163814-4-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822002433.1163814-1-sboyd@kernel.org>
References: <20240822002433.1163814-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add unit tests for the two types of assigned rate properties. Test
different combinations of assigned clocks and make sure that rates
aren't assigned when the DT properties are malformed or are zero.

Cc: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/Makefile                          |  14 +
 drivers/clk/clk_test.c                        | 321 ++++++++++++++++++
 drivers/clk/kunit_clk_assigned_rates.h        |   8 +
 .../kunit_clk_assigned_rates_multiple.dtso    |  16 +
 ..._clk_assigned_rates_multiple_consumer.dtso |  20 ++
 .../clk/kunit_clk_assigned_rates_null.dtso    |  14 +
 ...unit_clk_assigned_rates_null_consumer.dtso |  18 +
 drivers/clk/kunit_clk_assigned_rates_one.dtso |  14 +
 ...kunit_clk_assigned_rates_one_consumer.dtso |  18 +
 ...kunit_clk_assigned_rates_u64_multiple.dtso |  16 +
 ..._assigned_rates_u64_multiple_consumer.dtso |  20 ++
 .../clk/kunit_clk_assigned_rates_u64_one.dtso |  14 +
 ...t_clk_assigned_rates_u64_one_consumer.dtso |  18 +
 .../clk/kunit_clk_assigned_rates_without.dtso |  13 +
 ...t_clk_assigned_rates_without_consumer.dtso |  17 +
 .../clk/kunit_clk_assigned_rates_zero.dtso    |  12 +
 ...unit_clk_assigned_rates_zero_consumer.dtso |  16 +
 17 files changed, 569 insertions(+)
 create mode 100644 drivers/clk/kunit_clk_assigned_rates.h
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_multiple.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_multiple_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_null.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_null_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_one.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_one_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_u64_multiple.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_u64_multiple_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_u64_one.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_u64_one_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_without.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_without_consumer.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_zero.dtso
 create mode 100644 drivers/clk/kunit_clk_assigned_rates_zero_consumer.dtso

diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 9b783c3e5d2f..00bc19331b76 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -4,6 +4,20 @@ obj-$(CONFIG_HAVE_CLK)		+= clk-devres.o clk-bulk.o clkdev.o
 obj-$(CONFIG_COMMON_CLK)	+= clk.o
 obj-$(CONFIG_CLK_KUNIT_TEST)	+= clk-test.o
 clk-test-y			:= clk_test.o \
+				   kunit_clk_assigned_rates_u64_one.dtbo.o \
+				   kunit_clk_assigned_rates_u64_one_consumer.dtbo.o \
+				   kunit_clk_assigned_rates_u64_multiple.dtbo.o \
+				   kunit_clk_assigned_rates_u64_multiple_consumer.dtbo.o \
+				   kunit_clk_assigned_rates_multiple.dtbo.o \
+				   kunit_clk_assigned_rates_multiple_consumer.dtbo.o \
+				   kunit_clk_assigned_rates_null.dtbo.o \
+				   kunit_clk_assigned_rates_null_consumer.dtbo.o \
+				   kunit_clk_assigned_rates_one.dtbo.o \
+				   kunit_clk_assigned_rates_one_consumer.dtbo.o \
+				   kunit_clk_assigned_rates_without.dtbo.o \
+				   kunit_clk_assigned_rates_without_consumer.dtbo.o \
+				   kunit_clk_assigned_rates_zero.dtbo.o \
+				   kunit_clk_assigned_rates_zero_consumer.dtbo.o \
 				   kunit_clk_parent_data_test.dtbo.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-divider.o
 obj-$(CONFIG_COMMON_CLK)	+= clk-fixed-factor.o
diff --git a/drivers/clk/clk_test.c b/drivers/clk/clk_test.c
index 41fc8eba3418..cb53a8df55fc 100644
--- a/drivers/clk/clk_test.c
+++ b/drivers/clk/clk_test.c
@@ -4,6 +4,7 @@
  */
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
+#include <linux/clk/clk-conf.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 
@@ -15,6 +16,7 @@
 #include <kunit/platform_device.h>
 #include <kunit/test.h>
 
+#include "kunit_clk_assigned_rates.h"
 #include "clk_parent_data_test.h"
 
 static const struct clk_ops empty_clk_ops = { };
@@ -3108,7 +3110,326 @@ static struct kunit_suite clk_register_clk_parent_data_device_suite = {
 	.test_cases = clk_register_clk_parent_data_device_test_cases,
 };
 
+struct clk_assigned_rates_context {
+	struct clk_dummy_context clk0;
+	struct clk_dummy_context clk1;
+};
+
+/*
+ * struct clk_assigned_rates_test_param - Test parameters for clk_assigned_rates test
+ * @desc: Test description
+ * @overlay_begin: Pointer to start of DT overlay to apply for test
+ * @overlay_end: Pointer to end of DT overlay to apply for test
+ * @rate0: Initial rate of first clk
+ * @rate1: Initial rate of second clk
+ * @consumer_test: true if a consumer is being tested
+ */
+struct clk_assigned_rates_test_param {
+	const char *desc;
+	u8 *overlay_begin;
+	u8 *overlay_end;
+	unsigned long rate0;
+	unsigned long rate1;
+	bool consumer_test;
+};
+
+#define TEST_PARAM_OVERLAY(overlay_name)				\
+	.overlay_begin = of_overlay_begin(overlay_name),		\
+	.overlay_end = of_overlay_end(overlay_name)
+
+static void
+clk_assigned_rates_register_clk(struct kunit *test,
+				struct clk_dummy_context *ctx,
+				struct device_node *np, const char *name,
+				unsigned long rate)
+{
+	struct clk_init_data init = { };
+
+	init.name = name;
+	init.ops = &clk_dummy_rate_ops;
+	ctx->hw.init = &init;
+	ctx->rate = rate;
+
+	KUNIT_ASSERT_EQ(test, 0, of_clk_hw_register_kunit(test, np, &ctx->hw));
+	KUNIT_ASSERT_EQ(test, ctx->rate, rate);
+}
+
+/*
+ * Does most of the work of the test:
+ *
+ * 1. Apply the overlay to test
+ * 2. Register the clk or clks to test
+ * 3. Register the clk provider
+ * 4. Apply clk defaults to the consumer device if this is a consumer test
+ *
+ * The tests will set different test_param values to test different scenarios
+ * and validate that in their test functions.
+ */
+static int clk_assigned_rates_test_init(struct kunit *test)
+{
+	struct device_node *np, *consumer;
+	struct clk_hw_onecell_data *data;
+	struct clk_assigned_rates_context *ctx;
+	u32 clk_cells;
+	const struct clk_assigned_rates_test_param *test_param;
+
+	test_param = test->param_value;
+
+	KUNIT_ASSERT_EQ(test, 0, __of_overlay_apply_kunit(test,
+							  test_param->overlay_begin,
+							  test_param->overlay_end));
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test,
+		ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL));
+	test->priv = ctx;
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test,
+		np = of_find_compatible_node(NULL, NULL, "test,clk-assigned-rates"));
+	of_node_put_kunit(test, np);
+
+	KUNIT_ASSERT_EQ(test, 0, of_property_read_u32(np, "#clock-cells", &clk_cells));
+	/* Only support #clock-cells = <0> or <1> */
+	KUNIT_ASSERT_LT(test, clk_cells, 2);
+
+	clk_assigned_rates_register_clk(test, &ctx->clk0, np,
+					"test_assigned_rate0", test_param->rate0);
+	if (clk_cells == 0) {
+		KUNIT_ASSERT_EQ(test, 0,
+				of_clk_add_hw_provider_kunit(test, np, of_clk_hw_simple_get,
+							     &ctx->clk0.hw));
+	} else if (clk_cells == 1) {
+		clk_assigned_rates_register_clk(test, &ctx->clk1, np,
+						"test_assigned_rate1", test_param->rate1);
+
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test,
+			data = kunit_kzalloc(test, struct_size(data, hws, 2), GFP_KERNEL));
+		data->num = 2;
+		data->hws[0] = &ctx->clk0.hw;
+		data->hws[1] = &ctx->clk1.hw;
+
+		KUNIT_ASSERT_EQ(test, 0,
+				of_clk_add_hw_provider_kunit(test, np, of_clk_hw_onecell_get, data));
+	}
+
+	/* Consumers are optional */
+	if (test_param->consumer_test) {
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test,
+			consumer = of_find_compatible_node(NULL, NULL, "test,clk-consumer"));
+		of_node_put_kunit(test, consumer);
+
+		KUNIT_ASSERT_EQ(test, 0, of_clk_set_defaults(consumer, false));
+	}
+
+	return 0;
+}
+
+static void clk_assigned_rates_assigns_one(struct kunit *test)
+{
+	struct clk_assigned_rates_context *ctx = test->priv;
+
+	KUNIT_EXPECT_EQ(test, ctx->clk0.rate, ASSIGNED_RATES_0_RATE);
+}
+
+static void clk_assigned_rates_assigns_multiple(struct kunit *test)
+{
+	struct clk_assigned_rates_context *ctx = test->priv;
+
+	KUNIT_EXPECT_EQ(test, ctx->clk0.rate, ASSIGNED_RATES_0_RATE);
+	KUNIT_EXPECT_EQ(test, ctx->clk1.rate, ASSIGNED_RATES_1_RATE);
+}
+
+static void clk_assigned_rates_skips(struct kunit *test)
+{
+	struct clk_assigned_rates_context *ctx = test->priv;
+	const struct clk_assigned_rates_test_param *test_param = test->param_value;
+
+	KUNIT_EXPECT_NE(test, ctx->clk0.rate, ASSIGNED_RATES_0_RATE);
+	KUNIT_EXPECT_EQ(test, ctx->clk0.rate, test_param->rate0);
+}
+
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_one);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_one_consumer);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_u64_one);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_u64_one_consumer);
+
+/* Test cases that assign one rate */
+static const struct clk_assigned_rates_test_param clk_assigned_rates_assigns_one_test_params[] = {
+	{
+		/*
+		 * Test that a single cell assigned-clock-rates property
+		 * assigns the rate when the property is in the provider.
+		 */
+		.desc = "provider assigns",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_one),
+	},
+	{
+		/*
+		 * Test that a single cell assigned-clock-rates property
+		 * assigns the rate when the property is in the consumer.
+		 */
+		.desc = "consumer assigns",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_one_consumer),
+		.consumer_test = true,
+	},
+	{
+		/*
+		 * Test that a single cell assigned-clock-rates-u64 property
+		 * assigns the rate when the property is in the provider.
+		 */
+		.desc = "provider assigns u64",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_u64_one),
+	},
+	{
+		/*
+		 * Test that a single cell assigned-clock-rates-u64 property
+		 * assigns the rate when the property is in the consumer.
+		 */
+		.desc = "consumer assigns u64",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_u64_one_consumer),
+		.consumer_test = true,
+	},
+};
+KUNIT_ARRAY_PARAM_DESC(clk_assigned_rates_assigns_one,
+		       clk_assigned_rates_assigns_one_test_params, desc)
+
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_multiple);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_multiple_consumer);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_u64_multiple);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_u64_multiple_consumer);
+
+/* Test cases that assign multiple rates */
+static const struct clk_assigned_rates_test_param clk_assigned_rates_assigns_multiple_test_params[] = {
+	{
+		/*
+		 * Test that a multiple cell assigned-clock-rates property
+		 * assigns the rates when the property is in the provider.
+		 */
+		.desc = "provider assigns",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_multiple),
+	},
+	{
+		/*
+		 * Test that a multiple cell assigned-clock-rates property
+		 * assigns the rates when the property is in the consumer.
+		 */
+		.desc = "consumer assigns",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_multiple_consumer),
+		.consumer_test = true,
+	},
+	{
+		/*
+		 * Test that a single cell assigned-clock-rates-u64 property
+		 * assigns the rate when the property is in the provider.
+		 */
+		.desc = "provider assigns u64",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_u64_multiple),
+	},
+	{
+		/*
+		 * Test that a multiple cell assigned-clock-rates-u64 property
+		 * assigns the rates when the property is in the consumer.
+		 */
+		.desc = "consumer assigns u64",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_u64_multiple_consumer),
+		.consumer_test = true,
+	},
+};
+KUNIT_ARRAY_PARAM_DESC(clk_assigned_rates_assigns_multiple,
+		       clk_assigned_rates_assigns_multiple_test_params,
+		       desc)
+
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_without);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_without_consumer);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_zero);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_zero_consumer);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_null);
+OF_OVERLAY_DECLARE(kunit_clk_assigned_rates_null_consumer);
+
+/* Test cases that skip changing the rate due to malformed DT */
+static const struct clk_assigned_rates_test_param clk_assigned_rates_skips_test_params[] = {
+	{
+		/*
+		 * Test that an assigned-clock-rates property without an assigned-clocks
+		 * property fails when the property is in the provider.
+		 */
+		.desc = "provider missing assigned-clocks",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_without),
+		.rate0 = 3000,
+	},
+	{
+		/*
+		 * Test that an assigned-clock-rates property without an assigned-clocks
+		 * property fails when the property is in the consumer.
+		 */
+		.desc = "consumer missing assigned-clocks",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_without_consumer),
+		.rate0 = 3000,
+		.consumer_test = true,
+	},
+	{
+		/*
+		 * Test that an assigned-clock-rates property of zero doesn't
+		 * set a rate when the property is in the provider.
+		 */
+		.desc = "provider assigned-clock-rates of zero",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_zero),
+		.rate0 = 3000,
+	},
+	{
+		/*
+		 * Test that an assigned-clock-rates property of zero doesn't
+		 * set a rate when the property is in the consumer.
+		 */
+		.desc = "consumer assigned-clock-rates of zero",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_zero_consumer),
+		.rate0 = 3000,
+		.consumer_test = true,
+	},
+	{
+		/*
+		 * Test that an assigned-clocks property with a null phandle
+		 * doesn't set a rate when the property is in the provider.
+		 */
+		.desc = "provider assigned-clocks null phandle",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_null),
+		.rate0 = 3000,
+	},
+	{
+		/*
+		 * Test that an assigned-clocks property with a null phandle
+		 * doesn't set a rate when the property is in the consumer.
+		 */
+		.desc = "provider assigned-clocks null phandle",
+		TEST_PARAM_OVERLAY(kunit_clk_assigned_rates_null_consumer),
+		.rate0 = 3000,
+		.consumer_test = true,
+	},
+};
+KUNIT_ARRAY_PARAM_DESC(clk_assigned_rates_skips,
+		       clk_assigned_rates_skips_test_params,
+		       desc)
+
+static struct kunit_case clk_assigned_rates_test_cases[] = {
+	KUNIT_CASE_PARAM(clk_assigned_rates_assigns_one,
+			 clk_assigned_rates_assigns_one_gen_params),
+	KUNIT_CASE_PARAM(clk_assigned_rates_assigns_multiple,
+			 clk_assigned_rates_assigns_multiple_gen_params),
+	KUNIT_CASE_PARAM(clk_assigned_rates_skips,
+			 clk_assigned_rates_skips_gen_params),
+	{}
+};
+
+/*
+ * Test suite for assigned-clock-rates{-u64} DT property.
+ */
+static struct kunit_suite clk_assigned_rates_suite = {
+	.name = "clk_assigned_rates",
+	.test_cases = clk_assigned_rates_test_cases,
+	.init = clk_assigned_rates_test_init,
+};
+
 kunit_test_suites(
+	&clk_assigned_rates_suite,
 	&clk_leaf_mux_set_rate_parent_test_suite,
 	&clk_test_suite,
 	&clk_multiple_parents_mux_test_suite,
diff --git a/drivers/clk/kunit_clk_assigned_rates.h b/drivers/clk/kunit_clk_assigned_rates.h
new file mode 100644
index 000000000000..df2d84dcaa93
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _KUNIT_CLK_ASSIGNED_RATES_H
+#define _KUNIT_CLK_ASSIGNED_RATES_H
+
+#define ASSIGNED_RATES_0_RATE		1600000
+#define ASSIGNED_RATES_1_RATE		9700000
+
+#endif
diff --git a/drivers/clk/kunit_clk_assigned_rates_multiple.dtso b/drivers/clk/kunit_clk_assigned_rates_multiple.dtso
new file mode 100644
index 000000000000..e600736e70f5
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_multiple.dtso
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <1>;
+		assigned-clocks = <&clk 0>,
+				  <&clk 1>;
+		assigned-clock-rates = <ASSIGNED_RATES_0_RATE>,
+				       <ASSIGNED_RATES_1_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_multiple_consumer.dtso b/drivers/clk/kunit_clk_assigned_rates_multiple_consumer.dtso
new file mode 100644
index 000000000000..260aba458daf
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_multiple_consumer.dtso
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <1>;
+	};
+
+	kunit-clock-consumer {
+		compatible = "test,clk-consumer";
+		assigned-clocks = <&clk 0>,
+				  <&clk 1>;
+		assigned-clock-rates = <ASSIGNED_RATES_0_RATE>,
+				       <ASSIGNED_RATES_1_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_null.dtso b/drivers/clk/kunit_clk_assigned_rates_null.dtso
new file mode 100644
index 000000000000..0b27b38a9130
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_null.dtso
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <0>;
+		assigned-clocks = <0>;
+		assigned-clock-rates = <ASSIGNED_RATES_0_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_null_consumer.dtso b/drivers/clk/kunit_clk_assigned_rates_null_consumer.dtso
new file mode 100644
index 000000000000..99fb332ae83d
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_null_consumer.dtso
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <0>;
+	};
+
+	kunit-clock-consumer {
+		compatible = "test,clk-consumer";
+		assigned-clocks = <0>;
+		assigned-clock-rates = <ASSIGNED_RATES_0_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_one.dtso b/drivers/clk/kunit_clk_assigned_rates_one.dtso
new file mode 100644
index 000000000000..dd95ec9b1cf9
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_one.dtso
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <0>;
+		assigned-clocks = <&clk>;
+		assigned-clock-rates = <ASSIGNED_RATES_0_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_one_consumer.dtso b/drivers/clk/kunit_clk_assigned_rates_one_consumer.dtso
new file mode 100644
index 000000000000..a41dca806318
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_one_consumer.dtso
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <0>;
+	};
+
+	kunit-clock-consumer {
+		compatible = "test,clk-consumer";
+		assigned-clocks = <&clk>;
+		assigned-clock-rates = <ASSIGNED_RATES_0_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_u64_multiple.dtso b/drivers/clk/kunit_clk_assigned_rates_u64_multiple.dtso
new file mode 100644
index 000000000000..389b4e2eb7f7
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_u64_multiple.dtso
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <1>;
+		assigned-clocks = <&clk 0>,
+				  <&clk 1>;
+		assigned-clock-rates-u64 = /bits/ 64 <ASSIGNED_RATES_0_RATE>,
+					   /bits/ 64 <ASSIGNED_RATES_1_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_u64_multiple_consumer.dtso b/drivers/clk/kunit_clk_assigned_rates_u64_multiple_consumer.dtso
new file mode 100644
index 000000000000..3e117fd59b7d
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_u64_multiple_consumer.dtso
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <1>;
+	};
+
+	kunit-clock-consumer {
+		compatible = "test,clk-consumer";
+		assigned-clocks = <&clk 0>,
+				  <&clk 1>;
+		assigned-clock-rates-u64 = /bits/ 64 <ASSIGNED_RATES_0_RATE>,
+					   /bits/ 64 <ASSIGNED_RATES_1_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_u64_one.dtso b/drivers/clk/kunit_clk_assigned_rates_u64_one.dtso
new file mode 100644
index 000000000000..87041264e8f5
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_u64_one.dtso
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <0>;
+		assigned-clocks = <&clk>;
+		assigned-clock-rates-u64 = /bits/ 64 <ASSIGNED_RATES_0_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_u64_one_consumer.dtso b/drivers/clk/kunit_clk_assigned_rates_u64_one_consumer.dtso
new file mode 100644
index 000000000000..3259c003aec0
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_u64_one_consumer.dtso
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <0>;
+	};
+
+	kunit-clock-consumer {
+		compatible = "test,clk-consumer";
+		assigned-clocks = <&clk>;
+		assigned-clock-rates-u64 = /bits/ 64 <ASSIGNED_RATES_0_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_without.dtso b/drivers/clk/kunit_clk_assigned_rates_without.dtso
new file mode 100644
index 000000000000..22d333495cf2
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_without.dtso
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <0>;
+		assigned-clock-rates = <ASSIGNED_RATES_0_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_without_consumer.dtso b/drivers/clk/kunit_clk_assigned_rates_without_consumer.dtso
new file mode 100644
index 000000000000..75ac09140f83
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_without_consumer.dtso
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+#include "kunit_clk_assigned_rates.h"
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <0>;
+	};
+
+	kunit-clock-consumer {
+		compatible = "test,clk-consumer";
+		assigned-clock-rates = <ASSIGNED_RATES_0_RATE>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_zero.dtso b/drivers/clk/kunit_clk_assigned_rates_zero.dtso
new file mode 100644
index 000000000000..08e042c2eafe
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_zero.dtso
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <0>;
+		assigned-clocks = <&clk>;
+		assigned-clock-rates = <0>;
+	};
+};
diff --git a/drivers/clk/kunit_clk_assigned_rates_zero_consumer.dtso b/drivers/clk/kunit_clk_assigned_rates_zero_consumer.dtso
new file mode 100644
index 000000000000..1d964672e855
--- /dev/null
+++ b/drivers/clk/kunit_clk_assigned_rates_zero_consumer.dtso
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+&{/} {
+	clk: kunit-clock {
+		compatible = "test,clk-assigned-rates";
+		#clock-cells = <0>;
+	};
+
+	kunit-clock-consumer {
+		compatible = "test,clk-consumer";
+		assigned-clocks = <&clk>;
+		assigned-clock-rates = <0>;
+	};
+};
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

