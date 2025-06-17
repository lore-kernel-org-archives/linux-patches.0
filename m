Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7843C21B908;
	Tue, 17 Jun 2025 16:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178079; cv=none; b=RkTD8OOtllV08PsNVHDjRLOrrDjJgRfJrEldiEp678mcYKu5Zdoq1kGvoxO53EKCoNLPrCVJJ7UsXGLhszR7yvOV3JjVk2dIP4+zQNdnOP973V0jA79rU0JGbKfFZliDk3hsnolcvH7H0042pNAjZ3dMgOdBzl2gBMsMy9aJGBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178079; c=relaxed/simple;
	bh=54o4/0aapF3Eqa5QtguFMjyMNrizQdwBEio0KCnFYlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYlzpeMmBZBzonyM8gZQJ25h/wc4OYHOrCAiIJC6+2wWh2Cx27BDUxELrSwBeXvORH+99jeCksx8Uvr8n5+JvJuo0am2ZgUbFREOZHPVyc1c2G8rV7yDGIcwKHHTC3FgZCYIMMVp2p6ue38tiuMYbMgUOGynw60d0LsZNSc55DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1E6QEETx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1E6QEETx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91286C4CEE3;
	Tue, 17 Jun 2025 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178079;
	bh=54o4/0aapF3Eqa5QtguFMjyMNrizQdwBEio0KCnFYlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1E6QEETxLwLdmCNN5gUhYZc7ng9eERf+0WoT0LLpOKzCqh+bqeo+AeQMO+euPts29
	 RiEpv0ZUspGmGEcPo8VM0j7iG4QF12FWGZBsR6Ke/o/06Zzfy4mQxmyyd62DO8mqsa
	 DYRjzSdle5W/p3VjgwV1EP1+APMmFcSjCZ7nYTn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 383/780] arm64: dts: qcom: x1e001de-devkit: Fix pin config for USB0 retimer vregs
Date: Tue, 17 Jun 2025 17:21:31 +0200
Message-ID: <20250617152507.059897239@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 635d0c8edf26994dc1dcbc09add9423aa61869b0 ]

Describe the missing power source, bias and direction for each of the USB0
retimer gpio-controlled voltage regulators related pin configuration.

Fixes: 019e1ee32fec ("arm64: dts: qcom: x1e001de-devkit: Enable external DP support")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20250422-x1e001de-devkit-dts-fix-retimer-gpios-v2-2-0129c4f2b6d7@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e001de-devkit.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
index 8f4482ade0f98..3cfe42ec08914 100644
--- a/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
+++ b/arch/arm64/boot/dts/qcom/x1e001de-devkit.dts
@@ -1039,6 +1039,10 @@
 	usb0_3p3_reg_en: usb0-3p3-reg-en-state {
 		pins = "gpio11";
 		function = "normal";
+		power-source = <1>; /* 1.8 V */
+		bias-disable;
+		input-disable;
+		output-enable;
 	};
 };
 
@@ -1046,6 +1050,10 @@
 	usb0_pwr_1p15_en: usb0-pwr-1p15-en-state {
 		pins = "gpio8";
 		function = "normal";
+		power-source = <1>; /* 1.8 V */
+		bias-disable;
+		input-disable;
+		output-enable;
 	};
 };
 
@@ -1053,6 +1061,10 @@
 	usb0_1p8_reg_en: usb0-1p8-reg-en-state {
 		pins = "gpio8";
 		function = "normal";
+		power-source = <1>; /* 1.8 V */
+		bias-disable;
+		input-disable;
+		output-enable;
 	};
 };
 
-- 
2.39.5



