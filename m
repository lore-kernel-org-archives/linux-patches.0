Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1981EBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:06:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F6EC433D2;
	Tue,  7 Mar 2023 17:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208794;
	bh=FAg6p3sOAYzpf1ftDCljxWFI7Iab7Fg+sKie9UC7+N0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiVupBcji6o7jxyWcMQh+nBceHrTgnqA2DAA8x70JpWUi7DPfEBl4AJs6QDfIhX+K
	 ggj4hnDx1h+jnyfM6r3Ttem6P0XHXQNxJsBVLCbdWobclwB6OmOLSWLIMCI/TH23H8
	 tKxj00L30HTQM2ldRob8OXALjuldprCcUUZ915Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0013/1001] arm64: dts: qcom: sm6115: Provide xo clk to rpmcc
Date: Tue,  7 Mar 2023 17:46:25 +0100
Message-Id: <20230307170022.720733541@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit ad9514be8ddb9d3a8c262aa415c2f1c1f4cc97f9 ]

rpmcc used to rely on global clock lookup (and still does so for
backwards compat reasons) of "xo_board", which was common back
when we did not care about things like underscores in node names.
Nowadays it expects to be fed a reference to the fixed clock.
Satisfy that requirement to make sure rpm clock rates are not all
stuck at zero.

Fixes: 97e563bf5ba1 ("arm64: dts: qcom: sm6115: Add basic soc dtsi")
Reported-by: Adam Skladowski <a39.skl@gmail.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221208201401.530555-2-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index 3f4017bc667d6..81523ab7ff602 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -296,6 +296,8 @@ rpm_requests: rpm-requests {
 
 			rpmcc: clock-controller {
 				compatible = "qcom,rpmcc-sm6115", "qcom,rpmcc";
+				clocks = <&xo_board>;
+				clock-names = "xo";
 				#clock-cells = <1>;
 			};
 
-- 
2.39.2



