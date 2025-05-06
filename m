Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04F3224258;
	Tue,  6 May 2025 21:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567383; cv=none; b=P/Dao4CZSxbbgykgxkQz5HeQpTIuyUOts9uOtfy8X2aeYsQGBxB9l6bW/XowCv5KLRj0VPpqvmJ0TdFXZKYNT0GW7LAyAC+0IUwOu0h8HDCaQ6yFzJd7vLbe7Bgj1+SeT680Q9WQWSynPK0RwK1CHlIzSrZk9/yA+GOsjAdiXA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567383; c=relaxed/simple;
	bh=weLPTUItMG+rTi3LWZLsyL2Ya6aRK8lpVgUaPQf4XFc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rl6nFF3X5NTGSUV8GEIHdN1p9UjY6AGPyZHPynTNtiSXzTWcZ59eHqM0aWbNLXEEPCKBlzYstGaib6t6RUhecSwIHGbYDFNjkLk2sYzituLWrKphGorU2I36+fx+cDy1P/88HQdN7Du+voWLNaWZfADd5iw4U9nlAir01Cyb4MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mdE9VO+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mdE9VO+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F8EC4CEEE;
	Tue,  6 May 2025 21:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567383;
	bh=weLPTUItMG+rTi3LWZLsyL2Ya6aRK8lpVgUaPQf4XFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdE9VO+SFpIj4fBt6T1WoNZMna9k9owgE6d8oUM3wQytst+CMPo0+usDvFhy4nz4y
	 64+gCvkLDlgT5NVJG8RFwlbg7DmYQlkntDj4ieQyWUI51pC/oukzWw4u8tX9abIJe3
	 N92YT7hFd89BtCLR/Fn1OdN1Fh1pnC6VNtbpvlQF9I70GR0HJ8+W0lOdbdmey1aN5O
	 Mw1qwze4W4yxcIxC0+8zwx3VVZ7s3sUpmwPADxw42le904HmsUH4PRcEJSi08ci9rp
	 GMZipO/L7hl8UdM7+qBiR0UiDyQft2LPmPFlyUELHTMNUwGiOELXARIArceu1eMAiD
	 vNSsdgMSi8Ebw==
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
Subject: [PATCH AUTOSEL 6.12 06/18] platform/x86: asus-wmi: Disable OOBE state after resume from hibernation
Date: Tue,  6 May 2025 17:35:58 -0400
Message-Id: <20250506213610.2983098-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213610.2983098-1-sashal@kernel.org>
References: <20250506213610.2983098-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
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
index 1101e5b2488e5..051aa4fe46759 100644
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
@@ -4741,6 +4742,7 @@ static int asus_wmi_add(struct platform_device *pdev)
 	asus->egpu_enable_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_EGPU);
 	asus->dgpu_disable_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_DGPU);
 	asus->kbd_rgb_state_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_TUF_RGB_STATE);
+	asus->oobe_state_available = asus_wmi_dev_is_present(asus, ASUS_WMI_DEVID_OOBE);
 	asus->ally_mcu_usb_switch = acpi_has_method(NULL, ASUS_USB0_PWR_EC0_CSEE)
 						&& dmi_check_system(asus_ally_mcu_quirk);
 
@@ -4993,6 +4995,13 @@ static int asus_hotk_restore(struct device *device)
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

