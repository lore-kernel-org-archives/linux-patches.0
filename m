Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C81B1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAECC433C7;
	Mon, 11 Sep 2023 14:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441000;
	bh=NtqGWMpr9T63u0GnTPX3CYuEuIXrk9c7NcAQ2JDf9CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQpjjtzBNMrJO6qkXVierk5L5jlBfjjlvr9KU+q6LxHAdG4vQ6r+Zkb5kPLEi3YUJ
	 mVXbwLYbn4CYS22ql9b6X0toC9VB4JZeMkcG2zQ9JoTzykcSSQAalH8uQWUpgp4jL6
	 6C7CEe/GTOGB7LHpFuiIHaY3SGE1PfrMQkpSGU38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Luca Weiss <luca@z3ntu.xyz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 253/739] arm64: dts: qcom: pm6150l: Add missing short interrupt
Date: Mon, 11 Sep 2023 15:40:52 +0200
Message-ID: <20230911134658.221138489@linuxfoundation.org>
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

[ Upstream commit 7e1f024ef0d1da456f61d00f01dc3287ede915b3 ]

Add the missing short interrupt. This fixes the schema warning:

wled@d800: interrupt-names: ['ovp'] is too short

Fixes: fe508ced49dd ("arm64: dts: qcom: pm6150l: Add wled node")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Luca Weiss <luca@z3ntu.xyz>
Link: https://lore.kernel.org/r/20230626-topic-bindingsfixups-v1-3-254ae8642e69@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm6150l.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/pm6150l.dtsi b/arch/arm64/boot/dts/qcom/pm6150l.dtsi
index 6f7aa67501e27..0fdf440596c01 100644
--- a/arch/arm64/boot/dts/qcom/pm6150l.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm6150l.dtsi
@@ -121,8 +121,9 @@ pm6150l_flash: led-controller@d300 {
 		pm6150l_wled: leds@d800 {
 			compatible = "qcom,pm6150l-wled";
 			reg = <0xd800>, <0xd900>;
-			interrupts = <0x5 0xd8 0x1 IRQ_TYPE_EDGE_RISING>;
-			interrupt-names = "ovp";
+			interrupts = <0x5 0xd8 0x1 IRQ_TYPE_EDGE_RISING>,
+				     <0x5 0xd8 0x2 IRQ_TYPE_EDGE_RISING>;
+			interrupt-names = "ovp", "short";
 			label = "backlight";
 
 			status = "disabled";
-- 
2.40.1



