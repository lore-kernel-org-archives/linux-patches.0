Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDD611705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC1CC433CA;
	Mon, 11 Sep 2023 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443234;
	bh=wuH9gqXG54yiyTg5OxkfhMg55buDxy2QJA4JlGebBx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvN3beumpz3GxQm6LHAykSXqNIZ8EwM5x6Xz/FnS4GNruLvkmC6JwprEkL5yuiWh7
	 vSvixgkbj3mqjIsItrP9aLphSNIQkp61WpYvRWkRMTRirsX4+D+ciiLadPhrwUHKI5
	 eUWT0OIbz/CDCvRLLri7t0K2asYxcusdme4oZ1NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 298/737] arm64: dts: qcom: pmk8350: fix ADC-TM compatible string
Date: Mon, 11 Sep 2023 15:42:37 +0200
Message-ID: <20230911134658.879797248@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 435a73d7377ceb29c1a22d2711dd85c831b40c45 ]

The commit b2de43136058 ("arm64: dts: qcom: pmk8350: Add peripherals for
pmk8350") for the ADC TM (thermal monitoring device) have used the
compatible string from the vendor kernel ("qcom,adc-tm7"). Use the
proper compatible string that is defined in the upstream kernel
("qcom,spmi-adc-tm5-gen2").

Fixes: b2de43136058 ("arm64: dts: qcom: pmk8350: Add peripherals for pmk8350")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230707123027.1510723-6-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmk8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pmk8350.dtsi b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
index f26fb7d32faf2..767ab7f284608 100644
--- a/arch/arm64/boot/dts/qcom/pmk8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
@@ -49,7 +49,7 @@ pmk8350_vadc: adc@3100 {
 		};
 
 		pmk8350_adc_tm: adc-tm@3400 {
-			compatible = "qcom,adc-tm7";
+			compatible = "qcom,spmi-adc-tm5-gen2";
 			reg = <0x3400>;
 			interrupts = <PMK8350_SID 0x34 0x0 IRQ_TYPE_EDGE_RISING>;
 			#address-cells = <1>;
-- 
2.40.1



