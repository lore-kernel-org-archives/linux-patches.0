Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA7D36405A;
	Wed, 20 May 2026 17:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298379; cv=none; b=K6DH0jF133yAkeC+SkxUP+Q/tsl/ejkZqjj7lJuaddAl5e5asJPgR2IapczYn1brROWfxqZpzHyNoT7kUdawHo3BEP8ztxdKbqiO6OJpvMlQOwEGUsoudMEDoU84PoYIY/bipwF5yuTwIi+S8BTXLujo39aD8KOgYlfGRFDhQbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298379; c=relaxed/simple;
	bh=3tM6CKB9vPl2+OlwOhFvPR2P/HpxUyRymGxb55G2iqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuzPWB/IE3V4dAx9H/NWr0UJxSAXBdfWkmte/TRRRCrjKBoeVQXKp8e54psctrF4KYjBh9DPE0h7Okp7279xD8jK2VQsOqH7AYmyTQSi32VuSZstGpTJ/vv67uTya/CO3dC14v8GFXLMGVxGYUAr7PucLnvDbiWL6YtyjeTo/Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcTNrKDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcTNrKDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C8D1F00894;
	Wed, 20 May 2026 17:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298378;
	bh=9Z6KDVGNqRDFr9WfryjxvhCiwZ6u0hMJYKHo8nIARH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcTNrKDPFpflWFAt0R2Dk0T7RAQSOIk3eI88xxxNsUZETqxa8+fbTDHiUKduo1w+/
	 5qe05yLwBBI8LKnHiOBF9Kxd/vg6TWUeXd6b2cDO/SaBmBymWb3NayxKF6mNettBHQ
	 ZSrmzdNNp3Jr1v/cLtARaHvR1so972pYUvp+WzY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 387/957] arm64: dts: rockchip: Correct Fan Supply for Gameforce Ace
Date: Wed, 20 May 2026 18:14:30 +0200
Message-ID: <20260520162142.920672167@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f5894672fcbd3..ef8805219ea16 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-gameforce-ace.dts
@@ -304,7 +304,7 @@ pwm_fan: pwm-fan {
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



