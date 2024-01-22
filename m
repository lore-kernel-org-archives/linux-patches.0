Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE4860251;
	Tue, 23 Jan 2024 01:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974666; cv=none; b=GUoqHrhTVxRY4Cm8MybmaDtUqfb7HDQZciuuQZBSJzGzP7XeZ+sUggQIZ/7u/4JBZw+ZJA3Kr14/1Rrt7KyFiW7iuYm5XsbtLbCJJWooDfiH4qt1jiIKIs09RigZWbWUKsqHecoc5+ON1kWcwj0mSP2l0a1aiYQ7ETgyypuDu8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974666; c=relaxed/simple;
	bh=UIwLldMZImME5c3+F/Q8aXfdN4MzuyAdFtvc8ersrB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/ia48t4ra825Zi/upIi8j5Jvu3LO87mTBADdh1M9fsCtfpi4bEuiHbLSLxbQTxxNMH7DGkVwvchLOm+aVeCBxQsdWFveiRlVOEv8a56bVklENyIPHreaCYuagHQ89iA0tdUOQUaTldNOySdX95i5MIM4t29oUG5HAQh7k5c6TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KCO9YyLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KCO9YyLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306E7C433C7;
	Tue, 23 Jan 2024 01:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974666;
	bh=UIwLldMZImME5c3+F/Q8aXfdN4MzuyAdFtvc8ersrB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KCO9YyLO1PcObnfKuNaMqomLo1PvSsNFAsUeGnU5T1fQa10t1IFuR/uHKeJza4X25
	 viuFE8Iy7pzHIvv45rxwomt7dEcwLzAfGchvcKrd0qL8End+mLy95if7zMwyZ5/SCz
	 huEgSSXMoqvf58vL+04mc5fkNWJK3A3LQWVOL6H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 114/583] arm64: dts: qcom: sm8150: Make watchdog bark interrupt edge triggered
Date: Mon, 22 Jan 2024 15:52:45 -0800
Message-ID: <20240122235815.647032703@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 9204e9a4099212c850e1703c374ef4538080825b ]

As described in the patch ("arm64: dts: qcom: sc7180: Make watchdog
bark interrupt edge triggered"), the Qualcomm watchdog timer's bark
interrupt should be configured as edge triggered. Make the change.

Fixes: b094c8f8dd2a ("arm64: dts: qcom: sm8150: Add watchdog bark interrupt")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20231106144335.v2.4.I23d0aa6c8f1fec5c26ad9b3c610df6f4c5392850@changeid
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 19c6003dca15..d7a2c3567532 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -4197,7 +4197,7 @@ watchdog@17c10000 {
 			compatible = "qcom,apss-wdt-sm8150", "qcom,kpss-wdt";
 			reg = <0 0x17c10000 0 0x1000>;
 			clocks = <&sleep_clk>;
-			interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 0 IRQ_TYPE_EDGE_RISING>;
 		};
 
 		timer@17c20000 {
-- 
2.43.0



