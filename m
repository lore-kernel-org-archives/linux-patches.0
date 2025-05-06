Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E6821C9E3;
	Tue,  6 May 2025 21:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567338; cv=none; b=IYL3E+kH/jPZ+a1WNEZh5sABbOosCZBPRmJ+++C5RfO/uwVObxGD1sGHdCn8JrL9sqCzaXAEjGof5d1lxaMvaAc4jQg3bBt/mLSeolqpFhy8xZwgAt/pb3NcmwL0FXJEidNvrkGVVVhrxWxlCLQ8LGUs+5gPgPfDGABf5qXCH9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567338; c=relaxed/simple;
	bh=pbi/kPC1mhSRu3XI/qaaJ3zd/6zy9hIcAradsicUA2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V/JoOVnkJnMsqV/M8sZfehJVGrqW0fs5/h03EsOh6vFxeYJR4CU43/eSaMMY3WP56j79KsIRMhRYlLR4RjYx34rMDWvh3JqZkaeyA8b1yCHALHvlfENd0SUrCJ9Ha6dIVzAKeP9L1P1A94Pnk85eofvcuOFgpopKcRhar1mt6Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/2qAmKD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/2qAmKD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC266C4CEEE;
	Tue,  6 May 2025 21:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567337;
	bh=pbi/kPC1mhSRu3XI/qaaJ3zd/6zy9hIcAradsicUA2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/2qAmKDlhuq7kSFZb7l9rasDMaz9l9FotmREpgQjfJQyw0pdtU4ynWcDRgoskX8/
	 X9FOn4rTLzX+a4dOBhezzYjo1x2ADJKmQnv+PT4p6q1WYehnqUZhBliy6MePbnZZKL
	 SZUw805g+OVR5ZaSTEp1gFaRLqGvr8k5IvHNg0Bvqx5oo/sjkouhWOHPHmV4VttCdM
	 MYBzACK2wPly1OLfByRK6MPYKIvsRCXcalZPFLBcSCOLlk4rFzkB/4AcdhHIVqOt3z
	 tuMdphZnP4+E1KW8/82oKlLZkdCvGxWH0KaBIG3FZWPqvdArPlCkJPmKDwCg41YqOq
	 VNn6FRCsXg6uA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pavel Nikulin <pavel@noa-labs.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	corentin.chary@gmail.com,
	luke@ljones.dev,
	hdegoede@redhat.com,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 06/20] platform/x86: asus-wmi: Disable OOBE state after resume from hibernation
Date: Tue,  6 May 2025 17:35:09 -0400
Message-Id: <20250506213523.2982756-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213523.2982756-1-sashal@kernel.org>
References: <20250506213523.2982756-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Pavel Nikulin <pavel@noa-labs.com>

[ Upstream commit 77bdac73754e4c0c564c1ca80fe3d9c93b0e715a ]

ASUS firmware resets OOBE state during S4 suspend, so the keyboard
blinks during resume from hibernation. This patch disables OOBE state
after resume from hibernation.

Signed-off-by: Pavel Nikulin <pavel@noa-labs.com>
Link: https://lore.kernel.org/r/20250418140706.1691-1-pavel@noa-labs.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 38ef778e8c19b..0c697b46f436a 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -304,6 +304,7 @@ struct asus_wmi {
 
 	u32 kbd_rgb_dev;
 	bool kbd_rgb_state_available;
+	bool oobe_state_available;
 
 	u8 throttle_thermal_policy_mode;
 	u32 throttle_thermal_policy_dev;
@@ -1826,7 +1827,7 @@ static int asus_wmi_led_init(struct asus_wmi *asus)
 			goto error;
 	}
 
-	if (asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_OOBE)) {
+	if (asus->oobe_state_available) {
 		/*
 		 * Disable OOBE state, so that e.g. the keyboard backlight
 		 * works.
@@ -4723,6 +4724,7 @@ static int asus_wmi_add(struct platform_device *pdev)
 	asus->egpu_enable_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_EGPU);
 	asus->dgpu_disable_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_DGPU);
 	asus->kbd_rgb_state_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_TUF_RGB_STATE);
+	asus->oobe_state_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_OOBE);
 	asus->ally_mcu_usb_switch = acpi_has_method(NULL, ASUS_USB0_PWR_EC0_CSEE)
 						&& dmi_check_system(asus_ally_mcu_quirk);
 
@@ -4970,6 +4972,13 @@ static int asus_hotk_restore(struct device *device)
 	}
 	if (!IS_ERR_OR_NULL(asus->kbd_led.dev))
 		kbd_led_update(asus);
+	if (asus->oobe_state_available) {
+		/*
+		 * Disable OOBE state, so that e.g. the keyboard backlight
+		 * works.
+		 */
+		asus_wmi_set_devstate(ASUS_WMI_DEVID_OOBE, 1, NULL);
+	}
 
 	if (asus_wmi_has_fnlock_key(asus))
 		asus_wmi_fnlock_update(asus);
-- 
2.39.5

