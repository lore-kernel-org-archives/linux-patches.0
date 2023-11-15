Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565193EA7B
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDzbCkCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022FCC433C7;
	Wed, 15 Nov 2023 19:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076406;
	bh=behyjWGst69K6PMh5KRjzZntfVjKFk8/A5LnANTkgUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDzbCkCwVg1Qs2rSTFRPOnl5VZ6rjb3zvax9g11aEfHCJXH4ps3KQdFwb6zQ/Sw7O
	 dhOIsSZUFhuW22LAr9lmT5aXEWavrcnL2m94CflgZz642U3+WRoAiDHh5vdhXw+pKk
	 eMppsy4b+UBOIMAVTSfu4znFG1v7jMS5lbKTJHW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 271/550] arm64: dts: qcom: sm8350: fix pinctrl for UART18
Date: Wed, 15 Nov 2023 14:14:15 -0500
Message-ID: <20231115191619.527068220@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c1efa960114f743924b884da098298512a7e9983 ]

On sm8350 QUP18 uses GPIO 68/69, not 58/59. Fix correponding UART18
pinconf configuraion.

Fixes: 98374e6925b8 ("arm64: dts: qcom: sm8350: Set up WRAP2 QUPs")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230825214550.1650938-1-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index c236967725c1b..df0a4cc9c4358 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -2939,7 +2939,7 @@ qup_uart6_default: qup-uart6-default-state {
 			};
 
 			qup_uart18_default: qup-uart18-default-state {
-				pins = "gpio58", "gpio59";
+				pins = "gpio68", "gpio69";
 				function = "qup18";
 				drive-strength = <2>;
 				bias-disable;
-- 
2.42.0



