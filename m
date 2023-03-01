Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C828847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51DCC433D2;
	Wed,  1 Mar 2023 18:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694319;
	bh=Cs+M07axfazicUtMljub5Y2DDqCfcNlViF85M3SkxYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYAiwufjoa8T0/RmwDSyt1ADvqBODaoqk2Y2Sf6F17rwi84nf5ls6SKDRCIQQFHl7
	 AeVi8e2LeOfjlSrxTMz0cAi0DbSDoSJzZqRRKjaGFebjeOnndUivfGVSOoUh5TU7Ts
	 taFyRKO45bDolojffIA3BFS3iGxuouEzMzGacW94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarrah Gosbell <kernel@undef.tools>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/42] arm64: dts: rockchip: reduce thermal limits on rk3399-pinephone-pro
Date: Wed,  1 Mar 2023 19:08:23 +0100
Message-Id: <20230301180657.123102521@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jarrah Gosbell <kernel@undef.tools>

[ Upstream commit 33e24f0738b922b6f5f4118dbdc26cac8400d7b9 ]

While this device uses the rk3399 it is also enclosed in a tight package
and cooled through the screen and back case. The default rk3399 thermal
limits can result in a burnt screen.

These lower limits have resulted in the existing burn not expanding and
will hopefully result in future devices not experiencing the issue.

Signed-off-by: Jarrah Gosbell <kernel@undef.tools>
Link: https://lore.kernel.org/r/20221207113212.8216-1-kernel@undef.tools
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
index 2e058c3150256..fccc2b2f327df 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinephone-pro.dts
@@ -83,6 +83,13 @@ vcc1v8_codec: vcc1v8-codec-regulator {
 	};
 };
 
+&cpu_alert0 {
+	temperature = <65000>;
+};
+&cpu_alert1 {
+	temperature = <68000>;
+};
+
 &cpu_l0 {
 	cpu-supply = <&vdd_cpu_l>;
 };
-- 
2.39.0



