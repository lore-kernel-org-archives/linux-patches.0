Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0B8374C4;
	Tue,  8 Apr 2025 11:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110775; cv=none; b=BpCaSyNQXD1AgMzH47nOATSbQzN5GP8pq/BnvTS2jol8+AYcvQcwhwnWiOcF9LERPQfckqMUJBKuin9iE7uD0hSu2phabez3tb9yxapRRnHfrdnV/EJQiDWTiiJsKgkEX9z+MDsPzV0DNQe5jWdyf2ztztLLWTtMCdTV7tmfanc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110775; c=relaxed/simple;
	bh=9Gb5j5/qAjvRPFp6m5isUdQuc2tU3TFkc1n8XWyFo8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTOt5mCk4opOx2hzvZi0lniT1pbj+IdoZxHo4335IpEyuB3L3Ds9xX1ZGVUrFD/Uj5ktldeZ+rBHtFSeOP0R62da5GgLuBwSFZvhZ1AIr1aH8Tk3y++Oyv6H8IxPA25ak9dpa6oN6ZCgUoNkfGNV9ddXKebuVbPQ4oMppSetoPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXGmeEC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXGmeEC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1446C4CEE5;
	Tue,  8 Apr 2025 11:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110775;
	bh=9Gb5j5/qAjvRPFp6m5isUdQuc2tU3TFkc1n8XWyFo8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXGmeEC0kJmAJ9gRobjkE1s3eaAGhrOWh7qEWfb5TQifrZAS2chzlTa0Mdrf89Eam
	 mfXuRyBu8pOVFSo0pQg7s0tonnPxrEVSc1XWvK63gVeQw17SU5Lr+j8FPEwp7wvTtj
	 fSnj5Une5swWjCWo/V85bNliPKQWKnx7M/KZX9eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 189/731] arm64: dts: rockchip: remove ethm0_clk0_25m_out from Sige5 gmac0
Date: Tue,  8 Apr 2025 12:41:26 +0200
Message-ID: <20250408104918.675491817@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

[ Upstream commit 73d246b4402c3356f6b3d13665de3a51eea7b555 ]

The GPIO3 A4 pin on the ArmSoM Sige5 is routed to the 40-pin GPIO
header. This pin can serve a variety of functions, including ones of
questionable use to us on a GPIO header such as the 25MHz clock of the
ethernet controller.

Unfortunately, this is the precise function that it is being claimed for
by the gmac0 node in the Sige5 board dts, meaning it can't be used for
anything else despite serving no useful function in this role. Since it
goes through a RS0108 bidirectional voltage level translator with a
maximum data rate of 24Mbit/s in push-pull mode and 2Mbit/s data rate in
open-drain mode, it's doubtful as to whether the 25MHz clock signal
would even survive to the actual user-accessible pin it terminates in.

Remove it to leave the pin for users to play with. It's infinitely more
useful as a GPIO or even as a PWM.

Fixes: 40f742b07ab2 ("arm64: dts: rockchip: Add rk3576-armsom-sige5 board")
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Link: https://lore.kernel.org/r/20250314-rk3576-sige5-eth-clk-begone-v1-1-2858338fc555@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts b/arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts
index 7c7331936a7fd..a9b9db31d2a3e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts
@@ -182,8 +182,7 @@
 		     &eth0m0_tx_bus2
 		     &eth0m0_rx_bus2
 		     &eth0m0_rgmii_clk
-		     &eth0m0_rgmii_bus
-		     &ethm0_clk0_25m_out>;
+		     &eth0m0_rgmii_bus>;
 
 	phy-handle = <&rgmii_phy0>;
 	status = "okay";
-- 
2.39.5



