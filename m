Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB4A32FA3D;
	Fri,  9 Jan 2026 11:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959385; cv=none; b=YSnTb3gBamtxaYTbFaIE2b875B5v2l82fReCFPeDMJ6GXBr+MpOeHDeN0gCRKyBunKz3doABom/SMpQE0Ef41vX8YzLPwq0JcT/zb0G3QxLWLeWTMn0sCSAVCAuInVImV/wvXXPky4YYWqXKLrH20oSry+Sulg+uLt69roHQlG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959385; c=relaxed/simple;
	bh=Q+nB0QJ2Lhc5PjkKZ5iVpOvp72y+WmPDw7GwP7I2/kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sJWEgjfD3x9drNOOMz4IHdLD96oJymaUikTuT6iSQuqAczZeLLMDPB4O1W6JPXfQ9R1IHll8YfL9T3a/YwV8s3pr29z9yVQy/XEskUinOtiPtsxpyQVBnSjH89Y5sgVO74m2Bre4hQxd9KyfvsRhDOpMUaep4az83JSksXRNnxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QO6X4wsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QO6X4wsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179D8C4CEF1;
	Fri,  9 Jan 2026 11:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959384;
	bh=Q+nB0QJ2Lhc5PjkKZ5iVpOvp72y+WmPDw7GwP7I2/kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QO6X4wsUjZvRQsPGJziPIdv0ylU9bPK9gorHbivfHDHVp2L3vj9aq9e9UgOc0Hjs6
	 1z9RcbTbsyFOZr5uPE3qErHERnTp56CmDikJo0IQpMXA/8Zw5zzvn1pGloWUe9fR6R
	 6bnGFYJiElmMBxtEA8e27vWZKNlg0ttzlHWifsy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bugaddr <Bugaddr@protonmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/737] platform/x86: acer-wmi: Ignore backlight event
Date: Fri,  9 Jan 2026 12:32:51 +0100
Message-ID: <20260109112135.205040072@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 868faccfb8628..e7a43f824272f 100644
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



