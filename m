Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80C220E034;
	Thu, 12 Dec 2024 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015824; cv=none; b=b2Krwcp8lFdbzzj26pQRIV854IIRen4+dTkdrmh8S1lMymhehYbN+xTXBRjA3ZbsGbjvMfmEcU8XULcOP7K901cCTlvMRwq64geOji9+3OoQtj4N3ta4ZYA2TdOPehjyJiHSp68kYrT1h8X/4m4Ri8BU0Q363lGJIPWeUjZCrnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015824; c=relaxed/simple;
	bh=kDfDacqcWStKR6JtWdwj8ifyCuLKq05u9g5Gh7sXRwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C9jNmFUeZX0H8zVk40P3bODkY/a4InJBjblqbuvg5pcJwf+iqCZzzxs+acjLQAf0Uwt/94j3odbc1FyMeMkcNOOjztCpuV8BuQHd8KiOt8HpgfGFV9bliw3MPwcNYGTvjOs9HrweiqzOlB+5Iwyu8o6z6RVfkOqO86lsL6wChNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8peQXvU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8peQXvU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0859CC4CEE0;
	Thu, 12 Dec 2024 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015824;
	bh=kDfDacqcWStKR6JtWdwj8ifyCuLKq05u9g5Gh7sXRwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8peQXvU+Y9FAsmmv+IhV+RXWCpih9JWOUArBmQeTtKEEwJDd9TIC7q2SW+qdlVLG
	 NVHXS+Gnwh2K1yVOtM7KVzo6VsxwVCoX//oNpVK5NntzpK+DY+JYLkPZR1mv+M+WPx
	 XKNf0yxy+1vk44W5fxa87fsdfX4wUCesEM25VmX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	auslands-kv@gmx.de,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/466] platform/x86: asus-wmi: Ignore return value when writing thermal policy
Date: Thu, 12 Dec 2024 15:53:17 +0100
Message-ID: <20241212144307.799069911@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 25fb5f47f34d90aceda2c47a4230315536e97fa8 ]

On some machines like the ASUS Vivobook S14 writing the thermal policy
returns the currently writen thermal policy instead of an error code.

Ignore the return code to avoid falsely returning an error when the
thermal policy was written successfully.

Reported-by: auslands-kv@gmx.de
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219517
Fixes: 2daa86e78c49 ("platform/x86: asus_wmi: Support throttle thermal policy")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241124171941.29789-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 89f5f44857d55..1101e5b2488e5 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3696,7 +3696,6 @@ static int asus_wmi_custom_fan_curve_init(struct asus_wmi *asus)
 /* Throttle thermal policy ****************************************************/
 static int throttle_thermal_policy_write(struct asus_wmi *asus)
 {
-	u32 retval;
 	u8 value;
 	int err;
 
@@ -3718,8 +3717,8 @@ static int throttle_thermal_policy_write(struct asus_wmi *asus)
 		value = asus->throttle_thermal_policy_mode;
 	}
 
-	err = asus_wmi_set_devstate(asus->throttle_thermal_policy_dev,
-				    value, &retval);
+	/* Some machines do not return an error code as a result, so we ignore it */
+	err = asus_wmi_set_devstate(asus->throttle_thermal_policy_dev, value, NULL);
 
 	sysfs_notify(&asus->platform_device->dev.kobj, NULL,
 			"throttle_thermal_policy");
@@ -3729,12 +3728,6 @@ static int throttle_thermal_policy_write(struct asus_wmi *asus)
 		return err;
 	}
 
-	if (retval != 1) {
-		pr_warn("Failed to set throttle thermal policy (retval): 0x%x\n",
-			retval);
-		return -EIO;
-	}
-
 	/* Must set to disabled if mode is toggled */
 	if (asus->cpu_fan_curve_available)
 		asus->custom_fan_curves[FAN_CURVE_DEV_CPU].enabled = false;
-- 
2.43.0



