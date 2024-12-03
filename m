Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B751E3DF9;
	Tue,  3 Dec 2024 15:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238178; cv=none; b=ovTJVTXlHZNPYEu79RziLf8z+QXedBzks+eq6kB0/7i7a4Et4dGDx725jhtFZTeECQjvty0ZYcjBToBUq/TevRZ1bamvpRwjdpL2iyEuutlEVGpdRf3ZnKf5prqABe5xQOxa85es86hhc4T7FdS+IftysuJ3DPlxnSOeFGJdUQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238178; c=relaxed/simple;
	bh=/hLnpbk7yzQ6RpYABG7VOSQ6hTh+s7Htlnwz4KHDick=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cypSvorsg+NWEnyVYlNXKAmcGy7HteKUFEwZlRLWSCKs3jWfihGR2KrT/IrXkctx980MvOIjZrh/+CRUC2OnIC743KXQ7jeADPwNczAbxzftVvs4qjfSPJQ0Ay4YwsZWAnkU7qRYF51BXp8YNcOU3PGaiozCK8Gv3ECVip7WXn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCfktJue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCfktJue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8264DC4CECF;
	Tue,  3 Dec 2024 15:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238177;
	bh=/hLnpbk7yzQ6RpYABG7VOSQ6hTh+s7Htlnwz4KHDick=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCfktJuehFA43CyWX954y27FquqCbCVsLM5rfBrEbcaRljX4nQZHZuWedULZYdDCk
	 yPtqORoJuoz/mrYoodQecodWlnQr5Oui6twJhU8Ra2q8/7XABeYSyZwZYEUEhTkEZz
	 qbXHFXLwZkc5FDgU/7/4VmJsd+HsjuKPR3/u+Ri0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 188/817] arm64: dts: qcom: x1e80100: Update C4/C5 residency/exit numbers
Date: Tue,  3 Dec 2024 15:36:00 +0100
Message-ID: <20241203144003.074926976@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 2e65616ef07fa4c72c3898b22e5bede7d468cf32 ]

Update the numbers based on the information found in the DSDT.

Fixes: af16b00578a7 ("arm64: dts: qcom: Add base X1E80100 dtsi and the QCP dts")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240716-topic-h_bits-v1-2-f6c5d3ff982c@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 2a03581b0ab56..db0304c564980 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -278,8 +278,8 @@ CLUSTER_C4: cpu-sleep-0 {
 				idle-state-name = "ret";
 				arm,psci-suspend-param = <0x00000004>;
 				entry-latency-us = <180>;
-				exit-latency-us = <320>;
-				min-residency-us = <1000>;
+				exit-latency-us = <500>;
+				min-residency-us = <600>;
 			};
 		};
 
@@ -298,7 +298,7 @@ CLUSTER_CL5: cluster-sleep-1 {
 				idle-state-name = "ret-pll-off";
 				arm,psci-suspend-param = <0x01000054>;
 				entry-latency-us = <2200>;
-				exit-latency-us = <2500>;
+				exit-latency-us = <4000>;
 				min-residency-us = <7000>;
 			};
 		};
-- 
2.43.0



