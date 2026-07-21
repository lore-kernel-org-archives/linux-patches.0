Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6010B46AA71;
	Tue, 21 Jul 2026 15:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648207; cv=none; b=BfpSM3BV7utK+xH7/l52ydi7Z6Nq0tx/HfBruQfUXf8kMrK/2s+ydHeDkWJhks5RH9NFUYrFysa5guSrQLsjZPV/w8qaegnSV+nS2RHISk/DJXL4hec9XRhKNILdIqXwsFRBcyKs5Sjp/cWNvkN1vKANqRloC5g2GQpqCMBzvuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648207; c=relaxed/simple;
	bh=gDJt5noGotxzft8tJD6/0DmwMcEkQ2PxqwI2DiATi4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMr6/7pcKZzCYnGAu1xYUu4bsYFpAHEflf5bEQJEZaT+FD1XoDO60X018bVaSW8YoYlbtJonrMCanrDZXavuQzPNwJs1WGIiMi6dypj4L5OCovbk4fIok9yZvxnGk7msCFD1mkTnMTPRn7XKGpjDQLETWIm/4tcd0EX29N0To9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yp7/d3Le; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yp7/d3Le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58301F000E9;
	Tue, 21 Jul 2026 15:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648206;
	bh=xN6V2bahv9VT/jkS2OWEILkZ1F/ggDoj2xkFHbemh2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yp7/d3LeTjV5BHThqS2WjUuRMkQJvszrkbPvpTA2bURi5Vk4WpXIsZzbbP3D+q3Om
	 nL5wTkfMt81vCEbe+2lFrBHuAkDqAhJIb5hhvG1WRchCdp2ZycMGgG49YExx3X/75u
	 eVtaRJs9saANqarBl/+ssH1f9na+v0CsW+Pa3ZxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0085/2077] arm64: dts: qcom: glymur: Fix cache and SRAM simple_bus_reg warnings
Date: Tue, 21 Jul 2026 16:55:58 +0200
Message-ID: <20260721152554.700663339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 46eccc1034c3740b07b58c125190bbb99247c9de ]

Correct the unit address of cache controller and SRAM nodes in Qualcomm
Glymur SoC DTSI to fix W=1 DTC warnings:

  glymur.dtsi:5876.36-5908.5: Warning (simple_bus_reg): /soc@0/system-cache-controller@20400000: simple-bus unit address format error, expected "21800000"
  glymur.dtsi:5917.23-5934.5: Warning (simple_bus_reg): /soc@0/sram@81e08000: simple-bus unit address format error, expected "81e08600"

Fixes: 41b6e8db400c ("arm64: dts: qcom: Introduce Glymur base dtsi")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260405-dts-qcom-w-1-fixes-v2-2-1f2c7b74a93f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index ab2a6b577bc9d0..7283d45ca259a8 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -5865,7 +5865,7 @@ oobm_ss_noc: interconnect@1f300000 {
 			#interconnect-cells = <2>;
 		};
 
-		system-cache-controller@20400000 {
+		system-cache-controller@21800000 {
 			compatible = "qcom,glymur-llcc";
 			reg = <0x0 0x21800000 0x0 0x100000>,
 			      <0x0 0x21a00000 0x0 0x100000>,
@@ -5906,7 +5906,7 @@ nsp_noc: interconnect@320c0000 {
 			#interconnect-cells = <2>;
 		};
 
-		imem: sram@81e08000 {
+		imem: sram@81e08600 {
 			compatible = "mmio-sram";
 			reg = <0x0 0x81e08600 0x0 0x300>;
 
-- 
2.53.0



