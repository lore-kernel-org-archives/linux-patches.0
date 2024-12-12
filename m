Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD713212D6A;
	Thu, 12 Dec 2024 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017551; cv=none; b=hcHaG+7npAz6y9J8W1k0ox1yAuUQeJAIP+ntaY2jTAATxLFj1J7FBHlYtBaKaDfsP10SNLKFa6a0knMPnxHEcVEwyeupOuB3t9VIc+feyBdAfAn+THYJ7afCBS+6MEaqmHceuZ4+lbOfG4zf/23z1VFJvB0Oxar9DYdBAo1/lpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017551; c=relaxed/simple;
	bh=4nOxgON3Xy/eZO+QOWfy/fPre+lLZq6+fRkYQYd7yVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OE7YpATpYzK94G390my7NwQVODF7u2ctDF7520juqS/K4D6FxybpfGVQdEDg40hPW49+6/pegdZUqXKV2JcuMwbxbWs5gL7RfcLqNUTZOpoBBziacmI1dmpLDDSC05N5ckRUgxas++bEX1eejx63LjeDWmCt8ayck/U5nCZO77s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0MQ9GKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0MQ9GKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532E0C4CECE;
	Thu, 12 Dec 2024 15:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017551;
	bh=4nOxgON3Xy/eZO+QOWfy/fPre+lLZq6+fRkYQYd7yVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0MQ9GKk39xak8P6iSZZyk7TsWzhSFp3/TOCQFJDrZXcjdrjw4exBszkErzE+/B7m
	 T7QOnKWiXY/cdj6jmiNY/XdlTsj5ke77fSGEFLEjIpQUg4TsI4Wva1O9D27oyNkeGi
	 OmhKtEeuMgc/uSsfoSFXCOzLJ2jLiZxnwyAzoR6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	auslands-kv@gmx.de,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/356] platform/x86: asus-wmi: Ignore return value when writing thermal policy
Date: Thu, 12 Dec 2024 15:55:47 +0100
Message-ID: <20241212144245.739417738@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e36c299dcfb17..1bf6178a3a105 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3386,7 +3386,6 @@ static int asus_wmi_custom_fan_curve_init(struct asus_wmi *asus)
 /* Throttle thermal policy ****************************************************/
 static int throttle_thermal_policy_write(struct asus_wmi *asus)
 {
-	u32 retval;
 	u8 value;
 	int err;
 
@@ -3408,8 +3407,8 @@ static int throttle_thermal_policy_write(struct asus_wmi *asus)
 		value = asus->throttle_thermal_policy_mode;
 	}
 
-	err = asus_wmi_set_devstate(asus->throttle_thermal_policy_dev,
-				    value, &retval);
+	/* Some machines do not return an error code as a result, so we ignore it */
+	err = asus_wmi_set_devstate(asus->throttle_thermal_policy_dev, value, NULL);
 
 	sysfs_notify(&asus->platform_device->dev.kobj, NULL,
 			"throttle_thermal_policy");
@@ -3419,12 +3418,6 @@ static int throttle_thermal_policy_write(struct asus_wmi *asus)
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



