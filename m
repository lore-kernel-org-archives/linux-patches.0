Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC06536C5BF;
	Wed, 20 May 2026 16:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295723; cv=none; b=IT1tQC3jH/J0gaTjg8i9MXqOQtjr/+HA781yklXODQ22ee8K/jgWoCnL8wCIAWKR2imQwdZveKr8QLgbMWVjssOmFhYI2Ngh+B1idIs3CeONB0VhwBIK1tNRtS6D3NZPb5E3iHD3gcYgOtf8o+iHTNVydlyCUdRa6/LrTL1ASWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295723; c=relaxed/simple;
	bh=7HbNSHUK3FoL8++yeWhFkFpVR9wK8D1ODoA0s1313Gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d63nr3TJdCh+80niOEL+IglBGu6HePAWt8IVamQQ4NcZ1mEdB8+3b9Fh/EJ+s5n94QMEc8o1BeFeo1nJQ2O8psCZhjNij5SAZynYH32HqpyBSBgoaUa71G2wYzsMk20NpHaVzz2YJht4izOmm99xS4gMnaJHx7/fPwm8AcNMusU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZdXHDPZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZdXHDPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC231F00893;
	Wed, 20 May 2026 16:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295721;
	bh=ZbQqxaryPu1jNuSHIs2hyYPalN/RQ9/BrFCcvW97y0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZdXHDPZCfUk7FNIH1RP2NqC2KsZ+1t3OILGQPQnWbnbEjA1u03xgrLTLIsESk1kN
	 eucO7fSt3GmpaoXVqG5SSbHlIT/AXr+QrRK81JXeHyIyMfWt/vDEVgcva/8oPqy6Ks
	 fA3HfZOlzPasT13/7KdM+tuWPtON5woLSbTcMSeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0528/1146] arm64: dts: qcom: sm8650: Enable UHS-I SDR50 and SDR104 SD card modes
Date: Wed, 20 May 2026 18:12:58 +0200
Message-ID: <20260520162200.130459495@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 93f823e7d48232e62fb8fb74481696609c90244a ]

The restriction on UHS-I speed modes was added to all SM8650 platforms
by copying it from SM8450 and SM8550 dtsi files, and it was an actually
reproducible problem due to the overclocking of SD cards. Since the latter
issue has been fixed in the SM8650 GCC driver, UHS-I speed modes are
working fine on SM8650 boards, below is the test performed on SM8650-HDK:

SDR50 speed mode:

    mmc0: new UHS-I speed SDR50 SDHC card at address 0001
    mmcblk0: mmc0:0001 00000 14.6 GiB
     mmcblk0: p1

    % dd if=/dev/mmcblk0p1 of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB, 1.0 GiB) copied, 24.8086 s, 43.3 MB/s

SDR104 speed mode:

    mmc0: new UHS-I speed SDR104 SDHC card at address 59b4
    mmcblk0: mmc0:59b4 USDU1 28.3 GiB
     mmcblk0: p1

    % dd if=/dev/mmcblk0p1 of=/dev/null bs=1M count=1024
    1024+0 records in
    1024+0 records out
    1073741824 bytes (1.1 GB, 1.0 GiB) copied, 12.9448 s, 82.9 MB/s

Unset the UHS-I speed mode restrictions from the SM8550 platform dtsi
file, there is no indication that the SDHC controller is broken.

Fixes: 10e024671295 ("arm64: dts: qcom: sm8650: add interconnect dependent device nodes")
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20260314023715.357512-7-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 75de839f7a2df..64a7480291d84 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -4976,9 +4976,6 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
 
 			bus-width = <4>;
 
-			/* Forbid SDR104/SDR50 - broken hw! */
-			sdhci-caps-mask = <0x3 0>;
-
 			qcom,dll-config = <0x0007642c>;
 			qcom,ddr-config = <0x80040868>;
 
-- 
2.53.0



