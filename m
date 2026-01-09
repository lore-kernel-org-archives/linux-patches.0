Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925EE33B97A;
	Fri,  9 Jan 2026 12:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961136; cv=none; b=Iq+A/jeGc1E9ai8O4aK8afbrfOrTQi+0kvpmOh4zD8xQ+WRx7+debsv07NYwfuXPPLVAd4gPdQUTTz2YnV43tE8iVGDE+PstQdohwXoHyXYNlvsO/tXA91yvEInZLjMX4NKHrpaCl8AFE6xrqr99eQXqZaI4Q9526nrylD4TLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961136; c=relaxed/simple;
	bh=LdRr0JX5d7YWS5eaMmTyCTg4M3Ufgja1fqIENHORGVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl6Tj+7PxevHfLNne1ET1ibs4u546s190LImMPw/7kX6yJrv6NQ0g5myOGCUKg7D0KXzuTPdQvuLj4Lx6M9ZKktLDQtuzJeux8ayUunV/150f63um9fVxwfXFpMS8N5xcitkcfwv/1oJxCPj0ZNVTTaWm+LeX89xW9P478XibI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFxy5U6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFxy5U6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE8FC4CEF1;
	Fri,  9 Jan 2026 12:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961136;
	bh=LdRr0JX5d7YWS5eaMmTyCTg4M3Ufgja1fqIENHORGVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFxy5U6ZSgRCHMlZvH0RdFlj1U1rk9mlAILfNT5p3BNsugdDI24+/D4BuTX3sJB1c
	 qirpx9wciQxGrLe721fnDyDvIW80O1O8H+KSmAdSjxSG7ZcK1Qgp9YTCZje2Q9N3Cy
	 /Lm9FGnk9T3agHYFglQbZoW36CAyXXuujExCdmTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Askar Safin <safinaskar@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 648/737] gpiolib: acpi: Add quirk for Dell Precision 7780
Date: Fri,  9 Jan 2026 12:43:07 +0100
Message-ID: <20260109112158.393652215@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Askar Safin <safinaskar@gmail.com>

[ Upstream commit 2d967310c49ed93ac11cef408a55ddf15c3dd52e ]

Dell Precision 7780 often wakes up on its own from suspend. Sometimes
wake up happens immediately (i. e. within 7 seconds), sometimes it happens
after, say, 30 minutes.

Fixes: 1796f808e4bb ("HID: i2c-hid: acpi: Stop setting wakeup_capable")
Link: https://lore.kernel.org/linux-i2c/197ae95ffd8.dc819e60457077.7692120488609091556@zohomail.com/
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Askar Safin <safinaskar@gmail.com>
Link: https://lore.kernel.org/r/20251206180414.3183334-2-safinaskar@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
[ adapted quirk entry location from gpiolib-acpi-quirks.c to gpiolib-acpi.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1720,6 +1720,28 @@ static const struct dmi_system_id gpioli
 			.ignore_interrupt = "AMDI0030:00@11",
 		},
 	},
+	{
+		/*
+		 * Spurious wakeups, likely from touchpad controller
+		 * Dell Precision 7780
+		 * Found in BIOS 1.24.1
+		 *
+		 * Found in touchpad firmware, installed by Dell Touchpad Firmware Update Utility version 1160.4196.9, A01
+		 * ( Dell-Touchpad-Firmware-Update-Utility_VYGNN_WIN64_1160.4196.9_A00.EXE ),
+		 * released on 11 Jul 2024
+		 *
+		 * https://lore.kernel.org/linux-i2c/197ae95ffd8.dc819e60457077.7692120488609091556@zohomail.com/
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_FAMILY, "Precision"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 7780"),
+			DMI_MATCH(DMI_BOARD_NAME, "0C6JVW"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "VEN_0488:00@355",
+		},
+	},
 	{} /* Terminating entry */
 };
 


