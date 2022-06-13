Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A34C3D8E
	for <patches@lists.linux.dev>; Mon, 13 Jun 2022 23:22:26 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id t3-20020a17090a510300b001ea87ef9a3dso7454349pjh.4
        for <patches@lists.linux.dev>; Mon, 13 Jun 2022 16:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B3RxiogwxQ3efUX3+sbp3cwVCT5XzvkaPhVLnHLET4Y=;
        b=BqiMiN+lQO+8l/tGBuOxJn2dFR3aFYKX4uFwvVPTVw9Tj0NCQMlDy4L3Ic/ONqIl31
         wzplWXTVffQhgKN0pb8Qe6+UaeYgrIuAGQgjchacCAgw3eH84QGONtmqN+2GuLf5sKqy
         8neAm2iWJ61No+MZXjc82pQNWaZZjB6WB5IMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B3RxiogwxQ3efUX3+sbp3cwVCT5XzvkaPhVLnHLET4Y=;
        b=Bzb8Fo7XQPrSkO0DFBF4QT7RpCrJzyye6FZszj1vyvLQGDIbbr9ovvxraQ/iESonXa
         FzUcfcjm549Dy0ej4mLHTPZ6TJcEN+BOah9tUD7ZeExgQ8M84G9F0+HMMcQW/DTjUjoj
         YXmLMPnjr/coIhNt9k35jQZUQr/p9Sz70aG/kVcihUONCjHQroeIwzqgvJYJ0sSpde3Q
         5Goa22uHXHG5/mN+Oy7lAapSPFNM92Is3U5NrFMguPfGVr497bbHRODwa9kRWWC30Afa
         cyZw9gi+bYwTKwBrwp3dUqifMwB/40KaQuhMkP/h6aNR4DDrcl4s/M4rlEVM2NdhaaTk
         /ppg==
X-Gm-Message-State: AJIora983iyDj3b7Mx/BCzji9oJJvV2x7OR8BAk6HAR5T3KsMG3YUAr+
	k+6vjYzqbUizVSm2+T3xoZGR7Q==
X-Google-Smtp-Source: AGRyM1uhlZCnyIP4x2P9IFkCataXFtmzmEbxJHxrC4AW0Y0NWP6mb3j4cyOf8LdmLE/f++Ma2sk8Zg==
X-Received: by 2002:a17:902:d50b:b0:165:2aa0:4b22 with SMTP id b11-20020a170902d50b00b001652aa04b22mr1358214plg.131.1655162545532;
        Mon, 13 Jun 2022 16:22:25 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:82ae:1136:b202:95da])
        by smtp.gmail.com with ESMTPSA id s9-20020a63af49000000b003f5d7f0ad6asm6057407pgo.48.2022.06.13.16.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 16:22:25 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Aashish Sharma <shraash@google.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-iio@vger.kernel.org,
	Gwendal Grignou <gwendal@chromium.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] iio:proximity:sx9324: Check ret value of device_property_read_u32_array()
Date: Mon, 13 Jun 2022 16:22:24 -0700
Message-Id: <20220613232224.2466278-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aashish Sharma <shraash@google.com>

0-day reports:

drivers/iio/proximity/sx9324.c:868:3: warning: Value stored
to 'ret' is never read [clang-analyzer-deadcode.DeadStores]

Put an if condition to break out of switch if ret is non-zero.

Signed-off-by: Aashish Sharma <shraash@google.com>
Fixes: a8ee3b32f5da ("iio:proximity:sx9324: Add dt_binding support")
Reported-by: kernel test robot <lkp@intel.com>
[swboyd@chromium.org: Reword commit subject, add fixes tag]
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/iio/proximity/sx9324.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/proximity/sx9324.c b/drivers/iio/proximity/sx9324.c
index 70c37f664f6d..63fbcaa4cac8 100644
--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -885,6 +885,9 @@ sx9324_get_default_reg(struct device *dev, int idx,
 			break;
 		ret = device_property_read_u32_array(dev, prop, pin_defs,
 						     ARRAY_SIZE(pin_defs));
+		if (ret)
+			break;
+
 		for (pin = 0; pin < SX9324_NUM_PINS; pin++)
 			raw |= (pin_defs[pin] << (2 * pin)) &
 			       SX9324_REG_AFE_PH0_PIN_MASK(pin);

base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
https://chromeos.dev

