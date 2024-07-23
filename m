Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC55156F29;
	Tue, 23 Jul 2024 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759261; cv=none; b=XCwqwvbpJN+jLoYJ9yvU/DIvGiQNODiv9KGZnefca0mI38Of95QJsoB8YBiqDvtX4HR5BEvRFKGIJvP9l96g0PyvmrcsGLDcW8bOqPZZ5zGHGHpCcYtrueb0pgbhM8cV2eOJVUMoq7XyVQorm8oUv+riCZKEUaYARoIU4D9TAaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759261; c=relaxed/simple;
	bh=DWmD0REmdxFORw3GbA8Xuj9pg7cUvnQAKfOMKq9GTPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmkmMCC4DfNnyJYfJgyPz86QOh9KknIcjfOrWKU354/xNQboXLvW9PAJCjX2xc8KzfefP5uk6sYd2lyzLkQTwi+mLD/+CY8m/D3muWQLOKnOPHWWh2Z6r15kVuz6MTRoRHVaQyenkC3O3umMSePaS+iPp846QVmKFUUYQ9C72sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aghAbpJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aghAbpJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040BDC4AF0A;
	Tue, 23 Jul 2024 18:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759261;
	bh=DWmD0REmdxFORw3GbA8Xuj9pg7cUvnQAKfOMKq9GTPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aghAbpJ0PnAOG8Wt9lXR+HkdIuT3m08WvT5J7ynhNmOMEKLtkJvqzXqVy5Xkw9oXL
	 eqDGebxGKuhMZbDf8mOKJkZFn7e+lY/hRsrfUjZGAsfvM9hMhxys+LzkhklUBA2Ojr
	 UL9Diu4LZ2DfUTWUeDmRpTwJd8K/hheNfd7CCQ74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/105] Input: i8042 - add Ayaneo Kun to i8042 quirk table
Date: Tue, 23 Jul 2024 20:23:32 +0200
Message-ID: <20240723180405.370510781@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>

[ Upstream commit 955af6355ddfe35140f9706a635838212a32513b ]

See the added comment for details. Also fix a typo in the
quirk's define.

Signed-off-by: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Link: https://lore.kernel.org/r/20240531190100.3874731-1-tjakobi@math.uni-bielefeld.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/serio/i8042-acpipnpio.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/input/serio/i8042-acpipnpio.h b/drivers/input/serio/i8042-acpipnpio.h
index dfc6c581873b7..5b50475ec4140 100644
--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -76,7 +76,7 @@ static inline void i8042_write_command(int val)
 #define SERIO_QUIRK_PROBE_DEFER		BIT(5)
 #define SERIO_QUIRK_RESET_ALWAYS	BIT(6)
 #define SERIO_QUIRK_RESET_NEVER		BIT(7)
-#define SERIO_QUIRK_DIECT		BIT(8)
+#define SERIO_QUIRK_DIRECT		BIT(8)
 #define SERIO_QUIRK_DUMBKBD		BIT(9)
 #define SERIO_QUIRK_NOLOOP		BIT(10)
 #define SERIO_QUIRK_NOTIMEOUT		BIT(11)
@@ -1332,6 +1332,20 @@ static const struct dmi_system_id i8042_dmi_quirk_table[] __initconst = {
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		/*
+		 * The Ayaneo Kun is a handheld device where some the buttons
+		 * are handled by an AT keyboard. The keyboard is usually
+		 * detected as raw, but sometimes, usually after a cold boot,
+		 * it is detected as translated. Make sure that the keyboard
+		 * is always in raw mode.
+		 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AYANEO"),
+			DMI_MATCH(DMI_BOARD_NAME, "KUN"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_DIRECT)
+	},
 	{ }
 };
 
@@ -1655,7 +1669,7 @@ static void __init i8042_check_quirks(void)
 		if (quirks & SERIO_QUIRK_RESET_NEVER)
 			i8042_reset = I8042_RESET_NEVER;
 	}
-	if (quirks & SERIO_QUIRK_DIECT)
+	if (quirks & SERIO_QUIRK_DIRECT)
 		i8042_direct = true;
 	if (quirks & SERIO_QUIRK_DUMBKBD)
 		i8042_dumbkbd = true;
-- 
2.43.0



