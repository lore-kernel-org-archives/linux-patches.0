Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE5522B8AB;
	Thu,  3 Jul 2025 15:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555733; cv=none; b=J74/q8sfQQH5begaFIIjfG5kDdySruffI4eJooAravgA60F23eJogMJQiNLxt22KWTsKWkUjcpRN57DJx60b+EN8Jh6Wkr30qejbS3xtskAo0quP6qhTlWiJwigpZurtvXz9P9rkmvsQQ5Ils6epJYD5yYYYVDQ8KlqhqqX+nEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555733; c=relaxed/simple;
	bh=K/n8zeHwSccs13NNe7qQ5fOtdApmfKGnqca4sIzbFu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hD7IVZe4sniNIIsmO/KvCrxGU3gd12dmXFMd2FggcH8rs9dY0lqZsg6Z+P5o+IOjlXhXLAXUvip9y8VQKc6BD7tae7iWWuq3DY7y7KynmzfmG9+S2Rwc+8tj5wGEsBiWIVYu4Rt+amWGysxbd533c3M+Qmf2izto9RUomaqng4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1o4SINYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1o4SINYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA828C4CEE3;
	Thu,  3 Jul 2025 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555733;
	bh=K/n8zeHwSccs13NNe7qQ5fOtdApmfKGnqca4sIzbFu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1o4SINYlLXwDl7Gq2F/I1SCqj5Xeb2Wv3LGJ++G22GEKPN9K1DFcGCY9Y2i4uYR5G
	 rXVrAxQsKwVFk4VaFJJ5WUOUPmrJ9b+7bUeWPhqCvgMoXuYCg4TyHPNKMsYc9Olcjw
	 5ZPmEEC+jax4XymMWXJhwz4U8UAjPwp4mGt/oYQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/139] platform/x86: ideapad-laptop: move ACPI helpers from header to source file
Date: Thu,  3 Jul 2025 16:42:07 +0200
Message-ID: <20250703143943.668727834@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

[ Upstream commit 6c1fa8edfef815a97db57f30216265bfa152792d ]

Since moving ymc_trigger_ec from lenovo-ymc to ideapad-laptop, only the
latter uses these definitions and functions.

Move them back to source file.

Signed-off-by: Gergo Koteles <soyer@irl.hu>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/57a48d2582b567f6c6fbcd3b379e17aee0fb5a94.1721898747.git.soyer@irl.hu
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 5808c3421695 ("platform/x86: ideapad-laptop: use usleep_range() for EC polling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 136 +++++++++++++++++++++++++
 drivers/platform/x86/ideapad-laptop.h | 139 --------------------------
 2 files changed, 136 insertions(+), 139 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 3d23c4f908426..db8256cde34aa 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
+#include <linux/jiffies.h>
 #include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/module.h>
@@ -86,6 +87,34 @@ enum {
 	SALS_FNLOCK_OFF       = 0xf,
 };
 
+enum {
+	VPCCMD_R_VPC1 = 0x10,
+	VPCCMD_R_BL_MAX,
+	VPCCMD_R_BL,
+	VPCCMD_W_BL,
+	VPCCMD_R_WIFI,
+	VPCCMD_W_WIFI,
+	VPCCMD_R_BT,
+	VPCCMD_W_BT,
+	VPCCMD_R_BL_POWER,
+	VPCCMD_R_NOVO,
+	VPCCMD_R_VPC2,
+	VPCCMD_R_TOUCHPAD,
+	VPCCMD_W_TOUCHPAD,
+	VPCCMD_R_CAMERA,
+	VPCCMD_W_CAMERA,
+	VPCCMD_R_3G,
+	VPCCMD_W_3G,
+	VPCCMD_R_ODD, /* 0x21 */
+	VPCCMD_W_FAN,
+	VPCCMD_R_RF,
+	VPCCMD_W_RF,
+	VPCCMD_W_YMC = 0x2A,
+	VPCCMD_R_FAN = 0x2B,
+	VPCCMD_R_SPECIAL_BUTTONS = 0x31,
+	VPCCMD_W_BL_POWER = 0x33,
+};
+
 /*
  * These correspond to the number of supported states - 1
  * Future keyboard types may need a new system, if there's a collision
@@ -234,6 +263,7 @@ static void ideapad_shared_exit(struct ideapad_private *priv)
 /*
  * ACPI Helpers
  */
+#define IDEAPAD_EC_TIMEOUT 200 /* in ms */
 
 static int eval_int(acpi_handle handle, const char *name, unsigned long *res)
 {
@@ -249,6 +279,29 @@ static int eval_int(acpi_handle handle, const char *name, unsigned long *res)
 	return 0;
 }
 
+static int eval_int_with_arg(acpi_handle handle, const char *name, unsigned long arg,
+			     unsigned long *res)
+{
+	struct acpi_object_list params;
+	unsigned long long result;
+	union acpi_object in_obj;
+	acpi_status status;
+
+	params.count = 1;
+	params.pointer = &in_obj;
+	in_obj.type = ACPI_TYPE_INTEGER;
+	in_obj.integer.value = arg;
+
+	status = acpi_evaluate_integer(handle, (char *)name, &params, &result);
+	if (ACPI_FAILURE(status))
+		return -EIO;
+
+	if (res)
+		*res = result;
+
+	return 0;
+}
+
 static int exec_simple_method(acpi_handle handle, const char *name, unsigned long arg)
 {
 	acpi_status status = acpi_execute_simple_method(handle, (char *)name, arg);
@@ -291,6 +344,89 @@ static int eval_dytc(acpi_handle handle, unsigned long cmd, unsigned long *res)
 	return eval_int_with_arg(handle, "DYTC", cmd, res);
 }
 
+static int eval_vpcr(acpi_handle handle, unsigned long cmd, unsigned long *res)
+{
+	return eval_int_with_arg(handle, "VPCR", cmd, res);
+}
+
+static int eval_vpcw(acpi_handle handle, unsigned long cmd, unsigned long data)
+{
+	struct acpi_object_list params;
+	union acpi_object in_obj[2];
+	acpi_status status;
+
+	params.count = 2;
+	params.pointer = in_obj;
+	in_obj[0].type = ACPI_TYPE_INTEGER;
+	in_obj[0].integer.value = cmd;
+	in_obj[1].type = ACPI_TYPE_INTEGER;
+	in_obj[1].integer.value = data;
+
+	status = acpi_evaluate_object(handle, "VPCW", &params, NULL);
+	if (ACPI_FAILURE(status))
+		return -EIO;
+
+	return 0;
+}
+
+static int read_ec_data(acpi_handle handle, unsigned long cmd, unsigned long *data)
+{
+	unsigned long end_jiffies, val;
+	int err;
+
+	err = eval_vpcw(handle, 1, cmd);
+	if (err)
+		return err;
+
+	end_jiffies = jiffies + msecs_to_jiffies(IDEAPAD_EC_TIMEOUT) + 1;
+
+	while (time_before(jiffies, end_jiffies)) {
+		schedule();
+
+		err = eval_vpcr(handle, 1, &val);
+		if (err)
+			return err;
+
+		if (val == 0)
+			return eval_vpcr(handle, 0, data);
+	}
+
+	acpi_handle_err(handle, "timeout in %s\n", __func__);
+
+	return -ETIMEDOUT;
+}
+
+static int write_ec_cmd(acpi_handle handle, unsigned long cmd, unsigned long data)
+{
+	unsigned long end_jiffies, val;
+	int err;
+
+	err = eval_vpcw(handle, 0, data);
+	if (err)
+		return err;
+
+	err = eval_vpcw(handle, 1, cmd);
+	if (err)
+		return err;
+
+	end_jiffies = jiffies + msecs_to_jiffies(IDEAPAD_EC_TIMEOUT) + 1;
+
+	while (time_before(jiffies, end_jiffies)) {
+		schedule();
+
+		err = eval_vpcr(handle, 1, &val);
+		if (err)
+			return err;
+
+		if (val == 0)
+			return 0;
+	}
+
+	acpi_handle_err(handle, "timeout in %s\n", __func__);
+
+	return -ETIMEDOUT;
+}
+
 /*
  * debugfs
  */
diff --git a/drivers/platform/x86/ideapad-laptop.h b/drivers/platform/x86/ideapad-laptop.h
index 948cc61800a95..1e52f2aa0aac3 100644
--- a/drivers/platform/x86/ideapad-laptop.h
+++ b/drivers/platform/x86/ideapad-laptop.h
@@ -9,9 +9,6 @@
 #ifndef _IDEAPAD_LAPTOP_H_
 #define _IDEAPAD_LAPTOP_H_
 
-#include <linux/acpi.h>
-#include <linux/jiffies.h>
-#include <linux/errno.h>
 #include <linux/notifier.h>
 
 enum ideapad_laptop_notifier_actions {
@@ -22,140 +19,4 @@ int ideapad_laptop_register_notifier(struct notifier_block *nb);
 int ideapad_laptop_unregister_notifier(struct notifier_block *nb);
 void ideapad_laptop_call_notifier(unsigned long action, void *data);
 
-enum {
-	VPCCMD_R_VPC1 = 0x10,
-	VPCCMD_R_BL_MAX,
-	VPCCMD_R_BL,
-	VPCCMD_W_BL,
-	VPCCMD_R_WIFI,
-	VPCCMD_W_WIFI,
-	VPCCMD_R_BT,
-	VPCCMD_W_BT,
-	VPCCMD_R_BL_POWER,
-	VPCCMD_R_NOVO,
-	VPCCMD_R_VPC2,
-	VPCCMD_R_TOUCHPAD,
-	VPCCMD_W_TOUCHPAD,
-	VPCCMD_R_CAMERA,
-	VPCCMD_W_CAMERA,
-	VPCCMD_R_3G,
-	VPCCMD_W_3G,
-	VPCCMD_R_ODD, /* 0x21 */
-	VPCCMD_W_FAN,
-	VPCCMD_R_RF,
-	VPCCMD_W_RF,
-	VPCCMD_W_YMC = 0x2A,
-	VPCCMD_R_FAN = 0x2B,
-	VPCCMD_R_SPECIAL_BUTTONS = 0x31,
-	VPCCMD_W_BL_POWER = 0x33,
-};
-
-static inline int eval_int_with_arg(acpi_handle handle, const char *name, unsigned long arg, unsigned long *res)
-{
-	struct acpi_object_list params;
-	unsigned long long result;
-	union acpi_object in_obj;
-	acpi_status status;
-
-	params.count = 1;
-	params.pointer = &in_obj;
-	in_obj.type = ACPI_TYPE_INTEGER;
-	in_obj.integer.value = arg;
-
-	status = acpi_evaluate_integer(handle, (char *)name, &params, &result);
-	if (ACPI_FAILURE(status))
-		return -EIO;
-
-	if (res)
-		*res = result;
-
-	return 0;
-}
-
-static inline int eval_vpcr(acpi_handle handle, unsigned long cmd, unsigned long *res)
-{
-	return eval_int_with_arg(handle, "VPCR", cmd, res);
-}
-
-static inline int eval_vpcw(acpi_handle handle, unsigned long cmd, unsigned long data)
-{
-	struct acpi_object_list params;
-	union acpi_object in_obj[2];
-	acpi_status status;
-
-	params.count = 2;
-	params.pointer = in_obj;
-	in_obj[0].type = ACPI_TYPE_INTEGER;
-	in_obj[0].integer.value = cmd;
-	in_obj[1].type = ACPI_TYPE_INTEGER;
-	in_obj[1].integer.value = data;
-
-	status = acpi_evaluate_object(handle, "VPCW", &params, NULL);
-	if (ACPI_FAILURE(status))
-		return -EIO;
-
-	return 0;
-}
-
-#define IDEAPAD_EC_TIMEOUT 200 /* in ms */
-
-static inline int read_ec_data(acpi_handle handle, unsigned long cmd, unsigned long *data)
-{
-	unsigned long end_jiffies, val;
-	int err;
-
-	err = eval_vpcw(handle, 1, cmd);
-	if (err)
-		return err;
-
-	end_jiffies = jiffies + msecs_to_jiffies(IDEAPAD_EC_TIMEOUT) + 1;
-
-	while (time_before(jiffies, end_jiffies)) {
-		schedule();
-
-		err = eval_vpcr(handle, 1, &val);
-		if (err)
-			return err;
-
-		if (val == 0)
-			return eval_vpcr(handle, 0, data);
-	}
-
-	acpi_handle_err(handle, "timeout in %s\n", __func__);
-
-	return -ETIMEDOUT;
-}
-
-static inline int write_ec_cmd(acpi_handle handle, unsigned long cmd, unsigned long data)
-{
-	unsigned long end_jiffies, val;
-	int err;
-
-	err = eval_vpcw(handle, 0, data);
-	if (err)
-		return err;
-
-	err = eval_vpcw(handle, 1, cmd);
-	if (err)
-		return err;
-
-	end_jiffies = jiffies + msecs_to_jiffies(IDEAPAD_EC_TIMEOUT) + 1;
-
-	while (time_before(jiffies, end_jiffies)) {
-		schedule();
-
-		err = eval_vpcr(handle, 1, &val);
-		if (err)
-			return err;
-
-		if (val == 0)
-			return 0;
-	}
-
-	acpi_handle_err(handle, "timeout in %s\n", __func__);
-
-	return -ETIMEDOUT;
-}
-
-#undef IDEAPAD_EC_TIMEOUT
 #endif /* !_IDEAPAD_LAPTOP_H_ */
-- 
2.39.5



