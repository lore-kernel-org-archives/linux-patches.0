Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E169D14BFB4
	for <patches@lists.linux.dev>; Tue,  4 Jun 2024 21:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717537360; cv=none; b=QvzjyB79WDLBmMWaL6ER08t/CkiX9i3Om56+MhVaJlq8onutcDdyDcGH3g5OBBER5E7S9YX4JlcbzifyUs1ZH6UtNr6HylsdRzzjXkfe/WymaQmK5ZKKVC4QkNVSC0dN7HWolBns8D3A0rgNMwgXZ18kZfJD9xv6DdkB8vSx82M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717537360; c=relaxed/simple;
	bh=DR4noGTvQJfxqZgaRPYStAP3sxtorZHW3MerXwYFYK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQ2rBFYJtKxDqwXwrDGIIKqJAvuymYvuQHKZHZ+ZvCzpY8VscZ4iUkHb3NCnMkPiTX0FlS3DIIaj9HrQDI0cSZ9+XSA6rgCAknwBjAzfxavWMcHFNRgIScdb8ZH09h9Dr4Yq9AdCz9+1b1a/f3U478Q2bVXplIH9bVBw1AbHA0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=iYRBdR7O; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iYRBdR7O"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1f6342c5faaso13168235ad.2
        for <patches@lists.linux.dev>; Tue, 04 Jun 2024 14:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717537358; x=1718142158; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RYm2Ihcymc0GYYvAeFdOt61hcsgG8S3It6RMdtYbi9k=;
        b=iYRBdR7OaGTR3tNOY8Bus1HuAiiM90TARNNElDhqkKxnggQ+QVcBbGhCpGHVvDSOr2
         ndpZ1VohmBbpFv8zQ+9NMLKMRJvDbgP7yOn0S2ozutoC0P2YdvpdfDQCnzsgWWxnccBb
         ue8hbzH+at3rMm5kH1I1hAnTim5TiL4FaHedo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717537358; x=1718142158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RYm2Ihcymc0GYYvAeFdOt61hcsgG8S3It6RMdtYbi9k=;
        b=NLAPKs9FS/4bZDOpxsAgge7lXkGPf0Z7tleSgsSEpkdln/yjIyXO6kCZkOTwKlODr4
         ZLw2EsD/pcumF4/QgJBw4BCy5IygrmgvwNao1vxvwmwEpGj6BNAobMYT3D55VLmiVv9L
         tX7MoB9ciig1XR7mXXC/nqOoi1ICMfTuPvLCDhTgC8BL3+2vjb8M3fwjaECPqC6O9zij
         aN/iVxykJqH2zD6Q3quM1LsxCm6fpZwlR12L/CdezDRF+Gi8v9qfQFN7ebz4++uu4/nM
         EwSIwHZyKNxvXyOnJLxIVt572fV/HGxtlotwmPxL/+NQka8dixSEfIVrHWQCYnKtiaYF
         /hLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIjsK4mZcMsZL1uZjJBhJ44eXxFU83plPYEKMSWZuNmuUOmib1qgiqB3VBSR6I5iCa8W2Ymlo+3oy4d62eFNluLseup4YItQ==
X-Gm-Message-State: AOJu0Ywv9wUvlP21rZF5ae7FdzmvrrFPInTIiqDlpOwUEyS6taj7bcn8
	Gf0Ir3YMOHKsQbW96IZgQKa9AY8l7HqsznGlpuScBXfCZey9uzYwMY4yJw5dSw==
X-Google-Smtp-Source: AGHT+IFhf8nAUYL+FNdvnpqa7A/O+7CUJFcajK2GH8sYTtYnOeRE9RYY6Tu3RIZW/OiV5NO7hyrY8Q==
X-Received: by 2002:a17:902:e543:b0:1f6:5551:9e6c with SMTP id d9443c01a7336-1f6a5a6b42amr9616895ad.54.1717537358165;
        Tue, 04 Jun 2024 14:42:38 -0700 (PDT)
Received: from localhost (132.197.125.34.bc.googleusercontent.com. [34.125.197.132])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-1f66c412fd2sm51747355ad.283.2024.06.04.14.42.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 14:42:37 -0700 (PDT)
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
Subject: [PATCH 2/3] arm64: dts: qcom: sc7180: pazquel: Add missing comment header
Date: Tue,  4 Jun 2024 14:42:31 -0700
Message-ID: <20240604214233.3551692-3-swboyd@chromium.org>
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

We put a header before modifying pinctrl nodes defined in
sc7180-trogdor.dtsi in every other file. Add one here so we know that
this section is for pinctrl modifications.

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
 arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi
index 8823edbb4d6e..73aa75621721 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi
@@ -83,6 +83,8 @@ &pp3300_dx_edp {
 	gpio = <&tlmm 67 GPIO_ACTIVE_HIGH>;
 };
 
+/* PINCTRL - modifications to sc7180-trogdor.dtsi */
+
 &en_pp3300_dx_edp {
 	pins = "gpio67";
 };
-- 
https://chromeos.dev

