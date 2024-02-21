Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D787BAF7;
	Wed, 21 Feb 2024 14:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525606; cv=none; b=I1GfqmR9+ALvZ5O6G2fosEm7JOJ/NGe0T76s9HVZJ0ah9lX3f6rVG7iTq9ciFIsy/Fr+BPZAzIEgioIqonxk0KxqUvMxu8+zbD+metnF5k860uFsuza9uJcOjXrVA1BjscLp4KPGQ3lo/AnaeV8l+x0ziTaoSipnu/aDbasQqYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525606; c=relaxed/simple;
	bh=Xg/PMUQjhul62weFzS9CvDSWIEOYWU3TSrpQcldU518=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIsPrmbWcI19ig5v4inS8ED0wLK6c+tqJU2N/cucBWAF8HQw5apnAz1vpvgi9RuyAPPyuY9NoxySFiSYcfCebjV4r6Qqu6LXUV/FRXfgssAXgwGXVBzpM58cTYWaKucEJADmrR8h0684cZvKUusR4v0zV9Weov6auaha1GV/L5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nbtirdem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nbtirdem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF09C43390;
	Wed, 21 Feb 2024 14:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525606;
	bh=Xg/PMUQjhul62weFzS9CvDSWIEOYWU3TSrpQcldU518=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbtirdemWRwR23zXZVnk071ksZwsElslrXwx7TVXkogt4zE6nJ27ddDsv6aS3hYB6
	 ovXRO+Ydn7WvuNItiLn/x4avQLKMJZf8mzQkKXOHdsWzKlEVGO+zKOhBVSW/rpjYmG
	 mt9t86oTLsA7PMv1Rp/oUfZbO/8/IFPjIgPqJJnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Rowand <frank.rowand@sony.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/267] of: unittest: add overlay gpio test to catch gpio hog problem
Date: Wed, 21 Feb 2024 14:09:08 +0100
Message-ID: <20240221125946.683733412@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Rowand <frank.rowand@sony.com>

[ Upstream commit f4056e705b2ef7f123a188f6aee23ade70e7d793 ]

Geert reports that gpio hog nodes are not properly processed when
the gpio hog node is added via an overlay reply and provides an
RFC patch to fix the problem [1].

Add a unittest that shows the problem.  Unittest will report "1 failed"
test before applying Geert's RFC patch and "0 failed" after applying
Geert's RFC patch.

[1] https://lore.kernel.org/linux-devicetree/20191230133852.5890-1-geert+renesas@glider.be/

Signed-off-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: 607aad1e4356 ("of: unittest: Fix compile in the non-dynamic case")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/unittest-data/Makefile             |   8 +-
 drivers/of/unittest-data/overlay_gpio_01.dts  |  23 ++
 drivers/of/unittest-data/overlay_gpio_02a.dts |  16 ++
 drivers/of/unittest-data/overlay_gpio_02b.dts |  16 ++
 drivers/of/unittest-data/overlay_gpio_03.dts  |  23 ++
 drivers/of/unittest-data/overlay_gpio_04a.dts |  16 ++
 drivers/of/unittest-data/overlay_gpio_04b.dts |  16 ++
 drivers/of/unittest.c                         | 253 ++++++++++++++++++
 8 files changed, 370 insertions(+), 1 deletion(-)
 create mode 100644 drivers/of/unittest-data/overlay_gpio_01.dts
 create mode 100644 drivers/of/unittest-data/overlay_gpio_02a.dts
 create mode 100644 drivers/of/unittest-data/overlay_gpio_02b.dts
 create mode 100644 drivers/of/unittest-data/overlay_gpio_03.dts
 create mode 100644 drivers/of/unittest-data/overlay_gpio_04a.dts
 create mode 100644 drivers/of/unittest-data/overlay_gpio_04b.dts

diff --git a/drivers/of/unittest-data/Makefile b/drivers/of/unittest-data/Makefile
index 9b6807065827..009f4045c8e4 100644
--- a/drivers/of/unittest-data/Makefile
+++ b/drivers/of/unittest-data/Makefile
@@ -21,7 +21,13 @@ obj-$(CONFIG_OF_OVERLAY) += overlay.dtb.o \
 			    overlay_bad_add_dup_prop.dtb.o \
 			    overlay_bad_phandle.dtb.o \
 			    overlay_bad_symbol.dtb.o \
-			    overlay_base.dtb.o
+			    overlay_base.dtb.o \
+			    overlay_gpio_01.dtb.o \
+			    overlay_gpio_02a.dtb.o \
+			    overlay_gpio_02b.dtb.o \
+			    overlay_gpio_03.dtb.o \
+			    overlay_gpio_04a.dtb.o \
+			    overlay_gpio_04b.dtb.o
 
 # enable creation of __symbols__ node
 DTC_FLAGS_overlay += -@
diff --git a/drivers/of/unittest-data/overlay_gpio_01.dts b/drivers/of/unittest-data/overlay_gpio_01.dts
new file mode 100644
index 000000000000..699ff104ae10
--- /dev/null
+++ b/drivers/of/unittest-data/overlay_gpio_01.dts
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+&unittest_test_bus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	gpio@0 {
+		compatible = "unittest-gpio";
+		reg = <0>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		ngpios = <2>;
+		gpio-line-names = "line-A", "line-B";
+
+		line-b {
+			gpio-hog;
+			gpios = <2 0>;
+			input;
+			line-name = "line-B-input";
+		};
+	};
+};
diff --git a/drivers/of/unittest-data/overlay_gpio_02a.dts b/drivers/of/unittest-data/overlay_gpio_02a.dts
new file mode 100644
index 000000000000..ec59aff6ed47
--- /dev/null
+++ b/drivers/of/unittest-data/overlay_gpio_02a.dts
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+&unittest_test_bus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	gpio@2 {
+		compatible = "unittest-gpio";
+		reg = <2>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		ngpios = <2>;
+		gpio-line-names = "line-A", "line-B";
+	};
+};
diff --git a/drivers/of/unittest-data/overlay_gpio_02b.dts b/drivers/of/unittest-data/overlay_gpio_02b.dts
new file mode 100644
index 000000000000..43ce111d41ce
--- /dev/null
+++ b/drivers/of/unittest-data/overlay_gpio_02b.dts
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+&unittest_test_bus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	gpio@2 {
+		line-a {
+			gpio-hog;
+			gpios = <1 0>;
+			input;
+			line-name = "line-A-input";
+		};
+	};
+};
diff --git a/drivers/of/unittest-data/overlay_gpio_03.dts b/drivers/of/unittest-data/overlay_gpio_03.dts
new file mode 100644
index 000000000000..6e0312340a1b
--- /dev/null
+++ b/drivers/of/unittest-data/overlay_gpio_03.dts
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+&unittest_test_bus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	gpio@3 {
+		compatible = "unittest-gpio";
+		reg = <3>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		ngpios = <2>;
+		gpio-line-names = "line-A", "line-B", "line-C", "line-D";
+
+		line-d {
+			gpio-hog;
+			gpios = <4 0>;
+			input;
+			line-name = "line-D-input";
+		};
+	};
+};
diff --git a/drivers/of/unittest-data/overlay_gpio_04a.dts b/drivers/of/unittest-data/overlay_gpio_04a.dts
new file mode 100644
index 000000000000..7b1e04ebfa7a
--- /dev/null
+++ b/drivers/of/unittest-data/overlay_gpio_04a.dts
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+&unittest_test_bus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	gpio@4 {
+		compatible = "unittest-gpio";
+		reg = <4>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		ngpios = <2>;
+		gpio-line-names = "line-A", "line-B", "line-C", "line-D";
+	};
+};
diff --git a/drivers/of/unittest-data/overlay_gpio_04b.dts b/drivers/of/unittest-data/overlay_gpio_04b.dts
new file mode 100644
index 000000000000..a14e95c6699a
--- /dev/null
+++ b/drivers/of/unittest-data/overlay_gpio_04b.dts
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+/dts-v1/;
+/plugin/;
+
+&unittest_test_bus {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	gpio@4 {
+		line-c {
+			gpio-hog;
+			gpios = <3 0>;
+			input;
+			line-name = "line-C-input";
+		};
+	};
+};
diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 1ed470b03cd7..7585df5e3daf 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -23,6 +23,7 @@
 
 #include <linux/i2c.h>
 #include <linux/i2c-mux.h>
+#include <linux/gpio/driver.h>
 
 #include <linux/bitops.h>
 
@@ -45,6 +46,97 @@ static struct unittest_results {
 	failed; \
 })
 
+/*
+ * Expected message may have a message level other than KERN_INFO.
+ * Print the expected message only if the current loglevel will allow
+ * the actual message to print.
+ */
+#define EXPECT_BEGIN(level, fmt, ...) \
+	printk(level pr_fmt("EXPECT \\ : ") fmt, ##__VA_ARGS__)
+
+#define EXPECT_END(level, fmt, ...) \
+	printk(level pr_fmt("EXPECT / : ") fmt, ##__VA_ARGS__)
+
+struct unittest_gpio_dev {
+	struct gpio_chip chip;
+};
+
+static int unittest_gpio_chip_request_count;
+static int unittest_gpio_probe_count;
+static int unittest_gpio_probe_pass_count;
+
+static int unittest_gpio_chip_request(struct gpio_chip *chip, unsigned int offset)
+{
+	unittest_gpio_chip_request_count++;
+
+	pr_debug("%s(): %s %d %d\n", __func__, chip->label, offset,
+		 unittest_gpio_chip_request_count);
+	return 0;
+}
+
+static int unittest_gpio_probe(struct platform_device *pdev)
+{
+	struct unittest_gpio_dev *devptr;
+	int ret;
+
+	unittest_gpio_probe_count++;
+
+	devptr = kzalloc(sizeof(*devptr), GFP_KERNEL);
+	if (!devptr)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, devptr);
+
+	devptr->chip.of_node = pdev->dev.of_node;
+	devptr->chip.label = "of-unittest-gpio";
+	devptr->chip.base = -1; /* dynamic allocation */
+	devptr->chip.ngpio = 5;
+	devptr->chip.request = unittest_gpio_chip_request;
+
+	ret = gpiochip_add_data(&devptr->chip, NULL);
+
+	unittest(!ret,
+		 "gpiochip_add_data() for node @%pOF failed, ret = %d\n", devptr->chip.of_node, ret);
+
+	if (!ret)
+		unittest_gpio_probe_pass_count++;
+	return ret;
+}
+
+static int unittest_gpio_remove(struct platform_device *pdev)
+{
+	struct unittest_gpio_dev *gdev = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+	struct device_node *np = pdev->dev.of_node;
+
+	dev_dbg(dev, "%s for node @%pOF\n", __func__, np);
+
+	if (!gdev)
+		return -EINVAL;
+
+	if (gdev->chip.base != -1)
+		gpiochip_remove(&gdev->chip);
+
+	platform_set_drvdata(pdev, NULL);
+	kfree(pdev);
+
+	return 0;
+}
+
+static const struct of_device_id unittest_gpio_id[] = {
+	{ .compatible = "unittest-gpio", },
+	{}
+};
+
+static struct platform_driver unittest_gpio_driver = {
+	.probe	= unittest_gpio_probe,
+	.remove	= unittest_gpio_remove,
+	.driver	= {
+		.name		= "unittest-gpio",
+		.of_match_table	= of_match_ptr(unittest_gpio_id),
+	},
+};
+
 static void __init of_unittest_find_node_by_name(void)
 {
 	struct device_node *np;
@@ -2114,6 +2206,153 @@ static inline void of_unittest_overlay_i2c_15(void) { }
 
 #endif
 
+static void __init of_unittest_overlay_gpio(void)
+{
+	int chip_request_count;
+	int probe_pass_count;
+	int ret;
+
+	/*
+	 * tests: apply overlays before registering driver
+	 * Similar to installing a driver as a module, the
+	 * driver is registered after applying the overlays.
+	 *
+	 * - apply overlay_gpio_01
+	 * - apply overlay_gpio_02a
+	 * - apply overlay_gpio_02b
+	 * - register driver
+	 *
+	 * register driver will result in
+	 *   - probe and processing gpio hog for overlay_gpio_01
+	 *   - probe for overlay_gpio_02a
+	 *   - processing gpio for overlay_gpio_02b
+	 */
+
+	probe_pass_count = unittest_gpio_probe_pass_count;
+	chip_request_count = unittest_gpio_chip_request_count;
+
+	/*
+	 * overlay_gpio_01 contains gpio node and child gpio hog node
+	 * overlay_gpio_02a contains gpio node
+	 * overlay_gpio_02b contains child gpio hog node
+	 */
+
+	unittest(overlay_data_apply("overlay_gpio_01", NULL),
+		 "Adding overlay 'overlay_gpio_01' failed\n");
+
+	unittest(overlay_data_apply("overlay_gpio_02a", NULL),
+		 "Adding overlay 'overlay_gpio_02a' failed\n");
+
+	unittest(overlay_data_apply("overlay_gpio_02b", NULL),
+		 "Adding overlay 'overlay_gpio_02b' failed\n");
+
+	/*
+	 * messages are the result of the probes, after the
+	 * driver is registered
+	 */
+
+	EXPECT_BEGIN(KERN_INFO,
+		     "GPIO line <<int>> (line-B-input) hogged as input\n");
+
+	EXPECT_BEGIN(KERN_INFO,
+		     "GPIO line <<int>> (line-A-input) hogged as input\n");
+
+	ret = platform_driver_register(&unittest_gpio_driver);
+	if (unittest(ret == 0, "could not register unittest gpio driver\n"))
+		return;
+
+	EXPECT_END(KERN_INFO,
+		   "GPIO line <<int>> (line-A-input) hogged as input\n");
+	EXPECT_END(KERN_INFO,
+		   "GPIO line <<int>> (line-B-input) hogged as input\n");
+
+	unittest(probe_pass_count + 2 == unittest_gpio_probe_pass_count,
+		 "unittest_gpio_probe() failed or not called\n");
+
+	unittest(chip_request_count + 2 == unittest_gpio_chip_request_count,
+		 "unittest_gpio_chip_request() called %d times (expected 1 time)\n",
+		 unittest_gpio_chip_request_count - chip_request_count);
+
+	/*
+	 * tests: apply overlays after registering driver
+	 *
+	 * Similar to a driver built-in to the kernel, the
+	 * driver is registered before applying the overlays.
+	 *
+	 * overlay_gpio_03 contains gpio node and child gpio hog node
+	 *
+	 * - apply overlay_gpio_03
+	 *
+	 * apply overlay will result in
+	 *   - probe and processing gpio hog.
+	 */
+
+	probe_pass_count = unittest_gpio_probe_pass_count;
+	chip_request_count = unittest_gpio_chip_request_count;
+
+	EXPECT_BEGIN(KERN_INFO,
+		     "GPIO line <<int>> (line-D-input) hogged as input\n");
+
+	/* overlay_gpio_03 contains gpio node and child gpio hog node */
+
+	unittest(overlay_data_apply("overlay_gpio_03", NULL),
+		 "Adding overlay 'overlay_gpio_03' failed\n");
+
+	EXPECT_END(KERN_INFO,
+		   "GPIO line <<int>> (line-D-input) hogged as input\n");
+
+	unittest(probe_pass_count + 1 == unittest_gpio_probe_pass_count,
+		 "unittest_gpio_probe() failed or not called\n");
+
+	unittest(chip_request_count + 1 == unittest_gpio_chip_request_count,
+		 "unittest_gpio_chip_request() called %d times (expected 1 time)\n",
+		 unittest_gpio_chip_request_count - chip_request_count);
+
+	/*
+	 * overlay_gpio_04a contains gpio node
+	 *
+	 * - apply overlay_gpio_04a
+	 *
+	 * apply the overlay will result in
+	 *   - probe for overlay_gpio_04a
+	 */
+
+	probe_pass_count = unittest_gpio_probe_pass_count;
+	chip_request_count = unittest_gpio_chip_request_count;
+
+	/* overlay_gpio_04a contains gpio node */
+
+	unittest(overlay_data_apply("overlay_gpio_04a", NULL),
+		 "Adding overlay 'overlay_gpio_04a' failed\n");
+
+	unittest(probe_pass_count + 1 == unittest_gpio_probe_pass_count,
+		 "unittest_gpio_probe() failed or not called\n");
+
+	/*
+	 * overlay_gpio_04b contains child gpio hog node
+	 *
+	 * - apply overlay_gpio_04b
+	 *
+	 * apply the overlay will result in
+	 *   - processing gpio for overlay_gpio_04b
+	 */
+
+	EXPECT_BEGIN(KERN_INFO,
+		     "GPIO line <<int>> (line-C-input) hogged as input\n");
+
+	/* overlay_gpio_04b contains child gpio hog node */
+
+	unittest(overlay_data_apply("overlay_gpio_04b", NULL),
+		 "Adding overlay 'overlay_gpio_04b' failed\n");
+
+	EXPECT_END(KERN_INFO,
+		   "GPIO line <<int>> (line-C-input) hogged as input\n");
+
+	unittest(chip_request_count + 1 == unittest_gpio_chip_request_count,
+		 "unittest_gpio_chip_request() called %d times (expected 1 time)\n",
+		 unittest_gpio_chip_request_count - chip_request_count);
+}
+
 static void __init of_unittest_overlay(void)
 {
 	struct device_node *bus_np = NULL;
@@ -2173,6 +2412,8 @@ static void __init of_unittest_overlay(void)
 	of_unittest_overlay_i2c_cleanup();
 #endif
 
+	of_unittest_overlay_gpio();
+
 	of_unittest_destroy_tracked_overlays();
 
 out:
@@ -2226,6 +2467,12 @@ OVERLAY_INFO_EXTERN(overlay_11);
 OVERLAY_INFO_EXTERN(overlay_12);
 OVERLAY_INFO_EXTERN(overlay_13);
 OVERLAY_INFO_EXTERN(overlay_15);
+OVERLAY_INFO_EXTERN(overlay_gpio_01);
+OVERLAY_INFO_EXTERN(overlay_gpio_02a);
+OVERLAY_INFO_EXTERN(overlay_gpio_02b);
+OVERLAY_INFO_EXTERN(overlay_gpio_03);
+OVERLAY_INFO_EXTERN(overlay_gpio_04a);
+OVERLAY_INFO_EXTERN(overlay_gpio_04b);
 OVERLAY_INFO_EXTERN(overlay_bad_add_dup_node);
 OVERLAY_INFO_EXTERN(overlay_bad_add_dup_prop);
 OVERLAY_INFO_EXTERN(overlay_bad_phandle);
@@ -2250,6 +2497,12 @@ static struct overlay_info overlays[] = {
 	OVERLAY_INFO(overlay_12, 0),
 	OVERLAY_INFO(overlay_13, 0),
 	OVERLAY_INFO(overlay_15, 0),
+	OVERLAY_INFO(overlay_gpio_01, 0),
+	OVERLAY_INFO(overlay_gpio_02a, 0),
+	OVERLAY_INFO(overlay_gpio_02b, 0),
+	OVERLAY_INFO(overlay_gpio_03, 0),
+	OVERLAY_INFO(overlay_gpio_04a, 0),
+	OVERLAY_INFO(overlay_gpio_04b, 0),
 	OVERLAY_INFO(overlay_bad_add_dup_node, -EINVAL),
 	OVERLAY_INFO(overlay_bad_add_dup_prop, -EINVAL),
 	OVERLAY_INFO(overlay_bad_phandle, -EINVAL),
-- 
2.43.0



