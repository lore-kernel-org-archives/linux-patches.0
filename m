Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B9925A2BB
	for <patches@lists.linux.dev>; Sat,  6 Dec 2025 18:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765046109; cv=none; b=uf6hvLu7xoUrL6eLbGrdOro55E8ieX1lOZsfKlhpK/UyIcFMVBlRn4OGM5PChTvOq7XhHnTHMPkJrbz2VL/To9QKhRoZIkNT9jFAY07jGxhVkOA6QNXv4R3klTngYlhV/YXCd9ovS9o533jpJZoXg+ZFYqeQMxUJ4MoVT3ohWKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765046109; c=relaxed/simple;
	bh=2Xj9BvX5DJCNWMWbbzPbSZXRdRtJu6wOg59n92iAbNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqTxxWGH0Tw9ddIyyp2lm9LOfTrlD9SEnNDKlq46hIi6dy0vJARJOA+cFX6UfkaACVD4+PEIH2BHt3K0LV0AeLWQ70x9P6JqM3GoQ6bQUfl+jCD6la/mzmsWNsR5gEN3IHqPIGb2RvmPUGYJSXWXFopdGrJT5WVS3DKuzg42JzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nDhrUL8q; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nDhrUL8q"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-596ba05aaecso3195760e87.0
        for <patches@lists.linux.dev>; Sat, 06 Dec 2025 10:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765046105; x=1765650905; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBbB448ht3hgqVqiqj9wAU25sZQEfiyetfXCLvEq3so=;
        b=nDhrUL8qg75pFTrWlV5ap3N2i5h4AwNPO/ijG3RW45WzIVh2F5aM5C9zYKvIDXtwkQ
         gqK3UUH1oaj5GSgEqfhzIXMhImNficvA5Lp69r/Eva/bSAk2JHKgNUJZHoyg1D8uk2Wq
         +lyA5yXlLnGqQDZ1iaCJLB6Yj/HAzHVjto6cqbU8zgXhu//jE6FNtI1BRJ94z1K69UBB
         hifHUWYh88eOvRQKeUXCmAl2zDWnzjSD+VB+880ydOGm1wGggeloIjGYfTy9hdHCJfLp
         6sDrgTMCvFu19Q2R358N2hpbOD2Vxfj7htB6ZFQT9K3pw7xr6ArzLp70HiS+gRBqxJJG
         /5xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765046105; x=1765650905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yBbB448ht3hgqVqiqj9wAU25sZQEfiyetfXCLvEq3so=;
        b=Az3I50+KhivGNAzFtcDrQijxe7WhUglOhMX8h7MBeQwQ8UyKw8jlk2jiMDKGW82ElQ
         AH3h2GcWEDdgyBcJzbnekDgsRJIB5NnAI51d6w67cRqmjUp5PNo0PcvIjpMH3hZPEzm9
         i8IcPbw2jZWmbV9zz0rNRQy4r5yGpOlzJj8vFxFMmkCyDf68XbaZMeuwJ5kGnRuxPHlv
         PhtkR5HV57zjlw+VuiF6/PhRRJO6JbNLTzMTgtfX/W7ruf1DXowPTmZvflpxrJrRMKUd
         QZO9tWISDCNnyqCpT8xi+qNOCIkasAhslTj9bs5edJmfA6LTnFaRV8xUahS5b4vS5pow
         LxOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr/GF+aBzSiMqnHvqscXv4zjFJyzwQZoW+roWjNS6xnDZ63OHODCe0wqPslZ1fwYEwf+xUYeiL@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0cQv4vdJ/c2s2OSigfV9Q5eYhnJwHQTFWBxXvOE6Y6I832Ud/
	Gggrvcsqa72ClhmWR9W3GKLlr5JS3kXkhOekLn3f2bz5V/mhMFTHKNbtQxDCSbLX
X-Gm-Gg: ASbGncubtS3sCpo0anNuGZGxnKu0XeFipL8CGgexfnHXpBFn7HGCz061dUFB+T+WRBJ
	AZnnXly+Hr3nFdSQ6KH7FRehZtqV9bg+wRKyhGhcKlyKxRV3puoDacIsNMrVWhCH6LsNNWfsYiJ
	YKYe3y2ByxYPx91LJbAvbUmHoMXDUOmGDKe88IoB+hAgU0bbIyKRlBFlpx8ebohQPznJcCR681x
	Ag2xho6W2wXkVcv7ozXrme9Q1Tt6JmNXFlMWO9VIHku+pcFTSAWXsgwuOOXZ9xhR0yN3U6iYW6E
	6Zt3z9O/JpD9YBTsJT3tWNQ/uubkJXLdLRarup0RQi+ehI5Vh3Xcu+dUGY8CiTSSZg/WprvafMq
	w07P+O1KaHkLkRAKKR/SB5YefnicRScaXca4n/H+P1NkEIMRVr3Bg3rssrS24VpEsYC/qU39yV0
	3/nrF9f6dZ
X-Google-Smtp-Source: AGHT+IHnxnTE4IQRpHLhybpHqVatvtv9+syN2SM1jyy7DP6ZE+rzLXHDgj4+p7nmI+TmaroB84yRhg==
X-Received: by 2002:a05:6512:1113:b0:595:81ba:fb4 with SMTP id 2adb3069b0e04-598853c54e7mr893651e87.47.1765046104377;
        Sat, 06 Dec 2025 10:35:04 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-597d7c31520sm2588902e87.101.2025.12.06.10.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Dec 2025 10:35:03 -0800 (PST)
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
	stable@vger.kernel.org
Subject: [PATCH v2 1/1] gpiolib: acpi: Add quirk for Dell Precision 7780
Date: Sat,  6 Dec 2025 18:04:13 +0000
Message-ID: <20251206180414.3183334-2-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251206180414.3183334-1-safinaskar@gmail.com>
References: <20251206180414.3183334-1-safinaskar@gmail.com>
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
Link: https://lore.kernel.org/linux-i2c/197ae95ffd8.dc819e60457077.7692120488609091556@zohomail.com/
Cc: <stable@vger.kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
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
 
-- 
2.47.3

