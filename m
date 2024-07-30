Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADB529A2;
	Tue, 30 Jul 2024 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354889; cv=none; b=N/XIBgVAnRglZeyBDNz+4sxlXx0QqmI7/mGWx8pxPCjIU0xFiBarZaJ8TrbSMvI9d9Bw/lBvhqpKsKxJqg5tIZUkJ/rQRosGWxyuyS8woZBM5ifM3hAmq6Vot3uDxVrMfCjo2weZs5oZh1sDPYf20/U4xPjqS/kpC+h7mBUXZj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354889; c=relaxed/simple;
	bh=G3Q38zRtMfH4K4qlsTh/tCtgjT0TYPoca66tAhUShws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjwPnFwTdzJFx13jWOav+ULX2LMSeiaVU3Py3vmvds9G5VcIBDXGRMcJtkoqyuUZ82Bnafzm5jDWzJgIObc7E4p6lP5STy6DLocH4za8v+N+SmzojsQl6xWe5VzK2NdgPcNjPkQRICFJpFNUDRWZy6osSQiSwBEgder4FKh+La0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEnLmOzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEnLmOzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9085EC32782;
	Tue, 30 Jul 2024 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354889;
	bh=G3Q38zRtMfH4K4qlsTh/tCtgjT0TYPoca66tAhUShws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEnLmOztcwkIWMWNMchsTdzX6FRkuxmj7IaAgXujRZOGQY+SziTtglgmuuaoac1FH
	 ZBkLdU+FI7+YYI98WxoCgcEM4JAu9Wm5kWGuLuXBD8EYFq41IMoIh3fbmxBA0yT1hx
	 jWdHJBzlMfmfuT4n545PL+Y+9Oic29vglzCrRKyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/440] arm64: dts: qcom: sm6350: add power-domain to UFS PHY
Date: Tue, 30 Jul 2024 17:44:25 +0200
Message-ID: <20240730151617.020080919@linuxfoundation.org>
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
index 9da373090593c..66998df053d52 100644
--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -830,6 +830,8 @@ ufs_mem_phy: phy@1d87000 {
 			clocks = <&gcc GCC_UFS_MEM_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
+			power-domains = <&gcc UFS_PHY_GDSC>;
+
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
 
-- 
2.43.0



