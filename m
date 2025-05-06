Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973FC21CFFF;
	Tue,  6 May 2025 21:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567339; cv=none; b=ktTDEh0Qj0uDGwcmM6CzJWXnvR2M5PML83ENYurbIcE5jNLjzb11gIt9IuSDu548pe3SZHAay4y/L4livMHpHLk+DRg5Kv3V+xaWYTTyZpHrd1ssAyZY40JrsFit2v6R7SIuYCK+5QdfUKa6kobPEEeP964YD7g45+oE8HjTsT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567339; c=relaxed/simple;
	bh=ooALjbOB7dA2Sw+Wn93nyYWekBKNU1vpl8SG26Ub79k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iZaxJyAdPurTohTrA9YeeFiWMPPD52SY/f0cmkWdP5BfkfPBAzP9FkALcBy7XNyk4nPOk504kcHWK1yFCHz7ucSsg2N5VcEHISuPuYo5x+hFf7DvBzTJuTg3r9H7cIX6Aq0vXQG76p8BMsxZmdI3R6K5g0N5EwURHdFuigmhPyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApXQk5Sn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApXQk5Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4DDC4CEE4;
	Tue,  6 May 2025 21:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567339;
	bh=ooALjbOB7dA2Sw+Wn93nyYWekBKNU1vpl8SG26Ub79k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApXQk5Sn6Yrf0r4vs+kAex1MZjzaN3Q4YsNtU3oEPusE8EbjrBp3ReTwi8N6ldwM/
	 9iEYdnHw+x9nf7CgnqTEGEYndy0l9lJgkHvJngxhlHAoYg9WycrDWFiWnMoOMNAmEY
	 jdWfxKTuaCqfiQXlVmRi1m2ZA1VvipnQbNcY0JUpHTNhc7k2u9Uuka7ytm7jvEo69L
	 kMxoUdZbGAFAUEehrsqzdlpnQdIqTMyRIUyGH+Gt72DHW4kEwmrlBUYeNoZQ1Jrq5b
	 aT+KeBVTyEt4PKuvzBQHeCvJa52LGxxYYzJ411QJYcZ874dbv3ckSX/vYoFT7onstS
	 4Bt42ep+AenKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Ga=C5=A1per=20Nemgar?= <gasper.nemgar@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	ikepanhc@gmail.com,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 07/20] platform/x86: ideapad-laptop: add support for some new buttons
Date: Tue,  6 May 2025 17:35:10 -0400
Message-Id: <20250506213523.2982756-7-sashal@kernel.org>
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

From: Gašper Nemgar <gasper.nemgar@gmail.com>

[ Upstream commit 02c6e43397c39edd0c172859bf8c851b46be09a8 ]

Add entries to unsupported WMI codes in ideapad_keymap[] and one
check for WMI code 0x13d to trigger platform_profile_cycle().

Signed-off-by: Gašper Nemgar <gasper.nemgar@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20250418070738.7171-1-gasper.nemgar@gmail.com
[ij: joined nested if ()s & major tweaks to changelog]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/ideapad-laptop.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 30bd366d7b58a..b740c7bb81015 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1308,6 +1308,16 @@ static const struct key_entry ideapad_keymap[] = {
 	/* Specific to some newer models */
 	{ KE_KEY,	0x3e | IDEAPAD_WMI_KEY, { KEY_MICMUTE } },
 	{ KE_KEY,	0x3f | IDEAPAD_WMI_KEY, { KEY_RFKILL } },
+	/* Star- (User Assignable Key) */
+	{ KE_KEY,	0x44 | IDEAPAD_WMI_KEY, { KEY_PROG1 } },
+	/* Eye */
+	{ KE_KEY,	0x45 | IDEAPAD_WMI_KEY, { KEY_PROG3 } },
+	/* Performance toggle also Fn+Q, handled inside ideapad_wmi_notify() */
+	{ KE_KEY,	0x3d | IDEAPAD_WMI_KEY, { KEY_PROG4 } },
+	/* shift + prtsc */
+	{ KE_KEY,   0x2d | IDEAPAD_WMI_KEY, { KEY_CUT } },
+	{ KE_KEY,   0x29 | IDEAPAD_WMI_KEY, { KEY_TOUCHPAD_TOGGLE } },
+	{ KE_KEY,   0x2a | IDEAPAD_WMI_KEY, { KEY_ROOT_MENU } },
 
 	{ KE_END },
 };
@@ -2094,6 +2104,12 @@ static void ideapad_wmi_notify(struct wmi_device *wdev, union acpi_object *data)
 		dev_dbg(&wdev->dev, "WMI fn-key event: 0x%llx\n",
 			data->integer.value);
 
+		/* performance button triggered by 0x3d */
+		if (data->integer.value == 0x3d && priv->dytc) {
+			platform_profile_cycle();
+			break;
+		}
+
 		/* 0x02 FnLock, 0x03 Esc */
 		if (data->integer.value == 0x02 || data->integer.value == 0x03)
 			ideapad_fn_lock_led_notify(priv, data->integer.value == 0x02);
-- 
2.39.5

