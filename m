Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A198F18EB0
	for <patches@lists.linux.dev>; Thu,  2 May 2024 23:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714692621; cv=none; b=XD9XocyoUZoeKcO7ImLiVa2Fc20thACpHtXjjSz9+WK0lOwBlSSn1e+A/4WsnJH3jza77f3Y6RVZ7F0L8WFiC2fVi1ZWTusUbEPRUO3RXvT64DkwHV/Y/5vFX1kNhOWRXet7h56DR2OtJDMoISDrNTHAhfTvpRXC0/NWsV8A5p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714692621; c=relaxed/simple;
	bh=ieLJkhs2QHRkxAuQ7oeBN/5dxz1NuU1GS5D6U1nGO3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SfVx6E95x4BQ23CJXDEfkfpFI3dRc2PPcFqQTQP1oXGihZCPldwQBlZs3QzNtkv0AXPKAEwXQ6iuFSk0IPcaHgJd22cZn1mTtBoLTERRXSPnKciCbxh1MIbz04HTM3+Px8QeUDpoOS+JSszmgsvFCMMpLBVkVIE71DAHB4kEULo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=BRSQjPSm; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BRSQjPSm"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-613a6bb2947so3633928a12.3
        for <patches@lists.linux.dev>; Thu, 02 May 2024 16:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714692619; x=1715297419; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4aHlRU+lYNz9FFM2hjk7x/6oGNEaOSMbIgLXm8XygnI=;
        b=BRSQjPSmeZJ4hJU7H3aZeSVzN6bFATTXh1qvrfHqeoPDRndd4y/r0muXi8ITNC1orV
         JQlgpnpgVan5RTQxJWDYhGHeiSp++oE2UQ+8zo+Jouzf5dRq1TFrgVKNbQEUtYT54g87
         Lm7zC685VLOCL0F104kZfcysHd0VtxRDpaZpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714692619; x=1715297419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4aHlRU+lYNz9FFM2hjk7x/6oGNEaOSMbIgLXm8XygnI=;
        b=ifUnAHTELC1J+vZkLk6zFbHZ1mHockh7vayvaT45IQ3eb5DAVyBATCqaiUotr00kh7
         MkP2V1Yp3B5sY9haBuV5UZsmnolY0kReOZMbFjAuXbs75MTAEwZAKDuTmfk2uM05YgRe
         A7LrQZ9InEKo8leQL1JSxLZDpP9opVLMyqMMr7T7TSz5VvfkiqH5H7TNP7ogEAaYF8CH
         jOgBqmw1cCtHBAdukqDNoc/G1hSoY3qj0qPMh+E6JY2138Y1vH+6Gk/OzmLs9xG8rtTO
         FvYW+0jWeQdrpnO8dP58y7DqHe5gY8rTRnITik9kBrYSG1ZXwpYKlKjsUSYY90RvCX5p
         +9BQ==
X-Forwarded-Encrypted: i=1; AJvYcCVML3J416sv07GCsVyFRrhQ33L6mqRRLIYY/RxfpyC2mlyTPb8BItduu+yLZnIlXZOX+vPhjyNxPROG/5NdVKSTPnXFvKTk0g==
X-Gm-Message-State: AOJu0YzvlK/Ss4qRUu23vHuFHY/z+97W4uwfvmZKTCYMU3mxychW54w2
	ra2OZQnbJZHolAzFXAaADINYw2QzStvV+Ovww+S5kFmqyVV9ayNkk2mmcwc39A==
X-Google-Smtp-Source: AGHT+IHKrfn8+eXI8IWJ2Tfq/Z+DpLDHoUndaSRPdcyF4wNGAdIV5FDxV8ykztx/38ibgvf4U9YTJw==
X-Received: by 2002:a05:6a21:329e:b0:1a9:fe63:90f0 with SMTP id yt30-20020a056a21329e00b001a9fe6390f0mr1553336pzb.53.1714692618977;
        Thu, 02 May 2024 16:30:18 -0700 (PDT)
Received: from localhost (4.198.125.34.bc.googleusercontent.com. [34.125.198.4])
        by smtp.gmail.com with UTF8SMTPSA id j4-20020a056a00130400b006ed2709ada6sm1825666pfu.65.2024.05.02.16.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 16:30:18 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Jisheng Zhang <jszhang@kernel.org>,
	Ionela Voinescu <ionela.voinescu@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] clocksource/drivers/arm_arch_timer: Mark validate_timer_rate() init
Date: Thu,  2 May 2024 16:30:15 -0700
Message-ID: <20240502233017.419365-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the __init marking to validate_timer_rate() so that it gets
discarded after init.

  $ ./scripts/bloat-o-meter vmlinux.before vmlinux.after
  add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-8 (-8)
  Function                                     old     new   delta
  arch_timer_register                         1724    1716      -8
  Total: Before=69177808, After=69177800, chg -0.00%

Cc: Jisheng Zhang <jszhang@kernel.org>
Cc: Ionela Voinescu <ionela.voinescu@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 drivers/clocksource/arm_arch_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 8d4a52056684..9c4a4af25d2c 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -1045,7 +1045,7 @@ static int arch_timer_starting_cpu(unsigned int cpu)
 	return 0;
 }
 
-static int validate_timer_rate(void)
+static int __init validate_timer_rate(void)
 {
 	if (!arch_timer_rate)
 		return -EINVAL;

base-commit: 4cece764965020c22cff7665b18a012006359095
-- 
https://chromeos.dev

