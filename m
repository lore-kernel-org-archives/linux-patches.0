Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE280BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0A6C433D2;
	Tue,  7 Mar 2023 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214827;
	bh=jJA8kcX1J7/AUsBOuJWfRU4injPoIr+3+5p/Iku2siA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15eZVFPn7MqEnlgK+e8CSuJ8KzM5AzhYp15DK66U/D8w4T7oTLWMntXwBB+bEsvMT
	 IDEJGGX6PiZTLpc1+O0ucCgsj5SsQvJrx/inQFRWKTBHzZZpvOjAUj93iBX397fbpv
	 ZsVe/lh2iOWM6FVPwuPZSIb211QKUj8+rPVbBxxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/567] arm64: dts: qcom: pmk8350: Specify PBS register for PON
Date: Tue,  7 Mar 2023 17:56:39 +0100
Message-Id: <20230307165908.620079839@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

[ Upstream commit f46ef374e0dcb8fd2f272a376cf0dcdab7e52fc2 ]

PMK8350 is the first PMIC to require both HLOS and PBS registers for
PON to function properly (at least in theory, sm8350 sees no change).
The support for it on the driver side has been added long ago,
but it has never been wired up. Do so.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221115132626.7465-1-konrad.dybcio@linaro.org
Stable-dep-of: c0ee8e0ba5cc ("arm64: dts: qcom: pmk8350: Use the correct PON compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmk8350.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pmk8350.dtsi b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
index 04fc2632a0b20..530adc87a4096 100644
--- a/arch/arm64/boot/dts/qcom/pmk8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
@@ -17,7 +17,8 @@ pmk8350: pmic@0 {
 
 		pmk8350_pon: pon@1300 {
 			compatible = "qcom,pm8998-pon";
-			reg = <0x1300>;
+			reg = <0x1300>, <0x800>;
+			reg-names = "hlos", "pbs";
 
 			pwrkey {
 				compatible = "qcom,pmk8350-pwrkey";
-- 
2.39.2



