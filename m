Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408F829B200;
	Thu, 15 Jan 2026 17:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497330; cv=none; b=s9L/XRF+hD1yFtCB0itYu8t1fh9V2JHKFKD1UlZOfbLVPplJtaxCcZmd4EwYtT90I7Uppb8n5It/3DAK5LU3V41il2hgiUbjJkoRUgllSi301OwTu7D/+2LwCnZLz3OF1ESD449Wvnmo6MVHwxwZBDZAxW4S4NyNz/OlwPoAejg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497330; c=relaxed/simple;
	bh=YI8JNCZY0hDFHdYH+kNDdT9M+eJH684RCs12pNCnsnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OQPw+ORf3HN5NUMpyWrWixVrWbYEgVkUJYx6V0j4Gh+8xfnPc2Mi37gVAnA9t2KGi6p0ojNYIlunAHo/uLWPnpxYw3UwhCISJUbV1B8aJy5HBQos9szq2sO/cg7GK6nhYqcXg/HlUkbFek/LfOhBIVvSFPC3N0nUrng+XTIOdLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+uGaGAp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+uGaGAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3882C116D0;
	Thu, 15 Jan 2026 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497330;
	bh=YI8JNCZY0hDFHdYH+kNDdT9M+eJH684RCs12pNCnsnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+uGaGAp1qPYU5oWvdh6ZQS5BYFoATAoKz9M0FG3aXhd9jQLmbt0DM/zU8YHfmW3U
	 44m2mhEUEjdiZrx1hDJS5bD1j9QHyJpzYKBXa9wrC5Q51Alw0bPQkPKKuozS7siubS
	 5NtpuZE4qY1lnwoNCfE8jDe32krwjqM8AffAW7BE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bugaddr <Bugaddr@protonmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/554] platform/x86: acer-wmi: Ignore backlight event
Date: Thu, 15 Jan 2026 17:41:32 +0100
Message-ID: <20260115164247.186751245@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 444a9256f8d106e08a6bc2dc8ef28a8699e4b3ba ]

On the Acer Nitro AN515-58, the event 4 - 0 is send by the ACPI
firmware when the backlight up/down keys are pressed. Ignore this
event to avoid spamming the kernel log with error messages, as the
acpi-video driver already handles brightness up/down events.

Reported-by: Bugaddr <Bugaddr@protonmail.com>
Closes: https://bugaddr.tech/posts/2025-11-16-debugging-the-acer-nitro-5-an515-58-fn-f10-keyboard-backlight-bug-on-linux/#wmi-interface-issues
Tested-by: Bugaddr <Bugaddr@protonmail.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20251117155938.3030-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 7ef80f517e76e..ea5dbe8081570 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -86,6 +86,7 @@ MODULE_ALIAS("wmi:676AA15E-6A47-4D9F-A2CC-1E6D18D14026");
 
 enum acer_wmi_event_ids {
 	WMID_HOTKEY_EVENT = 0x1,
+	WMID_BACKLIGHT_EVENT = 0x4,
 	WMID_ACCEL_OR_KBD_DOCK_EVENT = 0x5,
 	WMID_GAMING_TURBO_KEY_EVENT = 0x7,
 	WMID_AC_EVENT = 0x8,
@@ -2060,6 +2061,9 @@ static void acer_wmi_notify(u32 value, void *context)
 			sparse_keymap_report_event(acer_wmi_input_dev, scancode, 1, true);
 		}
 		break;
+	case WMID_BACKLIGHT_EVENT:
+		/* Already handled by acpi-video */
+		break;
 	case WMID_ACCEL_OR_KBD_DOCK_EVENT:
 		acer_gsensor_event();
 		acer_kbd_dock_event(&return_value);
-- 
2.51.0



