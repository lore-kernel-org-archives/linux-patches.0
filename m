Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25AA1F76BC;
	Tue,  3 Dec 2024 15:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240491; cv=none; b=JerlaCKr++edu5Vct6k0TdMxUhfDf+AVhMDF2iBLTKWX2eZWW/quzA1U5AErS8KmdsiTI+C/KPQYj9BjhZ2dZ6jP1p8xmjX4OiicfNL8wcQhw0l/SyEMi5iIcRYH2Z/oPzBWAz0qCC2wy3+G4LHclzQYsgp+Pj7YeIYXcD1KV0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240491; c=relaxed/simple;
	bh=y5wgMpQabJH7NeVhEyay4yoTWhQVSbvlcAPtUVZuNHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvTWaauKjt3oBIgcSjRbNXr68x5p5Uxbl9ZE8xZvGM7YWQ8mMZn1Ds8H355rRUSz6X1XW8HV9cac7Kgk95iPPW1x2a+CbWLHqdcAjxvAiOBYNX4AN7iB4U3veOdJ11sNZzxQlucoTzms4vcrNFGYYe82kMfZnh0Bx26IlPV9M+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKM3JaCP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKM3JaCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440FFC4CED6;
	Tue,  3 Dec 2024 15:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240491;
	bh=y5wgMpQabJH7NeVhEyay4yoTWhQVSbvlcAPtUVZuNHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKM3JaCPjEeDZsurd1fuUk7zVbuhbCtDggFPBluphT67ETkjr2bYNk8FMt5y//+YI
	 VyWw/hJDUOtK7r10dmvEEv/2K0IDGdS5Zmj2vis9wnhN3f0OSlJ8o6A9Vk/YDwiHmT
	 N4JggLv/1adzC2WbIG+0BhUkpr9dGhII9XvSNsl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/826] arm64: dts: qcom: x1e80100: Update C4/C5 residency/exit numbers
Date: Tue,  3 Dec 2024 15:37:59 +0100
Message-ID: <20241203144749.673578152@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a073336ca0bed..914f9cb3aca21 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -279,8 +279,8 @@ CLUSTER_C4: cpu-sleep-0 {
 				idle-state-name = "ret";
 				arm,psci-suspend-param = <0x00000004>;
 				entry-latency-us = <180>;
-				exit-latency-us = <320>;
-				min-residency-us = <1000>;
+				exit-latency-us = <500>;
+				min-residency-us = <600>;
 			};
 		};
 
@@ -299,7 +299,7 @@ CLUSTER_CL5: cluster-sleep-1 {
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



