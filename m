Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859FF13D600;
	Tue, 23 Jul 2024 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760125; cv=none; b=EHWKUrI4PscariT0qsa8F7nCUZJFeRA5A3HHKZ0RtELEaviuNjzGJTZrdDtsB1qwR+L5jNpKvqNqpAjW6IjvDnUS+arwrh3pLWLz7taqA89/EdNOLZxyljKtb5zvP6SkpBdctxabuJbyyiXO2XLiZtIKYF061bjXLktW0aJuFRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760125; c=relaxed/simple;
	bh=oSj0Vr9+AsMaVNnOzqn7OmiTDrzWpSO423c0SBGzAiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=htqx62RvV6BZUZSKjLywalDpbkS9mrzO+FHq3oQqqKocy/Xz7smGJdtXDphybq1+ktNuH4twFWx0WSZVBj+MaPBh9nMi3CW0zMTue+6U8OWxoAm84qB1iiB2kKGik+BWQy8+e41WM8tbVuSPsXW00TRt9GJz/hEq5LPOGKDrdac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKxs4sA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKxs4sA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E93C4AF0B;
	Tue, 23 Jul 2024 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760125;
	bh=oSj0Vr9+AsMaVNnOzqn7OmiTDrzWpSO423c0SBGzAiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKxs4sA8kkzEdTcBrvxLjU1CipeTFIHLtOmN6ibtgM3UaRN5+4VbOWUQ7Kl6NaTEI
	 c1AXB1hPFgNM0QssZfFu1kPqr6Oo1t4+CuXKYb83IdDop0sYgooF7/O5t2+nTmWnvL
	 PqedU7mnlxyeC18GOLuE9HitvFABKuYeoIEKV3Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 111/163] platform/x86: lg-laptop: Remove LGEX0815 hotkey handling
Date: Tue, 23 Jul 2024 20:24:00 +0200
Message-ID: <20240723180147.764809594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index e714ee6298dda..5d4df782ce8e1 100644
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



