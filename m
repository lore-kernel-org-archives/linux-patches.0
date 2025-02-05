Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089CB151997
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 23:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738798223; cv=none; b=WuzUfpbwB3nygEgXhawM6HLS0yiYbAfFQNfydClawohFftG3jKHzIvpbVPzypGbcxF+7m6rYFO0P6ifZznpaM09NNuDxW/rvvkpYK2uCnxwnXAkXrVLQmFkkFH+s3kmIvyQsCcaySBNOS2UBdrSyyEmCTEKIyZJnSoQaVKBnKqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738798223; c=relaxed/simple;
	bh=w0KqSvz4LKHnh40uBElw2aDPtTJnsxo3kIyaKh2DPsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dx+t7lFlxKJ9UD4hRlYxDl757Hto1dC6MeCI/iCrl2yAtgBee03ra3ZHxPqeWd87EHUMW9JtRJ0K4OekHh+xc5nQKHemTsJXHy3AtAeGQvh7v9Qs7p4EPY8p6VLlJL97AKyii5iFzs9VmPNk7tlJOpWWlJ0e2O6UVZweKgdZyaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mBx7DZ1I; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mBx7DZ1I"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21661be2c2dso6987665ad.1
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 15:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1738798221; x=1739403021; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LfrhKTgFStXH2HCRNCmE3wFhveRGNarb8z2r9ekUmYk=;
        b=mBx7DZ1Iixq1innxTTH4teUeFZlfNGWzail5F2c7hQZreiqnuBlGKmGZ3px/6/9u0C
         Nhnr/Nfzsgbzg18lL16K491tI3lc3PCvYHSnDi9Q0O0hpzub0+xwMQtuacR8v/5o6pjW
         zZhhSrDJq5a4mQY1Oy7cjk4SyJAt/Zk0d5+lw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738798221; x=1739403021;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LfrhKTgFStXH2HCRNCmE3wFhveRGNarb8z2r9ekUmYk=;
        b=bXLv+ubUoiLmOK8dvd7Bx/Rp7n1RYM+1+YKUTiakLRH1iOReGIM0b6fVmyrMk3xnY0
         lH3GweFuQB1fttJUzvRsDl1VBYseNrFbUZMijiSFyjzOvjxu9tqWeKSATXdIqrFRb/4p
         gTHoSc2lGfsNcBZwSKDF9gcpK43OEGIDa0GyHkDBWcoCN+ew0q3xziSELrw+RgA5c729
         U6OJ4TvyzVY/Yx475pkFdgRO3SUeL9QiFcBcg+rKhy0+luTlLK07Fh83boelB4Mn8ACt
         c+sJqjmIgL4qGgj5435POiSvzecLwTUpgNl3C7RregCm72aXQhi9jfeQV6/5WrVqEpM5
         /4Og==
X-Forwarded-Encrypted: i=1; AJvYcCXowxRnsu3183EcYExkF30pD9+4aTjDUfgE/vy43XeumpNQ4BG36r5OnuXCE4JKzClae+0S8ix9@lists.linux.dev
X-Gm-Message-State: AOJu0YykjHS21cmB2kXAOFfK68zhg6uW8HMAd1B8YmnuyXNNJtPi0tdb
	uokfISsqHXRDAzxGcBoIFFzZHHhMxgfCOV83AZtjqqlHhoxUA8MFqfFX4oBBTw==
X-Gm-Gg: ASbGnct1H6dUzImzfVwe98oSNGFIy6UpsZVo8mGGgL+IG+scA2K2nmzzeo9fHE4kTPf
	YjModrd0efIVCZs1IC9bf81L0l9K5evyzL/Q2GYv7ea8rt3I8NnT7y09gF+5dFUTP0Dr6EKKv+t
	K5T6W+fdGEXrvHpQEqU4U9lKwdDY+5wlEM40Ag6LRWk6ix8jXeQipkvkTTXlldDEp1UblHELgWm
	Tacr30kqs3/CS8K7Fw78O1eOiVsFThxo9s3ztf4qnbFYba2cJmztOdMV52s/vno7RGr1BjdZgtK
	0+W18YO/zVgBuNKyLovyJKIGTopG/CiNSuQaRj9+trpZOqtnDJzAI2I=
X-Google-Smtp-Source: AGHT+IHUo+FqElUk1sltTHIWznB6GdIP99OTajELLS9rXgQ0/Ee3VmZ7ONPYnmSuxZTKWCv2pLwwGg==
X-Received: by 2002:a05:6a20:3d93:b0:1eb:3661:da3b with SMTP id adf61e73a8af0-1ede88ad4a8mr7472061637.33.1738798219826;
        Wed, 05 Feb 2025 15:30:19 -0800 (PST)
Received: from localhost (129.135.125.34.bc.googleusercontent.com. [34.125.135.129])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-73048ae7f79sm15435b3a.77.2025.02.05.15.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 15:30:19 -0800 (PST)
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
Subject: [PATCH v2 0/2] arm64: dts: qcom: sc7180-trogdor: Wire up USB
Date: Wed,  5 Feb 2025 15:30:13 -0800
Message-ID: <20250205233016.1600517-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
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
cros-ec-typec node.

The first patch adds the pogo pin binding to describe the detachable
keyboards found on some trogdor devices (actually strongbad). The second
patch is the dts changes required to wire up all the USB stuff. This is
sufficient to set the connect_type and removable sysfs properties of USB
devices.

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
  dt-bindings: chrome: Add binding for ChromeOS Pogo pin connector
  arm64: dts: qcom: sc7180-trogdor: Wire up USB to usb-c-connectors

 .../chrome/google,pogo-pin-connector.yaml     |  68 +++++++++++
 .../dts/qcom/sc7180-trogdor-clamshell.dtsi    |  21 ++++
 .../boot/dts/qcom/sc7180-trogdor-coachz.dtsi  |  47 ++++++++
 .../dts/qcom/sc7180-trogdor-detachable.dtsi   |  15 +++
 .../dts/qcom/sc7180-trogdor-homestar.dtsi     |  47 ++++++++
 .../dts/qcom/sc7180-trogdor-kingoftown.dts    |  55 +++++++++
 .../boot/dts/qcom/sc7180-trogdor-lazor.dtsi   |  55 +++++++++
 .../boot/dts/qcom/sc7180-trogdor-pazquel.dtsi |  55 +++++++++
 .../boot/dts/qcom/sc7180-trogdor-pompom.dtsi  |  44 +++++++
 .../qcom/sc7180-trogdor-quackingstick.dtsi    |  31 +++++
 .../arm64/boot/dts/qcom/sc7180-trogdor-r1.dts |  56 ++++++++-
 .../dts/qcom/sc7180-trogdor-wormdingler.dtsi  |  47 ++++++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi  | 109 ++++++++++++++++++
 13 files changed, 648 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/chrome/google,pogo-pin-connector.yaml


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
https://chromeos.dev

