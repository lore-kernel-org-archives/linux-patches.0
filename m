Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475DB11184
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBE2C433C8;
	Mon, 11 Sep 2023 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440950;
	bh=JLCvWy+VGpvn/geBsMqKmyO5Qt8E7LNK7NmiEB3Rgto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3ROGY1goc0OOvbVuS7B8WcSnLq7wWpQoCXhG+dyPxlGxhlfeWqDsPJP09Kn9J34U
	 bJ5qn9HXINCljlhAYqG2MB8o8Bm8D7YoJ4H0TX0Xjbr3f1+sEb46PYbs3xV010fkkS
	 MGr/KgqPZb0mR8LkMEvjTnXW07qHdl/aKalIIM9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 225/739] arm64: dts: qcom: msm8939: Add missing cache-unified to L2
Date: Mon, 11 Sep 2023 15:40:24 +0200
Message-ID: <20230911134657.463800675@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 68a59251f1c590ad567ff7fd799f6634fbab6e16 ]

Add the missing property to fix the dt checker warning:

qcom/apq8039-t2.dtb: l2-cache: 'cache-unified' is a required property

Fixes: 61550c6c156c ("arm64: dts: qcom: Add msm8939 SoC")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20230627-topic-more_bindings-v1-3-6b4b6cd081e5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8939.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8939.dtsi b/arch/arm64/boot/dts/qcom/msm8939.dtsi
index 8a856bd8e8e92..3d9270b5482b4 100644
--- a/arch/arm64/boot/dts/qcom/msm8939.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8939.dtsi
@@ -55,6 +55,7 @@ CPU0: cpu@100 {
 			L2_1: l2-cache {
 				compatible = "cache";
 				cache-level = <2>;
+				cache-unified;
 			};
 		};
 
@@ -111,6 +112,7 @@ CPU4: cpu@0 {
 			L2_0: l2-cache {
 				compatible = "cache";
 				cache-level = <2>;
+				cache-unified;
 			};
 		};
 
-- 
2.40.1



