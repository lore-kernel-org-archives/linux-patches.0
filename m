Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1AB2741BC;
	Wed, 10 Dec 2025 07:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351923; cv=none; b=YiFchPg7pOEJi9DS9Ig4wRLwZlw7kgNjZuWN00Ho3Ep2UEVU0qvwqO14Mk1u/VXjkwfR4frrfd0ezQev4TB2h1rFQarXTX/QcJuoqNeRThxq28Hz7iszjCFAGg+GfkujYg+p5Xd2KYp5iEcNMpcfEO0u7g04/OUtoUemLuI8yFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351923; c=relaxed/simple;
	bh=zahdaIMMkrMYTIfFTkFMk0LfHBOap0IscxYQhzEmreE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g6z+pyKOmZBsH7Cp73RvH0Dx8Inasyl9nlLXjC4GL4xlL5xZnZR09F+0X65/oczzBpuCpBBaXyiNJT6vmm7pEtw8I2NduANxi4Ooh79GKlsR9P81ntBBhAEjvmOVhvGj9zEbXTm7DBZv7IE+eiLaShx5MnjiU3YdicAGtk/AdBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmrwVQz2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmrwVQz2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CDAC4CEF1;
	Wed, 10 Dec 2025 07:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351922;
	bh=zahdaIMMkrMYTIfFTkFMk0LfHBOap0IscxYQhzEmreE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kmrwVQz2uk5HojsUqdDgM0+DdR8xltUR5qjTLHLZ9aUI7euyeht8x0tzT/1j95W0s
	 pyK2eKkK7fz68P9TFgJmMuoopIheAFTIebnmQ8l7eD8K4MkItoCd+HM9MGZ81bfeEM
	 wEPCEgwcW+XT3ykmhqmaM57tcHP4eHUyNv5PR3m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bugaddr <Bugaddr@protonmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 32/49] platform/x86: acer-wmi: Ignore backlight event
Date: Wed, 10 Dec 2025 16:30:02 +0900
Message-ID: <20251210072948.959326849@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c5679e4a58a76..d7602962b3cad 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -93,6 +93,7 @@ MODULE_ALIAS("wmi:676AA15E-6A47-4D9F-A2CC-1E6D18D14026");
 
 enum acer_wmi_event_ids {
 	WMID_HOTKEY_EVENT = 0x1,
+	WMID_BACKLIGHT_EVENT = 0x4,
 	WMID_ACCEL_OR_KBD_DOCK_EVENT = 0x5,
 	WMID_GAMING_TURBO_KEY_EVENT = 0x7,
 	WMID_AC_EVENT = 0x8,
@@ -2317,6 +2318,9 @@ static void acer_wmi_notify(union acpi_object *obj, void *context)
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



