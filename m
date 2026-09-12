Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57382CA6F;
	Sat, 12 Sep 2026 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207531; cv=none; b=LbbwZBZURdQylkn4rBFRZb51BQJqIlRFd1OgWmwnATP0BMaw9HRPGqL4MhwF+riVtBcqbdLcOAQXOucr7ZhCiOupeq+PYMX6rpG+btLSxFq1NKaMqglC9QJfbjW11UEJkJGNmgy8Hhv2WcpECCtMZfxutNcJwDiciVYB3IYazNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207531; c=relaxed/simple;
	bh=4PdCGRAKqgdjy2zuHWxe4B8vre0QcXfmoGHL1kjAQqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxF9/6QzK6LNvHgl/y65Kgdlj+SqYWMgq096MtRQdT58uOoRTv1ctNIW/DtCCJb9oChrvvEqXYU+wpxyqCFNPA35QgEMETniv/cbNbmgVZpFbZ4BFEEAH7rH1tnw1beCtl/sUSFN1gUcHAg9MPf3uehREBmLi9L6/DoXbCXBm2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNdMV+M3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNdMV+M3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12711F000FF;
	Sat, 12 Sep 2026 10:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207530;
	bh=ASu6L/mc8mR2SPMUVfg1HsA8XcZ1g+MbCVKt0QB5S1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNdMV+M3OL7dJGgsBjidHP7GwV0gHGZZWTwFt9qDPojGgzXQELOXRQSOT6gIhfhw7
	 udAzlXLEjy44WxCJOt+8OJZH7ssiccEpGZYz0Cjjut3t9r7SROo/RVjNHPAi624Z6d
	 RrhKIEsx/PCLDm8+6tgM3NqPs5TX2JU880P2K+sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	George Moussalem <george.moussalem@outlook.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0414/1518] arm64: qcom: ipq5018: Add GEPHY RX and TX clocks
Date: Sat, 12 Sep 2026 08:43:03 +0200
Message-ID: <20260912065632.819758241@linuxfoundation.org>
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

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit 742dc058588bf1233647dcd95738c0afc621435d ]

Add RX and TX clocks for the IPQ5018 GEPHY to enable the datapath.

Fixes: f5f2b835e316 ("arm64: dts: qcom: ipq5018: Add GE PHY to internal mdio bus")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Link: https://lore.kernel.org/r/20260608-ipq5018-gephy-clocks-v4-3-fb2ccd56894b@outlook.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq5018.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/ipq5018.dtsi b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
index ed1abb41fbe47..40b5de02d5c5d 100644
--- a/arch/arm64/boot/dts/qcom/ipq5018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5018.dtsi
@@ -229,6 +229,9 @@ ge_phy: ethernet-phy@7 {
 				compatible = "ethernet-phy-id004d.d0c0";
 				reg = <7>;
 
+				clocks = <&gcc GCC_GEPHY_RX_CLK>,
+					 <&gcc GCC_GEPHY_TX_CLK>;
+				clock-names = "rx", "tx";
 				resets = <&gcc GCC_GEPHY_MISC_ARES>;
 			};
 		};
-- 
2.53.0



