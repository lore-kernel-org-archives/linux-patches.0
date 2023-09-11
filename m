Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B705FC157
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 11:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7739DC433C9
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 11:51:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y8pgf+S/"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Mon, 11 Sep 2023 12:51:01 +0100
Resent-Message-ID: <ZP7/JVnw3oWpYCaB@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 11 Sep 2023 09:28:05 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=2kaG=E3=linaro.org=linus.walleij@kernel.org>)
	id 1qfcH4-00AW2L-SU
	for broonie@sirena.co.uk; Mon, 11 Sep 2023 09:28:05 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id A38A0B80DF7
	for <broonie@sirena.co.uk>; Mon, 11 Sep 2023 08:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7E56AC433C7; Mon, 11 Sep 2023 08:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 90EE0C433C8
	for <broonie@kernel.org>; Mon, 11 Sep 2023 08:28:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 90EE0C433C8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-502984f5018so5462696e87.3
        for <broonie@kernel.org>; Mon, 11 Sep 2023 01:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694420878; x=1695025678; darn=kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6Ant9w/M8lJ8/bqeJlIlR81Dk6HgwwGjD6bLZoS2FcM=;
        b=y8pgf+S/FQxjnP66qiOM8rOB3Iwln32w679gTAA9gdrKVfUGgBYdNCxzirRyzi354H
         miSaxDbWpvZaAvli0iCqvn1W04r966LH7EEFUPbM+lDHwBtZv3IDU0RQd883DN/XWBQY
         6UjmjuIkMI7TJ2pdaOvMBt6uURVxhm8IthFC3G4IxgAVT2wZJXKg3nGXkMhgMPmEA17R
         EUXx8E1qtZBmbSIFs+WxGd07/JfXeuPTn2IzAkUYRCr+5t1Vq2MSjQiY+k19j5HMbzyK
         z6WleLiEIW0wEbuP+xLbk5wFUXjBGfH97AhDVAMxP+mwa+mCaNmEKpZCzzaDNahIaRns
         +IKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694420878; x=1695025678;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Ant9w/M8lJ8/bqeJlIlR81Dk6HgwwGjD6bLZoS2FcM=;
        b=NwZXcgbX8bR96dhtXLoz0IlQQinxrgdDTjcmZQbk8ZoR0JLb58BadQblZQa3N8q5Y8
         746sCnusoKunX0N4w5hlNEH0ueWteCbHkEi4o8R3rZ1RcLUk0A+gj+XFrymVNNg9EVgU
         AiOvty0GBBCyN9hMQpn2oiMThGmOugh7hMIdXyeNjUhKZBhLKzlxgljcQS9pt7fLbwN6
         EaAxIHqtryLydOB6X0jF6Q0fd/HnQhUx6IdZzD3eRBbVMYhWcUIDTrfX+6kyIY8TSGtL
         AxQUNVQ8NBsh1/VlvZcIZzXhYILN5YMa5iGRcCRQwuYcYrLamE3ECeEm+2FTW+043Tmv
         iing==
X-Gm-Message-State: AOJu0YyjjpeVpAI6jsSrLAfXkaoyM75/MFGEhq5CqwkszYWu15e9+Emy
	n91GgXHbpEkKVFALYyOML/tbTPVpvfC2aa7NfR4=
X-Google-Smtp-Source: AGHT+IFLGIOqVnXFWErddjEW3L5OvOYLNCSgzbMfhN71ZCO7WhkLQqRXFrPnDwQ63q3uvX2l/z43bw==
X-Received: by 2002:a19:2d17:0:b0:500:9946:9c69 with SMTP id k23-20020a192d17000000b0050099469c69mr6021171lfj.29.1694420878624;
        Mon, 11 Sep 2023 01:27:58 -0700 (PDT)
Received: from [127.0.1.1] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id h25-20020ac25979000000b004fe83d228e4sm1268022lfp.71.2023.09.11.01.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 01:27:58 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 11 Sep 2023 10:27:58 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230911-descriptors-regulator-v2-1-ce978c52c557@linaro.org>
X-B4-Tracking: v=1; b=H4sIAI3P/mQC/42NQQqDMBBFryJZNyUmWqOr3qO4iGaiA2Jk0oYW8
 e6NQqGbQnfzhv/+X1kAQgisyVZGEDGgnxPIU8b60cwDcLSJmRRSCS0qbiH0hMvdU+AEw2My6eQ
 KbGUK6ayoJEvuQuDwefTe2sQjhhR7HTMx37+fRv2jMeZccOlcqTpxMV1prhPOhvzZ07Av/KPXq
 u5K0IW1uf7W223b3gNeCW36AAAA
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.12.3
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=2kaG=E3=linaro.org=linus.walleij@kernel.org
Subject: [PATCH v2] regulator: rk808: Drop useless headers
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: DCMQYsENm/J8

The RK808 is already using the proper <linux/gpio/consumer.h>
header and includes the legacy headers <linux/gpio.h> and
<linux/of_gpio.h> for no reason, drop the includes.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
This removes some low hanging dangling <linux/gpio.h>
includes.
---
Changes in v2:
- Just the dangling RK808 patch from previous work remains
- Link to v1: https://lore.kernel.org/r/20230808-descriptors-regulator-v1-0-939b5e84dd18@linaro.org
---
 drivers/regulator/rk808-regulator.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 867a2cf243f6..e374fa6e5f28 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -15,10 +15,8 @@
  */
 
 #include <linux/delay.h>
-#include <linux/gpio.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/of_gpio.h>
 #include <linux/mfd/rk808.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>

---
base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
change-id: 20230807-descriptors-regulator-3ed7a42fd072

Best regards,
-- 
Linus Walleij <linus.walleij@linaro.org>

