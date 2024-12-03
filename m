Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081C91F7591;
	Tue,  3 Dec 2024 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240379; cv=none; b=axCX/TTcEL9iexJpuOfRi3eLQRwcHXx6QnRgiNzrLcYi3a/1wvBJMiANyHAMAn2UH4bm47m3+wPG9sKHgPTgAyHUc5WIYv6m9BM69UlyIk4C7LYqrY2YZfPlOytnxtpYg6wBBm94Tr39Z4I+xOMKMUTCQnuxAi1jBZh8tnsoTKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240379; c=relaxed/simple;
	bh=ZQQBLUoanNzRBplCJfuc2aHvMqYKT8n4O1MiNrpoMl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQEqSmgA36cdRkf/48FXX18cMiPU9Qt7L0IxJl6i6LJ/9rN6tFR0yU9vhGpcGsGYS7L4IrjEy5TDaf0Q9hbKGWSvnQJ7Ts65xbx+ewVqOqgCRm8TaXuiAJIML8IzrJKSdW4xmEirJlpq0+Fb6YBVA9VVDDLMgBY6t40bZhpRg08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usGSNC2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usGSNC2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F40C4CECF;
	Tue,  3 Dec 2024 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240378;
	bh=ZQQBLUoanNzRBplCJfuc2aHvMqYKT8n4O1MiNrpoMl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usGSNC2uM/0jt4VbU++zLPjLMUN/gvUMSvrEtyB98XRqkBVB0/nuaQwRIg/1uIVuJ
	 l6DP1NNG//p7f7enzqbJBtC23UsK4PNC3Y4JxBCX1rzJq/e0nmsM2PvGeonMZVT6ZJ
	 rbjjIN2+QVsb5ldtQERuR3u1FUBqHwgbNdPIK1Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/826] arm64: dts: qcom: x1e80100-vivobook-s15: Drop orientation-switch from USB SS[0-1] QMP PHYs
Date: Tue,  3 Dec 2024 15:37:26 +0100
Message-ID: <20241203144748.387710600@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 27344eb70c8fd60fe7c570e2e12f169ff89d2c47 ]

The orientation-switch is already set in the x1e80100 SoC dtsi,
so drop from Vivobook S15 dts.

Fixes: d0e2f8f62dff ("arm64: dts: qcom: Add device tree for ASUS Vivobook S 15")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20241014-x1e80100-dts-drop-orientation-switch-v1-2-26afa6d4afd9@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
index fb4a48a1e2a8a..2926a1aba7687 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-asus-vivobook-s15.dts
@@ -594,8 +594,6 @@ &usb_1_ss0_qmpphy {
 	vdda-phy-supply = <&vreg_l3e_1p2>;
 	vdda-pll-supply = <&vreg_l1j_0p8>;
 
-	orientation-switch;
-
 	status = "okay";
 };
 
@@ -628,8 +626,6 @@ &usb_1_ss1_qmpphy {
 	vdda-phy-supply = <&vreg_l3e_1p2>;
 	vdda-pll-supply = <&vreg_l2d_0p9>;
 
-	orientation-switch;
-
 	status = "okay";
 };
 
-- 
2.43.0



