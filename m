Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6CB4D5A1;
	Sat, 12 Sep 2026 07:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198792; cv=none; b=oWWqBdAubVBCwtLcq/PvBFi/hHdCJq0oGKIbZwRzteEpmVVQRVjymli0aTP7O2N4wMWzF8qlmJ72ERGUjz0lvH92oRzfJwVs/n78HebcpCpy9m6FTqR9ZiquhzJAwL5qk3akQXdz+VcXNuNTuMtcWX/FNdYp6pgamUfyJ/DLG80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198792; c=relaxed/simple;
	bh=xzV/RCZHDsExCnta8CtF4+m0xQWhL6jvsbUgnaTCgMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q53K3CN86c71PWjKq0ybZXSp8yfhrTksecKFEt1MYJNw47nIGmPXX0zCjj2dFraCz5xv6X8tQMkPBJ8++mEUwoQ9I4vc7KE4KPNiWwVRCYJskIuZT8BY97Q/l6ayYdg8cTzAX2fXw2Hbyd0OmkFt5gvmO2yA9OxidURY0P5gJH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CC/e/A9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CC/e/A9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680941F000FF;
	Sat, 12 Sep 2026 07:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198791;
	bh=BmRT6JANQVtUhE4H6iLxFzhd78p1utjBK+GKLwP6S/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CC/e/A9vaHZ959BFWqzC8GqSfOHNm/LCSgVU/v1VaSatJJXQWfWZFbCI9mY/TztoI
	 tcIasgFzwNggqCV1DKbsrzHg3JtkjZqjLc30bjemL1xZessKUvDLTTriK+NbMjaBSb
	 ZXOOcqpv4rrUZJmQc108uLNVBKFGbbgVB8vQUr9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	George Moussalem <george.moussalem@outlook.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0451/1815] arm64: qcom: ipq5018: Add GEPHY RX and TX clocks
Date: Sat, 12 Sep 2026 08:36:41 +0200
Message-ID: <20260912065659.478954784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index f6cf2cca44eb0..52fc2d266b44b 100644
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



