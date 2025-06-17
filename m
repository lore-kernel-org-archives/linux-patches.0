Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD9618E025;
	Tue, 17 Jun 2025 16:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176338; cv=none; b=PZwlyMBqsnGzvErF2rCm9U963JGv7B2Q5fTs6aPrglCVSwX7AGaepzF+FYG7tqRbSAIZSVbWHuVn9Hq36CT2pi0xZr51i3Nwh9ERaxeN0q2IGjSQYTR/AOj08QLFnzq8S0E8bsdIgdzU4qeINVd2HcjgjQLvgRT+OQKwXt+LkdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176338; c=relaxed/simple;
	bh=VCM5Zhu3EFcY+ujqj5iSyVFpukuLky64y3nmbzi39iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZbmsuASWlOKM2cpC1BS9z6meuO1cZRjQ9/BTsvUO0vY8ZKWb508MWGpkn6lG/Lp/MGqqJHL0fkbgnaiichlcK7iwJmuy2rRL1dnHj3ldBDUy54JGNjoyEnNeik64MR3kSKu0b/dleXs5V0VyCj544JgAUacHHKQSDklj+P/1Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBMY8tyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBMY8tyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42665C4CEE3;
	Tue, 17 Jun 2025 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176337;
	bh=VCM5Zhu3EFcY+ujqj5iSyVFpukuLky64y3nmbzi39iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBMY8tyOEZfYnkMBDmjoVOioMITDnN5CKkw9EuZd9iWQHzH413IPHI0Bhpgnq085z
	 F/kc7G+GbA0VF6u9n4xxcy/45lEc8yefoB16iHmXGxjNw43LDG5K7J2wibpFbAsOJ0
	 hvL5hCjpH4R84l7vfR55U+987waGvPYoHhBkhZKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/512] arm64: dts: qcom: sm8650: add missing cpu-cfg interconnect path in the mdss node
Date: Tue, 17 Jun 2025 17:23:06 +0200
Message-ID: <20250617152428.542747015@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit f22be5c1dd3e12519e3f3b80c14d10b90be2c2fc ]

The bindings requires the mdp0-mem and the cpu-cfg interconnect path,
add the missing cpu-cfg path to fix the dtbs check error and also to ensure
that MDSS has enough bandwidth to let HLOS write config registers.

Fixes: 9fa33cbca3d2 ("arm64: dts: qcom: sm8650: correct MDSS interconnects")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250227-topic-sm8x50-mdss-interconnect-bindings-fix-v5-2-bf6233c6ebe5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 0c54a89bb3322..edde21972f5ac 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -3605,8 +3605,11 @@
 			resets = <&dispcc DISP_CC_MDSS_CORE_BCR>;
 
 			interconnects = <&mmss_noc MASTER_MDP QCOM_ICC_TAG_ALWAYS
-					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
-			interconnect-names = "mdp0-mem";
+					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
+					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ACTIVE_ONLY
+					 &config_noc SLAVE_DISPLAY_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
+			interconnect-names = "mdp0-mem",
+					     "cpu-cfg";
 
 			power-domains = <&dispcc MDSS_GDSC>;
 
-- 
2.39.5



