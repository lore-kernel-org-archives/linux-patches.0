Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D527E205E34;
	Tue, 30 Jul 2024 16:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355284; cv=none; b=YlkeL2NvFglag0NW6eXyGJEWegPT1L/PS74ZGCUUAWm3Ne590mYnMD7LAkxpQBIdUXeC+ZKAKSaIrhJbqxrytpyHjDPTWeXnTAHeFb/RUffPaW5sJOX884ilddGMbtGrUhgLdg53jBSSBC/WHPBy7HT1iSBOKSNbHJDsWUAbb0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355284; c=relaxed/simple;
	bh=0elKTB2Pwkd2ig4Lu8eNHQcYIwJ9GZhFTTck66F31+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTzlvtJ2hq0kW6ltmlJ6Mro8S9a76+zmMkmYQWLLJiaNVoC82WTFW14FQH/7FQdd5apb2MHdnZSwbpwU3cW7fVNcSbP6Nhq1TDJR6tc8D26e60f88HWInwXKQTbqrkDAgbCCLyia6Ng5RBaJyAFpgZU0MKpZ1k9vFCVHvqaewlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkxEc50L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkxEc50L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A78C32782;
	Tue, 30 Jul 2024 16:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355283;
	bh=0elKTB2Pwkd2ig4Lu8eNHQcYIwJ9GZhFTTck66F31+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkxEc50LpdNbYLB5TE2LmyFPMDeug7gqPCV6ev6Er3GmKDXViYOjOQyIWONmN4IAV
	 P3RNep3HA1Qhx7hnhevajAntIJRc6d3lXdTNsrWftiuRROHYL1rxsUXBWfpaIE39yB
	 ELt5OAngVT3N4HcZOsGEvT85j17tTrssmdECYoVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/568] arm64: dts: rockchip: Add pinctrl for UART0 to rk3308-rock-pi-s
Date: Tue, 30 Jul 2024 17:42:31 +0200
Message-ID: <20240730151641.564408936@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 7affb86ef62581e3475ce3e0a7640da1f2ee29f8 ]

UAR0 CTS/RTS is not wired to any pin and is not used for the default
serial console use of UART0 on ROCK Pi S.

Override the SoC defined pinctrl props to limit configuration of the
two xfer pins wired to one of the GPIO pin headers.

Fixes: 2e04c25b1320 ("arm64: dts: rockchip: add ROCK Pi S DTS support")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20240521211029.1236094-6-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
index f436284cb89c3..e31b831cd5fb3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-rock-pi-s.dts
@@ -232,6 +232,8 @@ u2phy_otg: otg-port {
 };
 
 &uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_xfer>;
 	status = "okay";
 };
 
-- 
2.43.0



