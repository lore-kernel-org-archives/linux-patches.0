Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD0229A2;
	Tue, 30 Jul 2024 15:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354917; cv=none; b=mpoLqS7K29eMxxDFjxB8fGSO5KLyrmQU4wR/T+v/VJuzvUoM1AbIz4t8BgC03eh++vdEo0tXJEcEdazyC9KeRh/rmzWEu8eB8Q/f82ksWC5+Q9bDEUeYVBfwqjGwWL90/4aXWN+S3Sce3k9QM1p4xJDpkcg2BdyFjEevNXvc3lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354917; c=relaxed/simple;
	bh=nJ3yn5XugadMmhn2z5MJxx1HWS8eVPv9gnmxOM36KI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2o2AIBgdb7UtRfkmPfkoFHUVkREOip3SRzs2FpDZCaL785JlePYEmcnnDAk1oLTSZf/E+IWcUcWuvCsIN7EOkiWVpTItraq6OCOjyvLZOBA5RjwdkSJKlbeJlzvIbWPF8ZzcC5FIG2DaCiCvZVuvi7CtwR78xCHek5ArY5ITC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNaxW7s5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNaxW7s5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DB0C32782;
	Tue, 30 Jul 2024 15:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354917;
	bh=nJ3yn5XugadMmhn2z5MJxx1HWS8eVPv9gnmxOM36KI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNaxW7s5dfhXcSHEt7LgUorsMhqm6MgQvks6/Dxo4yKrqJlKsdZH6KU4PEg6iL35A
	 nWTPt5hYphG0DXeRgI3b6nphWBigKU0D5EjjbkXP9dipY6gRDjoZpnu/ku0Eh3YHKa
	 gqm2O/WEjDtVZq38Gzn2sbTTmXb55O3hw+35Khh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yassine Oudjana <y.oudjana@protonmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/440] arm64: dts: qcom: msm8996-xiaomi-common: drop excton from the USB PHY
Date: Tue, 30 Jul 2024 17:44:29 +0200
Message-ID: <20240730151617.174369088@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 77819186086ac..de320bebe4124 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996-xiaomi-common.dtsi
@@ -368,7 +368,6 @@ &usb3_dwc3 {
 
 &hsusb_phy1 {
 	status = "okay";
-	extcon = <&typec>;
 
 	vdda-pll-supply = <&vreg_l12a_1p8>;
 	vdda-phy-dpdm-supply = <&vreg_l24a_3p075>;
-- 
2.43.0



