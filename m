Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD9A2D8391
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 23:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976401; cv=none; b=MXVlc+H4eo4HeCmApmIOEZ9YSmX2X5AEyrOSldXn5AKHmBwrZZy+JhA/g3W8lI76hv5xe6o6tLH6NiVEsVroWXIHpKda1dXtYCQAyZS+EYtuDLXKHdLfdA78yj2UWIBcKn1vBIMllcKD/FSHWppDgDMHmr6QsmdGZhDkpOizA/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976401; c=relaxed/simple;
	bh=Z2TnggYnSPNTQQA0qeFMaIKiMc/QIExFwLuHda2smVU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lBc1t3vzi8VKWk/d4jNBTu4EvLDYYu/NJ/XAaihyZ8aVYn1pwtzhjohaB2XLlbw8FS2zcB22kF2VgmBLD1q5kkGz68XiiWeI7FqN6lY+LYadVEXXlkbD/n44MNZt2PSzwnoZgNG3m61Is+Hrm1w6p4gdBHBGnhWW53OBnTU3W1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P+pigfWi; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P+pigfWi"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-59431f57bf6so3113673e87.3
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 15:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764976398; x=1765581198; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ok3XVC2kEB7d6LX2W7MFJKuf7Db93yAzAqWhVXvqPiI=;
        b=P+pigfWiUPyM6cymwT1ik8fTBamVmorxmeT9l/BDQ3MIWpReZ9aJy5HBTRjuN99ueG
         bCreYYhAmCpBCrc+JJid+YlKQjPjrHVsR71SM5JNxLmunr9BrwLtx3Mj/j5OTdVAPsJ+
         rCiFB/fq6BZImfc0S+3lAAotVxDGsos0evan7gvcoR9nfyUL5T3vq5qP4kEMKg4aJ+EM
         YeQMiT60SpyuVzGa/A2El3NDkurBk+Hc6B7MSjEwXnjaCroheKZJPMFH53S8GIZYKw6Z
         KN41SKiJY3iH8tWHrHsmALtaMFNJ7xO8C06mrCP2ZwngTJm7HWyRi7oBVLJGVKP7ENQb
         Np0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976398; x=1765581198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ok3XVC2kEB7d6LX2W7MFJKuf7Db93yAzAqWhVXvqPiI=;
        b=o5edL7c++7DWROnWu4ngodTqCFj3cq8FWftzDBit4He7ml3W5LEqDqheWXEzWv4qOD
         HDHzWooLgya4lxPWPrtvrLPJlAB5FD+tc3vRdv/HXh3dwrZ/xxROv9E1AaNr9vlvHLbM
         qsFY/sh9HxmZpHbYCmIG2A0se5zxl35+zwzANg/dDCYxfm4VbyIcbNdKW5VfSnmzlZUM
         rVYNZtfhyObZdohNKXYDgYiwuIBAMCuhDbTv1TWHFLWt6iKUuYIz9/gyZRgQD5JYMuji
         xIZvXI77VgO1/mb6TXP0uRk2jy3QeTOTx3WWj7y3Nm4WjNUJF0w+sqjJLc1UJ8f3+m9P
         I6vA==
X-Forwarded-Encrypted: i=1; AJvYcCWeONaenwz06e6MzQHekiJO+rWmI5AQ170OWCnHCHvq5Fum7Yw6cUInslRk3wpQMjCLoZdbeu83@lists.linux.dev
X-Gm-Message-State: AOJu0YxrRj8VMXn39ueF2TT+nE+Gx5aYFct1PCR4kg4tXdjHJGFn3/fL
	EPLDXLj2GcCPruyCRRnCE79II04FRQZ4efGTFN3U6bdkrISkZSI2Yccc
X-Gm-Gg: ASbGncvTijPUcKwWXe5wboqs1pjc5p0HArabKjKJD2UCJ3DAJVlqi8uMI+hVlJj14zL
	Ky6pctkEmWJnTIVfqwsKdPxC9qy8exKAbkzxX5jOKQfx8HZwVuavP3buaxNa5suAxz45qtmQoqt
	Se6gewepTeU+wBVPZonOQcUmt30ELn3i7jOcgDCFqA3WP5AoP26fImRY1OFpDjZUs4c5VkGVwo8
	3FcDJNLBMI0Eb755H9IUMUVcokEPdVFtsgiAYjybkACzSTppScwmmr18MQoTrQG9a9VnGhla7Hb
	yRHAmwPaXSpClkg0z0iKtQDzwbI5m6lBSTysfAjj7RU2cqfMgP8xtprXRUzrEPxDGlW3kj+oRgU
	UNd4P8rSIUagwGyLiQzw2LCtRu5Kgt06cd8nxPCVug8vTAQjBBtDfRnJZafvgjfaVH4sjXLt9eM
	t6ikQsXCIvGn1tUz5v0dw=
X-Google-Smtp-Source: AGHT+IHw+siol0Y/HCUauT594fFSjA/LYfEXRKCDELP7T7smqU9LZ6s7uqmUidrRDZEZmBY4flxMEA==
X-Received: by 2002:a05:6512:2353:b0:595:8200:9f7e with SMTP id 2adb3069b0e04-5987e8af414mr145380e87.20.1764976397518;
        Fri, 05 Dec 2025 15:13:17 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-597d7c1e2efsm1918614e87.56.2025.12.05.15.13.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 15:13:17 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: Mika Westerberg <westeri@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@kernel.org>,
	linux-gpio@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: regressions@lists.linux.dev,
	Dell.Client.Kernel@dell.com,
	Mario Limonciello <superm1@kernel.org>,
	patches@lists.linux.dev,
	Askar Safin <safinaskar@zohomail.com>,
	stable@vger.kernel.org
Subject: [PATCH] gpiolib: acpi: Add quirk for Dell Precision 7780
Date: Fri,  5 Dec 2025 22:32:42 +0000
Message-ID: <20251205230724.2374682-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dell Precision 7780 often wakes up on its own from suspend. Sometimes
wake up happens immediately (i. e. within 7 seconds), sometimes it happens
after, say, 30 minutes.

Fixes: 1796f808e4bb ("HID: i2c-hid: acpi: Stop setting wakeup_capable")
Reported-by: Askar Safin <safinaskar@zohomail.com>
Link: https://lore.kernel.org/linux-i2c/197ae95ffd8.dc819e60457077.7692120488609091556@zohomail.com/
Cc: <stable@vger.kernel.org>
Tested-by: Askar Safin <safinaskar@gmail.com>
Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 drivers/gpio/gpiolib-acpi-quirks.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/gpio/gpiolib-acpi-quirks.c b/drivers/gpio/gpiolib-acpi-quirks.c
index 7b95d1b03361..a0116f004975 100644
--- a/drivers/gpio/gpiolib-acpi-quirks.c
+++ b/drivers/gpio/gpiolib-acpi-quirks.c
@@ -370,6 +370,28 @@ static const struct dmi_system_id gpiolib_acpi_quirks[] __initconst = {
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
 
base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449 (v6.18)
-- 
2.47.3

