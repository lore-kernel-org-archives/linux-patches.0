Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88475BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0F0C433EF;
	Tue,  7 Mar 2023 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212012;
	bh=jPHWB2TWQMuyh/0dVL4nFyzZZMcXN3WKGdvG1T+nohA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9jVO82pOsD5Rm8i6q71yw0O6Iaf9AWfW2o7CTsUIJZmzM3a+B6qJuRpH1bHpUoaX
	 bS4Rlmj+65bkqUgkasiTwc+4BxG89NLrOnjX4+UYIrH+xCltQYEyToYpoQpOY38m8p
	 rVy2OIhn/Y0Mcwgb/U7DrD2VzL6xin5U/ktlAC3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/885] arm64: dts: mediatek: mt8186: Fix systimer 13 MHz clock description
Date: Tue,  7 Mar 2023 17:49:12 +0100
Message-Id: <20230307170002.429777742@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit b391efba57ff085233d5ead5e01817bf4b71d999 ]

The systimer block derives its 13 MHz clock by dividing the main 26 MHz
oscillator clock by 2 internally. The 13 MHz clock is not a separate
oscillator.

Fix this by making the 13 MHz clock a divide-by-2 fixed factor clock,
taking its input from the main 26 MHz oscillator.

Fixes: 2e78620b1350 ("arm64: dts: Add MediaTek MT8186 dts and evaluation board and Makefile")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221201084229.3464449-5-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186.dtsi | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186.dtsi b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
index 64693c17af9ec..fb32e3efcdb12 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
@@ -211,10 +211,12 @@ l3_0: l3-cache {
 		};
 	};
 
-	clk13m: oscillator-13m {
-		compatible = "fixed-clock";
+	clk13m: fixed-factor-clock-13m {
+		compatible = "fixed-factor-clock";
 		#clock-cells = <0>;
-		clock-frequency = <13000000>;
+		clocks = <&clk26m>;
+		clock-div = <2>;
+		clock-mult = <1>;
 		clock-output-names = "clk13m";
 	};
 
-- 
2.39.2



