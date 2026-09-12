Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267601EB5FD;
	Sat, 12 Sep 2026 07:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197858; cv=none; b=nsubRCE7peWPH3QwWiwqYH1/RKOEVGx5x5VZBX2rxy5Svpqcga7yOb1BH4oTNSyihR4KihqD3xirpUfLeU7CLw6A7a8rmHPOvDU6K76UklHY1WmkovE9gQNUjyngekD2NbIqEPfsEvnRZd63RU0w2IdTKkqB+UT5JI3pF2vTzBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197858; c=relaxed/simple;
	bh=bwQ/6QaHRR6fjIAJdL3XRUkyU8gh7FMSykj5TfDmPgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZjeiapAZm2pXrOmnjZwn8cTyhkMXNo3nKVsevxIJUl2GiIirIq552bBkVCBFJ2XFlTpw5MxKNXcg8qInPPdAxlzcJekXekjySCYsoTIJ/20XINO7uLqFFupTb0KfVFDPCPO/rpOevDpCeTQtmaDcJ+QyjoTI5oXUudgOnACsJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgOw4X9w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgOw4X9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00671F000FF;
	Sat, 12 Sep 2026 07:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197856;
	bh=+/PYRn8ouVGTv8llX/YR1mgPpZ0V2Eb1IvzNFq7/WhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xgOw4X9wtXGqQWqRBjYvpVQTECPliO11BOrLAZ4mBi7OswDFlCr1VK2R2k80NdXuJ
	 t7AiqnWsFiegt0azqGpDBcHPVXiw+41thQYSrmYbMUGJF7Yy+BRHIiimTLUeBNN2GA
	 Y9ILIzFkbZX1v9RbyHBUBSR0+IGu5kVa/4oCNnk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0260/1815] arm64: dts: qcom: sc8180x-primus: Rename regulator nodes
Date: Sat, 12 Sep 2026 08:33:30 +0200
Message-ID: <20260912065655.081497862@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit ae51d9396f9318189e91578878409d8ada152edb ]

The nodes would be sorted correctly, if their names started with
"regulator-" (which is the style used in the latest submissions).
Touch that up.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260616-topic-8180_disp_power-v2-1-167785993231@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 80bf2eb87bfb ("arm64: dts: qcom: sc8180x-primus: Describe the display power net")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8180x-primus.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
index aff398390eba7..ffe7c45366ed4 100644
--- a/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
+++ b/arch/arm64/boot/dts/qcom/sc8180x-primus.dts
@@ -167,7 +167,7 @@ reserved-region@9a500000 {
 		};
 	};
 
-	vreg_nvme_0p9: nvme-0p9-regulator {
+	vreg_nvme_0p9: regulator-nvme-0p9 {
 		compatible = "regulator-fixed";
 		regulator-name = "vreg_nvme_0p9";
 
@@ -177,7 +177,7 @@ vreg_nvme_0p9: nvme-0p9-regulator {
 		regulator-always-on;
 	};
 
-	vreg_nvme_3p3: nvme-3p3-regulator {
+	vreg_nvme_3p3: regulator-nvme-3p3 {
 		compatible = "regulator-fixed";
 		regulator-name = "vreg_nvme_3p3";
 
@@ -190,7 +190,7 @@ vreg_nvme_3p3: nvme-3p3-regulator {
 		regulator-always-on;
 	};
 
-	vdd_kb_tp_3v3: vdd-kb-tp-3v3-regulator {
+	vdd_kb_tp_3v3: regulator-vdd-kb-tp-3v3 {
 		compatible = "regulator-fixed";
 		regulator-name = "vdd_kb_tp_3v3";
 		regulator-min-microvolt = <3300000>;
@@ -205,7 +205,7 @@ vdd_kb_tp_3v3: vdd-kb-tp-3v3-regulator {
 		pinctrl-0 = <&kb_tp_3v3_en_active_state>;
 	};
 
-	vph_pwr: vph-pwr-regulator {
+	vph_pwr: regulator-vph-pwr {
 		compatible = "regulator-fixed";
 		regulator-name = "vph_pwr";
 		regulator-min-microvolt = <3700000>;
-- 
2.53.0



