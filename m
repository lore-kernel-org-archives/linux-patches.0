Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243BE3CF6C
	for <patches@lists.linux.dev>; Sat, 10 Feb 2024 07:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707549015; cv=none; b=buy1K4by0+8ZAY4NeCHjVp/LQSuN4eaJjsUwSi0jJ8Cg8vhpdUZpcxhT7xwZWg+wVDWU7VIjedB/ibLZRhvddq52Jovaa5l+CMl45MRMmPaJIa3+hvLoVokSXZ31Jh44PKN4pTENonjTKCrq0u79K5J3V8YSPzT4lE12MPctYZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707549015; c=relaxed/simple;
	bh=uNtg6CNmd9g6D1sTnVrmmBjdLymre6S2FvTNdICMapI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7SWpiJ0hWA87WTAqqzq4gvzWHury6WCR5SdHsB9/+zu2bL1KNES0fsPEA45rcxp9XgPAcl1T+kUDE0ZvUoh7ZggHkhFR2oQz/Ajn/Ggr1aQe77uaSapjRbJzVgTWuF8WuLsdueK7xwIs03/3xbmOfooD3YFtlS5A/tCMgTUiQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=KmDz5QO5; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KmDz5QO5"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5986d902ae6so927843eaf.3
        for <patches@lists.linux.dev>; Fri, 09 Feb 2024 23:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1707549013; x=1708153813; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2cCreiQeaQPfjD+hacap9EW4I/2E2LqZap0vCweqZeE=;
        b=KmDz5QO561inVJZR+4Za664g5nMOA8rMuFKwA/uZLfFp+EnTwIR5ylMXgusqk6MgAs
         F2ga6NUjYKDlqdwrDOBG9Pq6TFpRnQ96kmRboojhMEZbWixdkk+TuQ+tWrdogHNhxxTP
         Y5efnrnshfrY1Euy1vspRnv4gAw98I4Y7NZlg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707549013; x=1708153813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2cCreiQeaQPfjD+hacap9EW4I/2E2LqZap0vCweqZeE=;
        b=XEIdMS2f7gcju4XiDpsa4P1ZXjt3IyflfMLWU6hvH1uvD+r67JqI0ZK5lFbiuiZ+my
         jcshbMcUvxg3hRUNClaPySYo9FnzY+JsSVgLsxPyxzGTUZdhFF1XSOljbm8VMbQ+eRMR
         7ytqa9TzSkhDiLrtW+mLp9RPNpD4MD2lGyBCQ6alm05KCpJlNQcZQb7hGlyQ5OvvACpk
         ECAGsiF0+hW23Xz4bHBXY63ZgZNJFk2myGrGHa/k9AiITyO0+EbGww7Z/u7Ls7bFbpmb
         dk3tvXqwKNit0whgAUUWc8VWrPhtiFYifgz0/rO/bBth/+1Umo+ZHAV46+3wBDiUtIre
         RSUg==
X-Gm-Message-State: AOJu0YxBgHEh5UpeUR+x2/sQM4+vdenQ6F0ae6xAduACLop9X3r93qkP
	2u6LXVKPd+8Rled8k0hhQ9hagn3naM9mGPorjnAjK9PbsbRm/BWQotu+Tmogig==
X-Google-Smtp-Source: AGHT+IHmIBXR3wTN+fnMxCGP+XCwXJqcs2DSyOB+AQ0XxDnDr1ftAkvP1E8Ip81n7RTMzc7ueUQ+5Q==
X-Received: by 2002:a05:6358:750d:b0:175:c1d8:7c61 with SMTP id k13-20020a056358750d00b00175c1d87c61mr2464147rwg.12.1707549013289;
        Fri, 09 Feb 2024 23:10:13 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVrUedD/UnAk3HKDxEGV83AYo8GBo7hWhlcoAZgULLhTJWi6/kUeog2hDaitCzqURciEjhoayaHgdZ/5X2eKy7547us70905x3X9/a8Yu3Tab0PaOOV3AyTHHRaKGiKrh9swnEiVwYwkwDM2gHfMwsVx3WIRgGwh8paDpPxQ3PgzmPq/kDmKjROhqAlJlYfNi6uvCtki4AehhaQRff9jXrXhX25lUDre0eYuhJPCpc1zZrz24yrxVsBXmt9LmHXpDJR0WlVreLSHV+vw/gWyNyGzSBKJSv9U1+OBKIlqlDiqReIp0VdviRmL0g3I0ntOL9ql8Z6S1WKOwT2rfPOiHJHg2nRfyo8rLWKW8hgscXEIoSggIiFTPde27pOl3+wMUaWZy/O8TktXpmAHRe/VMSMChhv/JKUsya7655B9iFe8QV0Y9t3kHVZZ3hJvDMKXGxkQPiLo1G27Wr+EnLW4JM821QQHEIWPScXd7tPCFPK1bBe41uywl/TFbrP+qkmJx7BFF6FGMfKSR4jhg==
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id gm15-20020a17090b100f00b00296f780de33sm2898701pjb.36.2024.02.09.23.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 23:10:12 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: chrome-platform@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	cros-qcom-dts-watchers@chromium.org,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>
Subject: [PATCH 20/22] arm64: dts: qcom: sc7180: pazquel: Add missing comment header
Date: Fri,  9 Feb 2024 23:09:31 -0800
Message-ID: <20240210070934.2549994-21-swboyd@chromium.org>
X-Mailer: git-send-email 2.43.0.687.g38aa6559b0-goog
In-Reply-To: <20240210070934.2549994-1-swboyd@chromium.org>
References: <20240210070934.2549994-1-swboyd@chromium.org>
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
Cc: Andy Gross <agross@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: <linux-arm-msm@vger.kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Pin-yen Lin <treapking@chromium.org>
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

