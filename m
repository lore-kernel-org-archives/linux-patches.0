Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F69F33993;
	Wed,  5 Feb 2025 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767252; cv=none; b=aqm4w9FyC1zpWqU776rF44E+AvXOiFEq9td/DP63LWSOwjdI2yQ+JN3uaHCypR+CaxLHGyfKp3NtomM4bbA2Vr6PkTExjWDQSQKlm1LNy1e5IFpIDaDW1zDR7M/SBUlHbv1W6rVftoDiOZYNVDgtYPY0XWIa0F0+bIv/AJy7OSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767252; c=relaxed/simple;
	bh=S2oKUbDr8Rn2W4H62mCRbREoWbVe9M3KSb6znvApeQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVpZFm9bZUlsZKkRe8Xw3BMptQD+Een0NxjAIhApJ1EBmWwBV9adjFAApkYBVN89VpJVKFfzPLbYpGzpWL/sIwUhSz9pPqucOpGLKwZS/3FLJsmFseTDvZNr5xlFaU+Qo9NTgEUhdsXLP3uus0XxaGHUwC1AiF6OJiKvUVALA0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtgxBM1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtgxBM1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C57C4CED1;
	Wed,  5 Feb 2025 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767252;
	bh=S2oKUbDr8Rn2W4H62mCRbREoWbVe9M3KSb6znvApeQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtgxBM1+kYZY/Fzu8+HR6XlGr1rUvNuokkLqF1eTosEJs5lehE3qNXNVYcEGPf5PO
	 qVujCzu92NIQTRvDeeKubGxNZu5klAvrBPYpbGcXrZ0+lc4twNem18NEm2U27DBcW6
	 +hZwkBDZDzAeCxQr8Rhg0IHiElY+7qb6kP9BZGkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 378/623] arm64: dts: qcom: msm8994: correct sleep clock frequency
Date: Wed,  5 Feb 2025 14:42:00 +0100
Message-ID: <20250205134510.679486951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a4148d869d47d8c86da0291dd95d411a5ebe90c8 ]

The MSM8994 platform uses PM8994/6 to provide sleep clock. According to the
documentation, that clock has 32.7645 kHz frequency. Correct the sleep
clock definition.

Fixes: feeaf56ac78d ("arm64: dts: msm8994 SoC and Huawei Angler (Nexus 6P) support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241224-fix-board-clocks-v3-3-e9b08fbeadd3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 8c0b1e3a99a76..b5cbdd620bb9e 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -34,7 +34,7 @@
 		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
-			clock-frequency = <32768>;
+			clock-frequency = <32764>;
 			clock-output-names = "sleep_clk";
 		};
 	};
-- 
2.39.5



