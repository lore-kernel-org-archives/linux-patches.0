Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4DB346772
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302095; cv=none; b=AfrbgIYjENp318AnPsyKSH/g6WjHFpMJX7eJVkslgpXW/Jp7JenDsVLazUR2j3w7R7Fl9mUKqlRHPi8PDw5c3xP0p4nZ4z/9pk1SnMAuUmO5IK03pI0yj3aCZZUBZDUis39v6aYuP0wpXahxOlXYuDcrneEdjCnhTuH3HlXl3qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302095; c=relaxed/simple;
	bh=1EsHpoKXrTAlsIm+ZPRF8o0N0Zrp6PYYfKsdi8srjlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMOFCJiXPP3VhAczeWuBaCVa74IQX3556zc3IigcCD/wup7cvTb1Lqarg7wQiPmQTiSRvngGsw3f746kUZuPAKXG4NLSKwhoOtOPDeA4AudSrpgws+dYIUbhB2nF7Op+rJsCF62IdrDKHENDKkPQXN45B9/wSKgvW6uYb4b8Mgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pv+hKUyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pv+hKUyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6A2C19424;
	Sat, 28 Feb 2026 18:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302095;
	bh=1EsHpoKXrTAlsIm+ZPRF8o0N0Zrp6PYYfKsdi8srjlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pv+hKUyZfn8YoxSf/mRjpx+mT9h6+xKxliS7yR+/lZQuxdtIXenG5fs5xGiLWHlxE
	 apKNKU2jzxpfpArFnY3/RppyzQXkb1gHu8KSPE1sJ93JY4bRVkgXAyo9WbRrE/o2UB
	 OtWYt4y51GI9tYA8cQCBMtgSYTkbTHrUfff6wgPFK1WIBGSrEmVnin0Vj474iY3JSR
	 3QjOnMLZCteUzsmI6rMaHB6kjvaPQA6TesNm3fnnWg0BEZvKVCpoZTz0hl5UA2t3ML
	 2+oVyoCgbQaQetOk4E9E3zCGfx4ef/0YW8ksNjA2YZUYkw71fQn9FIDoC/7O0N5+ub
	 DEsc7nUYofB3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/283] arm64: dts: qcom: sm6115: Add CX_MEM/DBGC GPU regions
Date: Sat, 28 Feb 2026 13:03:42 -0500
Message-ID: <20260228180709.1583486-80-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 5c6fcf725473c..4c6d30404ff13 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -1336,8 +1336,12 @@ usb_dwc3: usb@4e00000 {
 
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

