Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994C32FE57B;
	Tue,  6 Jan 2026 17:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721394; cv=none; b=T2Ld9iJ1L6ANTqWr/iiNsbAnCaNLsCkKCGeP4YKfzsDM6ecTDT5aL8zMDnoZJY1cmGWDq1BqpfBdeJYecpRx1Q/KIgYxp9FnwP8jWH2h2HncLIGK7/cmT4dNe3DV6/Er8+pa+XovMRhainX97sW2fIM3bTlNYDXfOG6l0GizLu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721394; c=relaxed/simple;
	bh=cKPpLJl4rFxCKdvs6wAlqerp/IJdtJc7mP7UoeOekJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ls0ZEHMYQh43uKUz3G4epgLMRriFTUs9SKaweOYD9HaeUbAc13gqwSQ20muZMd1mnhvgRsSr7pTTh3IcJe92HpsWlBF4GXvpn+nernJoF9amSdrdHKFyCjhc1J9p/deE8FQNz9Vxci1f2EXvEw3zaIo52p7lV6gUd+7Rsh0X3WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjnBkZua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjnBkZua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F109C116C6;
	Tue,  6 Jan 2026 17:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721394;
	bh=cKPpLJl4rFxCKdvs6wAlqerp/IJdtJc7mP7UoeOekJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mjnBkZuar5Pps9KLey6kFLac+8MGf4k6YkxHho7fXqYIHSYXQrXPTPM7a6u4j5WiC
	 TJAuDakMH4oepI1yoLMmMGv2tD7O6b+b4TN8emSAqnp9oAx2chRnpuI+u4xYH0hv5K
	 fN4L00Pl/pVHxaoujDzkOyxbSiQWwNxeXSCo6XOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Askar Safin <safinaskar@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 522/567] gpiolib: acpi: Add quirk for Dell Precision 7780
Date: Tue,  6 Jan 2026 18:05:04 +0100
Message-ID: <20260106170510.698908752@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi-quirks.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/gpio/gpiolib-acpi-quirks.c
+++ b/drivers/gpio/gpiolib-acpi-quirks.c
@@ -358,6 +358,28 @@ static const struct dmi_system_id gpioli
 			.ignore_wake = "ASCP1A00:00@8",
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
 


