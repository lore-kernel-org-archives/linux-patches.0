Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A480F211A35
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 22:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740522643; cv=none; b=VB6xgD2zOerMKzUqJkRfG4MKLlB9RLlc+HSSDbzxrDHIZJO0wOtnV7zHme7ScsWIM79dw9Fc/MnvkYcEVr8RWyWUf3zouCglAFrmiVTPsswlrljr5Hb1kwZWItj+anUY6+Bm5psEg3EyfrVWD0EBKpHSmEN+NqomTCZKzJvWPjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740522643; c=relaxed/simple;
	bh=oxaCiQCmqeAS1epekehXbElGJ+m3X0CqMo4HcDIs+cU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NQGaOjjYOlAivg4g1iN2eftJGIBWGQ7Ddi2+djL+p8lQNjMZRZjTo0k5kR6zSI41kfLz4i1tziuP3eHt2PP1VviefULQsFdXzKICE5BO1Nn6Z4V7vDiH2UANRlT/lh3uirAijHuBoLWyzGvwebgL5NR7fkOgi3WXgP3lZRNtXKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=L17E50dC; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="L17E50dC"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-220ecbdb4c2so56563885ad.3
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 14:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1740522640; x=1741127440; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CxPMcTd9qCEBN074ty2w+VRI4Bnqdaah0BYjoLFwE7k=;
        b=L17E50dCsFqQiPoxyaly2XkhPVoi/u2fREKPr4q5ieTQ3gRs+JNrpXQRdiC83H7HHa
         RBwxPJtT5TBOpSEmhWytRILVWg4zMIFBm7gwDA/jXDar2vZvESSCY5PS46nkKXrSiC3A
         58mV79gRpyIgMJLa4dloAu0L/bgX5A8Zaj/Xg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740522640; x=1741127440;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CxPMcTd9qCEBN074ty2w+VRI4Bnqdaah0BYjoLFwE7k=;
        b=hoswhfOGneAelhZqHArNNe2MXhzwf8770oN1NbpC8UAtgic2a0cvXoiKlEKnQmQdzM
         xYlg01bKys/XJ5cbe2y/j6dSuEN5blrozFa1ryDv4BdHmVl21iHpn7tC7qEcDfxWA2yo
         nEy6iIaQAicOq8fmm2SNl2Eq58ef0ehw9vIraEJHW82IsF5I+A+FYtxmII4YuWX99Fyn
         hu+IijkNx77t0AImhXGMjv31Xu9KSisV8UPVzhhJVRfu0xsyWe/+n9ezov6gSZfZxPEz
         MIg3slUZodyZe/jDKwTohtFvMSsUW+iZIdCql9w0ahyMV86JlANGzRk1OPYi7vPv6iNe
         7S1w==
X-Forwarded-Encrypted: i=1; AJvYcCWWZzK4rMWJ9SdODKQBjAkHu60QaTfuMGlEWGxlg3O3EzNsOj7lzYy1jR1j5XxXMWdla9X+GNe4@lists.linux.dev
X-Gm-Message-State: AOJu0YzhmS2RbpIflwXXpJeU9MA1S3gz9tAhOhipgHlUjNT30SV8dKRZ
	xlH8nH5paEKJaXumSOo12ig0CqnLcsmpbcryBmOu45womp9n3siWi8+f0mIicw==
X-Gm-Gg: ASbGncufLykOSDABaKpF/RXtm8zpjUilEqba7yLB7Q6XzJKt/ayNf+kZ/cN2NCwkQ7U
	jvmL8fspJ8FwEAaSMYYGNFGbvvyZ+iAFoclwPEQYCKG+PiVn8osO13THLe3Q28bQr+nyx7KV49b
	yqlwJUfC1ZX6rsebbQqIOBhb92nU3pUGpHNNzejKAWrc2SDDtjNxmbxWvmpnQPuLQPSWaM2rxiv
	FLbPvFGN8WW2mFLsmGwN5AFAVavaWqYIob78DGxxNHhVzxQgPmPK2DMD/e7dEJbP++uJzFq7zRC
	dymbasrBDxgVENIWIABBQmJpFkhSsE5CBCcVu+ehdRyTAoIqYaRbETV9wBEnQfqVxw==
X-Google-Smtp-Source: AGHT+IGfycDzz2jrkUoYR/BFevUgFFIrZzQind7dUvVF1+Ua3fNlMG4d7Bly/f+2404A/5GyvlX3Qw==
X-Received: by 2002:a17:902:f64c:b0:21f:49f2:e33f with SMTP id d9443c01a7336-221a0ed7885mr305363575ad.21.1740522639971;
        Tue, 25 Feb 2025 14:30:39 -0800 (PST)
Received: from localhost (222.246.125.34.bc.googleusercontent.com. [34.125.246.222])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-aeda7c9079dsm1949830a12.23.2025.02.25.14.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 14:30:39 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benson Leung <bleung@chromium.org>,
	devicetree@vger.kernel.org,
	chrome-platform@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	cros-qcom-dts-watchers@chromium.org
Subject: [PATCH v5 0/2] arm64: dts: qcom: sc7180-trogdor: Wire up USB
Date: Tue, 25 Feb 2025 14:30:35 -0800
Message-ID: <20250225223038.879614-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Wiring up the USB hub to the connectors allows us to gain the proper
'connect_type' and 'removable' values in sysfs for the USB devices on
sc7180 trogdor devices. These two patches are split off of a larger
series[1] so they can land faster and because we've come to the
conclusion that the DisplayPort path is going to connect to the
cros-ec-typec node, not the usb-c-connector node.

The first patch adds the pogo pin binding to describe the detachable
keyboards found on some trogdor devices (actually strongbad). The second
patch is the dts changes required to wire up all the USB stuff. This is
sufficient to set the sysfs properties for USB devices so that the
builtin USB webcam is considered "fixed" or hard-wired while devices
plugged into the connectors or the keyboard are considered "removable"
or hotpluggable.

Changes from v4 https://lore.kernel.org/r/20250221233120.3596158-1-swboyd@chromium.org
 * Add newline after property before child node
 * Pick up ack from Konrad

Changes from v3 https://lore.kernel.org/r/20250210225714.1073618-1-swboyd@chromium.org
 * Consistent quotes in binding
 * Drop unused labels on hub ports

Changes from v2 https://lore.kernel.org/r/20250205233016.1600517-1-swboyd@chromium.org
 * Make binding specific to keyboard and move to usb/
 * Update dts to reflect new compatible string for pogo pin keyboard

Changes from v1 https://lore.kernel.org/r/20240210070934.2549994-1-swboyd@chromium.org
 * Split out of larger series
 * Added description to DT binding
 * Removed DP part of dts changes

[1] https://lore.kernel.org/r/20240210070934.2549994-1-swboyd@chromium.org

Cc: Rob Herring <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Benson Leung <bleung@chromium.org>
Cc: <devicetree@vger.kernel.org>
Cc: <chrome-platform@lists.linux.dev>
Cc: Pin-yen Lin <treapking@chromium.org>
Cc: <cros-qcom-dts-watchers@chromium.org>

Stephen Boyd (2):
  dt-bindings: usb: Add binding for ChromeOS Pogo pin keyboard connector
  arm64: dts: qcom: sc7180-trogdor: Wire up USB to usb-c-connectors

 .../usb/google,usb-pogo-keyboard.yaml         |  68 ++++++++++
 .../dts/qcom/sc7180-trogdor-clamshell.dtsi    |  21 +++
 .../boot/dts/qcom/sc7180-trogdor-coachz.dtsi  |  47 +++++++
 .../dts/qcom/sc7180-trogdor-detachable.dtsi   |  16 +++
 .../dts/qcom/sc7180-trogdor-homestar.dtsi     |  47 +++++++
 .../dts/qcom/sc7180-trogdor-kingoftown.dts    |  55 ++++++++
 .../boot/dts/qcom/sc7180-trogdor-lazor.dtsi   |  55 ++++++++
 .../boot/dts/qcom/sc7180-trogdor-pazquel.dtsi |  55 ++++++++
 .../boot/dts/qcom/sc7180-trogdor-pompom.dtsi  |  44 +++++++
 .../qcom/sc7180-trogdor-quackingstick.dtsi    |  31 +++++
 .../arm64/boot/dts/qcom/sc7180-trogdor-r1.dts |  57 ++++++++-
 .../dts/qcom/sc7180-trogdor-wormdingler.dtsi  |  47 +++++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi  | 121 ++++++++++++++++++
 13 files changed, 662 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/google,usb-pogo-keyboard.yaml


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
https://chromeos.dev

