Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECAB158A02;
	Tue, 23 Jul 2024 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759653; cv=none; b=gGzw8Qcl+VxOA4eOxHHCs5nTQkFWN4sE9WDy8W0Ce/IdoaAAJC+ew0HtQ09j4EV7SoDqf2UmdxzN7RlKcXE15VWURwus8RDm5Tb34T4XbVM6/F65TZyJVbvonUMeQ3G8qfAh/DUicuWFcSu8a/lXgNBCYVwO4yzqMK+JB++W9rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759653; c=relaxed/simple;
	bh=I4+LwafH7gSzLnAUPQ2o0AWLET+NgNOymU25uX3d0lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqrM8f9VR7Jdd5urcQLM1a71DLHjDjDUAOPIVuhV7hlRmmAmJRQ2NEfTPpqC2hAt4tXmYoOfdcrWSo5MWkbA0zh4E56KcwtewmqimggHgie3tG0bm30gIHR+qA9CHHVsBGW2XEeaoALjEYK9+iW+uISr2n53U6G/AT+6yP8QFAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLE+iJRS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLE+iJRS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2608C4AF0A;
	Tue, 23 Jul 2024 18:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759653;
	bh=I4+LwafH7gSzLnAUPQ2o0AWLET+NgNOymU25uX3d0lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gLE+iJRSn6zg5aGwH/Oux+tACNjcc6xph5CY6hsl87HTUdjheygvD2+6r/83To4RJ
	 CEjIbm21MQsChOWNKIJZu8kQvbBIv2/O28UicaEbVQJFNzia1HbRm4a4634jhTbpR2
	 tdYq9CsZg+TapOj6AEkw3IEyd+JXVIJ8D1yrkR0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agathe Boutmy <agathe@boutmy.com>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/129] platform/x86: wireless-hotkey: Add support for LG Airplane Button
Date: Tue, 23 Jul 2024 20:23:50 +0200
Message-ID: <20240723180407.953207757@linuxfoundation.org>
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



