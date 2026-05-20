Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AB736B059;
	Wed, 20 May 2026 16:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295812; cv=none; b=IOCJ5H6BkzNcr4k7LjcyOkzCdwdEeYs31X/rCkvVVSVA5wJ/5zojGke0LGg3QqkYfvqGt5vb5a8GxLtUgDL2WMDjQYE1qrMnHEoT4g4WoNYPOkDhcSdUhAsWjlRFqQHg8lDw0nODmj5Lhe+Ioo7XS4i3sEFDlT1FjsguEBR7+gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295812; c=relaxed/simple;
	bh=Ke1fnMGoDkq+Oi7xD8O4a+5Cdb6BdjdHUTxDCZ1yUnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pd72ri7Zgn8wfgQlMiI5qewSdtKhRxXOyrgZu8cY3iaaDWkFSNHIW/Q24WUntrfVDwQCFyJW4LEO2T6WNTvaVBr8sYwhw5vjPka00DwDdUIsGO/MDyLnmP2WR5DJBYSjzh3jWhk4D3rpsPGrHL+B9izpJs1dsQQLcKlvzQ2sX08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ScdAoV34; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ScdAoV34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3E31F000E9;
	Wed, 20 May 2026 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295811;
	bh=imfeG8sEhtjVqGBblFISIuc4V7UWXLdp/0j/hPlQSuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ScdAoV345gph2iDmI92aTLFT/OnHHYPThafsZWSKntTXCFlLyYdgaZLk9WXX3hBCi
	 CyVBkt0Wkc/FLvKj21R41ue+fmCdp9m1HrXoBhOVKupinownAEZ32ss+P4Eq3ShGH+
	 hxYcPfDNRDb8e9YyaFM/EtnYKMC4z9SBRR/ynIdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0520/1146] arm64: dts: qcom: sm8550: Fix GIC_ITS range length
Date: Wed, 20 May 2026 18:12:50 +0200
Message-ID: <20260520162159.952874629@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 357c559e386705609b6b9dc0544c420e3f91f3a0 ]

Currently, the GITS_SGIR register is cut off. Fix it up.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260317-topic-its_range_fixup-v1-4-49be8076adb1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 6a338c522ee92..1f088219b2dae 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -5274,7 +5274,7 @@ ppi_cluster3: interrupt-partition-3 {
 
 			gic_its: msi-controller@17140000 {
 				compatible = "arm,gic-v3-its";
-				reg = <0 0x17140000 0 0x20000>;
+				reg = <0 0x17140000 0 0x40000>;
 				msi-controller;
 				#msi-cells = <1>;
 			};
-- 
2.53.0



