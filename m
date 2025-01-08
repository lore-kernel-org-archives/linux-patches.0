Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13C586AE3
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 01:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736299732; cv=none; b=ZCluaTN/zZ4WrXgkLQ3kCLumPTA8tpzDIu4jCAbjP6iHqkJIu5ypiICC2VmRaByWIkEstVxjx6Zj2QGTGbMbkPUilpadhFxuG2aDVUenhfMolwFdjjUABgMWx7W63oJNvbJa7VlvDB3bpocUpCT2PZUuujVjuxJARqo2BwAUKoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736299732; c=relaxed/simple;
	bh=bqg0+FMlOKL/Oya+KGSPfGQW2exu4yfKcdmsG6B/3po=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N5eGWlX1hPNMho2U5Ny53lnxC5CISeKmg/w4Cj+kIb+YV6oAfTrRPTUJ6BZmvJ1XUFdYje5CvChg0A3GfGFTnU/wLd4VtU9vU3UXUrkcDjNvGDcSQC7HegJlI8/po+JQivbNZ4FmwECGU9gF6IuVJorsFf1U2Hjt1EKr3/S9pf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=dVm2r70W; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dVm2r70W"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee51f8c47dso18818565a91.1
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 17:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736299729; x=1736904529; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tqd+1cGHPrlBvYanevBgNpqOS63DSGTtWvcDTpfRh2k=;
        b=dVm2r70WuQ6unwjo2UauO7Np1ZPDiUZoNGU9LbAUxfFe8vKRQUwyTmD/293Gtq8F89
         m/yzj26vQIcKP4oHtDLvwTI6uAtPozM1rru7Rlrr4L9jDuiZmR0J0w6dF4ljycTp+kyd
         J1F1YgqUWamaNrnd6+oBMdCqg/JLhbPcm+suQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736299729; x=1736904529;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tqd+1cGHPrlBvYanevBgNpqOS63DSGTtWvcDTpfRh2k=;
        b=QyXwG2nQ3t/1sIG8UDYjbQWQluHLsH/NPITZ2qloY/sXglPsIh4MvmqAb82Jyyh0xm
         PClyKEOSAw1UP0mj/dY8ZqGpiaZ3Pz1xOWToDaVdyUMANTYPbvhrLVOrStoM9QWYXnEN
         /rdT3gVRjLfYvRi4U3GekORdxOr8rESkRa0HL1BHrKMEnxTFzMdp97QvS/GFNeq8/7H2
         97ruipitsB4B6uS0gD1sZaHD0iJNiwalBd0Qhc7MjaAaUPVj/1J8IFqH9QA0D4UxTIwp
         KmbWvQvzCiIk1szEloMfuX4SZLc5d4Nvn4YikO0eU4TMq48uVSM2DHiIRGc4clN7Aq1C
         yT+A==
X-Forwarded-Encrypted: i=1; AJvYcCXZmCvkPIyXhkuxI4ZgbxGPgqiUiRUcLhOqY+jU9Y22NNWF2mtNyAq5nuHgHZ1hGoUuDPOSdf39@lists.linux.dev
X-Gm-Message-State: AOJu0YxSblMXfd0jIuTHkIr8ycJjCjrGt/sioMK293Q7hiJv+Dohc7So
	cHDh9NA76g6tzxEerNAroF6uRMaiAvrkeff53UwzkwvNYDfMVxmr5f7yMiRt4Q==
X-Gm-Gg: ASbGncv99R7PyiiCysYCV8l2RMxi1WFhLdmA97JaUP7TIWt1B/MSBZAeaBdn+jDQMXG
	L2yVlso9+Mvlc2EGZ3GJ+I2+yDuFiypfTaXvM8FQK7JtpQmPgCGzTt8AOzmxHovwwWwkF21+8ZI
	+asqn4Y5Y7GOpe6Rdb1RP3rdMvLkPUk8S17WRqdsxUBM54qUCBPFare0ntjA8g96lUMK2jbUb2W
	ZKgh0UOaa5SKhO8tmhqjAScA4danwyCCzOQien23uDwoXyldAL/E9adH6IbESknY8vOIr1uFNMR
	Nc+9Y0hpKc/foLLMjfwz
X-Google-Smtp-Source: AGHT+IGLMAn658p03PrE1F/SvBkX0kJr3VIC8TJvPQU2lqUj87YfRHHuWKXhHHpqPyBEZ+g+tphMPA==
X-Received: by 2002:a17:90b:5448:b0:2f4:f7f8:fc8b with SMTP id 98e67ed59e1d1-2f548f1c430mr1421193a91.27.1736299729083;
        Tue, 07 Jan 2025 17:28:49 -0800 (PST)
Received: from localhost (129.135.125.34.bc.googleusercontent.com. [34.125.135.129])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2f54a2d43dcsm225080a91.38.2025.01.07.17.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 17:28:48 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Rob Herring <robh@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Arnd Bergmann <arnd@arndb.de>,
	Conor Dooley <conor+dt@kernel.org>,
	Saravana Kannan <saravanak@google.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
Subject: [RFC PATCH 0/6] qcom: Add an SoC PM driver for sc7180 using PM domains
Date: Tue,  7 Jan 2025 17:28:37 -0800
Message-ID: <20250108012846.3275443-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series implements an SoC PM driver for Qualcomm's SC7180 SoC that
creates devices for the nodes that make up the soc node and attaches PM
domains to those devices before the devices are added to the platform
bus. The overall plan is to remove power management logic from various
platform drivers and consolidate it into this SoC PM driver using PM
domains. This series isn't there yet, as I haven't had the time to do
much beyond this starting part.

This is a followup to my presentation at OSSEU in 2024[1]. I'm sending
it out so that the early pieces can land while we work through the PM
domain parts which I worry is going to get annoying rather quickly.

TODO:
 * Populate more child devices and attach more pm domains to test out
   more stuff
 * Set power state of PM domains to match on/off state of resources like
   clks, regulators, etc.
 * Investigate setting runtime PM state of devices before they're added
   to platform bus
 * Remove PM code from drivers using the platform_data non-NULL trick
 * Make multiple domains? Perhaps clk domain, regulator domain,
   interconnect domain, etc?
 * Provide a way for runtime active devices out of boot to be powered
   down when a driver isn't attached

[1] https://osseu2024.sched.com/event/1ej38/the-case-for-an-soc-power-management-driver-stephen-boyd-google

Stephen Boyd (6):
  bus: Extract simple-bus into self-contained driver
  dt-bindings: bus: Add qcom,soc-sc7180 SoC
  bus: Add basic sc7180 bus driver
  of: Extract alloc/add functions from of_platform_device_create_pdata()
  bus: qcom-sc7180: Attach pm domain to watchdog device
  arm64: dts: qcom: sc7180: Add SoC specific compatible to soc node

 .../bindings/bus/qcom,soc-sc7180.yaml         |  76 ++++++++
 arch/arm64/boot/dts/qcom/sc7180.dtsi          |   2 +-
 drivers/bus/Kconfig                           |  26 +++
 drivers/bus/Makefile                          |   6 +
 drivers/bus/qcom/Kconfig                      |  16 ++
 drivers/bus/qcom/Makefile                     |   3 +
 drivers/bus/qcom/qcom-sc7180.c                | 173 ++++++++++++++++++
 drivers/bus/simple-bus.c                      |  79 ++++++++
 drivers/bus/simple-pm-bus.c                   |   2 +
 drivers/of/platform.c                         | 130 +++++++++++--
 include/linux/of_platform.h                   |  14 ++
 11 files changed, 511 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/bus/qcom,soc-sc7180.yaml
 create mode 100644 drivers/bus/qcom/Kconfig
 create mode 100644 drivers/bus/qcom/Makefile
 create mode 100644 drivers/bus/qcom/qcom-sc7180.c
 create mode 100644 drivers/bus/simple-bus.c


base-commit: 3c48780d48df029cf9d5f42b8971663e6fb975ae
-- 
https://chromeos.dev

