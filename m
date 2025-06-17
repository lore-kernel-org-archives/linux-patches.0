Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065582DFF2A;
	Tue, 17 Jun 2025 15:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175258; cv=none; b=O+v/tNJx2ye7ViqI/0VgJJyJDDJ+QtJ/PDEc5EZWeqFrPL3WXxQt9lKQC6Pgf+UUUTD2DcbCBGt0xhjU/HhuObmhwnEgp0s85avTEakZ2K2kYz+fhpsUsd4ZACyt9aIPhQrOCL9UHON9s1XkxyECdjScRLsgcdDiGLXHCFIXtwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175258; c=relaxed/simple;
	bh=+MvLmrgvDjXKEQhu0L4jsiW03/TTsEqQ/HB9e7gQfFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efwBOLDhWIBugNhseH0OFbD2HreEJ0LDzcMqgugMglFWfrVnDPYb2A4ddzZX/s36NdxRqJYAOk+/Fch2cWgn/tunL5ctFi/DWdauizprj4yuXraAP96gsZon+vg7jmE9B1udtIjj6agHq5MxL5GT6VFQ10NnW+x/OyR9q4GnfXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpMX06Yq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpMX06Yq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D65C4CEE3;
	Tue, 17 Jun 2025 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175257;
	bh=+MvLmrgvDjXKEQhu0L4jsiW03/TTsEqQ/HB9e7gQfFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpMX06YqNicPiOfazEZDEsuovwwLxO3zU4+J8eAe1/cOvftUHSinGg+19Ay/STmZm
	 4YrrejFwVsH28xcaOsVMCWxK5XEkabPCywN7yjQ09SAmDc9HFhKPBmQHHQy44h3Ei6
	 I9ZajaeYW5NOUmWtpKLboMkN3WdEK/oOMTGCh4KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dzmitry Sankouski <dsankouski@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/356] arm64: dts: qcom: sdm845-starqltechn: fix usb regulator mistake
Date: Tue, 17 Jun 2025 17:24:33 +0200
Message-ID: <20250617152344.585566675@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dzmitry Sankouski <dsankouski@gmail.com>

[ Upstream commit 242e4126ee007b95765c21a9d74651fdcf221f2b ]

Usb regulator was wrongly pointed to vreg_l1a_0p875.
However, on starqltechn it's powered from vreg_l5a_0p8.

Fixes: d711b22eee55 ("arm64: dts: qcom: starqltechn: add initial device tree for starqltechn")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dzmitry Sankouski <dsankouski@gmail.com>
Link: https://lore.kernel.org/r/20250225-starqltechn_integration_upstream-v9-3-a5d80375cb66@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
index 6fc30fd1262b8..f3f2b25883d81 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-samsung-starqltechn.dts
@@ -135,8 +135,6 @@
 		vdda_sp_sensor:
 		vdda_ufs1_core:
 		vdda_ufs2_core:
-		vdda_usb1_ss_core:
-		vdda_usb2_ss_core:
 		vreg_l1a_0p875: ldo1 {
 			regulator-min-microvolt = <880000>;
 			regulator-max-microvolt = <880000>;
@@ -157,6 +155,7 @@
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 
+		vdda_usb1_ss_core:
 		vdd_wcss_cx:
 		vdd_wcss_mx:
 		vdda_wcss_pll:
-- 
2.39.5



