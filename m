Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0EB30567B;
	Sat, 12 Sep 2026 08:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200454; cv=none; b=JnJjaNle+6aVCdJwxOOUrpAFlHJbonhBV27pe0dXwDJG+nTEIeVHi2S5dhivyM3bJAM0BBPmAtdz6ZzNltNIkohUWNPxBG4t1j9QiDO3YQYSmeNaNkZ3fs7RnxTRQcMdpvbQ8BissuqP9k09tvfcNFw4pVsYBB94HPVmYd0XOm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200454; c=relaxed/simple;
	bh=+1tYBETKCcmdatBBnf0/M/28i7wvv5haoShrG/MbRqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akOw9chnul98o2LtfL8Ia6I1/seAknCyE+yc/NoeXtuY6T9v6picPFrhoTHBJbNVl7DZflTxxDB/6+jHwjmmqcVMA+EHyHG60XaUm4TGMqKNw/zEXtLsCzjyBMDhAQpNLhzLMSQjMzebxtZ/94eEOJG+Z6BrXghb8Isg4/B6A7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDreCtCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDreCtCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5581F000FF;
	Sat, 12 Sep 2026 08:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200453;
	bh=Wt3FbDWW2EWZaq/e/hT/AGEvzdQUR7FK46UUo4++Q3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDreCtCPC5QdsmMNYYdK88TDL8E7vSKDtngDBy+Xt/+5PF4owx7fsg4E0cHfQtAZN
	 6xEsFNUClpFBGRjgNvU4rmwB+O7ADS99EoKvoWPzp0QROw/VJrWOBOQc8huAz9S/iB
	 IjHf9U0BiijaWMKTr+Kd/lV2n8WxLvLX6lJoHolM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0793/1815] arm64: dts: qcom: glymur: Fix PDC IRQ mapping
Date: Sat, 12 Sep 2026 08:42:23 +0200
Message-ID: <20260912065707.526347669@linuxfoundation.org>
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

[ Upstream commit 1b0b6ddd0299efa29d18f68a2d7152ad67cb9576 ]

Some of the sub-ranges are inconsistent with HW docs. Fix them.
They are valid for both Glymur and Mahua.

Fixes: 41b6e8db400c ("arm64: dts: qcom: Introduce Glymur base dtsi")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260729-topic-glymur_pdc-v1-1-8747789e35aa@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 55a5055b138b9..16f5185474811 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -4836,9 +4836,13 @@ dispcc: clock-controller@af00000 {
 		pdc: interrupt-controller@b220000 {
 			compatible = "qcom,glymur-pdc", "qcom,pdc";
 			reg = <0x0 0x0b220000 0x0 0x10000>;
-			qcom,pdc-ranges = <0 745 51>,
-					  <51 527 47>,
-					  <98 609 32>,
+			qcom,pdc-ranges = <0 745 38>,
+					  <40 785 11>,
+					  <51 527 4>,
+					  <57 533 10>,
+					  <70 546 4>,
+					  <75 551 18>,
+					  <108 619 22>,
 					  <130 717 12>,
 					  <142 251 5>,
 					  <147 796 16>,
-- 
2.53.0



