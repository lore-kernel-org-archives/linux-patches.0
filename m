Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54261863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA60C433D2;
	Wed, 28 Dec 2022 15:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239967;
	bh=Qj/SXy18cHpH7QQcS78XbBcQoLPXunvN4/SVGVFz718=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yV1EYO3+MX/JpyERjCAg/fli/YjxCKVInkoCBpc2XkGEar8FNwz1URs8/lHUaDSGx
	 Wq83Wpz+LtnVMLMRxi8EIiMHPdUDEHRXRSV70chRXy4uQss4Omq+Ziry6u1IRzpf87
	 C93VZ0FfC6TGS2kBlGp+rWnDJ/Hw8FxXYfb0QVQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0033/1146] arm64: dts: qcom: sc7280: fix codec reset line polarity for CRD 3.0/3.1
Date: Wed, 28 Dec 2022 15:26:12 +0100
Message-Id: <20221228144331.067756792@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 1caf66104c02d327a2467a69ab18fb24b44e9715 ]

The driver for the codec, when resetting the chip, first drives the line
low, and then high. This means that the line is active low. Change the
annotation in the DTS accordingly.

Fixes: 0a3a56a93fd9 ("arm64: dts: qcom: sc7280: Add wcd9385 codec node for CRD 3.0/3.1")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221027074652.1044235-4-dmitry.torokhov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi b/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi
index 4b8c676b0bb1..f7665b379923 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-qcard.dtsi
@@ -37,7 +37,7 @@ wcd9385: audio-codec-1 {
 		pinctrl-0 = <&wcd_reset_n>, <&us_euro_hs_sel>;
 		pinctrl-1 = <&wcd_reset_n_sleep>, <&us_euro_hs_sel>;
 
-		reset-gpios = <&tlmm 83 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&tlmm 83 GPIO_ACTIVE_LOW>;
 		us-euro-gpios = <&tlmm 81 GPIO_ACTIVE_HIGH>;
 
 		qcom,rx-device = <&wcd_rx>;
-- 
2.35.1



