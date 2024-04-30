Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF56F12C801;
	Tue, 30 Apr 2024 11:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475243; cv=none; b=aAxve0DQBch1WthexJ97vjydcYaWfXbmtpn07nQEobI9SlZMNel8kQ4FwWqp+IHwX6wlsoFAoqZi2gg/AX0TqxowlUNytPSLd+bTyLhKzLLU9uhnef6byf/MuuXB1kASGF0vva394+YHb7m943Fqje4yFyCEU7m3XOYCFKnz3yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475243; c=relaxed/simple;
	bh=bO0ZTAYTv9dEPVfRaUoLZdHMZIXjZ9f6zd2EVkYa85Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDgPcmreDWxxxGQ8pTJHdqvFznt+JA65/4wuWiPUv3oUYL5a86vBoqc/SLupjrk3CxGk8pUhSu3CwQcU65pdCBYCU/muXoxZLMeIgXKvEECcugaRwrzuIV9Tw4ef6ZkSm9K7DAE5jE57EgH580iwG8lD+VDAYDssbsoxJ/Xr++M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yom2dIDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yom2dIDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E056C2BBFC;
	Tue, 30 Apr 2024 11:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475242;
	bh=bO0ZTAYTv9dEPVfRaUoLZdHMZIXjZ9f6zd2EVkYa85Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yom2dIDB7qnpHWwTw96hp6xskKRmijR0EUwTrnjQvgBn8uf/M07CQ4uJFjmNFAKeU
	 FYRpMCaVl9sKsYPmyIdei4ZIQVIfVbxrfBjTxSucEqSjpVUvCTl2SU4llVR10JkfoY
	 yi5ZIfkPViPBJD9ima0ytgzCTp9R/0Vx/Pq4dWZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@theobroma-systems.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/186] arm64: dts: rockchip: enable internal pull-up on Q7_USB_ID for RK3399 Puma
Date: Tue, 30 Apr 2024 12:37:39 +0200
Message-ID: <20240430103058.232142549@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: Quentin Schulz <quentin.schulz@theobroma-systems.com>

[ Upstream commit e6b1168f37e3f86d9966276c5a3fff9eb0df3e5f ]

The Q7_USB_ID has a diode used as a level-shifter, and is used as an
input pin. The SoC default for this pin is a pull-up, which is correct
but the pinconf in the introducing commit missed that, so let's fix this
oversight.

Fixes: ed2c66a95c0c ("arm64: dts: rockchip: fix rk3399-puma-haikou USB OTG mode")
Signed-off-by: Quentin Schulz <quentin.schulz@theobroma-systems.com>
Link: https://lore.kernel.org/r/20240308-puma-diode-pu-v2-1-309f83da110a@theobroma-systems.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 20e3f41efe97f..9b9d70bf7f0ca 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -443,7 +443,7 @@
 	usb3 {
 		usb3_id: usb3-id {
 			rockchip,pins =
-			  <1 RK_PC2 RK_FUNC_GPIO &pcfg_pull_none>;
+			  <1 RK_PC2 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
 };
-- 
2.43.0



