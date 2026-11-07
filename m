Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064680;
	b=L5H/5YRyXslMo/FIt4ujusEHWgnuc9PFpI4LXcSA2J/pRQ4A8ZMKZChwmQ9OfYUIayxr
	 MH8P+rMMAuHEgDB0uhbA7v3HIUM2+55m2awu4LKaGxT29pvRIkQTZsURxERhhLHVY6+Ps
	 sbgX+pVgV2PXKP8TlVTD8PP5cEGELwAoLaiVDfYJTHX6VNgs9tdPZypP8d4BM49Wkvxgf
	 OJ2oYOEq9gz5DvrgZN5m0egoCE7SCzaKn8vIs6f9QT36Laaq2MEYTMRj7h0TFPGMZXb5W
	 Cc+YvL316FIv7DyK4/La/SLa2mWLQbtHT66EXb0waD3UESNBwJCUVJ8QCLOVeBU9RGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rARQjjGYpzDRXAy/9savjSxabpoXBZXRAy/WxPUVF6M=;
	b=V/9UtcuW0B2BhTMYV9oVJezuMyC6EdEhJ3N2Y+jH8JfnK39HYelPtfgmPpRlqaKBOAjE
	 Fvv1I7XQJ0SMVf3gk5HbCJ6LyeUCXLZHRmCQWV15gIUmkfAxbgrtankV4BANT1Ztd9jl1
	 29f/zey1CuSsKL+TNFsQli3XRe6vy9YI/ikqeOmmlEdfA0v0JZB0DW7F2U/CzvJLZLRja
	 NwGrQjxXOuSF3+Zs4RWo+kf3SjuKDVUYIV9mqOUjBzZAaveWZ+kMvV9rhTl2mBgsilDSp
	 BinZs8UDhNbtFExY0yI7DYEmo4Ly/+S5ErA9Fanci98KUTuWXEfMoMvuCkgQjcg6Aeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIG7HioX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BC3606B8A5;
	Sat,  7 Nov 2026 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wIG7HioX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF3C1F008A2;
	Sat,  7 Nov 2026 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064680;
	bh=rARQjjGYpzDRXAy/9savjSxabpoXBZXRAy/WxPUVF6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wIG7HioXPf1Xh/zF3ZqrEDagxRJpvPRAARUKKTOa0OrFFD04/s0cWTVJTt4N7x+Iy
	 onX6+2dvj32ji3pC6AIQhooF85WjRH9tKYZbQTFM9SH4mUiMgoCn3FRx4Fz8PD+pfM
	 giYTu2wQKUGKd+hvmhmLE6zXbHsR6nB3L6QMKb64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	"Derek J. Clark" <derekjohn.clark@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0676/1257] platform/x86: oxpec: Fix Apex charge limit control
Date: Sat,  7 Nov 2026 08:49:32 -0500
Message-ID: <20261107134957.931731457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 0ccdf9a1381c7fb6d9e84abeb8e5d6c85dd07059 ]

The OneXPlayer Apex uses E5/E6 for battery bypass / charge limit, making
it the first device to deviate. This was verified by a user on Windows
with BIOS version 2.17 and later by running this kernel patch.

Drop X1_ from the MASK variables as they are common in all devices,
introduce a board enum for Apex, and make it use the new E5/E6 registers
for charge limit / bypass. Apply the same quirks as oxp_fly, since APEX
uses the same registers otherwise.

Fixes: 3385ea97c14d ("platform/x86: oxpec: Add support for OneXPlayer APEX")
Cc: stable@vger.kernel.org
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Reviewed-by: Derek J. Clark <derekjohn.clark@gmail.com>
Link: https://patch.msgid.link/20260920190438.3444923-1-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 68 ++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 15 deletions(-)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index 34bb17fca1481..38c272995437e 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -50,6 +50,7 @@ enum oxp_board {
 	oxp_x1,
 	oxp_g1_i,
 	oxp_g1_a,
+	oxp_apex,
 };
 
 static enum oxp_board board;
@@ -93,11 +94,14 @@ static struct device *oxp_dev;
 #define OXP_X1_CHARGE_LIMIT_REG		0xA3 /* X1 charge limit (%) */
 #define OXP_X1_CHARGE_INHIBIT_REG	0xA4 /* X1 bypass charging */
 
-#define OXP_X1_CHARGE_INHIBIT_MASK_AWAKE	0x01
+#define OXP_APEX_CHARGE_LIMIT_REG	0xE5 /* Apex charge limit (%) */
+#define OXP_APEX_CHARGE_INHIBIT_REG	0xE6 /* Apex bypass charging */
+
+#define OXP_CHARGE_INHIBIT_MASK_AWAKE	0x01
 /* X1 Mask is 0x0A, F1Pro is 0x02 but the extra bit on the X1 does nothing. */
-#define OXP_X1_CHARGE_INHIBIT_MASK_OFF		0x02
-#define OXP_X1_CHARGE_INHIBIT_MASK_ALWAYS	(OXP_X1_CHARGE_INHIBIT_MASK_AWAKE | \
-						 OXP_X1_CHARGE_INHIBIT_MASK_OFF)
+#define OXP_CHARGE_INHIBIT_MASK_OFF		0x02
+#define OXP_CHARGE_INHIBIT_MASK_ALWAYS	(OXP_CHARGE_INHIBIT_MASK_AWAKE | \
+					 OXP_CHARGE_INHIBIT_MASK_OFF)
 
 static const struct dmi_system_id dmi_table[] = {
 	{
@@ -154,7 +158,7 @@ static const struct dmi_system_id dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER APEX"),
 		},
-		.driver_data = (void *)oxp_fly,
+		.driver_data = (void *)oxp_apex,
 	},
 	{
 		.matches = {
@@ -352,6 +356,7 @@ static umode_t tt_toggle_is_visible(struct kobject *kobj,
 	case oxp_x1:
 	case oxp_g1_i:
 	case oxp_g1_a:
+	case oxp_apex:
 		return attr->mode;
 	default:
 		break;
@@ -381,6 +386,7 @@ static ssize_t tt_toggle_store(struct device *dev,
 	case oxp_fly:
 	case oxp_mini_amd_pro:
 	case oxp_g1_a:
+	case oxp_apex:
 		reg = OXP_TURBO_SWITCH_REG;
 		mask = OXP_TURBO_TAKE_VAL;
 		break;
@@ -427,6 +433,7 @@ static ssize_t tt_toggle_show(struct device *dev,
 	case oxp_fly:
 	case oxp_mini_amd_pro:
 	case oxp_g1_a:
+	case oxp_apex:
 		reg = OXP_TURBO_SWITCH_REG;
 		mask = OXP_TURBO_TAKE_VAL;
 		break;
@@ -524,6 +531,7 @@ static bool oxp_psy_ext_supported(void)
 	case oxp_g1_i:
 	case oxp_g1_a:
 	case oxp_fly:
+	case oxp_apex:
 		return true;
 	default:
 		break;
@@ -537,12 +545,24 @@ static int oxp_psy_ext_get_prop(struct power_supply *psy,
 				enum power_supply_property psp,
 				union power_supply_propval *val)
 {
+	u8 limit_reg, inhibit_reg;
 	long raw_val;
 	int ret;
 
+	switch (board) {
+	case oxp_apex:
+		limit_reg = OXP_APEX_CHARGE_LIMIT_REG;
+		inhibit_reg = OXP_APEX_CHARGE_INHIBIT_REG;
+		break;
+	default:
+		limit_reg = OXP_X1_CHARGE_LIMIT_REG;
+		inhibit_reg = OXP_X1_CHARGE_INHIBIT_REG;
+		break;
+	}
+
 	switch (psp) {
 	case POWER_SUPPLY_PROP_CHARGE_CONTROL_END_THRESHOLD:
-		ret = read_from_ec(OXP_X1_CHARGE_LIMIT_REG, 1, &raw_val);
+		ret = read_from_ec(limit_reg, 1, &raw_val);
 		if (ret)
 			return ret;
 		if (raw_val < 0 || raw_val > 100)
@@ -550,14 +570,14 @@ static int oxp_psy_ext_get_prop(struct power_supply *psy,
 		val->intval = raw_val;
 		return 0;
 	case POWER_SUPPLY_PROP_CHARGE_BEHAVIOUR:
-		ret = read_from_ec(OXP_X1_CHARGE_INHIBIT_REG, 1, &raw_val);
+		ret = read_from_ec(inhibit_reg, 1, &raw_val);
 		if (ret)
 			return ret;
-		if ((raw_val & OXP_X1_CHARGE_INHIBIT_MASK_ALWAYS) ==
-		    OXP_X1_CHARGE_INHIBIT_MASK_ALWAYS)
+		if ((raw_val & OXP_CHARGE_INHIBIT_MASK_ALWAYS) ==
+		    OXP_CHARGE_INHIBIT_MASK_ALWAYS)
 			val->intval = POWER_SUPPLY_CHARGE_BEHAVIOUR_INHIBIT_CHARGE;
-		else if ((raw_val & OXP_X1_CHARGE_INHIBIT_MASK_AWAKE) ==
-			 OXP_X1_CHARGE_INHIBIT_MASK_AWAKE)
+		else if ((raw_val & OXP_CHARGE_INHIBIT_MASK_AWAKE) ==
+			 OXP_CHARGE_INHIBIT_MASK_AWAKE)
 			val->intval = POWER_SUPPLY_CHARGE_BEHAVIOUR_INHIBIT_CHARGE_AWAKE;
 		else
 			val->intval = POWER_SUPPLY_CHARGE_BEHAVIOUR_AUTO;
@@ -573,29 +593,41 @@ static int oxp_psy_ext_set_prop(struct power_supply *psy,
 				enum power_supply_property psp,
 				const union power_supply_propval *val)
 {
+	u8 limit_reg, inhibit_reg;
 	long raw_val;
 
+	switch (board) {
+	case oxp_apex:
+		limit_reg = OXP_APEX_CHARGE_LIMIT_REG;
+		inhibit_reg = OXP_APEX_CHARGE_INHIBIT_REG;
+		break;
+	default:
+		limit_reg = OXP_X1_CHARGE_LIMIT_REG;
+		inhibit_reg = OXP_X1_CHARGE_INHIBIT_REG;
+		break;
+	}
+
 	switch (psp) {
 	case POWER_SUPPLY_PROP_CHARGE_CONTROL_END_THRESHOLD:
 		if (val->intval < 0 || val->intval > 100)
 			return -EINVAL;
-		return write_to_ec(OXP_X1_CHARGE_LIMIT_REG, val->intval);
+		return write_to_ec(limit_reg, val->intval);
 	case POWER_SUPPLY_PROP_CHARGE_BEHAVIOUR:
 		switch (val->intval) {
 		case POWER_SUPPLY_CHARGE_BEHAVIOUR_AUTO:
 			raw_val = 0;
 			break;
 		case POWER_SUPPLY_CHARGE_BEHAVIOUR_INHIBIT_CHARGE_AWAKE:
-			raw_val = OXP_X1_CHARGE_INHIBIT_MASK_AWAKE;
+			raw_val = OXP_CHARGE_INHIBIT_MASK_AWAKE;
 			break;
 		case POWER_SUPPLY_CHARGE_BEHAVIOUR_INHIBIT_CHARGE:
-			raw_val = OXP_X1_CHARGE_INHIBIT_MASK_ALWAYS;
+			raw_val = OXP_CHARGE_INHIBIT_MASK_ALWAYS;
 			break;
 		default:
 			return -EINVAL;
 		}
 
-		return write_to_ec(OXP_X1_CHARGE_INHIBIT_REG, raw_val);
+		return write_to_ec(inhibit_reg, raw_val);
 	default:
 		return -EINVAL;
 	}
@@ -656,6 +688,7 @@ static int oxp_pwm_enable(void)
 	case oxp_x1:
 	case oxp_g1_i:
 	case oxp_g1_a:
+	case oxp_apex:
 		return write_to_ec(OXP_SENSOR_PWM_ENABLE_REG, PWM_MODE_MANUAL);
 	default:
 		return -EINVAL;
@@ -676,6 +709,7 @@ static int oxp_pwm_disable(void)
 	case oxp_x1:
 	case oxp_g1_i:
 	case oxp_g1_a:
+	case oxp_apex:
 		return write_to_ec(OXP_SENSOR_PWM_ENABLE_REG, PWM_MODE_AUTO);
 	default:
 		return -EINVAL;
@@ -696,6 +730,7 @@ static int oxp_pwm_read(long *val)
 	case oxp_x1:
 	case oxp_g1_i:
 	case oxp_g1_a:
+	case oxp_apex:
 		return read_from_ec(OXP_SENSOR_PWM_ENABLE_REG, 1, val);
 	default:
 		return -EOPNOTSUPP;
@@ -732,6 +767,7 @@ static int oxp_pwm_fan_speed(long *val)
 	case oxp_mini_amd_a07:
 	case oxp_mini_amd_pro:
 	case oxp_g1_a:
+	case oxp_apex:
 		return read_from_ec(OXP_SENSOR_FAN_REG, 2, val);
 	default:
 		return -EOPNOTSUPP;
@@ -764,6 +800,7 @@ static int oxp_pwm_input_write(long val)
 	case oxp_fly:
 	case oxp_mini_amd_pro:
 	case oxp_g1_a:
+	case oxp_apex:
 		return write_to_ec(OXP_SENSOR_PWM_REG, val);
 	default:
 		return -EOPNOTSUPP;
@@ -803,6 +840,7 @@ static int oxp_pwm_input_read(long *val)
 	case oxp_fly:
 	case oxp_mini_amd_pro:
 	case oxp_g1_a:
+	case oxp_apex:
 	default:
 		ret = read_from_ec(OXP_SENSOR_PWM_REG, 1, val);
 		if (ret)
-- 
2.53.0



