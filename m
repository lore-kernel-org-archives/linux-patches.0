Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59EE4369A;
	Wed, 25 Feb 2026 01:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982987; cv=none; b=MFDeILWY8xSM1PKlXZobmWeWKlpi7ZLMK/lI3KUaEZrEuTnkq90bMqN/YDrRfOEv5W4GJJYUZ13aX7FIypGiuK+6Mis/3njjTAxeIZhRiK+GFN2dsYqQUPWFaRwpJKvMeqWUdpatl4fRdhSlu+VwY80tf7W5FeoX5qgKkAZvkZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982987; c=relaxed/simple;
	bh=7x5/3IP+OfT1G9enUaBwPMx+KHXPhqNKpvhVrdK3UKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVAI9qdPB2fXThl7laCNg3/Sq21J7ltzvN96w9eNr7/fwpdNrqGEmz+FoSTqzANKL68ekPK+rj3UTVbrpzAxMfDeR/d+u4a6HAmT7OzUoa/KD1pd4HdKgJkvJudLTfZhbSA/EUFUYSAN+VRTNZ943R8Fx8OVCaOLUJmmIs4DPCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s66rIIaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s66rIIaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CBFC116D0;
	Wed, 25 Feb 2026 01:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982987;
	bh=7x5/3IP+OfT1G9enUaBwPMx+KHXPhqNKpvhVrdK3UKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s66rIIaJ7jlK0TGuKnbhoATRoFg2WcVaYux4o9sySpQ+KhbcvBEaDay2rUhMJ9Jsg
	 fJRorVw7UFKSkBUvi/EQYXbXhj38xU+DMqzUUCQ/HN3Hb/LRiGHjCkwRZHlHLuU0cP
	 wHZJv1sjlQHOZh8eT8VHfI52nOevVKFhIbaeIsU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 157/781] arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on
Date: Tue, 24 Feb 2026 17:14:26 -0800
Message-ID: <20260225012403.506739889@linuxfoundation.org>
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

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit ad33ee060be46794a03d033894c9db3a9d6c1a0f ]

This regulator is used only for the display, which is enabled by the
bootloader and left on for continuous splash. Mark it as such.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251118-dts-oneplus-regulators-v2-3-3e67cea1e4e7@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index 5845bc3bb80b2..8251f5a2f9475 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -272,6 +272,7 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-boot-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0



