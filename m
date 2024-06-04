Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4177614BF91
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 21:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717537359; cv=none; b=m8Udin1lgoLzFBo2b3Rcirf7SpClHCGeEcu8xD1plJpQJheN8akFeekn0jNFpWIs9iqPI4uXWsu/MiPcayI6ApKBn/glxhLG4ktCHStJWThhOuOCSIumhBquBZPDOInxbbo/vveusZexXHkzp3kJ3kTYbKQQWt7yxG3tfdE+yXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717537359; c=relaxed/simple;
	bh=vDctSeMuSiGp9PwhggSWKoGFj8wcUjkUW53LOQym6rc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B/iebOFOhstZVU2GLipQUi+/yK7MGHaNkjvC45bs4itPiCjaWQ5pzS1c9v/IrBe2zwYvg3sHqft25Iqv9/KW03d/W7RfnXeFfE0dbtNX0SkW4CI4ugFU1cxZdMDivfH4Eq+3I4N2bZ801/h3wKIHH2jLUOiifyp7bgh4ho0+cwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=aEzA1Io6; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aEzA1Io6"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7024791a950so197234b3a.0
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 14:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717537355; x=1718142155; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6Vw66yFGizo7QKpTFL7E/hug1hRafbghl++kv8rPPs=;
        b=aEzA1Io6KnNdtSXYJfyrHM8NT1lvIm6EJjzVedE/78ckp/cqT1zEvQwnlSI4Ef4rcG
         hLOG+2Nxx3NT2mNnpzapqJDZFft9cPuApqkK/tEEZU1WMOiyHlHEh9eVa82LEXqpaPM6
         Dd2r/hvEWC3yVw0liQSsRb7ZPk2R7JyFFZdPU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717537355; x=1718142155;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q6Vw66yFGizo7QKpTFL7E/hug1hRafbghl++kv8rPPs=;
        b=SBmwom1uZkaaFddPp6S8L9pqDkowvQGGNoYHyIupnFdDuue7r7vzh1CzJYSwQdjh5H
         UItjW6E/9zcXDVCFwxssfr5IOGLCBp+HIQT0eR5k0N2PNP8xVeLHb31p1SPIqE3Axvj9
         51NWw3r4GYTQWi8pMCwemLA5ZODL12TxNnmaa8rayHYwHOB+iW30/DQgouzgP99Et2VQ
         wn+ILVipOeDioW1F02qyMtDWDjIByTkVKhOwBdFXSa6oThqtEo0EDX6crN6imVHcuLAU
         ojK2gZ9AnmzPXMRn43GXrgczF0G6VLtZXq8/pCwHV/xx+Q+2CYnqN9Dg+76J7UQyvmrx
         A1/w==
X-Forwarded-Encrypted: i=1; AJvYcCWOKUMiIx97PWoWrGvSgSx6bjek+QNaZpvL5gsB0Sp+QMfThrfjCAM5MSYi59Zvo6V6u8y04+PCIeo7+s8CvoADf4fPuInoSg==
X-Gm-Message-State: AOJu0YyVBlOVT0iU5XsizcfV1sjTuL1MrXFm5cA6ak3dUyZ/yaOFURP+
	74U0bJCruWVU3DGiwi14ZzYe4NXWgnlVZo9nmKlHExTqOwMH1k15+m7hCMe4Sw==
X-Google-Smtp-Source: AGHT+IFdOXCjV6WYTt/zwkB5UuQ0oRkBJqqgAgDp2qIDzzYVNu8sLTUOmr2dbUeuVyqxGp6ldB13nA==
X-Received: by 2002:a05:6a20:3ca9:b0:1ad:7e4f:9564 with SMTP id adf61e73a8af0-1b2b6eb668bmr1221578637.9.1717537355547;
        Tue, 04 Jun 2024 14:42:35 -0700 (PDT)
Received: from localhost (132.197.125.34.bc.googleusercontent.com. [34.125.197.132])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-6c35a4b973csm6365068a12.79.2024.06.04.14.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 14:42:35 -0700 (PDT)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	cros-qcom-dts-watchers@chromium.org,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Pin-yen Lin <treapking@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 0/3] arm64: dts: qcom: sc7180-trogdor: clamshell/detachable fragments
Date: Tue,  4 Jun 2024 14:42:29 -0700
Message-ID: <20240604214233.3551692-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a followup to a series I sent a few months ago[1]. I've split out
the dts patches and dropped the one that ties everything together for
DP/USB as that whole solution is still working it's way through and I
doubt I'll be able to get that done in the next couple weeks. Instead,
I'm sending these patches to reduce the patch stack and make that DP
series more manageable.

Cc: <cros-qcom-dts-watchers@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Pin-yen Lin <treapking@chromium.org>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Douglas Anderson <dianders@chromium.org>

[1] https://lore.kernel.org/r/20240210070934.2549994-1-swboyd@chromium.org

Stephen Boyd (3):
  arm64: dts: qcom: sc7180: quackingstick: Disable instead of delete
    usb_c1
  arm64: dts: qcom: sc7180: pazquel: Add missing comment header
  arm64: dts: qcom: sc7180-trogdor: Make clamshell/detachable fragments

 .../boot/dts/qcom/sc7180-trogdor-clamshell.dtsi   |  9 +++++++++
 .../boot/dts/qcom/sc7180-trogdor-coachz.dtsi      |  5 +----
 .../boot/dts/qcom/sc7180-trogdor-detachable.dtsi  | 13 +++++++++++++
 .../boot/dts/qcom/sc7180-trogdor-homestar.dtsi    |  9 +--------
 .../boot/dts/qcom/sc7180-trogdor-kingoftown.dts   |  2 +-
 .../arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi |  3 +--
 .../boot/dts/qcom/sc7180-trogdor-pazquel.dtsi     |  5 +++--
 .../boot/dts/qcom/sc7180-trogdor-pompom.dtsi      |  3 +--
 .../dts/qcom/sc7180-trogdor-quackingstick.dtsi    | 15 ++++++---------
 arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts    |  3 +--
 .../boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi |  5 +----
 11 files changed, 38 insertions(+), 34 deletions(-)
 create mode 100644 arch/arm64/boot/dts/qcom/sc7180-trogdor-clamshell.dtsi
 create mode 100644 arch/arm64/boot/dts/qcom/sc7180-trogdor-detachable.dtsi

base-commit: c3f38fa61af77b49866b006939479069cd451173
-- 
https://chromeos.dev

