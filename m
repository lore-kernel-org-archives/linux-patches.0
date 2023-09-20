Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1795F18654
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927ADC433C9;
	Wed, 20 Sep 2023 11:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210504;
	bh=Em8M8dtlGT90bHOmCi7jO6WJhfTpFqdsa5WfSLVSBm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HfwiWrZuhjfXGZ1U73rrXScss76APBHr6hiZVPyJZAzZW1KStw4FVuyjkqX2/qWs
	 Pti6gHt4mg0EF6p+bviLwtbArgjPPA6PdIdGMmcAQ9vNGdyoZjQwKwVrabSI/hP3mO
	 NiNWD7aozs7zvYtneen/schgN3X5HyTp7OsrVLGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 069/211] arm64: dts: qcom: sm6350: correct ramoops pmsg-size
Date: Wed, 20 Sep 2023 13:28:33 +0200
Message-ID: <20230920112847.912546477@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c86b97a72065e06eacb993dc71fa9febc93422af ]

There is no 'msg-size' property in ramoops, so assume intention was for
'pmsg-size':

  sm6350-sony-xperia-lena-pdx213.dtb: ramoops@ffc00000: Unevaluated properties are not allowed ('msg-size' was unexpected)

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230618114442.140185-5-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 7cafb32fbb941..4b4ea156a92c5 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -673,7 +673,7 @@ ramoops: ramoops@ffc00000 {
 			reg = <0 0xffc00000 0 0x100000>;
 			record-size = <0x1000>;
 			console-size = <0x40000>;
-			msg-size = <0x20000 0x20000>;
+			pmsg-size = <0x20000>;
 			ecc-size = <16>;
 			no-map;
 		};
-- 
2.40.1



