Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDF82836D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMUzIQ8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D142CC433C8;
	Wed, 15 Nov 2023 19:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078228;
	bh=7M8blOyujgf4APoqQq6GAz2LfpzypWzfjjWqgYDy7uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMUzIQ8cNKJZy955HxI4IqPM0H6RRIyaCNZ5L0kopVyzLu8ubtTKTDL2STUpIcXfR
	 5+qRCxSQccKrljWuGuvKa6MWj4LXIQ329X43EjQIJyXtYi+MV/MBey/KYm0aU7L98i
	 n3YhNYrFQpwl7d9eWQWm6q0Q1lpShjy+Rmj0fsYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/379] arm64: dts: qcom: sm8350: fix pinctrl for UART18
Date: Wed, 15 Nov 2023 14:24:01 -0500
Message-ID: <20231115192654.933603204@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b3245b13b2611..793768a2c9e1e 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1778,7 +1778,7 @@ qup_uart6_default: qup-uart6-default-state {
 			};
 
 			qup_uart18_default: qup-uart18-default-state {
-				pins = "gpio58", "gpio59";
+				pins = "gpio68", "gpio69";
 				function = "qup18";
 				drive-strength = <2>;
 				bias-disable;
-- 
2.42.0



