Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45305C613;
	Wed, 10 Dec 2025 07:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352073; cv=none; b=bEeOdZwuEtE2QSR//dQgSoyJsxzz5xI64/8ZBGiUmQBkzhizi48jfNeK8wzwrac6sW5MzTXs9AhN2maSf5/+8qi6+XFTnemhhYLyLnK/am+xWrN0YPev2GMEkR/v3ZQTM/9KM2ViLDBPME9SC7HXme0/vmqosnfIGW778m1mXSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352073; c=relaxed/simple;
	bh=X5bP54gA1HbStLUk1tfBIxH2CyNd6RqqdaPPAqTJlbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UwYtne7R9owCdhFTDY3ib4R/5ulvQjXAzG3MX4+v6Mezpn0gZYO9VID3GsRmWFQTnU2pUQVELOcTOMOYJPWQu7Em3Lf407MOtVk01B3F+NWWZ4NkRY5ThRhGTCrOXOb6EPjStCbFCujxGYFKmRL7f2w6jjnwVLIaaA/Rl4yBmGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M22bamGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M22bamGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3B4C4CEF1;
	Wed, 10 Dec 2025 07:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352073;
	bh=X5bP54gA1HbStLUk1tfBIxH2CyNd6RqqdaPPAqTJlbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M22bamGYZA3fZiL68P8z3qKOGTmL2uZi/vU8HU6o3vfFNFJXn6hlucOwlwGfBZkQK
	 PiHLZVr51WjBbUFdvdT6oMN6idHUwYTvwjgicrSevMKmFDbhj2vxehSrucOeWfOPGH
	 41crvUNhaa0tuqqdrKXHYg/WfL66x7QrplAq0MPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bugaddr <Bugaddr@protonmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 38/60] platform/x86: acer-wmi: Ignore backlight event
Date: Wed, 10 Dec 2025 16:30:08 +0900
Message-ID: <20251210072948.815639473@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 13eb22b35aa8f..d848afc91f87d 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -102,6 +102,7 @@ MODULE_ALIAS("wmi:676AA15E-6A47-4D9F-A2CC-1E6D18D14026");
 
 enum acer_wmi_event_ids {
 	WMID_HOTKEY_EVENT = 0x1,
+	WMID_BACKLIGHT_EVENT = 0x4,
 	WMID_ACCEL_OR_KBD_DOCK_EVENT = 0x5,
 	WMID_GAMING_TURBO_KEY_EVENT = 0x7,
 	WMID_AC_EVENT = 0x8,
@@ -2369,6 +2370,9 @@ static void acer_wmi_notify(union acpi_object *obj, void *context)
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



