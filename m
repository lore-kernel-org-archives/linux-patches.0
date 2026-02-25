Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71482BDC26;
	Wed, 25 Feb 2026 01:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983894; cv=none; b=HiqbeHxu/Wj3SSC0OZiZbHV2jdTozgY7zuluRjOOxz2a53OkRFwuds/nuQwWc7SMB1XrRfvs0V/Z3rpbwTJzecwY25Ic8Fb13sWfglJHP9M4OmKZp7NoxP05NeEScx+Gz0Zo2/SSPzCKFZLfdHV7AR6J2wEoK2S0r6UAgnE+bWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983894; c=relaxed/simple;
	bh=pWpvNS4I7lyVieQifszMPMb4MUKdliW5DcN28Qs5xf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCske8JbeAcugSTcpy8022zz5aQjLZnhq/8BjvnWN59AnWUED0Nr2riJHta+UschFFLDhB0qPqQ88zMYBdAkfMMNENnHUgOEm4Hu2n+OR11hzM2l1pouzcF3JpAtvI+tw9i1IwlUd7t41/9VypVOInt/lE+nSzbSQAMHC3VTEX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=str4n20C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="str4n20C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658ECC116D0;
	Wed, 25 Feb 2026 01:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983894;
	bh=pWpvNS4I7lyVieQifszMPMb4MUKdliW5DcN28Qs5xf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=str4n20C9atH8dvp0Mfu6DudE/T1lWtYbQzF/x94NDt7CXmsC8SFng7wYIWyiE7dM
	 jJgjkB4hgRdzqAcxFbj5NoVckhDi4gAsco8xF0t6jzijl1D/ZCLXQCDRd5jpEk6GMB
	 itGxXDgKgN6/TKw1PTZiZlC1zJz6NxtL9Yt8J994=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 166/641] arm64: dts: qcom: sm6115: Add CX_MEM/DBGC GPU regions
Date: Tue, 24 Feb 2026 17:18:12 -0800
Message-ID: <20260225012353.081275415@linuxfoundation.org>
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 78c13dac18cf0e6f6cbc6ea85d4f967e6cca9562 ]

Describe the GPU register regions, with the former existing but not
being used much if at all on this silicon, and the latter containing
various debugging levers generally related to dumping the state of
the IP upon a crash.

Fixes: 11750af256f8 ("arm64: dts: qcom: sm6115: Add GPU nodes")
Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Closes: https://lore.kernel.org/linux-arm-msm/8a64f70b-8034-45e7-86a3-0015cf357132@oss.qualcomm.com/T/#m404f1425c36b61467760f058b696b8910340a063
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251229-topic-6115_2290_gpu_dbgc-v1-3-4a24d196389c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index 91fc36b59abf9..8b8395f6a2dfc 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -1715,8 +1715,12 @@ usb_dwc3_ss: endpoint {
 
 		gpu: gpu@5900000 {
 			compatible = "qcom,adreno-610.0", "qcom,adreno";
-			reg = <0x0 0x05900000 0x0 0x40000>;
-			reg-names = "kgsl_3d0_reg_memory";
+			reg = <0x0 0x05900000 0x0 0x40000>,
+			      <0x0 0x0599e000 0x0 0x1000>,
+			      <0x0 0x05961000 0x0 0x800>;
+			reg-names = "kgsl_3d0_reg_memory",
+				    "cx_mem",
+				    "cx_dbgc";
 
 			/* There's no (real) GMU, so we have to handle quite a bunch of clocks! */
 			clocks = <&gpucc GPU_CC_GX_GFX3D_CLK>,
-- 
2.51.0



