Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94F0605A4;
	Tue, 23 Jan 2024 01:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974687; cv=none; b=ia1EgKMNl1kAKN5P1mh3m6j+sbIycQiq/4ORhVX6Naa8FzV/cLRI/YbsS/KEL/kiw9GJexwwADl1TQeO9kEW4wIN22lGXfMMV1t5728Y6SuwwuOAQrOp+7+5kPdOdhgJs2lqcEkuVeoDz+jMtkMG3KEv5bfXtSIMgh1p3vi2pns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974687; c=relaxed/simple;
	bh=iw+JglZIjjWzWzQzYscbA3q9hkVjwwUgG0JyuRf5Jck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2Jtp/D9JurVZGeWTGTFZ4wxSV9mAtyI/PFssoc2OK5sVh8b8xaQXrXCSrz6jWMA5iYiH5swffd2XXnGQeLxfUlgYXD7lebTUBBzrfsQ+v7T+z5em4j0wEBUguPNO2WkI1fzdVKh7uvuXYmmPL9Fm8MFabONy2wSTIBTYbS+OWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kE7HAAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kE7HAAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C65C43390;
	Tue, 23 Jan 2024 01:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974687;
	bh=iw+JglZIjjWzWzQzYscbA3q9hkVjwwUgG0JyuRf5Jck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kE7HAAazYShQPhEumtUVW/hhCn8ulh9nf/WGYOQHWOY3sAoaHx5cnHzy8yGBbisf
	 FCB4IP3HFKpl+WEP5uwut2V/hEITSqalhbjXLRWxPVJyXWMfCuIPJ4Rzsma659OjjA
	 eMlrLPkAVloPkKghRt1Z6b8gY0I8pADKP1MkOHIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/583] arm64: dts: qcom: qrb2210-rb1: Hook up USB3
Date: Mon, 22 Jan 2024 15:52:55 -0800
Message-ID: <20240122235815.934911509@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 59f9ff79cd9cf3bc10743d61662b5729fcffff24 ]

Configure the USB3 PHY to enable USB3 functionality

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230906-topic-rb1_features_sans_icc-v1-5-e92ce6fbde16@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: e0cee8dc6757 ("arm64: dts: qcom: qrb2210-rb1: use USB host mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb2210-rb1.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
index 0f7c59187896..52be19d55aed 100644
--- a/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
+++ b/arch/arm64/boot/dts/qcom/qrb2210-rb1.dts
@@ -366,6 +366,12 @@ &usb {
 	status = "okay";
 };
 
+&usb_qmpphy {
+	vdda-phy-supply = <&pm2250_l12>;
+	vdda-pll-supply = <&pm2250_l13>;
+	status = "okay";
+};
+
 &usb_hsphy {
 	vdd-supply = <&pm2250_l12>;
 	vdda-pll-supply = <&pm2250_l13>;
-- 
2.43.0



