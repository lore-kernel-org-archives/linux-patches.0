Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA851BA872;
	Tue, 30 Jul 2024 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355140; cv=none; b=JSVG7EyhqVbjeCsUmwYlLBoD9BeB3K2qImiszXCs57iMEyGe4P65UhIiBoef7JUY5Irjm1dF1qmJyPcFoU1q8gqahooWVDFcaikrE5OEdnF9sno4SE3HiCv800rZfasZI24X/U2gzFKzNegK16PiIGE8jVWI4OVTNbLtl4MYvzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355140; c=relaxed/simple;
	bh=QGa76LtPTI9F8RbubZawc0/qw4CqCiEq0aCNCXDTxfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTkHOg0zJSJtr76uC2OviiAjI2MokyOfiITcdnS9ruLo/OOAMTArdbAUaiB7yrdEIZXMfD1xDQUner2ufnIuWp65vXLefa9R927rplRGAWomini+5he94RD46zrkKfQMtSgZKdx6tGnIteS2jtve28Yy8UMKiYV3dKMAZ57kwHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8sbYkZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8sbYkZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DECEC32782;
	Tue, 30 Jul 2024 15:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355140;
	bh=QGa76LtPTI9F8RbubZawc0/qw4CqCiEq0aCNCXDTxfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8sbYkZK/8ZZrEQTJA13KjhWtF8GvqLG7cDRt+yiQKAr5J18tQ2OqTHcaQ02O5Gg5
	 CpE4/WLIPTwenYj4LXHJp9M6NkUMTIZ9I+WTZhnDcsHFe++UgPXJLmzELzEGXqcVpR
	 w6QqcRh7SGTdSwGGtSsdFYyLuieVxKG+SHxnySJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/568] arm64: dts: qcom: sdm845: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:42:18 +0200
Message-ID: <20240730151641.055312722@linuxfoundation.org>
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

[ Upstream commit fd39ae8b9bc10419b1e4b849cdbc6755a967ade1 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: cc16687fbd74 ("arm64: dts: qcom: sdm845: add UFS controller")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-6-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 5bf0d5af452af..9d9b378c07e14 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -2634,6 +2634,8 @@ ufs_mem_phy: phy@1d87000 {
 			clocks = <&gcc GCC_UFS_MEM_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 			status = "disabled";
-- 
2.43.0



