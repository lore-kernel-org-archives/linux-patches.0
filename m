Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DA253E18
	for <patches@lists.linux.dev>; Mon, 19 Feb 2024 20:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708374214; cv=none; b=RGONjt2cQouuyMWb6IU63CBDl47ypJtd43mOYbS2TvT9Rx4cPCWmHftlhAv/NBYRcJiWxj+6hYP9j69fwYT/5683BFRE1HoIf8zri9XF7bs9lIYAFBV+nA/hhKbsOch0Jarf7l2Iwt11axzJf70Vh8tbVZzFjVLyarz6Q0vOsCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708374214; c=relaxed/simple;
	bh=1LpOcOPE8NF67KY2Om+0rc+yLxqoD9d+aNt1OJgcsWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO4oBSAD0cePSSAcqfRE8RVltapFDOVBdk3izsRSz+GaxYlPqeuDgheHgD7PCi10ApocdX+Y6UwP3AjryYZPeIjGchASxS8d+iLUlRx0FwmfbsqYJlDMUJMG3NCDzXSfPJob4DW0pvTR5omszD68BObczgkIrAoMDbvQTeED1Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Z7+pLTf0; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Z7+pLTf0"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-5ce2aada130so4233167a12.1
        for <patches@lists.linux.dev>; Mon, 19 Feb 2024 12:23:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708374212; x=1708979012; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GaHCMRLTHpVjbQpn0nm8Soa0CT5I0pTuDvK1Y4TvoOs=;
        b=Z7+pLTf0rKydqKbUEnAvXuz41DgwS+JxpWkB+VnATJnKQn85JCLMmYE5CgvVwDipBu
         0S2oKXJHwmG8n+pv65t0IbEHLJwjnFxVgAbmGZEh2YDu6n5qloswH+C5piN4PkDpTFlA
         ua3URxhCdtUqotDrnP6NbHUuN9mkEjNAepcoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708374212; x=1708979012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GaHCMRLTHpVjbQpn0nm8Soa0CT5I0pTuDvK1Y4TvoOs=;
        b=blt8918tSj7bdRBIpdSTbfrwE6jmXG/BplIC9w/YfV6NxqKr6uMHyAZtUreFbyouOj
         MOjf/GbJG7jIe1NfSrOY9Kd7ycot5ZnQtphDAwg5PsbQcJF4ptYvtAHNSlscj95zmEO8
         PC0RQQAYy33hnuoxCk4TAW27ONIuX95vzAzWGbif36W3/WPOlgeH0HxntyNNgsyEZmQ7
         kuCRlLp2BCXBj3dggYF9I6iBJpXKXRIIETDCPpYJCjOqVXjgaeoVuzgNm8wHEzYTpBDk
         uqxMPiqSUgVz4RJu1np3lFx/lcVA/fRIQvBkQd0eKGGP9696i0RMFUyOVdLgMU7NZPYN
         r5qw==
X-Forwarded-Encrypted: i=1; AJvYcCULy5peT1XA0dGlc+WjdIOwTOsD5d5bzkQx8+zkYMmndBPHqNRukibkpf3uJhG34FEGccP2akla35GaWCadpG++NOy8uP3cQQ==
X-Gm-Message-State: AOJu0YwURRANuGxHiHtiRiHuSIz1kPSIdHcGPSy820rHCnI8Lk6e1wgV
	gtH39SZpnnZZ1Wa1OWrgLtRHjZ9tQAMe/p6M9gq1JgTGtJ21rlZVP/c541uUBw==
X-Google-Smtp-Source: AGHT+IEAUG2tvGVJGd+hj3U8ybO/DpLRVg66FdpMvbg2eIV6gnVcioXBOcc/U9zxzq4OgB0t7uZbUg==
X-Received: by 2002:a17:90a:b382:b0:299:3e54:83f3 with SMTP id e2-20020a17090ab38200b002993e5483f3mr6532900pjr.38.1708374212270;
        Mon, 19 Feb 2024 12:23:32 -0800 (PST)
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id e21-20020a17090ac21500b00298dd684b8csm5810598pjt.32.2024.02.19.12.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Feb 2024 12:23:31 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Lee Jones <lee@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	chrome-platform@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>
Subject: [PATCH 2/2] mfd: cros_ec_dev: Add gpio device if feature present on EC
Date: Mon, 19 Feb 2024 12:23:24 -0800
Message-ID: <20240219202325.4095816-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240219202325.4095816-1-swboyd@chromium.org>
References: <20240219202325.4095816-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ChromeOS embedded controller (EC) supports setting the state of
GPIOs when the system is unlocked, and getting the state of GPIOs in all
cases. Check for the feature support by checking for the GPIO feature
and then populate a sub-device for the gpio hardware on the EC.

Cc: Lee Jones <lee@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Benson Leung <bleung@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/mfd/cros_ec_dev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mfd/cros_ec_dev.c b/drivers/mfd/cros_ec_dev.c
index 603b1cd52785..9c3f8488b416 100644
--- a/drivers/mfd/cros_ec_dev.c
+++ b/drivers/mfd/cros_ec_dev.c
@@ -74,6 +74,10 @@ static const struct mfd_cell cros_ec_cec_cells[] = {
 	{ .name = "cros-ec-cec", },
 };
 
+static const struct mfd_cell cros_ec_gpio_cells[] = {
+	{ .name = "cros-ec-gpio", },
+};
+
 static const struct mfd_cell cros_ec_rtc_cells[] = {
 	{ .name = "cros-ec-rtc", },
 };
@@ -97,6 +101,11 @@ static const struct cros_feature_to_cells cros_subdevices[] = {
 		.mfd_cells	= cros_ec_cec_cells,
 		.num_cells	= ARRAY_SIZE(cros_ec_cec_cells),
 	},
+	{
+		.id		= EC_FEATURE_GPIO,
+		.mfd_cells	= cros_ec_gpio_cells,
+		.num_cells	= ARRAY_SIZE(cros_ec_gpio_cells),
+	},
 	{
 		.id		= EC_FEATURE_RTC,
 		.mfd_cells	= cros_ec_rtc_cells,
-- 
https://chromeos.dev

