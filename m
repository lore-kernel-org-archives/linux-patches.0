Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0AD20458A
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 23:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740180686; cv=none; b=pP15ML9scbwNt4n377pbMwmKLgfz6kzjROxp0YZYikBvYUiVhaXij6XZCHed1grXOszIIkQ1kmeAbgFJ9p4a7bH5v7VWRsNqqYebFtDmIK0+H8AiAdLQ0eo24QY1rEp6Btyh/XmsOQVTfGSKqA7IhNojjCd5Oham/OqObWA8wcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740180686; c=relaxed/simple;
	bh=f51eqVy7xwWHEuczDtwNNkEGNpGXp5mse0YoxqxxuSI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fWD0Ww1uOXUJqJEkairqwmc0Qopy31ye+37DgzGZrdu7AXVQaoqpSs0IlOUjmMHUpWhLkhZRJNNdiQZQotId9fAaQxKDm2quVdDoeX/4zarJDxqyNrS42ZVKqAVhDjLo5SKopQDXBMQ5D4q4rUQ36U+wmOR3aF9ylMffcbESHB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=A76+NkXZ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="A76+NkXZ"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-220ca204d04so41839765ad.0
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 15:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1740180683; x=1740785483; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=81FA3e/JZjjDAMLf5iojUcA5/pLMU3O5i7ad+AEyuhI=;
        b=A76+NkXZLniV508XzpQhH/AlFnT80F69OuSMmxAPn/jo2qiBIYzqAzgMQi4o4ERtMS
         3fg9H97XNxbYmsLhfouXQgzXFk4yGZPoN3aDPG8oNY2WS2dHuWdUcqZumHZqTQCQIKN3
         06QTPUej7dnP1shbqKbPEige9WTJK1oC6/Qv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740180683; x=1740785483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=81FA3e/JZjjDAMLf5iojUcA5/pLMU3O5i7ad+AEyuhI=;
        b=wfd8wgO1R3RotspUZT7NSu5addjG3/El743ckKFIorBeD8NrBriHQXQCgmTyyXnSmJ
         X8mK2yEKGPXXAJ6hrTbYTopLL3W3hOf8MgastIhmYBfiPzY1Q8nDKeG+gljjPA/QVlTE
         fVkvOaNwFQeZ1iw61KopbnOMKNWNqbuEURPs7pu0vO/mEy1RxN4Cg7JwivhgRONr2ib/
         leknG6x3dBwklgm9Fufuylj8A9k1WM1OoRpOBbAqj5pY9uE8QKb+KI9h0jU8/b0Gb8YZ
         4kMynI+anYxYB+SsTtuUW2STkYUvcfEBGBTHeZ/9/MlVV3HX864gcqSb9srxU8mBFWqd
         tWrA==
X-Forwarded-Encrypted: i=1; AJvYcCWlq7ZA26VqelcJ07Y3Ef0pkbUN4Te32pvWkxq1tRiLmvDC2Qx+lIeR1vFml72Kbs6lOgF5URSK@lists.linux.dev
X-Gm-Message-State: AOJu0YxWFOqHOrAKEI0S5yXnDV5KTn09TCOCC2vZsjypFlNVrTiXTNfc
	qJShX/Uiku7nDlApTHsg35MrJQD0WC82k1nW/5RbtzkiU3QcP8B667Jm70FH3Q==
X-Gm-Gg: ASbGncsjoPsCT1CgyzhDeiEiwH3Ru0GlyOhyqoxUjXFfd0M4OMwAuXoyihNLiMSUp0r
	/IElSBS+qo9SHxuLm7OzqhGvh7my0uh3HErQqmfSxVvvAZ0STEzaa0ZsU4+gB/Rm8Wt1A5uacNZ
	n32TllX8u9aT60pIQRKduufdoc1tJASz3YywVIXaw8dU9iQdZJh+BAqxs1lU7NKhJUvHfSdSmG4
	1r4pdW8Q8uQt60R7JFoaJ1lGLDKA2eU3IJ1r+/vSQUyaqDoHz4q9kuieq6sKfomaOrfWVbvOtXK
	caHbKdhpHQKyGPthxCIFIIxCzL/JBpiDkGUHlsz7/MulsS4rMR3xh1QZBivCrAHm7A==
X-Google-Smtp-Source: AGHT+IGkH7xMxeGNr82l2STxZJtAA8Gv2n4NyOTr4CeAZCvwgPvVhf6sJzdIj4GQWhVoUq34JljyhA==
X-Received: by 2002:a17:902:ce8a:b0:216:760c:3879 with SMTP id d9443c01a7336-2219ffc00c1mr74674785ad.46.1740180683043;
        Fri, 21 Feb 2025 15:31:23 -0800 (PST)
Received: from localhost (222.246.125.34.bc.googleusercontent.com. [34.125.246.222])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2210001ea01sm113953455ad.176.2025.02.21.15.31.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 15:31:21 -0800 (PST)
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
Subject: [PATCH v4 0/2] arm64: dts: qcom: sc7180-trogdor: Wire up USB
Date: Fri, 21 Feb 2025 15:31:13 -0800
Message-ID: <20250221233120.3596158-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
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

