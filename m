Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5662F522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EECC433C8;
	Sun,  9 Jul 2023 11:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902007;
	bh=ci//J/Ve9sVdubqsT3tIz9zgtUk7x+IqC97JJg2k8dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anTP/kpX+tHF2xhOu+1jaVux2yqty23tvxfLi8UpHR/YY6GdXYi67zvXzZYWAxK1t
	 0ikIjBKShSTyjayfRhNRKi2S5P0DxkJ4WkGZq1OJIwd/dde9a+4UkE/sBB02G3UJ6n
	 lR6xNBjkKgEZ9wvBfmk6afwp/B8Gl15K/rAxLwTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 223/431] arm64: dts: qcom: pm8998: dont use GIC_SPI for SPMI interrupts
Date: Sun,  9 Jul 2023 13:12:51 +0200
Message-ID: <20230709111456.389267101@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit d9ef7a805a709a0b07341857d97a25598a7f92da ]

Unlike typical GIC interrupts, first cell for SPMI interrupts is the
USID rather than GIC_SPI/GIC_PPI/GIC_LPI qualifier. Fix the resin
interrupt to use USID value 0x0 rather than GIC_SPI define.

Fixes: f86ae6f23a9e ("arm64: dts: qcom: sagit: add initial device tree for sagit")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230409182145.122895-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm8998.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pm8998.dtsi b/arch/arm64/boot/dts/qcom/pm8998.dtsi
index adbba9f4089ab..13925ac44669d 100644
--- a/arch/arm64/boot/dts/qcom/pm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8998.dtsi
@@ -55,7 +55,7 @@ pm8998_pwrkey: pwrkey {
 
 			pm8998_resin: resin {
 				compatible = "qcom,pm8941-resin";
-				interrupts = <GIC_SPI 0x8 1 IRQ_TYPE_EDGE_BOTH>;
+				interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
 				debounce = <15625>;
 				bias-pull-up;
 				status = "disabled";
-- 
2.39.2



