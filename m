Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A7434C13D;
	Tue, 16 Dec 2025 12:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887084; cv=none; b=iyxSZYZi9XsOCxSE320zPSrEPw2i50+FcTDaNfOHUktHu4NSjt5XdCxIe1p5ZW7hBtaRBQRw0MsaeElU2/h0DwYD0jQ8S0YQDfp26VGCGcfGZiPfIky8Ff1PpKvx8+7TO5q9MF7Wos+ooaWloZohqqvB2fm21n4QoFmEAfED6Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887084; c=relaxed/simple;
	bh=HlIwq5Y1V2G0ClfPxSAtGWUmtAIoFbqoY+hMxQsJftw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2OG0kKuta4wzXc7pGSWZPz8cexXIx5fghH0smeua4o1IOayKHLjoHWFjIumz7EzqvUWdl+2xURSNkF2l2DPfusdDuAD7p/xB5mQYMjon653kiqrThJ9iYG/elmXD2S8kXbLVQQ+NDlCW8X+Y1owiUnliF1EQDsUNMEtO7AGc6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wD2sw0Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wD2sw0Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA24C4CEF1;
	Tue, 16 Dec 2025 12:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887083;
	bh=HlIwq5Y1V2G0ClfPxSAtGWUmtAIoFbqoY+hMxQsJftw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wD2sw0DcrpnG0kDYzDsjjOjK069+g+Digwf9GGsvsIlG/DIgRqPGXtVBQHLzSRMQX
	 i2ieUbSzCCG8OG840j0JCuZXuVDRojSQH/5h2MzKgwzDwY79c6gSslWB9YoEXfx/Jt
	 2wHPxv8aJCgUQQFs62gwvAemoRNP7BM7eZjuwn3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Val Packett <val@packett.cool>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/614] arm64: dts: qcom: x1-dell-thena: Add missing pinctrl for eDP HPD
Date: Tue, 16 Dec 2025 12:08:08 +0100
Message-ID: <20251216111405.720178104@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit 1bdfe3edd4c862f97ac65b60da1db999981fc52a ]

The commit a41d23142d87 ("arm64: dts: qcom: x1e80100-dell-xps13-9345:
Add missing pinctrl for eDP HPD") has applied this change to a very
similar machine, so apply it here too.

This allows us not to rely on the boot firmware to set up the pinctrl
for the eDP HPD line of the internal display.

Fixes: e7733b42111c ("arm64: dts: qcom: Add support for Dell Inspiron 7441 / Latitude 7455")
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Val Packett <val@packett.cool>
Link: https://lore.kernel.org/r/20251012224706.14311-1-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
index cc64558ed5e6f..9df66295660c3 100644
--- a/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1-dell-thena.dtsi
@@ -1039,6 +1039,9 @@ &mdss_dp1_out {
 &mdss_dp3 {
 	/delete-property/ #sound-dai-cells;
 
+	pinctrl-0 = <&edp0_hpd_default>;
+	pinctrl-names = "default";
+
 	status = "okay";
 
 	aux-bus {
-- 
2.51.0



