Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E984802
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 00:04:11 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id ll10so14304067pjb.5
        for <patches@lists.linux.dev>; Mon, 18 Apr 2022 17:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s7ea13iPnpt+q7dmqo2mRLY0/XBrF29qE6q2CxF1o/A=;
        b=PSmNxogKyxaZ6FEJ0SgIM3n3i0PJZTT/kM7G2KnyuTqzyQaD95trQnfjILvGKWf5c/
         rWLkeBAgiPFoKHS7OXgYT0cD6/rZPpThbWBHm1xvjM/R9VldOUXu5VOXc/Vbflm+Y9f7
         qcnQR9Vq3+Ep6s8hNDEyPFW5/jezlN7+EFtQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s7ea13iPnpt+q7dmqo2mRLY0/XBrF29qE6q2CxF1o/A=;
        b=s7KCzkNeasD8nhz2FX6jSuYHWTZcKyP4+rOF1HfGPkoxLyoPlswPnVat+ncs5BzIm0
         2rPPQxDN8ftSu6MkIC4DI3ETj82lztwttRJmaznnFPxZG73DT/COF6eDVtbK0jDWCAJ6
         NwGihViy6w7hXj7f8Q5JyIGbgoH6CsXW2rpML0pxXcATMKdZjNSJ7nmhO5PapACHQD2A
         sPxap54pDFWv40UyyxazKAYOYgtrvBlasTEhoTnd8DP2DlTEHDUgbYQqeS6/oYH+zYO+
         NxlbUXWa+Ezfu6wIPd9KWADVS0PxrBI992sUHd2E1fPXGhk/Isw3er+sdYDKu0wLWJBz
         EOLw==
X-Gm-Message-State: AOAM531nrtcXV1IzfKWxZisnVVfeO1Rgsn81s8MhXIH5amt5lK/lMkqp
	UQ3ojkkWMFDfAfL5KkJtzwj8GA==
X-Google-Smtp-Source: ABdhPJz1N+a3rBLZ1RqMg3FLpMZPuR57Nigj7DvPPXLWFtXb0YZjjek0X7KdVgVIlBcDzR6HwAMGrA==
X-Received: by 2002:a17:902:ed83:b0:158:c459:ab59 with SMTP id e3-20020a170902ed8300b00158c459ab59mr13276330plj.161.1650326650775;
        Mon, 18 Apr 2022 17:04:10 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:4c14:390b:e6f0:6df7])
        by smtp.gmail.com with ESMTPSA id z8-20020aa785c8000000b005060d2d7085sm13695716pfn.151.2022.04.18.17.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:04:10 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: [PATCH v2] mfd: cros_ec_dev: Only register PCHG device if present
Date: Mon, 18 Apr 2022 17:04:08 -0700
Message-Id: <20220419000408.3202635-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't create a device for the peripheral charger (PCHG) if there aren't
any peripheral charger ports. This removes a device on most ChromeOS
systems, because the peripheral charger functionality isn't always
present.

Cc: Prashant Malani <pmalani@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>
Cc: Daisuke Nojiri <dnojiri@chromium.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: <chrome-platform@lists.linux.dev>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---

Changes from v1 (https://lore.kernel.org/r/20220415003253.1973106-1-swboyd@chromium.org):
 * Use cros_ec_command()
 * Drop the other patches that aren't needed anymore

 drivers/mfd/cros_ec_dev.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
index 546feef851ab..596731caf407 100644
--- a/drivers/mfd/cros_ec_dev.c
+++ b/drivers/mfd/cros_ec_dev.c
@@ -114,6 +114,9 @@ static const struct mfd_cell cros_ec_platform_cells[] = {
 	{ .name = "cros-ec-chardev", },
 	{ .name = "cros-ec-debugfs", },
 	{ .name = "cros-ec-sysfs", },
+};
+
+static const struct mfd_cell cros_ec_pchg_cells[] = {
 	{ .name = "cros-ec-pchg", },
 };
 
@@ -137,6 +140,7 @@ static int ec_device_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct cros_ec_platform *ec_platform = dev_get_platdata(dev);
 	struct cros_ec_dev *ec = kzalloc(sizeof(*ec), GFP_KERNEL);
+	struct ec_response_pchg_count pchg_count;
 	int i;
 
 	if (!ec)
@@ -242,6 +246,21 @@ static int ec_device_probe(struct platform_device *pdev)
 		}
 	}
 
+	/*
+	 * The PCHG device cannot be detected by sending EC_FEATURE_GET_CMD, but
+	 * it can be detected by querying the number of peripheral chargers.
+	 */
+	retval = cros_ec_command(ec->ec_dev, 0, EC_CMD_PCHG_COUNT, NULL, 0,
+				 &pchg_count, sizeof(pchg_count));
+	if (retval >= 0 && pchg_count.port_count) {
+		retval = mfd_add_hotplug_devices(ec->dev,
+					cros_ec_pchg_cells,
+					ARRAY_SIZE(cros_ec_pchg_cells));
+		if (retval)
+			dev_warn(ec->dev, "failed to add pchg: %d\n",
+				 retval);
+	}
+
 	/*
 	 * The following subdevices cannot be detected by sending the
 	 * EC_FEATURE_GET_CMD to the Embedded Controller device.

base-commit: 3123109284176b1532874591f7c81f3837bbdc17
-- 
https://chromeos.dev

