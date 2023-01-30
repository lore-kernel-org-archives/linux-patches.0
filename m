Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A46628EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB300C433D2;
	Mon, 30 Jan 2023 14:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087845;
	bh=bPQMSUTSi+96YJC2XZ18re+xFXTnyslxzy9DY6Lu9KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0zLDA0lPc3sRNQQMpA+k6TVUhBLGHLUraKe0UpXBKaJ5qxFGVFEL94WtFVWGQ9oP
	 5BzGy3sbSNSAFraHmF2Y1ff/85HujVXBHGcRoPOkqV3ZXTycLICiRb+3NZLvcXwxiY
	 ktoCY1gXfYQhbt1Rq+f0/cs+g+xfNFQYczyiLmLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugene Lepshy <fekz115@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 028/204] arm64: dts: qcom: msm8992: Dont use sfpb mutex
Date: Mon, 30 Jan 2023 14:49:53 +0100
Message-Id: <20230130134317.555787849@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 2bd5ab93335bf2c4d22c8db427822ae637ed8dc3 ]

MSM8992 uses the same mutex hardware as MSM8994. This was wrong
from the start, but never presented as an issue until the sfpb
compatible was given different driver data.

Fixes: 6a6d1978f9c0 ("arm64: dts: msm8992 SoC and LG Bullhead (Nexus 5X) support")
Reported-by: Eugene Lepshy <fekz115@gmail.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221219131918.446587-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992.dtsi | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992.dtsi b/arch/arm64/boot/dts/qcom/msm8992.dtsi
index 58fe58cc7703..765e1f1989b5 100644
--- a/arch/arm64/boot/dts/qcom/msm8992.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992.dtsi
@@ -14,10 +14,6 @@ &rpmcc {
 	compatible = "qcom,rpmcc-msm8992";
 };
 
-&tcsr_mutex {
-	compatible = "qcom,sfpb-mutex";
-};
-
 &timer {
 	interrupts = <GIC_PPI 2 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
 			     <GIC_PPI 3 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>,
-- 
2.39.0



