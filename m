Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56023130A7B
	for <patches@lists.linux.dev>; Wed, 27 Mar 2024 20:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711571267; cv=none; b=QW3lXJ6wmUsKqerYStHnoGX6QDjDAyN4VyUmheXDEpX2FuT+Aq0QmDGsZ3h/sgLbIIkLok9tiqmtDxR/HWx8NtFwQ2yFuA7ZVQgh37RdogfphG1r2wXUnnEbuzoCJjSfGDI2QgCp48w5L0+YH/phWFRsygAS5ACaZKGpAYCiNTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711571267; c=relaxed/simple;
	bh=UAlyW1XBQGh1I1s4OhUVYVSvSBWjHao81V/7b/ey64s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z3xUGNvc4nQY61TKTdxnu9K36G/Z+34vRRpdIyKGQpdi3lTMlFtNBgtRQ2PMEJh1CixtFWv7m7TpDeKqABru2X45AT85vnZ9dBL+NwwiRuSs3PUep2cDYYQeYn4/4mD8H81nPh4PzJIAXmh+n5TZ5HOFLZs2bo3v+NRQGPnFlFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ocZ+7THe; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ocZ+7THe"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6b5432439so285853b3a.1
        for <patches@lists.linux.dev>; Wed, 27 Mar 2024 13:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1711571264; x=1712176064; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LCVHzKM95nxrye1cfXoHnsCw/TjZEQVmmlga0bm4uZk=;
        b=ocZ+7THeLHiLWfkAdlSuw+kWMoCC2yQF0x0BI0P8k9nWgPmcnj6ksUHgpoEELHeP9I
         NfiqNGPihQxwaxRpT+x+9BwOxwQuK/FqAosVNDZy3yBmGalfIErcGGB4ERs4JF2DHUYN
         1p5gl9uhKB3SzDJ4SSKKlalm7c4PEUhqNSGpM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711571264; x=1712176064;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LCVHzKM95nxrye1cfXoHnsCw/TjZEQVmmlga0bm4uZk=;
        b=jmsoQwgZoUjG5z7gBgnEC3DbLqHZmI+f48J3Ep5IalFmES2PN1jvkAY1lHwRk94wZJ
         cCoUkeYvu4HlinHaEyKavMPQ1KwNdsyVfNUqZwqccSLKRjiBG5ZmI+6eTRH4azXGWEOl
         iSPemWz1T5g75I9JV34Qx0ms6KhTYdx1J9BHcjBg5dIx1yLrsuB4sM7fjhEuMZ3SCUAf
         hOaEkHLJYZy29YO4tqv2L+5IgoA4eAZjrMBp7irVc8lkP/sPXFL6BTjwbPji883XWQ6o
         OZ7PgJGsU2aTZvaB8wCbypIim1mcVbQ2Fh5TyQp/hzFlNGzORBLeopZobUNKeRVpLRRp
         w7uQ==
X-Forwarded-Encrypted: i=1; AJvYcCUL4bI8ljiI1wm3cU5YC1+HAEuNkpNaUuYsL6dH0gNf61mD26QghF0I0KoZFNdMLVNndmFyI0P+joHc5Z+4ECItwwa0CnO1/g==
X-Gm-Message-State: AOJu0Yyt5MrfyTIE291Wfs0GCksTLNVCGiaXLJOp1oQkCYM6tsqPcUny
	6bB2iLlJuSaPszdlNnPdDaiKaflaUqL6h+uXjoVAmEvGyI8fOVYt7rtqzNdxgA==
X-Google-Smtp-Source: AGHT+IHA1C7H1G9I13NxUAKmeyvwBUmBLxBfdkaCF4Xl43hsabFFNBcw1oAA9mmdxMEWX6SsZ2Maiw==
X-Received: by 2002:a05:6a20:7495:b0:1a3:683a:2cbd with SMTP id p21-20020a056a20749500b001a3683a2cbdmr1160699pzd.17.1711571263614;
        Wed, 27 Mar 2024 13:27:43 -0700 (PDT)
Received: from localhost (4.198.125.34.bc.googleusercontent.com. [34.125.198.4])
        by smtp.gmail.com with UTF8SMTPSA id e3-20020aa78c43000000b006e56bf07483sm8303143pfd.77.2024.03.27.13.27.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 13:27:42 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Laura Nao <laura.nao@collabora.com>
Subject: [PATCH 0/2] Fix a black screen on sc7180 Trogdor devices
Date: Wed, 27 Mar 2024 13:27:36 -0700
Message-ID: <20240327202740.3075378-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series fixes a black screen seen at boot on Trogdor devices.
The details of that problem are in the second patch, but the TL;DR is
that shared RCGs report the wrong parent to the clk framework and shared
RCGs never get turned off if they're left force enabled out of boot,
wedging the display GDSC causing the display bridge to fail to probe
because it can't turn on DSI.

The first patch is basically a hack. It avoids a problem where the mdss
driver probes, turns on and off the mdp clk, and hangs the rotator clk
because the rotator clk is using the same parent. We don't care about
this case on sc7180, so we simply disable the clk at driver probe so it
can't get stuck on.

The second patch fixes the shared RCG implementation so that the parent
is properly reported and so that the force enable bit is cleared. Fixing
the parent causes the problem that the first patch is avoiding, which is
why that patch is first. Just applying this second patch will make it so
that disabling the mdp clk disables the display pll that the rotator clk
is also using, causing the rotator clk to be stuck on.

This problem comes about because of a combination of issues. The clk
framework doesn't handle the case where two clks share the same parent
and are enabled at boot. The first clk to enable and disable will turn
off the parent. The mdss driver doesn't stay out of runtime suspend
while populating the child devices. In fact, of_platform_populate()
triggers runtime resume and suspend of the mdss device multiple times
while devices are being added. These patches side-step the larger issues
here with the goal of fixing Trogdor in the short-term. Long-term we
need to fix the clk framework and display driver so that shared parents
aren't disabled during boot and so that mdss can't runtime suspend until
the display pipeline/card is fully formed.

Stephen Boyd (2):
  clk: qcom: dispcc-sc7180: Force off rotator clk at probe
  clk: qcom: Properly initialize shared RCGs upon registration

 drivers/clk/qcom/clk-rcg2.c      | 19 +++++++++++++++++++
 drivers/clk/qcom/dispcc-sc7180.c | 14 ++++++++++++++
 2 files changed, 33 insertions(+)

Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Taniya Das <quic_tdas@quicinc.com>
Cc: Laura Nao <laura.nao@collabora.com>

base-commit: e8f897f4afef0031fe618a8e94127a0934896aba
-- 
https://chromeos.dev

