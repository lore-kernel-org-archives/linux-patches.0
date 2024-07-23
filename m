Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B38F13D896;
	Tue, 23 Jul 2024 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760122; cv=none; b=DXxJLPx1quPXLt1oal1hiZKqkNpVgkqXaRCXIez3xi2c93smNopMu+SmEDaR1rC7zg9eHcZL8NbO5DhfodZeftFTubOcDzamlh6R2WCXYwes4AuxePH9/GDbv/oQnY10fg1Qyh2PiYB4SdTpIwBgBLtrzxDtjXSzXZ434EzIkL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760122; c=relaxed/simple;
	bh=DOgjrKG7dukDLS5ih/LuM2PSEXI9ovlY+8U3/TqPQbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DGCZscTLohwDWm+Kz+UwZhAfrmJGM3Z0wKtMAxEYYxh4RX8Spm2HCjDUoFvs0ejGmbMg0klYb7EJSIlqcaRgmfA2XBuf+KkHibrB9669xqh/u7Osr6936d4MP4M/5R1o5omXk5dxng+LnWtQtZqSsVfGKDrZPVJAU8Yky+5ZylE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MS7gTiVI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MS7gTiVI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB7AC4AF09;
	Tue, 23 Jul 2024 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760122;
	bh=DOgjrKG7dukDLS5ih/LuM2PSEXI9ovlY+8U3/TqPQbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MS7gTiVIWIo96uQ6ea3y6tuL4fBscosg5k96evuhSePYO/ZO4ynGcjw2cOlnbyG9s
	 7VLVISAyxf1TF2ot8ogOZAM5KwrKdLOhMDfakXVuEvBoQTd8o2p4tbBDFBCPGjCpp4
	 /A4OSu4C+iOv+W/Pq6K88WrZlCl/RXw4ozAESyrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 110/163] platform/x86: wireless-hotkey: Add support for LG Airplane Button
Date: Tue, 23 Jul 2024 20:23:59 +0200
Message-ID: <20240723180147.725159850@linuxfoundation.org>
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

[ Upstream commit 151e78a0b89ee6dec93382dbdf5b1ef83f9c4716 ]

The LGEX0815 ACPI device is used by the "LG Airplane Mode Button"
Windows driver for handling rfkill requests. When the ACPI device
receives an 0x80 ACPI notification, an rfkill event is to be
send to userspace.

Add support for the LGEX0815 ACPI device to the driver.

Tested-by: Agathe Boutmy <agathe@boutmy.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240606233540.9774-2-W_Armin@gmx.de
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wireless-hotkey.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/wireless-hotkey.c b/drivers/platform/x86/wireless-hotkey.c
index 4422863f47bbe..01feb6e6787f2 100644
--- a/drivers/platform/x86/wireless-hotkey.c
+++ b/drivers/platform/x86/wireless-hotkey.c
@@ -19,6 +19,7 @@ MODULE_AUTHOR("Alex Hung");
 MODULE_ALIAS("acpi*:HPQ6001:*");
 MODULE_ALIAS("acpi*:WSTADEF:*");
 MODULE_ALIAS("acpi*:AMDI0051:*");
+MODULE_ALIAS("acpi*:LGEX0815:*");
 
 struct wl_button {
 	struct input_dev *input_dev;
@@ -29,6 +30,7 @@ static const struct acpi_device_id wl_ids[] = {
 	{"HPQ6001", 0},
 	{"WSTADEF", 0},
 	{"AMDI0051", 0},
+	{"LGEX0815", 0},
 	{"", 0},
 };
 
-- 
2.43.0



