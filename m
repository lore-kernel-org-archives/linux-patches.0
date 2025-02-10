Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE92259498
	for <patches@lists.linux.dev>; Mon, 10 Feb 2025 22:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739228238; cv=none; b=mg+uZVPJNH8FzpMnD9GsgmUz4FTJ8rjGmpu6lHLYCzG8dcBcpuJSSb60lO8K4G3cjxLiACX0IpfRFKdFnYVrTIYsdfjwpxtY+m/UadEfti9mrCYlVzjwNthkDqWLxIuX1D4/JB2hqT5Ch3g2SFL4VoJpO0d2qyFULMEHAhLcSTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739228238; c=relaxed/simple;
	bh=P8Z9KGZ1EY/Aam7wC/XcwEohXdrrV9mPxenYs5nNxZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AGv2Tvh6aAwtG0UuaT1jFDd167OFFH9ZrccaKNqtl36TiRLnzSA0zZF1xaTZm1+et/mvp4G7zrlrciZrwheUUnESdT4whJTam0eqBGvwmIRDyfMJ+xa5yRNpoAhcLbSrdfmfpwxpf3H2Ugu5q25ZV7a0/J3HNutT/sZ9nzU/Pno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=lFpI8Klx; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lFpI8Klx"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21f3e2b4eceso92422785ad.2
        for <patches@lists.linux.dev>; Mon, 10 Feb 2025 14:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1739228236; x=1739833036; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AEi5P1T/woClFPNOO/HVfADRLd3wrZGmG1KagX0zqo0=;
        b=lFpI8Klx25JyV2JYBmUKbqGZ0mJzntbgooHCS+Dgi5MFVnRZkSfVgYBjylhRmozef3
         wRRG7mtMefNEl013ieWXrawvJsIsClVzTQ442/GTVcsrScT2sbOkbhFqDsmoaQ3EkJv5
         Z13SkUbOtvYhUy8hXF0gqN5+bktdNbzVJjmgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739228236; x=1739833036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AEi5P1T/woClFPNOO/HVfADRLd3wrZGmG1KagX0zqo0=;
        b=AoDlOtGJNGcmFjQfi0m5PeAXBiYGdZrEPw1PaWOXPVrJx6yaUe4gw5Arc4b7AYmpsY
         R+khl/OrnbxMdt4ciJSXHfPCjVvgO9Qq/s+HKW8WRhm+361dhU/6Q9SMZrYfEPhHkMIW
         6tfx1YHbg9EtNuNHHGv7hHRhgl9g38un4W1d/ethmsD+N8W2Nv+VZzIp1euhAEo1UgP0
         LpZYp69YY+bYlt3Q8LKBb4V7dPHgK4YfWzj0jk7Uq3dpo7mRQN9ljSSyn6racZ36jh4i
         4+H41oM4S9D9LxWszC2DCfg8RmstCCKa1YjtQ5k+U4GNMrPIhlPzqhFSz3jVvI8ysbzY
         ITMw==
X-Forwarded-Encrypted: i=1; AJvYcCWoGvvPycvUWhrrrnZjbs5am1qthRek2www6eLa8S4owAIKudxlUCNT0Wiv/qNowf015n+qQj0K@lists.linux.dev
X-Gm-Message-State: AOJu0YxPvHhqgKWsbU3SLv5yGQRcyAmypZq40PfTWFmJVezWKK5QZGCS
	rV3ei/XhJuLwO4tRS/fvcXbMb2nXtiozmR+WMjL7a5dFKsd350QICUqYaTngnw==
X-Gm-Gg: ASbGncteCQCk+VitJlBhRKeEhm5M7pmC//xL0KiHKVKtc7E5Z/8k1Q4QjAtczvPGRMl
	l+WVeIwW3mGbK2RwNuehSzp4dm+cybqxsegVAs7GG2ldqlBuUbKoGWa5UZn6UcIML4DqA+E0Sq0
	cLY6NSnF6iBC6Xi+q1Yj9OI8g0ShjLwTeXg6G2w2IfhIP4st6IEnzulUgZF5YHKSZAaNr+wWx4C
	mV3+UTezHp0IeWuSHZjlAaRQ3uHExKw+SmSkGpd4wNJcOgUuJJs0oZtX9unq6sJi2uU5BH0yCiD
	Sze4IG+SmrLQ3dkuucjt55oWXFfLpVtXzehfe1Ex+N0jQ6VDS+yWbPk=
X-Google-Smtp-Source: AGHT+IF8+s1/Z9sleMTgtclTYSbjSD/tnuHHmxKYPG/4ilaOLCGwVt7wyP8vgrrgEddtg2CGTPOIWw==
X-Received: by 2002:a05:6a20:c88d:b0:1e1:f281:8cf5 with SMTP id adf61e73a8af0-1ee038c73a1mr27458604637.0.1739228235665;
        Mon, 10 Feb 2025 14:57:15 -0800 (PST)
Received: from localhost (222.246.125.34.bc.googleusercontent.com. [34.125.246.222])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7308a05f754sm3007589b3a.153.2025.02.10.14.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 14:57:15 -0800 (PST)
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
Subject: [PATCH v3 0/2] arm64: dts: qcom: sc7180-trogdor: Wire up USB
Date: Mon, 10 Feb 2025 14:57:10 -0800
Message-ID: <20250210225714.1073618-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
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

Chamges from v2 https://lore.kernel.org/r/20250205233016.1600517-1-swboyd@chromium.org
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

 .../usb/google,usb-pogo-keyboard.yaml         |  68 +++++++++++
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
 create mode 100644 Documentation/devicetree/bindings/usb/google,usb-pogo-keyboard.yaml


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
https://chromeos.dev

