Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0608F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50382C433C7;
	Sun, 16 Jul 2023 20:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538163;
	bh=gBAMXFNtSDTLu7Nx0mgqqEqsKI3OGpzqdzIOym259SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0a/RbMFK8MjLVIn1qnRuH7B4gBGDk5lpv+sKzuD6nZklWxwRrDOX4LJ/Ga4HUH7o
	 A15lU6UV1wZCfokP9RTyS+1k+rP5F0RwKl+KV4RExjmqj4ZD8Cw9GWNyUmYCbQ2LNA
	 /Lgkyd29WtnOAg+moFjFwrtJqvPLmkCCavl3t5WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 309/800] arm64: dts: qcom: sdm630: correct camss unit address
Date: Sun, 16 Jul 2023 21:42:42 +0200
Message-ID: <20230716194956.252884254@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit c8b7faa7e9913a94444b3f00b6480e53a174fcfd ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc/camss@ca00000: simple-bus unit address format error, expected "ca00020"

Fixes: f3d5d3cc6971 ("arm64: dts: qcom: sdm630: Configure the camera subsystem")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-10-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm630.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index eaead2f7beb4e..ab04903fa3ff3 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -1894,7 +1894,7 @@ pil-reloc@94c {
 			};
 		};
 
-		camss: camss@ca00000 {
+		camss: camss@ca00020 {
 			compatible = "qcom,sdm660-camss";
 			reg = <0x0ca00020 0x10>,
 			      <0x0ca30000 0x100>,
-- 
2.39.2



