Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2817619F467;
	Tue, 30 Jul 2024 15:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355160; cv=none; b=OG9qxB5JfhaJNLucokC7sMO6UzRJ9z1no5rbX7FOb3Tk2B430eAriJqZ7Th2b+8LPWHMDb09OGZRhW+n0SzoZ3LzjxaNGAv1HatGwMEVwu0IhhqF5mmZko5Ret6C4rnuHHdq9mDBKkhQGZJ+JK1f/fuzTyrd31LMs1kRLtODCTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355160; c=relaxed/simple;
	bh=PebqrAqZ/lUV4SFW71QPrIQix10qJ4YVZm2YnM6UTKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JailOU00zHJCAu93yK6opvHBaqC6S/B/Q8377GgIokTQBi4FyQ65fg+FTADBr+0M3FG8mjJu4XTW1Crpu+QrGc17AU8zP5BWbyPxanC6v1OeN06K6iQeILk3dUqqjsRplzvnIDTQCXXmdnnn2IP5hGHdrw/BHE7knjr5D44dFl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wa6jvE92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wa6jvE92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86215C32782;
	Tue, 30 Jul 2024 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355160;
	bh=PebqrAqZ/lUV4SFW71QPrIQix10qJ4YVZm2YnM6UTKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wa6jvE926Sil27UiQO0bwJJ5dNHLBFgkQMDiQ9hmVFoMVLdo4D5FnNp3vavZc6Ky7
	 ORFpEjxeFir0+o22bolhIxR/m2IG+2uGo7H2vlG3L6BxcAhHWldmSamkoGgJyUnXat
	 WjmrZBfpJsYmA8+D4Y2YhRuZJa+2QD/I3rZ+MGJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/568] arm64: dts: qcom: sm6350: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:42:20 +0200
Message-ID: <20240730151641.132796620@linuxfoundation.org>
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

[ Upstream commit 18c2727282c5264ff5502daac26c43000e8eb202 ]

The UFS PHY is powered on via the UFS_PHY_GDSC power domain. Add
corresponding power-domain the the PHY node.

Fixes: 5a814af5fc22 ("arm64: dts: qcom: sm6350: Add UFS nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240501-qcom-phy-fixes-v1-8-f1fd15c33fb3@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm6350.dtsi b/arch/arm64/boot/dts/qcom/sm6350.dtsi
index 71ccda7389ee1..7477bfbd20796 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1197,6 +1197,8 @@ ufs_mem_phy: phy@1d87000 {
 			clocks = <&gcc GCC_UFS_MEM_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
-- 
2.43.0



