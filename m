Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582DF4369A;
	Wed, 25 Feb 2026 01:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982978; cv=none; b=ZKKWbWV8xM0uwB25zSWiqsssOBtiyIlzfc0ws43odgM4AC2S6yiO/iZgTfqqcepG8PG9/iFRislKUXAl/JKpVQLUwP4cBQYzTZh4+06xXda9xMwNJan5uIENG7BdlDW7XjrCKEnUpp8KhLf7uPeVFi+x2gkEYuz4bJvacOwTHwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982978; c=relaxed/simple;
	bh=YuB6wEXOtONR/sc3Wp+bNC0J7jEA07AUN7gHGCvwknQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRUsg+M1ITKHUia6pc6lfN15gShr/tTozUPB+eE63KQNIhr/ZoQ63O/gaWzQrBN7g4f9UayDKtriAIYMWepG4aYIC0VAku7zGmIfh+8AeJwOI1AAS9QeCKxuuW5VUf+abL3clRlqLVo5cMZJ1KlAgd/+M4kAUi4m6O4NBPplj90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9pCHod/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9pCHod/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C6EC19423;
	Wed, 25 Feb 2026 01:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982978;
	bh=YuB6wEXOtONR/sc3Wp+bNC0J7jEA07AUN7gHGCvwknQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9pCHod/02PSlwecrV0RGCn98A0IRqGJhVunHyn9Ntk+0+ZNX/RmSJNQKbsY4mt+D
	 IcF/VPTUuPQl9zXiVsJIJYzWKL5flE6KKUmTkDD+V1z8qsQ3IOBjJgzm/TrQkX8nsq
	 rlsAUFg8z1zducXGy1diAutZeD2mPHx4Ue9ZWoEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 151/781] arm64: dts: qcom: sm8150-hdk,mtp: specify ZAP firmware name
Date: Tue, 24 Feb 2026 17:14:20 -0800
Message-ID: <20260225012403.365980415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit d43019ef200d567454a8f68e60a5b2df01d8c706 ]

The DT file has GPU node enabled, but doesn't specify the file name of
the ZAP firmware, which means using a default file name. Specify the
name to the ZAP shader firmware, pointing to the file in the
linux-firmware repo.

Fixes: f30ac26def18 ("arm64: dts: qcom: add sm8150 GPU nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251213-zap-names-v1-1-c889af173911@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150-hdk.dts | 4 ++++
 arch/arm64/boot/dts/qcom/sm8150-mtp.dts | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8150-hdk.dts b/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
index 0339a572f34d0..1eea9c5c66847 100644
--- a/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
+++ b/arch/arm64/boot/dts/qcom/sm8150-hdk.dts
@@ -387,6 +387,10 @@ &gpu {
 	status = "okay";
 };
 
+&gpu_zap_shader {
+	firmware-name = "qcom/sm8150/a640_zap.mbn";
+};
+
 &i2c4 {
 	clock-frequency = <100000>;
 
diff --git a/arch/arm64/boot/dts/qcom/sm8150-mtp.dts b/arch/arm64/boot/dts/qcom/sm8150-mtp.dts
index 12e8e1ada6d8b..0f2d511624a8b 100644
--- a/arch/arm64/boot/dts/qcom/sm8150-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8150-mtp.dts
@@ -358,6 +358,10 @@ &gpu {
 	status = "okay";
 };
 
+&gpu_zap_shader {
+	firmware-name = "qcom/sm8150/a640_zap.mbn";
+};
+
 &pon {
 	mode-bootloader = <0x2>;
 	mode-recovery = <0x1>;
-- 
2.51.0



