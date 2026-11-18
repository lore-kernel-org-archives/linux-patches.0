Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028894;
	b=lyu8rZAdDAb4QKh47IeDYHbJiFC4b2EBv5PXIV2BrHWW69wDJb52iedtqeKZebEgbxtu
	 U5dv6150Sy1xO3QVRap75v1NUgHkDc6VVTNauTLindB4Y5n9tmUKDEVWAvg4yP11Dy4jc
	 2uyBpB6ZngKA7i3ljv8UMnre/TAiKNWGHuLRjbiNN0ySEZ3G+HMhKTFrUPi2wgz9oqyy2
	 OkzgIgs+NNS1gY2PLwO1xHdWwgJFPrN2pulFRUyRfQ48Vx1HcwoO+QnnWlCGhawEOHYxn
	 cCxJsQgsw2II9BIPW/Kd/9Jz+67t4ULlPdUbjtcY2/sdHbuINtTUbREIG2ZiHgvPssQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IWKMZOsHcNjUgdNFm57r2p5n6uCctbgxDO80iuxQhHw=;
	b=vvxjczuO7TIZG4mlX2KCaNxDnmPWW6kLGW1QyVRi9BghErmOq+NRRizFR00oBoT+MwEl
	 cEjmRGy6aB/ZfpwstUNXTG4L4MyAdtVWdpU9PtBPQ+Tp5etiW2NQtAxoK885vQxj4xbu+
	 F3KwrvytzgQ+TrSTbeN8cksO4eqjJp/Aori2YkVN5G4s7kX/EysMBZBW4z5TfJd8ai67X
	 QEzpoREdtzGMxWgGCC9k+3FZ2c853irnZhi5ZuYpz/iGva+77o+HByHa0LjWHvibmqrjO
	 EhIPD7HgQY4YgBn/UASBQP2ghqfJaLYuEll0XJ8Xl5nVrE2bineZUuN+QOCyhLpaSKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kxm3/2uL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD95D606A32C;
	Wed, 18 Nov 2026 19:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kxm3/2uL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1971F000C4;
	Wed, 18 Nov 2026 19:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028894;
	bh=IWKMZOsHcNjUgdNFm57r2p5n6uCctbgxDO80iuxQhHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kxm3/2uL2ZfpbxPY+gVlYzLI9o2lXSlHTrg+zUPZBpMba6qlHvleOeuM35jkn/nht
	 YK1mz/H2n1KIes/75YF6Ww3FSgO61awl9+l/crH1iVimMtBKQYD0hTFY+MWd4Lzqs+
	 6zc5XT9xrI1vsWYUw93r/DSSM2oWgV16F4rL1vbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0155/1756] ARM: dts: helios4: fix lm75 supply name
Date: Wed, 18 Nov 2026 15:38:02 +0100
Message-ID: <20261118150014.298275552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit ef473a83c63e3173ac472e42727e990b923b99db ]

The lm75 driver requests a regulator named "vs" (the +VS power pin
of the chip).  The Helios4 DTS incorrectly used vcc-supply instead
of vs-supply, causing the regulator core to emit:

  lm75 0-004c: supply vs not found, using dummy regulator

Fix the property name to match the binding and the driver.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-388-helios4.dts b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
index 003b0708e9656..f5ae4bea1211f 100644
--- a/arch/arm/boot/dts/marvell/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
@@ -200,7 +200,7 @@ usb3-ilimit-hog {
 				temp_sensor: temp@4c {
 					compatible = "ti,lm75";
 					reg = <0x4c>;
-					vcc-supply = <&reg_3p3v>;
+					vs-supply = <&reg_3p3v>;
 				};
 
 				eeprom@53 {
-- 
2.53.0



