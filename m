Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1AA1A265E
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 01:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736299740; cv=none; b=ICSynP6WVMr61ksoxgp/kee3pxz08WB8IA5+tuKVmCvD6zrAA1ZZirwnLyCbf9X10Y+CLRCB7IA0hBqo0GAOwlTR6YwZ8h9kwWLSjjNkeINVprjkrEgNzE+QyMMr91hSKuKIs5hRSzNYK7rlljDuUmH/xlxvK1BIaaeYoadZDko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736299740; c=relaxed/simple;
	bh=5zubYY3zABlZ5Mj79nxt1+Y1cBxawP+c6+xykDpJnXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gefxWVLz36WbOk8dNX0YJlT25dx03jlSKMdt1HtEPGTeJ2bt82kK5yUfzirHc55picf79azsPX7jnbgzmlXyF3JEkhanhHGIUnCShxmUf4VHftXIbWmiDEaWeR1x0KhuaYc0hGVI7++iEyt7Cb4Ry0i6mT3fJvnqkUUkU4Jz62k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=EPH5yt3P; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EPH5yt3P"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-216281bc30fso22196175ad.0
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 17:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736299738; x=1736904538; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ffCbyZidm4yUSXcZ/TPGQgF5jycQyA1Mr5Btdy4Z8FA=;
        b=EPH5yt3PHhNKkKA8b/DmeImIfmi4VOapD3qwr87L4wgdGTdD7neEeCjPV6Mcw8ng7R
         cRaKARxgiUGmGnlDBJN/wYI0NqGDUK38lMV95iZ4XH7SbyLw1e/ljS0I5tA9tI7DIhWw
         fNSs9Y5ZyouNQSLJJnJQsxGGD6jgCXvCpaQ9s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736299738; x=1736904538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffCbyZidm4yUSXcZ/TPGQgF5jycQyA1Mr5Btdy4Z8FA=;
        b=R173SZGHNHQmiR8C66kAIIgQSjRgYL6dd4SHK10YSeNyI8wI10eFQDcxBnmxJOsKeU
         yAMnTq7BBheK9hAeXlOEHs/vQNiUZpXLdQZ43n3Cb3h4EPrsFHh8Z34XfGrMK9xp6ndf
         kjcmVOC86e9EpV+6K91rZFUA3bWmHBkE0z86WawkKKll/0k2G997TRGc4CLF2XkJPsTN
         GaYXL85WXOp+tXOAjX/dUBuR49twHpofClH3z9mtjNLaGe0Y4WWrtBFHux8cUi5Dunmi
         EvVqHApkebLUlagxaaEm/W8CNn73+FqU97L34Mkxx/YM0WHQbdpaX+jldbGo3EiWYpom
         zNJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVq4dtuA7LqDeZpHPHoqJd+ihLnyvFAdv+9D57nzx6SvnfGG1PXwzsrpbmAzsrluJJVYLVTyDIM@lists.linux.dev
X-Gm-Message-State: AOJu0YyjLaanFXLlMGG5w5G9CV2hPvUKU6sVAe8U/Xc2AEjaizTzudc/
	oN3cttQb2tgnBEAM+QRUpSIbvuR6oWuEyJ5prUwawP2n1dlF29MSD24KCq3b9w==
X-Gm-Gg: ASbGnctuDPYy41OL4fgNKoAItDlhP7ByzI8hQwaDtEFK2scpRQDr2t3NQwZkP4beDu0
	y4PvL02MeLvRCeKdPs0HR1ydgTJfiIEyAD5auHWmCyarPJZ9yxZrYbGwfP15Xw1N1nyOWKMjM85
	Fw38+QFrBaFaTAJHO4Y3Ftbl7aY43oTfV27dR1Oc09Prn2xL3EcdLfIbRHt11LaEZKj4s/wARJt
	UmXZDD+yj5SOo5XF+cUgi0ALc2YxCCL0M4hfoiMNLqlHe+4euVeV9KTOtazbZaWyXVmhqeO72AQ
	qdzl/WQiNyvX+bZphp18
X-Google-Smtp-Source: AGHT+IHCeMvnncVDMOJc7OiMB5lgPXTsD1S7AH7eB+5fQgbjHbeY0walQs9/plkYtVkogihuKxqjag==
X-Received: by 2002:a17:902:b18d:b0:216:1543:195e with SMTP id d9443c01a7336-21a83f3f501mr14970345ad.5.1736299738102;
        Tue, 07 Jan 2025 17:28:58 -0800 (PST)
Received: from localhost (129.135.125.34.bc.googleusercontent.com. [34.125.135.129])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-219dc9d4474sm318577745ad.142.2025.01.07.17.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 17:28:57 -0800 (PST)
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
Subject: [RFC PATCH 6/6] arm64: dts: qcom: sc7180: Add SoC specific compatible to soc node
Date: Tue,  7 Jan 2025 17:28:43 -0800
Message-ID: <20250108012846.3275443-7-swboyd@chromium.org>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
In-Reply-To: <20250108012846.3275443-1-swboyd@chromium.org>
References: <20250108012846.3275443-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow an SoC driver to probe for these devices. Add the SoC specific
compatible to the soc node. Leave the original simple-bus compatible in
place so that everything keeps working.

Cc: Rob Herring <robh@kernel.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: <linux-arm-msm@vger.kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 76fe314d2ad5..257890a193e6 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -782,7 +782,7 @@ soc: soc@0 {
 		#size-cells = <2>;
 		ranges = <0 0 0 0 0x10 0>;
 		dma-ranges = <0 0 0 0 0x10 0>;
-		compatible = "simple-bus";
+		compatible = "qcom,soc-sc7180", "simple-bus";
 
 		gcc: clock-controller@100000 {
 			compatible = "qcom,gcc-sc7180";
-- 
https://chromeos.dev

