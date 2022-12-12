Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB43128ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31CDC433D2;
	Mon, 12 Dec 2022 13:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852096;
	bh=DL5eO2ssTlaLD6hYZmW84GDgZ4a0XYtpgyQmCvFg2A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emWAFwlD7UWNCos9g5ttOnkjGuJJtubSnz7aBJbMLi3hUXxtjzXFDbZjodhoLtKIu
	 8vH4eh01QveC7NFt697hQNpvCWv56YK920a/G3Yg0+FZS1yLx/faM8l24AdoUbgOnA
	 uJVZsnihc6ZtLSzMMBpEdA3Ki/Y2RWCkthusHOCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 010/157] ARM: dts: rockchip: fix adc-keys sub node names
Date: Mon, 12 Dec 2022 14:15:58 +0100
Message-Id: <20221212130934.834323602@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 942b35de22efeb4f9ded83f1ea7747f3fe5a3bb2 ]

Fix adc-keys sub node names on Rockchip boards,
so that they match with regex: '^button-'

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/7a0013b1-3a55-a344-e9ea-eacb4b49433c@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3066a-mk808.dts | 2 +-
 arch/arm/boot/dts/rk3288-evb.dtsi   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/rk3066a-mk808.dts b/arch/arm/boot/dts/rk3066a-mk808.dts
index cfa318a506eb..2db5ba706208 100644
--- a/arch/arm/boot/dts/rk3066a-mk808.dts
+++ b/arch/arm/boot/dts/rk3066a-mk808.dts
@@ -32,7 +32,7 @@
 		keyup-threshold-microvolt = <2500000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <0>;
diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 399d6b9c5fd4..382d2839cf47 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -28,19 +28,19 @@
 			press-threshold-microvolt = <300000>;
 		};
 
-		menu {
+		button-menu {
 			label = "Menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <640000>;
 		};
 
-		esc {
+		button-esc {
 			label = "Esc";
 			linux,code = <KEY_ESC>;
 			press-threshold-microvolt = <1000000>;
 		};
 
-		home  {
+		button-home  {
 			label = "Home";
 			linux,code = <KEY_HOME>;
 			press-threshold-microvolt = <1300000>;
-- 
2.35.1



