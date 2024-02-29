Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E9E13D311
	for <patches@lists.linux.dev>; Thu, 29 Feb 2024 01:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709170507; cv=none; b=ZWVeq0zwMjesYAJzc+3/dSZojdhL04wRiEukygWwj+ZeEO+6GzTsNMajkDbzwBrz4APVS/mNxoAGiy84TYEBMD5++/fRh9XbRM/yiTktCKw/ylL3cQr1bFCx6AewuS7TepWgaMWlHi9TaTErP8fJDs6/FSwUYGhFMANQihGCFLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709170507; c=relaxed/simple;
	bh=rNhXvztlPIMQxaT3uBcxWgppme382OuBdUXTLAuCzMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WAZlw2c9xeYt+bS8vQVvom6vvsaVQMScu1XML1A0hn26+qdxR/DEXHIkphSYAm7LfuT7ddkmjpOwnb1QqLG8pGsZcYkot9evTBqOplCLojHaZSZemheaGfBX/NsRqdkGHpIrbWnQCOvD6gm4x47g/j5g8luJJpnJh4nvCr1WUDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=BQ3aq+NJ; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BQ3aq+NJ"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e571666804so222312b3a.2
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 17:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709170505; x=1709775305; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+iy/LQHSKsmIm2Ae2f5kmdkaP9KIdMysWT/fEuU36SA=;
        b=BQ3aq+NJejkiHxasL2TBGK91i7tFEcxFFZ+IKvykZydRaEOqXrbM8JXv2KABDHlr3k
         f4QHa1LzBF5QX6FBJGtNILS4jQQtGSNPd9IFMtMrAnn5hRn1DAXTBDF/X7byNf4YCWCC
         FaZ5bK/5cAMKYpIAwixTm6w9O1p2vgW+p3Ins=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709170505; x=1709775305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+iy/LQHSKsmIm2Ae2f5kmdkaP9KIdMysWT/fEuU36SA=;
        b=euHnZOwMsvZf1S8B8TtxHaa9qtVf6O3j6vJZiCpkx9ZBdV+rhwFq1CX+XS/wWk9Taj
         UT+tk+SdkmjQNZqlu0VXLImYIi3L6azU3v7HFVtESgwL3Pr+5/s+HpmOg385Hmmxmmth
         TrCnYd+ga8c7JbOrNnNy3nsRuYdnAD3v8T25Q4sLX1nJIZ2fzMte3MG3CyxTg6NOqfeR
         p0mqZGp651F2LlcPk7nEuR3xPAnrKerZ+/cSld/k5PnaNMOGd09upzc3pA+z82GXHRr7
         gs1VQszNuGVseQ8VhrClA11wpDiC8i98OfZ+PqIstl79PHRjVOGXaC/moD7Qm0vzkkOk
         ZiJg==
X-Forwarded-Encrypted: i=1; AJvYcCX5h+J+woR39l5EHBmaJGpMI+T7dhSA4Pt9mO8URCF43CmWjoXmIPDXvmueJYQ+piulM5t+q8W2jrslNdq4FX/Z0g4C0E670g==
X-Gm-Message-State: AOJu0Yxjjsh4vWlfRhs58LiSkGeFIQSdGCHNnXR9APcvUyS58TfIgo9M
	gLiq8w8XQX6tUAHz2UQGwuhVCwMT4ShoGDsRpa093rxh8TRDzVMUiJpIu9EH7g==
X-Google-Smtp-Source: AGHT+IHe8q/7Uap3Rq440sONVc3d/cawGrolo7Z307D4Y05inxotsQMMYjUjiMMfqtXROHeogJrWVQ==
X-Received: by 2002:aa7:8482:0:b0:6e4:eb29:357 with SMTP id u2-20020aa78482000000b006e4eb290357mr839544pfn.12.1709170505147;
        Wed, 28 Feb 2024 17:35:05 -0800 (PST)
Received: from localhost (217.108.125.34.bc.googleusercontent.com. [34.125.108.217])
        by smtp.gmail.com with UTF8SMTPSA id b26-20020aa7871a000000b006e13a88d52esm97174pfo.61.2024.02.28.17.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 17:35:04 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	cros-qcom-dts-watchers@chromium.org,
	Souradeep Chowdhury <quic_schowdhu@quicinc.com>
Subject: [PATCH] arm64: dts: qcom: sc7180: Disable DCC node by default
Date: Wed, 28 Feb 2024 17:35:01 -0800
Message-ID: <20240229013503.483651-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't use this device on Trogdor boards. If we did, it would be
enabled in the sc7180-trogdor.dtsi file. Let's disable this here so that
boards with t he sc7180 SoC can decide to enable or disable this device.

Cc: Souradeep Chowdhury <quic_schowdhu@quicinc.com>
Fixes: add74cad7c9d ("arm64: dts: qcom: sc7180: Add Data Capture and Compare(DCC) support node")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 4dcaa15caef2..f390bf3eccbe 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2239,6 +2239,7 @@ dma@10a2000 {
 			compatible = "qcom,sc7180-dcc", "qcom,dcc";
 			reg = <0x0 0x010a2000 0x0 0x1000>,
 			      <0x0 0x010ae000 0x0 0x2000>;
+			status = "disabled";
 		};
 
 		stm@6002000 {

base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
https://chromeos.dev

