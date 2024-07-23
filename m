Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C663158879;
	Tue, 23 Jul 2024 18:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759656; cv=none; b=WH2it5gxHCMStRHh69c4S4Ll9Xysy5jT4aaRrbMUCJOZBlPb38fP/U5yxkwmBS10LD1XZq54HvngptAQM6X0Sb6jK03HNpPn8z09JpkMNoMT5bJ0f+QoL/cfKFIvSX5bOPl0lBfqBC9dsEHWmmhu2Qf949i/9d0tzTmchAzTXfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759656; c=relaxed/simple;
	bh=3csEJ2eqwiTIi67gIOlcF/kiT+FZ596xm5hyuKTv2Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dajVor5KXRLacnRODBfk7BkQveZeGxrUSQJ83ys+bgq/BjetFWL61axwPRdyb0ecslfy2VHiBvkvQyx7qEKTNG3QwSgmwO2o+d5QgpcdoHwMEsrNMv6EKkhq74sZt0iCbXo9AEEH6IqEzN7hMChn0QtDKvoAmRL5LVI285DiQbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZ4UbY2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZ4UbY2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7450C4AF09;
	Tue, 23 Jul 2024 18:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759656;
	bh=3csEJ2eqwiTIi67gIOlcF/kiT+FZ596xm5hyuKTv2Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZ4UbY2xnqq8AfjFPpxE3RgnsbxbpfoRtpZvb4UeacxAljbu9mdgtTxSopESqv4Lp
	 sypPgTST9Wqpva9wUjGOQ7oOku1hS+v1JzLmiw7+0QF63ylUjHteVCr10nEJ1ktqtF
	 OPY3qhTyosqkH/rw8yZdujk3l8CwmyVAvLtHI9tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/129] platform/x86: lg-laptop: Remove LGEX0815 hotkey handling
Date: Tue, 23 Jul 2024 20:23:51 +0200
Message-ID: <20240723180407.991833685@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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
index ad3c39e9e9f58..545872adbc52a 100644
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



