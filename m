Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F6712BF32;
	Tue, 30 Apr 2024 11:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476519; cv=none; b=tWHsOoRUrSAk3TLb3ea/NGXT4punjeibdnWdtxhtjzK8GL0LrxWGv678phMsLB5F26BvE455ynGJbRZzUE/KG23f/b3qIg8Ta5p+IaER+eLqd+nMAmXXvVHPHsXsLrUswCx3qrPnUV98OmJzznTwecVSsEyUn+vwdvBLOnZeSR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476519; c=relaxed/simple;
	bh=oRHSn/3LaOecRJtf5/SD50H0IU+L5PhYbuSUi3Jc4lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIHLzzqlGPD8EqMiPp19XqM+CutOfNGqLpwy8d0As4p1tWmZOgYrS8Si1Xy4Oxc3XO/P+caTotKdCY2O5XM+1bEQ3bWvJI4jOxu4yInUQrpUg/oIQA+HBBN2cuBHwRhkn28BFUbmSQ0ibLfHnVjRgU4gKf8FQhr+cWhXmb+Qp7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tE9qwM/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tE9qwM/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769CEC2BBFC;
	Tue, 30 Apr 2024 11:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476518;
	bh=oRHSn/3LaOecRJtf5/SD50H0IU+L5PhYbuSUi3Jc4lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tE9qwM/ypgl2E9EV35cvZn6ZK0S6JLh2PZ3kCAB5Avnm2KOQj1oQPD4ixu2VsYC/F
	 Gob3jIXwH/eLR/8ye88KXFrio5/ezev1lYrow8yNLXohUpp3+bZSPQi5fchkdJjrF3
	 s9qpF+npQZaSms0vvxbtH9V9z/zo89h9iZ22Ri6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/110] arm64: dts: rockchip: enable internal pull-up on PCIE_WAKE# for RK3399 Puma
Date: Tue, 30 Apr 2024 12:39:37 +0200
Message-ID: <20240430103047.815692028@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit 945a7c8570916650a415757d15d83e0fa856a686 ]

The PCIE_WAKE# has a diode used as a level-shifter, and is used as an
input pin. While the SoC default is to enable the pull-up, the core
rk3399 pinconf for this pin opted for pull-none. So as to not disturb
the behaviour of other boards which may rely on pull-none instead of
pull-up, set the needed pull-up only for RK3399 Puma.

Fixes: 60fd9f72ce8a ("arm64: dts: rockchip: add Haikou baseboard with RK3399-Q7 SoM")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20240308-puma-diode-pu-v2-2-309f83da110a@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index a060419bca901..a77f922107c20 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -401,6 +401,11 @@
 	gpio1830-supply = <&vcc_1v8>;
 };
 
+&pcie_clkreqn_cpm {
+	rockchip,pins =
+		<2 RK_PD2 RK_FUNC_GPIO &pcfg_pull_up>;
+};
+
 &pinctrl {
 	i2c8 {
 		i2c8_xfer_a: i2c8-xfer {
-- 
2.43.0



