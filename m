Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2EA14C586
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 21:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717537360; cv=none; b=bvlxyzs5snQZNiY8EzkYbJO4jm7hl3WZLb2MBrL83yV4vdFZ5crO+/ch1lh3GrR3HpHQSyUJB2SvRKAtnZFj6f2x3jolZ641QhIW0VR3DNryB0GglrIYC82fF0XTy+lB0+2GVlIYXWAuq+BAut7Z8BK9gTzmziBOYmSw/EXsdmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717537360; c=relaxed/simple;
	bh=IOvBn7Nyio2Q5k5EJinHxCGnyjUHnIrr3ge6E0zpSHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4XfsiVixyK8ueuTUyALECtBCZwu550hKU9gst4FDhtDc156YdA4UgBYZ5tDZUpCgPOQlPlUaF9rUKVp4k96WQNiqstMuHV3hgDOt9PKq6YmygCNqGV8vNo1q6IwAZxEz3YkYLHvHwMSXeK1CaKA5P7mymwrWwzIMo2fu6GIi8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Yk1QH3fY; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Yk1QH3fY"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1f63642ab8aso37408355ad.3
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 14:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717537357; x=1718142157; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqRKPEKWRhplNDOM25p5twkIQfLSqkZ96KCbc1M+Mzk=;
        b=Yk1QH3fYbnnKYZTsJhPWFZIuejylhr1hyK4pI2oNMWgUjNcMDqXUBldzqW6aIYdUnz
         IsF6jpzHv4ZCDd/Gp1dUqtud/HyXLey2hS487siziRGeONWHCBg8a28KvIHzggcRmYJ7
         1Ftshf5vXqluI38zjA+2lqSfrKCWgGAJCl3zQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717537357; x=1718142157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqRKPEKWRhplNDOM25p5twkIQfLSqkZ96KCbc1M+Mzk=;
        b=t8LvyJKIyLI7KhLsxPK57ChYUwQevbZcm1mYphMv4HGJTIDBHgIsrV6/quAnj433PD
         n3Lk++0Ko98b9YY7ZoZuEKBFoxJ/jWUi/qcvVK17+Wj4izn9VjUfNPBepguJK+DQpMkD
         kvZNbCq+FEuu4EfxlL/k0ab7DnTHKbMwk+DuwexGGm39uoUGq5JzzZtiTGucQrqR46fQ
         9T4O3CPnLK2+1ugB7bVE23yKo8gD9I+r7y8rSAy7RHOtMonP0vzfC4vpzsmTC9JCGbnJ
         31tU7+YHJ1+vlA/bugKy2wXyt9AzDGvvYaK3cXo3YCv6NfPZvi+OPoJQMyWsnZB3n5dq
         KPhA==
X-Forwarded-Encrypted: i=1; AJvYcCUTa9K869OlC1gEfGAPL2IvQR0YifhYt9SEmb1paFOXjgKjD6PJGnTxAjUO2xxN3TvBgcG/jsDkaXLhJdeRdhhuknSrg+MHGg==
X-Gm-Message-State: AOJu0YzMGaPCGwKq+ovnTv4j1Nz+dbeIBtX3gnoRQeZk3h19tQLQbkxp
	2X+69722br3Oau3h9ItDwMjRihUElEhHrKs3xpHcJMoXRyXQmODcVqGv8E0l+g==
X-Google-Smtp-Source: AGHT+IGUaXR2dqUozpVweS1vyHr9chwC5OlcDsV5AJ7BJUmAiiMFibIo5WHvLjglWhoIQUC3RvtDRw==
X-Received: by 2002:a17:902:f606:b0:1f4:64d9:5cfd with SMTP id d9443c01a7336-1f6a5a5ca36mr10300155ad.42.1717537356867;
        Tue, 04 Jun 2024 14:42:36 -0700 (PDT)
Received: from localhost (132.197.125.34.bc.googleusercontent.com. [34.125.197.132])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1f6a39bb488sm5416775ad.267.2024.06.04.14.42.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 14:42:36 -0700 (PDT)
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
Subject: [PATCH 1/3] arm64: dts: qcom: sc7180: quackingstick: Disable instead of delete usb_c1
Date: Tue,  4 Jun 2024 14:42:30 -0700
Message-ID: <20240604214233.3551692-2-swboyd@chromium.org>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
In-Reply-To: <20240604214233.3551692-1-swboyd@chromium.org>
References: <20240604214233.3551692-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's simpler to reason about things if we disable nodes instead of
deleting them. Disable the second usb type-c connector node on
quackingstick instead of deleting it so that we can reason about ports
more easily.

Cc: <cros-qcom-dts-watchers@chromium.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: <linux-arm-msm@vger.kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Pin-yen Lin <treapking@chromium.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
index 5f06842c683b..b7de9fd3fa20 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
@@ -10,9 +10,6 @@
 #include "sc7180-trogdor.dtsi"
 #include "sc7180-trogdor-rt5682i-sku.dtsi"
 
-/* This board only has 1 USB Type-C port. */
-/delete-node/ &usb_c1;
-
 / {
 	ppvar_lcd: ppvar-lcd-regulator {
 		compatible = "regulator-fixed";
@@ -136,6 +133,11 @@ pp3300_disp_on: &pp3300_dx_edp {
 	gpio = <&tlmm 67 GPIO_ACTIVE_HIGH>;
 };
 
+/* This board only has 1 USB Type-C port. */
+&usb_c1 {
+	status = "disabled";
+};
+
 /* PINCTRL - modifications to sc7180-trogdor.dtsi */
 
 /*
-- 
https://chromeos.dev

