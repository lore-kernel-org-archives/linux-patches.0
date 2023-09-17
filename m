Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD766AAC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF17C433CA;
	Sun, 17 Sep 2023 20:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982081;
	bh=BgEHvlesz56ydWSOTi1krYckfQvbgUnTKy59oHWUmiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFZpiiCcAQOtqnjKvIOmMuzBmvMMpW5DXzstpcYIC8sEFRcxpQjpTt2baXTecfW8b
	 Lv2/lNg9m8NZopuVj6Dl02JR+q6RsIEMyc+UXFT/vGG3LOFeEkf7cZrfGCryGtgZhf
	 +I0ASe/kbfrTCYuWqR7VvMlY6wIxSyN/3NDA08wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/511] arm64: dts: qcom: Move WLED num-strings from pmi8994 to sony-xperia-tone
Date: Sun, 17 Sep 2023 21:09:35 +0200
Message-ID: <20230917191117.429040198@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 360f20c801f7ea2ddc9afcbc5ab74cebf8adea6b ]

The number of WLED strings used by a certain platform depend on the
panel connected to that board and may not be the same for every user of
pmi8994.

Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-By: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211007213400.258371-13-marijn.suijten@somainline.org
Stable-dep-of: 8db944326903 ("arm64: dts: qcom: pmi8994: Add missing OVP interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi | 1 +
 arch/arm64/boot/dts/qcom/pmi8994.dtsi                  | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi b/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
index 7802abac39fa5..e85f7cf4a56ce 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
@@ -620,6 +620,7 @@ pmi8994_s11: s11 {
 &pmi8994_wled {
 	status = "okay";
 	default-brightness = <512>;
+	qcom,num-strings = <3>;
 };
 
 &rpm_requests {
diff --git a/arch/arm64/boot/dts/qcom/pmi8994.dtsi b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
index 166467b637527..81899fe17f2b2 100644
--- a/arch/arm64/boot/dts/qcom/pmi8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
@@ -38,7 +38,6 @@ pmi8994_wled: wled@d800 {
 			reg = <0xd800>, <0xd900>;
 			interrupts = <3 0xd8 0x02 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "short";
-			qcom,num-strings = <3>;
 			qcom,cabc;
 			qcom,external-pfet;
 			status = "disabled";
-- 
2.40.1



