Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C711A2ED84B;
	Tue, 17 Jun 2025 16:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177871; cv=none; b=opcmnrC7VCnXbG/lwFQOeQX4nwQqCLT18/qVl8ETxozjWrOM/+1RfmIFsGs1kxzBdJ+Q5IP2yQ9FBGlQmxiseS4U0af8SuklRT1NEXt1lvbaHK6siQUPaaR+ENrBHMJ6n7Q16GjEQnkaob+9MUfgpUqngz1KOZR44vK7Wu/+NKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177871; c=relaxed/simple;
	bh=VojeSEBk0VRqdcmMD1gNrQR+fY4XyWiYW2JALcBZaMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKuDYLmGI7JfjfwqrjEx/L0KJxNKvLuLNekxMjbyhBULaQ7mm3YRbBZRLIRrh0jS6GjXBM9iKuaPkXT+/2aUjqMmrMqP7Br2IFwEH+BVi0+SwhXfOFjexgXhEkYnaBFXYX/3Sk+92PC3nzqdM1MTn8T4/XomkG7hoOC8r1bXAu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUqT0mS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUqT0mS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D395C4CEE3;
	Tue, 17 Jun 2025 16:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177871;
	bh=VojeSEBk0VRqdcmMD1gNrQR+fY4XyWiYW2JALcBZaMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUqT0mS/a3E6UFU6Cwt/VsLhNmfU0g+0Bvda/o0vyH3O5cDtzoSozsHmX0tltjFGk
	 97k2QrUI9Fr5Xuza67Cs1gDuWVTB/wA0DBWYXZm60UEUNfsgvIQ18IgfcBLEkYdDkB
	 nFvtPn0csfbE3rGqv5lA4Orj/GrdV1GX7J01+s7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jyothi Kumar Seerapu <quic_jseerapu@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 357/780] arm64: dts: qcom: sm8750: Correct clocks property for uart14 node
Date: Tue, 17 Jun 2025 17:21:05 +0200
Message-ID: <20250617152505.996481324@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jyothi Kumar Seerapu <quic_jseerapu@quicinc.com>

[ Upstream commit 515551e65635b988f2afa9e8683a6b57d6cfba36 ]

Correct the clocks property for the uart14 node to fix UART functionality
on QUP2_SE6. The current failure is due to an incorrect clocks assignment.

Change the clocks property to GCC_QUPV3_WRAP2_S6_CLK to resolve the issue.

Signed-off-by: Jyothi Kumar Seerapu <quic_jseerapu@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 068c3d3c83be ("arm64: dts: qcom: Add base SM8750 dtsi")
Link: https://lore.kernel.org/r/20250312104358.2558-1-quic_jseerapu@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8750.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8750.dtsi b/arch/arm64/boot/dts/qcom/sm8750.dtsi
index d08a2dbeb0f79..e8bb587a7813f 100644
--- a/arch/arm64/boot/dts/qcom/sm8750.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8750.dtsi
@@ -993,7 +993,7 @@
 
 				interrupts = <GIC_SPI 461 IRQ_TYPE_LEVEL_HIGH>;
 
-				clocks = <&gcc GCC_QUPV3_WRAP2_S5_CLK>;
+				clocks = <&gcc GCC_QUPV3_WRAP2_S6_CLK>;
 				clock-names = "se";
 
 				interconnects =	<&clk_virt MASTER_QUP_CORE_2 QCOM_ICC_TAG_ALWAYS
-- 
2.39.5



