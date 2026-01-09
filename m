Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE463359F9C;
	Fri,  9 Jan 2026 12:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961530; cv=none; b=JFkfyGU3aDN5PsBFWEK9vY7h+X/45v8Gsb3UB1nhvup/1pYMMCLYlK/K7Uy703SUJD9dkxWKjLyZgC9RDffkoIeP055hoLCKSTGwYPPlUCDASJKmLOuaU2cjCGZAW1NRAJMTRzVF00xWXdF5+nM+A52STShFqs1S8UWvQVU+ipM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961530; c=relaxed/simple;
	bh=io1jmPlXEIbLibNVHsOEnoANo2t3+PL+flL9Ev5M/2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kcoOXQDfKqAoAco9kHVEkhP4Uob6rMRzikDMnDg5s5jKFUKAj5DGPjhwlGtkIeY5t6+DHKgwaAY1JBZmHd2iro6T+g0vVrWNxHZcQWA0PjxlGFnGj4+A78mG3pF8j5EiBuE85/N+Yg6A8Y4AEH9veVKHjwga5i4r8Cv32EbpDl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXnXkC8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXnXkC8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C82CC4CEF1;
	Fri,  9 Jan 2026 12:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961529;
	bh=io1jmPlXEIbLibNVHsOEnoANo2t3+PL+flL9Ev5M/2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXnXkC8OOekwnm5+fadgIqj5mfhw1WbYW3ULVavMrgyFJbDsiCV1yUwd0z6X2fLwx
	 oHmxTNSuXl8Oj/04EHdfLW1hOobsg7hj+9M3pu3OmPHAo2b/IAu5vlm/swYIxqRVgQ
	 CSAdNE1+sinYl2Zfr6IgeTvZMGs3oWnlFYDmCuU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bugaddr <Bugaddr@protonmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/634] platform/x86: acer-wmi: Ignore backlight event
Date: Fri,  9 Jan 2026 12:35:07 +0100
Message-ID: <20260109112118.544335048@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index da765a7dedbc4..46311befc81ae 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -86,6 +86,7 @@ MODULE_ALIAS("wmi:676AA15E-6A47-4D9F-A2CC-1E6D18D14026");
 
 enum acer_wmi_event_ids {
 	WMID_HOTKEY_EVENT = 0x1,
+	WMID_BACKLIGHT_EVENT = 0x4,
 	WMID_ACCEL_OR_KBD_DOCK_EVENT = 0x5,
 	WMID_GAMING_TURBO_KEY_EVENT = 0x7,
 	WMID_AC_EVENT = 0x8,
@@ -1992,6 +1993,9 @@ static void acer_wmi_notify(u32 value, void *context)
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



