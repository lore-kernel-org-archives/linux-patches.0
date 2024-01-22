Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A225FDC1;
	Tue, 23 Jan 2024 01:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974653; cv=none; b=eACDQ9gZS+G6LMFD1kY7lqqcJJffT5qZHjbtdEbbCLAe7dxEngQQd0VhEcL2f1uhfSTczTXJ4R+Z9wYGN+5010u4UVr5mpjt42MccK0FpITfFkeex+odltPQr1DcSmGnv+g81I85ph1PI83PWW1OI6scPR12BK5GKpSaIyvT6cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974653; c=relaxed/simple;
	bh=qnj1c8M4H9oaQM200jrX346MRr4LoTVQkD/24p4aMIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uw/DUf/BzpuGPkrO/r6g3NU2LixWw5tLo5LJ5Nd4S+cMz+/rFQGqRTZZ6uE5figKpMVUNsyEI+AWrjXL8EfpfxjX3GNJ8qy1GMiFLShdHn3IHhX6sf6Pwq3z7PhNntRc6tgtJeof+MXHObfRclA9P5fbwfLkC4nTy0Ca/DezvwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHcB0+fa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHcB0+fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC6DC43390;
	Tue, 23 Jan 2024 01:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974653;
	bh=qnj1c8M4H9oaQM200jrX346MRr4LoTVQkD/24p4aMIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHcB0+fawr1zk9hp5PeBCVK3Oln0psII08+76d21bwAdv+VDudWz5sZI1BNVov6df
	 2KpAgXtbKVnED6mAvpbisTGS0m3TOK7cIMLbnExhyTvzBuaNcYgy69bxoyDmK800y2
	 WPDuEvbU+pWcCtwxOOySljm0q6OtG4oT4mZ6oPyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/583] arm64: dts: qcom: sm8450: correct TX Soundwire clock
Date: Mon, 22 Jan 2024 15:52:39 -0800
Message-ID: <20240122235815.468873974@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 20e886590a310665244a354e3b693b881544edec ]

The TX Soundwire controller should take clock from TX macro codec, not
VA macro codec clock, otherwise the clock stays disabled.  This looks
like a copy-paste issue, because the SC8280xp code uses here correctly
clock from TX macro.  The VA macro clock is already consumed by TX macro
codec, thus it won't be disabled by this change.

Fixes: 14341e76dbc7 ("arm64: dts: qcom: sm8450: add Soundwire and LPASS")
Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231129140537.161720-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 2a60cf8bd891..79cc8fbcd846 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2325,7 +2325,7 @@ swr2: soundwire-controller@33b0000 {
 				     <GIC_SPI 520 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "core", "wakeup";
 
-			clocks = <&vamacro>;
+			clocks = <&txmacro>;
 			clock-names = "iface";
 			label = "TX";
 
-- 
2.43.0



