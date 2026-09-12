Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BD5431A3E;
	Sat, 12 Sep 2026 10:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209754; cv=none; b=Lw5HWhA5nEITLCwaOqk9Huqw7mzknKPViL/Knapb9wtB8Mg8L2YFaYdVKQjHiGyXR1eEWpZSnFbi5XvjQs5OU4wvrUcmLvlVJtt7iBi8UrVfO8O0EhsuxVsARCf7L1HZZar0THiI7JAqvbTK9SspvoQ8IBdJew27wX1IucLqpOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209754; c=relaxed/simple;
	bh=vogsBKy41vwOWa8WCX3vJ/Q7+u0lcw6608mSeNTWcY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpIj0es0gzCKANmblO+qUhfww4wVPD/hpTxKf0sB1mbNoScOpBMVvJawiq3x8jM8N8NCZFl7iNbVckGmC1VsoPzxewNKWKGf0AVFsrVNoMlVWhO54Mosx9I9u198ws4P1ym4Otr265GiI73ftn0cqtv0XeHqk4svc7g8pq8khoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N4bnL9Js; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N4bnL9Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AE81F000FF;
	Sat, 12 Sep 2026 10:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209749;
	bh=N+SENCBThDgzvbOhaiB1FXHuoDhMoowtOyxVxTobYok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4bnL9JsnMqWEt9iFn/bc/NiYrqpDCekD/41Bh1pi8FEshpu4rhnuvSd21RPvmrEK
	 FFqqo/eo/Wuo8AY+OVQh4kTDkiqcajokTg5OAUBbt+fcQMve5oCRMqaZjEpqXn52Gk
	 HQu1C5q4LeiM/+71TuxylvRM2FSR8zwCVsSsOA2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0886/1518] arm64: dts: qcom: sm7225-fairphone-fp4: Fix swapped USB QMP PHY vdda-phy/vdda-pll supplies
Date: Sat, 12 Sep 2026 08:50:55 +0200
Message-ID: <20260912065643.492412308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit a3b3a060b696d964c769a7d9dc5835c79e4fe964 ]

The QMP PHY expects the vdda-phy supply to be around 0.88V and the
vdda-pll supply to be 1.2V. But these two supplies are swapped for the
USB QMP PHY on this board, feeding 1.2V to vdda-phy and 0.9V to
vdda-pll.

Fix it by swapping the two supplies back.

Fixes: 4cbea668767d ("arm64: dts: qcom: sm7225: Add device tree for Fairphone 4")
Reported-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Assisted-by: Claude:opus-4-8
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://lore.kernel.org/r/20260803-phy-supply-fix-v1-14-5880630cde3e@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
index b353de2bc37ad..b6d2a5d0c1c88 100644
--- a/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
+++ b/arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dts
@@ -1179,8 +1179,8 @@ &usb_1_hsphy {
 };
 
 &usb_1_qmpphy {
-	vdda-phy-supply = <&vreg_l22a>;
-	vdda-pll-supply = <&vreg_l16a>;
+	vdda-phy-supply = <&vreg_l16a>;
+	vdda-pll-supply = <&vreg_l22a>;
 
 	status = "okay";
 };
-- 
2.53.0



