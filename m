Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3D111C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DC8C433C9;
	Thu, 24 Aug 2023 14:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692888957;
	bh=ZzBiflekas4Bej4e+CaUZeBjaFExoIDPx3862YsN6xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V0nWKXIX/mnAp6NPSRCTNZ+sumPfZ2GGjC8EuGAdtli6YNWvKfdqmdx6D7sad80p/
	 5KPNU/C07+L6wQgNRmv5xdRu/8oVHhHSwHGQojCLz5y92ypBXxmAZP2n8TJUqJ/EJL
	 0jIA1Ve8Bewhn9pgxJ3fseWC+VN/j0FpHWp8/gTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/139] arm64: dts: qcom: qrb5165-rb5: fix thermal zone conflict
Date: Thu, 24 Aug 2023 16:50:25 +0200
Message-ID: <20230824145027.998749885@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 798f1df86e5709b7b6aedf493cc04c7fedbf544a ]

The commit 3a786086c6f8 ("arm64: dts: qcom: Add missing "-thermal"
suffix for thermal zones") renamed the thermal zone in the pm8150l.dtsi
file to comply with the schema. However this resulted in a clash with
the RB5 board file, which already contained the pm8150l-thermal zone for
the on-board sensor. This resulted in the board file definition
overriding the thermal zone defined in the PMIC include file (and thus
the on-die PMIC temp alarm was not probing at all).

Rename the thermal zone in qcom/qrb5165-rb5.dts to remove this override.

Fixes: 3a786086c6f8 ("arm64: dts: qcom: Add missing "-thermal" suffix for thermal zones")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230613131224.666668-1-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index 0ce2d36ab257f..d3449cb52defe 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -113,7 +113,7 @@
 			};
 		};
 
-		pm8150l-thermal {
+		pm8150l-pcb-thermal {
 			polling-delay-passive = <0>;
 			polling-delay = <0>;
 			thermal-sensors = <&pm8150l_adc_tm 1>;
-- 
2.40.1



