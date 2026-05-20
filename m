Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2A53AC00;
	Wed, 20 May 2026 16:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295651; cv=none; b=b0xn56GDzmNNyIVsXpBU2X0JE3O7kzsZ+8YPkfeTq4pBayxIY0bDcx0S7nLdPjYb2shIOCpYIDCQoSeyqL3jCUw9d38zE77yWWaCytUylevBCNWvslnijUTBhoGdnMT3Unc56BZDz3MEgzdoWSldnNBpvmp2GiXwEIFvjoRJfu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295651; c=relaxed/simple;
	bh=F4DdFezdZIPtSj3JL4d7S7lquhpLzYuBJYrx5nHyEzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyxTVIAKXlMvhRvqOP8wEfhKvUkFuPiX/55MS+I67Gt6/Wkt6XqZkvC03p89dxyHPKI/7ISskleH4v81qx6RQ9h1BcsxNjQXNjKYlPUY2WmYUN2EPFRkoK3mDiI8pG4V0p9FZmBKVw8fxK0X97Kjkb4YylmQ9BXG7219dyduldY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ivTm0GMk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ivTm0GMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6DA1F000E9;
	Wed, 20 May 2026 16:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295650;
	bh=RdfxuEsWResutZG/FNhAn0CcTRZTu1h6Sn+/uKvM990=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ivTm0GMkBIufXjPv7acK5K9R814mNFMoq0Ydp+g+wiVaA5PrErdA/T6oI/jv84gw7
	 n2USe8F66xaZxu6ltyvafMaE/lwAW7pRxuc211JtTCO2A4RU5eCWe7VCbmNatcbfE+
	 1BAiqjU0V9fH9RrDL8qSPBCmiarMaTuTQfi94T/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0500/1146] arm64: dts: rockchip: Correct Fan Supply for Gameforce Ace
Date: Wed, 20 May 2026 18:12:30 +0200
Message-ID: <20260520162159.505964896@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit c7079215b7dbf88b84a95ff13982bf3dab3cfbe1 ]

Correct the regulator providing power to the PWM controlled fan.
Without this fix the fan only runs when the audio path is playing
audio (because the speaker amplifier and PWM fan share the same
regulator).

Fixes: 4e946c447a04 ("arm64: dts: rockchip: Add GameForce Ace")
Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://patch.msgid.link/20260310134648.550006-1-macroalpha82@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
index e8ad525ba3f9b..59d2494c45100 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
@@ -318,7 +318,7 @@ pwm_fan: pwm-fan {
 		compatible = "pwm-fan";
 		#cooling-cells = <2>;
 		cooling-levels = <0 120 150 180 210 240 255>;
-		fan-supply = <&vcc5v0_sys>;
+		fan-supply = <&vcc5v0_spk>;
 		interrupt-parent = <&gpio4>;
 		interrupts = <RK_PB2 IRQ_TYPE_EDGE_RISING>;
 		pulses-per-revolution = <4>;
-- 
2.53.0



