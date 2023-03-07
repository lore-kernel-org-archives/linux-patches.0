Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8B3BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C53C4339B;
	Tue,  7 Mar 2023 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208801;
	bh=Uz81I3n+VgOx1HimoofgZSz2rKXimD+4sz9smWt8tMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5e3xexF4QRaBwhfuUJF2x5GODhR0yTJTjWbyT6+zSZLvbQE0yEEyxMR4Gw3De8MD
	 SLcqmaQWbmRLdAEoOI9IKNvQYV9UJivz8C9NwZ9NJ3LeGW2xE9KyQUa5eNp6IduqdX
	 wZKCAOKtF6sv+272KfIYRifHsLVF36xYjOB5Vlfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Luca Weiss <luca@z3ntu.xyz>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0015/1001] arm64: dts: qcom: pmi8950: Correct rev_1250v channel label to mv
Date: Tue,  7 Mar 2023 17:46:27 +0100
Message-Id: <20230307170022.813827798@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 3c3d2cb221b8647d1c547b4c44d2d6060cc742a9 ]

This was pointed out in review but never followed up on thanks to
sidetracked discussions about labels vs node names.

Fixes: 0d97fdf380b4 ("arm64: dts: qcom: Add configuration for PMI8950 peripheral")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Luca Weiss <luca@z3ntu.xyz>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221209215437.1783067-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmi8950.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pmi8950.dtsi b/arch/arm64/boot/dts/qcom/pmi8950.dtsi
index 32d27e2187e38..8008f02434a9e 100644
--- a/arch/arm64/boot/dts/qcom/pmi8950.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmi8950.dtsi
@@ -47,7 +47,7 @@ adc-chan@9 {
 			adc-chan@a {
 				reg = <VADC_REF_1250MV>;
 				qcom,pre-scaling = <1 1>;
-				label = "ref_1250v";
+				label = "ref_1250mv";
 			};
 
 			adc-chan@d {
-- 
2.39.2



