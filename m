Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1CF13FD97;
	Thu, 11 Apr 2024 10:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832233; cv=none; b=Dgj48iy6VBNYMSG1/PMvQ5bPJn8w6uHeAMtWErkzrRJ3E1MtP5yg2/jeMcH2Iwg8+/eUx1z30WqJx80/TRz573S+ZBjNKEhxsrYTGltsnKxs2H9iXgAmDH5hGXBaB5jctGfNnEqavKiyZ02mNg90YPX9wmZDdR4LouiFDnH/f50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832233; c=relaxed/simple;
	bh=Y4akQcT6rUQeOfITtbhC6VV/yQsk/7claS7f+TXAL1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFbtAE521dErP5Y0Z8dmTizVLAKFSXp9DKwkt5srQFSijfiNEFQenazmk7VJZW5t4UqENCzfMyRKMOH4uz6yUd9KcS5Jwj7DHhql+2vCWCfvA63RHLAnnwg0NCZ/I15rDOfDs5gvE5qVJWl9lTTmkr4DqpzsK11HPd9vkKavjjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klLrWDeX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klLrWDeX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E502AC433C7;
	Thu, 11 Apr 2024 10:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832233;
	bh=Y4akQcT6rUQeOfITtbhC6VV/yQsk/7claS7f+TXAL1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klLrWDeXMbP/wT74kBYizoD40uSbWAe0vqgt2bA+Ga/i4oWerLXKJHCkxrY0PtV8d
	 5V7mlzEhWnwStwcTpo+b8DNYF09dERNwywE3NqVIOgjHnaAWVtRdm6E+08krL05TvK
	 05qijgjZPswtgNJZXNGz3mQy8SuE5CsWgyuRx0cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Kaehlcke <mka@chromium.org>,
	Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/294] arm64: dts: qcom: sc7180: Remove clock for bluetooth on Trogdor
Date: Thu, 11 Apr 2024 11:56:29 +0200
Message-ID: <20240411095442.392387235@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>

[ Upstream commit a307a9773420dc7d385991f61fbede2fe100bd78 ]

Removed voting for RPMH_RF_CLK2 which is not required as it is
getting managed by BT SoC through SW_CTRL line.

Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Venkata Lakshmi Narayana Gubba <gubbaven@codeaurora.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210301133318.v2.8.I80c268f163e6d49a70af1238be442b5de400c579@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Stable-dep-of: e12e28009e58 ("arm64: dts: qcom: sc7180-trogdor: mark bluetooth address as broken")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index cb2c47f13a8a4..3f5883e8bf319 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -810,7 +810,6 @@ ap_spi_fp: &spi10 {
 		vddrf-supply = <&pp1300_l2c>;
 		vddch0-supply = <&pp3300_l10c>;
 		max-speed = <3200000>;
-		clocks = <&rpmhcc RPMH_RF_CLK2>;
 	};
 };
 
-- 
2.43.0



