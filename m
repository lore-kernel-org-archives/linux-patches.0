Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F12D34752E;
	Sat, 12 Sep 2026 10:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210681; cv=none; b=basKKR8fU26jDhKecMfy3ndJT50uDLH2pbOCISJaouuA1cw/6WgkAjV+gZAhJCFk7t6LoidHr3+VmabJE4+jRlbrrQjJZdN1hx2aGruk9uR8+rBFvEX746vnewhp3V826wltGuks50eOdF7mzITpRgUrTHPWVNBLvVYKD5TvHdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210681; c=relaxed/simple;
	bh=rAkaiISm3GrQ57jKSygiqEgT2r8SHEj8stjkPvcyQT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o6hk4am0HEpxlMkFEvJvgBWpLfJsUtbC+lDbwkKmAqjJiMrGg5ullCkzNjOZpMXsY7Vm0a7ECDolvu7Bt+GCSDIOY8d/1tMMk7tSgd9A7rlByAD0rVM3TOTbY4YifJJoeb7dgtsxBMSemRJ6loYCsxZZvs7AdBSkSGeV8r2SYh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ba8tZS8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ba8tZS8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200C91F000FF;
	Sat, 12 Sep 2026 10:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210680;
	bh=N8Nsa13eQwkmT77hhjh+SOpvFhKZ9hwRkGwkvMpE5bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ba8tZS8UVNNbxVL4ep/lXlAKOYfke37Oa9Rte1sLZbZEpDrlSzRuu4/Nk1Lku3QtY
	 LzWTGzVNnOeJgWdVYMNyfOjoY6Iy2w4/fFjKAOO1KcG2vlbzOE5fUFiMZqg9NQOFxT
	 1zWyxvU6P0h+AYQskJ6z+lxvFndwM+CxqbzfLuD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1076/1518] hwmon: (cros_ec) Move temperature channel params to a macro
Date: Sat, 12 Sep 2026 08:54:05 +0200
Message-ID: <20260912065647.790168064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 11c5802d28dd71fffb4df0720eafe840a953dc92 ]

An upcoming change will add more channel parameters.
This leads to a lot of churn and very long lines.

Use a macro to encapsulate all of the shared values.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20260118-cros_ec-hwmon-pwm-v2-3-77eb1709b031@weissschuh.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 26db27364088 ("hwmon: (cros_ec) Synchronize EC access from the thermal device callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/cros_ec_hwmon.c | 49 ++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/hwmon/cros_ec_hwmon.c b/drivers/hwmon/cros_ec_hwmon.c
index 48331703f2f50..9b5759e91c725 100644
--- a/drivers/hwmon/cros_ec_hwmon.c
+++ b/drivers/hwmon/cros_ec_hwmon.c
@@ -286,31 +286,32 @@ static const struct hwmon_channel_info * const cros_ec_hwmon_info[] = {
 			   HWMON_PWM_INPUT | HWMON_PWM_ENABLE,
 			   HWMON_PWM_INPUT | HWMON_PWM_ENABLE,
 			   HWMON_PWM_INPUT | HWMON_PWM_ENABLE),
+#define CROS_EC_HWMON_TEMP_PARAMS (HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL)
 	HWMON_CHANNEL_INFO(temp,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL,
-			   HWMON_T_INPUT | HWMON_T_FAULT | HWMON_T_LABEL),
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS,
+			   CROS_EC_HWMON_TEMP_PARAMS),
 	NULL
 };
 
-- 
2.53.0



