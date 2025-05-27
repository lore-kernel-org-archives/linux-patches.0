Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1798B2566;
	Tue, 27 May 2025 17:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368268; cv=none; b=PPHaFJwGoMRlcNZ/+yFur1dd+ezm26kyi0ZIzap5JC+9UAGzQ+HZS+xMKZOb57XsiS+8Hu3FH9+br6tadjyZ6zMfUej7c4BLM51gdBAlDHdWIw4tZ95y4kXXPfPfhoI7k/X8Fp4g/2vviJC0shoNNrKUH1f/GoqZLP79zzfs9qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368268; c=relaxed/simple;
	bh=5Qyq+HQfS3ORInVFXwKo1sSdWg2YZqGm+Pa42uiXiiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pu5oyKG9UHLMX2ysBc6a+umqr0QXyoss1WQXsGHiMxpNMj0vuhJQytnDCYPl2C70MqeuSeqEJARtegwEHoL4yC2hDzEVeg6ONSiqarUDRzooIaXy6MBn2SQ8fMNkLEzz8/DCyfl71xEf1Q/JXUX/KgMLQa5KcgGTv0CXNb7gEyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1f+d87k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1f+d87k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F39C4CEE9;
	Tue, 27 May 2025 17:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368268;
	bh=5Qyq+HQfS3ORInVFXwKo1sSdWg2YZqGm+Pa42uiXiiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1f+d87k+X72ONaPl39B196VH2T0OhZ3QdyWCXxbpchCZHvYAV0jfdvxWZZzLHqoM
	 0TJ/KPSBfxhl8rRtGGc/7u3gUaUDRMpilOIWVSSQbZoo/eNdrepUlS3vngbbgWi646
	 TtrT/JY2ZjbNtk9DB0p/jzU2rjd0S71s8wT+p/EQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ga=C5=A1per=20Nemgar?= <gasper.nemgar@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 653/783] platform/x86: ideapad-laptop: add support for some new buttons
Date: Tue, 27 May 2025 18:27:30 +0200
Message-ID: <20250527162539.722432073@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

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



