Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E34D1E2834;
	Wed, 25 Feb 2026 01:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983913; cv=none; b=EChUmkw32ETH3A0zuLNAsG3CMDVNbVWDGmih8XF7V2+pnKTI2w738+uRX+wom4xPvsbcsJBy26CRmddQaJxL1rAIHlZjbrHqBTXmL38BpCNRodKT8OU/ynjkHyIQsYhJmoOqe5xrO6JhDtCstnq9+GjSuOIC9AAI/mQ3mugVoGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983913; c=relaxed/simple;
	bh=GfPUpKntGUuvRa+a+mk+KDvHAFIVECAVyqx8odsqtb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXeM7n+pbsLP4TKhHkcYr6kqHpX9IW/A7JXe6918fU9ySb1V0Qa1mtC5Mpz60QkYxT73ybMI8wNj0eDnAgDHnPORwNN0vwWn4gRfaX1Pl8wPz+BjwvwJ8HykGNB8so8KkeWfiBCJu/IfGnOO6fUXzNSzc7HOrksiw2Rv0BctVqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHhSDMAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHhSDMAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5C3C116D0;
	Wed, 25 Feb 2026 01:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983913;
	bh=GfPUpKntGUuvRa+a+mk+KDvHAFIVECAVyqx8odsqtb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHhSDMAPbnJkRRkOaxMjfwPivURPomURAh/rX5782RLOb00UtWkcR+89q8aG+ROhJ
	 o2YL3OG1aj7yzlCUjv4CkDv8GlkW7mTmbFjd1r+rqieeKCf5M5yu4SoHaPpIj+BQXV
	 q9yLEiSPvqrtDENquz6tN7NBi9bb8tPAHcaDhVAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 137/641] arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on
Date: Tue, 24 Feb 2026 17:17:43 -0800
Message-ID: <20260225012352.453303935@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7169da658dcd0..1036305231b20 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -256,6 +256,7 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-boot-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0



