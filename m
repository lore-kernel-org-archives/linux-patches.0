Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813F01EB42
	for <patches@lists.linux.dev>; Thu, 29 Feb 2024 01:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709170112; cv=none; b=TSyPdRhL/8+5NqQkNwkXl8UqzZF3V42MvmYJCS2vAKU+6DMnhnIoouWOc5FqE3HpmdOLEOznYdWIHcS8PUujlVaeDQquE3PcSfqhVHtIbumYy2cPFZkMqJiojoRhOjkS5OrOlowjX3vXLCO9pVZ0wVifH00rA7Qk/wIc8j4Zf1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709170112; c=relaxed/simple;
	bh=jh68udILcKxaKugT7b2cDM3HVtsQku3plCWj0K+LaSE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AzXdxOhxw/Gwnl3X4dg9wEUriZuaR/lR5gU3ePiptzHGzjzEuy6gXKvnHE58TfE4NnqPTRgnkEQt0UC7oYAc+ALHoK+750NTq4/jbBf7AhTu926NSXNvzpkxFhWV6Nga9QjoNYHD3poj0z0NEA5FyRsG5gDEtxtu4fI+JN92o8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=XE60nusv; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XE60nusv"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-5dbcfa0eb5dso351836a12.3
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 17:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1709170110; x=1709774910; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Jq4TUlWX3GIYiIoQ+zpQ3OQeTgAG70ET6DGeOsDe4E=;
        b=XE60nusv/sdPOmmMOhHmRlDkj+NictXVDUD6hzjmDHWpCEFnTLS+6xokehJlYBXMJ7
         ehWfyAFXUTEaiserB6xX56K8BgbjsIEZyNNqEokSupN3CSEyF/JDAi3TyilPwTZ/F7FG
         omEmWl9qKdUndE3XFB8Fq1lMyFQ7x1sQxbXsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709170110; x=1709774910;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Jq4TUlWX3GIYiIoQ+zpQ3OQeTgAG70ET6DGeOsDe4E=;
        b=uLUMrbqdAZj1TUR4l1ovh7GEPsgnYU4jWFPKNGF5slSt0O4Sg+nnNVOMcCb7pxBXRy
         B4NPhPGtoBYcjJzBnDewK9LTKKYJQLpPaNhGGRESgTOC7tKaDR2wci5ogM1YNzrcaz53
         DY1CG5aIwedmdq5UTafGtV2WXEqVufzNcaszBP+yIRgdXvnqMvBRDKiPKhS0LtG/jgcB
         f7eH9ghGOvQgNdRhjNJMHPTrCDYlMjjt823Y6qG8CTPJsClK/Rwoy7sswmNpInoWjLhQ
         UXZM09+xsxdshU9f3G2hFm8Mp39Z5hxDg6H2la0rqxrtUY4mTkMIt3BCF0RYlD50bblu
         0hfw==
X-Forwarded-Encrypted: i=1; AJvYcCWI0B/OiSuW0I3RGAbcSb1EnA70Ng4QEz0c+fIwH7gQASQ2t+yarbpD9yk1z7sr2AhedjQJ9A4eS6ssIsWV2N7No6SshAoWYg==
X-Gm-Message-State: AOJu0YzAr4+axkZm7KH/pOpL4vynAjPDwM6SZExVigLSdVWlFUm/Qcr6
	sPO7AvLT5oZIi90Gf927JMNyiF/HI3LjgzF480PZQrrbj4u8Q+Q/JwDSBGa77w==
X-Google-Smtp-Source: AGHT+IEYN2In2MRJucUTR7e0wGoAIi/LK1pWKTCPgEITDs7weQjpJtIRVTB+q8iM3JfA2fuLcWiVug==
X-Received: by 2002:a17:90a:734a:b0:29a:6cf0:57a3 with SMTP id j10-20020a17090a734a00b0029a6cf057a3mr864753pjs.8.1709170110507;
        Wed, 28 Feb 2024 17:28:30 -0800 (PST)
Received: from localhost (217.108.125.34.bc.googleusercontent.com. [34.125.108.217])
        by smtp.gmail.com with UTF8SMTPSA id mf12-20020a17090b184c00b002904cba0ffbsm2187303pjb.32.2024.02.28.17.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 17:28:30 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	cros-qcom-dts-watchers@chromium.org
Subject: [PATCH] arm64: dts: qcom: sc7180: Disable pmic pinctrl node on Trogdor
Date: Wed, 28 Feb 2024 17:28:26 -0800
Message-ID: <20240229012828.438020-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.44.0.rc1.240.g4c46232300-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We don't use this pmic pinctrl node on any Trogdor devices. The
AP_SUSPEND pin is here, but this pinctrl device isn't a supplier to
anything in the devicetrees that include this file. Disable this device
node in the DTS so that we don't waste time or memory on this device.

Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 46aaeba28604..774c0647ea19 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -1164,6 +1164,7 @@ &pm6150_gpios {
 };
 
 &pm6150l_gpios {
+	status = "disabled"; /* No GPIOs are consumed or configured */
 	gpio-line-names = "AP_SUSPEND",
 			  "",
 			  "",

base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
https://chromeos.dev

