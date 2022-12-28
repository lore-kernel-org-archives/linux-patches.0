Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E301863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1D8C433EF;
	Wed, 28 Dec 2022 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239464;
	bh=QrB+XFpfa34uu7vr31NunYsH0rYTQL9VsgwwKQ+MYSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgoghZrBric321XGNxzBWJj1fQMwZGXUuti58WRMclVpKKfTt/OcPr2YAUEGd0uij
	 sMEzz19FufZZ70uTrbHUzB0r4t0bX7rBoyzta5Ak88Vwq1QXnF4nA7+jPBIfUybRLA
	 84a+ClTMY8z2s1E8H2GJneQulBKfJLvpl/B+fB+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0034/1073] arm64: dts: qcom: sm8450: fix UFS PHY registers
Date: Wed, 28 Dec 2022 15:27:02 +0100
Message-Id: <20221228144329.063263765@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 7af949211a0554bbc06163b081fc2cb516674880 ]

The sizes of the UFS PHY register regions are too small and does
specifically not cover all registers used by the Linux driver.

As Linux maps these regions as full pages this is currently not an issue
on Linux, but let's update the sizes to match the vendor driver.

Fixes: 07fa917a335e ("arm64: dts: qcom: sm8450: add ufs nodes")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221024091507.20342-5-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 8a6c0f3e7bb7..ed3e1eff4f58 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -3131,11 +3131,11 @@ ufs_mem_phy: phy@1d87000 {
 			status = "disabled";
 
 			ufs_mem_phy_lanes: phy@1d87400 {
-				reg = <0 0x01d87400 0 0x108>,
-				      <0 0x01d87600 0 0x1e0>,
-				      <0 0x01d87c00 0 0x1dc>,
-				      <0 0x01d87800 0 0x108>,
-				      <0 0x01d87a00 0 0x1e0>;
+				reg = <0 0x01d87400 0 0x188>,
+				      <0 0x01d87600 0 0x200>,
+				      <0 0x01d87c00 0 0x200>,
+				      <0 0x01d87800 0 0x188>,
+				      <0 0x01d87a00 0 0x200>;
 				#phy-cells = <0>;
 			};
 		};
-- 
2.35.1



