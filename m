Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF171CAA1
	for <patches@lists.linux.dev>; Thu,  2 May 2024 23:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692890; cv=none; b=TMFZ3xari4hbaiioHzjJ7zsPtzV3rO0o/uoodtZUVH1dGD5DUp2ZcQIlnMqxijmveHsB5u+PpiDLQdO+bog1nTl/VFbtdrIQFN0kmliT+S5ivCEIMReuiz2z4yiJVK2DViXHUj20V8XPSiG2c5YlSyyxoJ6FMnWbFNrYlDIsc8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692890; c=relaxed/simple;
	bh=+oAJcfJZ0iVz0HfgcZd1hd5sbZu4K44B4j8j7JhkyHE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IsUE0eP0hNxOEAtp6VUpHWSSSB107WnBjmHM+JgPnWfMVE8ZilOw5ygVrYuHx2HWHMuDBV6nICUDLKY1YaUlKCvoQcVAPD/aKtqs+fojGf3wXpxzS2AIrZ6HbkJAAJoAS3Lc1VI2bXFUaKieq1vX/Gp62pZpem25Jd9haQfHSfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KZGxMFDl; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KZGxMFDl"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e4c4fb6af3so17578605ad.0
        for <patches@lists.linux.dev>; Thu, 02 May 2024 16:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714692889; x=1715297689; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yZPhCGRyt2DJnFXWEm7SVWPd/lIZ+/DjudobDa5jvRA=;
        b=KZGxMFDl6u/ogeGO81mW/XpJ2ans0zCqMH0UuBuywypL453cHVlDTspUYX0cba9QMx
         0ofXlBC8su/lZ4lCncDC3rmLd2DL1wqY4wDdhV5bHa1sVCT0ApRnwgsbr0lVEfPZmviN
         HtmR7cFV0n64vmuhSPytS8m/nDgppdI27HYyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714692889; x=1715297689;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yZPhCGRyt2DJnFXWEm7SVWPd/lIZ+/DjudobDa5jvRA=;
        b=OmbyjB2gzuAH72lIOqarGrFNMojGcrENAe1fUC6Ms6+K2O2eX3bGi9Lk0m9IpDm3qj
         eycJ0JFuMmVTyjoqWHg2fA3NHfNK2PVNNLJjYFECgPOPBkBS2B6Yu9NO7pIAx4hbgAOl
         hQWWmLLOkbijAK16awBgJxCuBL/wLNfjmKPF82udWLu4x+6R0L5lEdWSXQxmN76r4Y+t
         QjXJQb2QZHBDbll7Xjcr7BIOymrOB1u+s2r8I5iiS2rUiPhu/vG2Prw54qMroWoYZQA4
         WOtm3lW3H36orqwJAM2YPK0/ltIs6DsR2/tLxhg21oHRZ/zsjIIVKY263vZP0ET8nYiK
         b1TA==
X-Forwarded-Encrypted: i=1; AJvYcCVOBUtyduvnPRE+4rL+sHs19IrVsOwKrUd6i+pIf91PHsHyTFgQVBW1uY2CRLWBpgBlQ0fOyoBuM+bwfpM4CHssj2rsPyUawg==
X-Gm-Message-State: AOJu0YxctK8InWnRM9T8tcIaxCkENPlWpOdqDPFtjIK0v65zd9ayoaZl
	HLWEpYQqNwuYlTc169zy1S+ohHxBQzpDshNQ6ORXaE5Nz/A8m+3zMMyMsRImKA==
X-Google-Smtp-Source: AGHT+IFKEyZC+FYK5ZAlKbPbSEB4TliBsHleowx8lMo5aBrupO2xayGkJ0+wK22L0fS4s7UHuycCxg==
X-Received: by 2002:a17:902:b085:b0:1ec:7084:3d8d with SMTP id p5-20020a170902b08500b001ec70843d8dmr5177281plr.9.1714692888764;
        Thu, 02 May 2024 16:34:48 -0700 (PDT)
Received: from localhost (4.198.125.34.bc.googleusercontent.com. [34.125.198.4])
        by smtp.gmail.com with UTF8SMTPSA id la13-20020a170902fa0d00b001ec412676adsm1903006plb.275.2024.05.02.16.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 16:34:48 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	dann frazier <dann.frazier@canonical.com>,
	Hanjun Guo <hanjun.guo@linaro.org>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] clocksource/drivers/arm_arch_timer: Mark hisi_161010101_oem_info const
Date: Thu,  2 May 2024 16:34:46 -0700
Message-ID: <20240502233447.420888-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This isn't modified at runtime. Mark it const so it can move to
read-only data.

Cc: dann frazier <dann.frazier@canonical.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/clocksource/arm_arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 8d4a52056684..5bb43cc1a8df 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -331,7 +331,7 @@ static u64 notrace hisi_161010101_read_cntvct_el0(void)
 	return __hisi_161010101_read_reg(cntvct_el0);
 }
 
-static struct ate_acpi_oem_info hisi_161010101_oem_info[] = {
+static const struct ate_acpi_oem_info hisi_161010101_oem_info[] = {
 	/*
 	 * Note that trailing spaces are required to properly match
 	 * the OEM table information.

base-commit: 4cece764965020c22cff7665b18a012006359095
-- 
https://chromeos.dev

