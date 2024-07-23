Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A60E155351;
	Tue, 23 Jul 2024 18:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759294; cv=none; b=CaIiFu8B2eK5SBANltabasdB5D0L8hPmSvT9ZE21/MwIwSJQzEmz/ZHG5qHxpI/9K0m6jSVbpuQRTK3BGgh4BtXOm2oUXH5+YOI/+eUjwn7AMPKWAC7kIrspXj6YY7orwHtHfA8HFVDFN5m+lvfji8zrfQRgIG5toIXjP3uzpdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759294; c=relaxed/simple;
	bh=Xml8rrKY3WqCCmpE7gB+1cSjXwErRziL/e4M5wZCppg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RHgpy1EVKkU1rapv0KerTacAMiTirels+6yPL0X059tiPxVsVTd/0M8MU8koLSsKf2rZ+REObnnInvGetGSaj+pZs5pUcbAxjOVQDH3GUEDKUc4LRqTXPLhPU6SYyaha5F/CB2+k4r25UkRh6C7xDRTutqj51DNEnFIU9AbLv9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZLgRnlk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZLgRnlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A06DDC4AF0A;
	Tue, 23 Jul 2024 18:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759294;
	bh=Xml8rrKY3WqCCmpE7gB+1cSjXwErRziL/e4M5wZCppg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZLgRnlk8elk1vLcx/bzgTv8DIf6RjvPNuUWCTJy8i+Ve4f+lxzzRvR5mdka0dlX2
	 PACnSg/3OL6i8jy/Q/Ov8XOvs+msJ0R9xM5eFtQPxU0CjBCeUYf19m//BS0K5H/x2j
	 7ku3h2J5hFh99qYl/ZrpuZHUhre6+m4sq9n9dXvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/105] platform/x86: lg-laptop: Remove LGEX0815 hotkey handling
Date: Tue, 23 Jul 2024 20:23:45 +0200
Message-ID: <20240723180405.866106655@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 413c204595ca98a4f33414a948c18d7314087342 ]

The rfkill hotkey handling is already provided by the wireless-hotkey
driver. Remove the now unnecessary rfkill hotkey handling to avoid
duplicating functionality.

The ACPI notify handler still prints debugging information when
receiving ACPI notifications to aid in reverse-engineering.

Tested-by: Agathe Boutmy <agathe@boutmy.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240606233540.9774-3-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lg-laptop.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/platform/x86/lg-laptop.c b/drivers/platform/x86/lg-laptop.c
index 332868b140ed5..aa063c3c935b5 100644
--- a/drivers/platform/x86/lg-laptop.c
+++ b/drivers/platform/x86/lg-laptop.c
@@ -84,7 +84,6 @@ static const struct key_entry wmi_keymap[] = {
 					  * this key both sends an event and
 					  * changes backlight level.
 					  */
-	{KE_KEY, 0x80, {KEY_RFKILL} },
 	{KE_END, 0}
 };
 
@@ -272,14 +271,7 @@ static void wmi_input_setup(void)
 
 static void acpi_notify(struct acpi_device *device, u32 event)
 {
-	struct key_entry *key;
-
 	acpi_handle_debug(device->handle, "notify: %d\n", event);
-	if (inited & INIT_SPARSE_KEYMAP) {
-		key = sparse_keymap_entry_from_scancode(wmi_input_dev, 0x80);
-		if (key && key->type == KE_KEY)
-			sparse_keymap_report_entry(wmi_input_dev, key, 1, true);
-	}
 }
 
 static ssize_t fan_mode_store(struct device *dev,
-- 
2.43.0



