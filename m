Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8201BF310;
	Tue, 30 Jul 2024 16:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355222; cv=none; b=RLPU1KC/vZTmuS9OeM+gFswNrnBD1+56cxTPUt7pOJTnExZmeN3a7qgPUDmvlXdAxjwSkHQqea+rG9N1NosBLNEr8/sIZXxKM0MhQBJHMgnYiLa8/3yUpa/h8R3ajkwWFRxK1UadpUKWEkCNy01FoC8N/ODnaknvN/RsflReOqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355222; c=relaxed/simple;
	bh=RPgdUzhDObRdCqkKGQVejwMMrq7gJoEQIf2wWuTFgAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6zLx4A1ZjT9PlJSU1PaQdXvBSIFsusfVT/ax1N3layKIN2UFpiuWXcQhY3gKNYVmPZKvGCqwFl82X87mml5T7hDS6dyYexaXFozY/CwnTXtQbiPy0hH1DQT3KCj+dDs8fybqELBDkKJPflAGTbnwMGoknyXiC9JijmamEW1dXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYccomoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYccomoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FB2C4AF0F;
	Tue, 30 Jul 2024 16:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355222;
	bh=RPgdUzhDObRdCqkKGQVejwMMrq7gJoEQIf2wWuTFgAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYccomocNh9UqoIz22gdac7M6bcIGP36XLmepQzTud+4+WYoG5v3jvqrrjK9GxKuR
	 x3UNLEtZPBIvkApPl81aXINcZ4YKlnYyN6GMxFAEcZDubdHQ/H4lY5KyrJpHqCrTTI
	 26I13i7TM+7E0fP56gklF9OWRwtEHfL+6R/K6Sis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/568] arm64: dts: qcom: msm8996-xiaomi-common: drop excton from the USB PHY
Date: Tue, 30 Jul 2024 17:42:25 +0200
Message-ID: <20240730151641.328380901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c1aefeae8cb7b71c1bb6d33b1bda7fc322094e16 ]

The USB PHYs don't use extcon connectors, drop the extcon property from
the hsusb_phy1 node.

Fixes: 46680fe9ba61 ("arm64: dts: qcom: msm8996: Add support for the Xiaomi MSM8996 platform")
Cc: Yassine Oudjana <y.oudjana@protonmail.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-13-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
index 06f8ff624181f..d5b35ff0175cd 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
@@ -405,7 +405,6 @@ &usb3_dwc3 {
 
 &hsusb_phy1 {
 	status = "okay";
-	extcon = <&typec>;
 
 	vdda-pll-supply = <&vreg_l12a_1p8>;
 	vdda-phy-dpdm-supply = <&vreg_l24a_3p075>;
-- 
2.43.0



