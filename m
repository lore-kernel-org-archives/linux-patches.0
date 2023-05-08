Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36736168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641B0C433D2;
	Mon,  8 May 2023 11:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543847;
	bh=sMHOMVXv3z0knY48gwqxw6tf0kbIc9u4FSLgn/iSKvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVnrqF6PsexWmNZFsPGMgU7BV/ytiZHaGYza/umudIOErQypJ8Bo2gDy5Ska9yYYZ
	 3mRR9EwgQT4iEcsJwIP0TlqKLQAcG0Ihe0/51PepeC6JZNcQ6teBK766MhovLUgG7i
	 fwhCubXnaWucHJPZYInivaX7vsOY5qjagP3keg30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 221/694] arm64: dts: qcom: sm8350-microsoft-surface: fix USB dual-role mode property
Date: Mon,  8 May 2023 11:40:56 +0200
Message-Id: <20230508094439.527049472@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 0beda02e530f8fc571877939645cb20ade113027 ]

The "dr_mode" is a property of USB DWC3 node, not the Qualcomm wrapper
one:
  sm8350-microsoft-surface-duo2.dtb: usb@a6f8800: 'dr_mode' does not match any of the regexes: '^usb@[0-9a-f]+$', 'pinctrl-[0-9]+'

Fixes: c16160cfa565 ("arm64: dts: qcom: add minimal DTS for Microsoft Surface Duo 2")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230304130315.51595-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350-microsoft-surface-duo2.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8350-microsoft-surface-duo2.dts b/arch/arm64/boot/dts/qcom/sm8350-microsoft-surface-duo2.dts
index b536ae36ae6de..3bd5e57cbcdaa 100644
--- a/arch/arm64/boot/dts/qcom/sm8350-microsoft-surface-duo2.dts
+++ b/arch/arm64/boot/dts/qcom/sm8350-microsoft-surface-duo2.dts
@@ -341,6 +341,9 @@
 
 &usb_1 {
 	status = "okay";
+};
+
+&usb_1_dwc3 {
 	dr_mode = "peripheral";
 };
 
-- 
2.39.2



