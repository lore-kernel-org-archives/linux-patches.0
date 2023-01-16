Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DD16FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635A3C433EF;
	Mon, 16 Jan 2023 17:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888485;
	bh=9jOCHAgGAvv3LpWUEljtvSZQ21ynLmnXTWrjbqPf078=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MlNkioNAbWpr3bLhMHyhzlaoviAryERxdsk4UGSuZngCnNl9sljoYyXwAKsV25Wx
	 J444c1uDrn7/0PASA42MfIL65nk/RS+daWptQFg8faiP1rEarmOQ7Hu8kWUFQ7eo7r
	 +xoOWyYvqynt/XmRVgOIQjjm/tPFPa5q+j/3Q2AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca@z3ntu.xyz>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 024/338] ARM: dts: qcom: apq8064: fix coresight compatible
Date: Mon, 16 Jan 2023 16:48:17 +0100
Message-Id: <20230116154821.809526461@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit a42b1ee868361f1cb0492f1bdaefb43e0751e468 ]

There's a typo missing the arm, prefix of arm,coresight-etb10. Fix it to
make devicetree validation happier.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Fixes: 7a5c275fd821 ("ARM: dts: qcom: Add apq8064 CoreSight components")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221013190657.48499-3-luca@z3ntu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 459358b54ab4..dac14153c7bf 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1534,7 +1534,7 @@ wifi {
 		};
 
 		etb@1a01000 {
-			compatible = "coresight-etb10", "arm,primecell";
+			compatible = "arm,coresight-etb10", "arm,primecell";
 			reg = <0x1a01000 0x1000>;
 
 			clocks = <&rpmcc RPM_QDSS_CLK>;
-- 
2.35.1



