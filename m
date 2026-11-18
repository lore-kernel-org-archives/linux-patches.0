Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039159;
	b=zC/BrzpCAFGOt7KFMFgu0UgVolDlWE7z0JgNhCZopj+YQTUY8IMqlR/kpFrI27E3HRrZ
	 fnb8RK77tzyVrHjqrFS0GqmCheCTu4ORUAoW2adA3NDxTL/pYP5xO75Qs+BP3FhHNgbmf
	 ohkwoipv27mYxMXPt1Uj8lR7Rw63O07G6R4C510F27K4zXX5BJXMNCoAGj6Ttr6/tQR4A
	 WgRe7GjRnfrj1l3igfCvUKyW9dYmkyr6BGE24Es5BwtVL/iTRzc8y6WPhq3OIBdUQqPGD
	 IB43xqc+iXiNHepJ1gq7uYWLRx9VBxrl7DdtNZ3VD30m/ybLuxbTC8ycmYvfemFzKvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8q8Ts+Ka9DjerJsU4uMIJte5yH1kC8tTk3yaotlsEIA=;
	b=kxxcn/4OJCOjtLftRUHaVOgOEIQV1qB5R+7E3hfZA66OFa+EIHg2VaEAoBgWJ2jk4zWz
	 uhgPQK2BPOodzgC5dVwUYxL73W806o7MvGN8iizsF42/u7Zokaen6nnhAj3Gadtb4vo7y
	 bqp+hq606NaJTwhIqu62BTsIc3ouMpjuaXMCS/bxmefPoinK45HHT+vkjO5U3M2WfDiBb
	 UHLaS7cqJRy8k56833N1S0NGxv1WPREbk067r4SKjCS0XvSZxruZzs9OJtqWiFEHEgPSR
	 R27qw4A3uguQPxvWXPdP/SQ01mlRlhnDAI2v60FUzGcMy9WoxyaftQ4k7uRUcIwUfvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aif+j/rq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A72606A31C;
	Wed, 18 Nov 2026 21:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aif+j/rq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019B01F000C4;
	Wed, 18 Nov 2026 21:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039158;
	bh=8q8Ts+Ka9DjerJsU4uMIJte5yH1kC8tTk3yaotlsEIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aif+j/rqfkjHIpvbGf1XbyYIA5EAUYXSukBOd4TjnTIpL/FQ23KWK7oIIesYD9vB/
	 Hort3tBshTq3fQvLlqk8xggPqgmRhA8Tfa7DjaguKja+oeWgj6witBJDPoIqUrLZ3d
	 WYShDn8zuwFcgmMvt7QxZ3lAXH0RAeTtB9yjqOJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1999/3318] ARM: dts: helios4: fix vbus-supply for USB2 PHY
Date: Wed, 18 Nov 2026 15:43:41 +0100
Message-ID: <20261118150422.022349923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a132798a133e76a7bb575ba95b2b64eadd245438 ]

The usb-nop-xceiv binding and driver use "vbus-supply"; the driver
acquires the VBUS regulator via devm_regulator_get_exclusive("vbus")
(phy-generic.c). The stale "vbus-regulator" name is never read by
the driver and dtbs_check rejects it as an unknown property. Rename
the property so reg_5p0v_usb is honored.

Fixes: ced8025b569e ("ARM: dts: armada388-helios4")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-388-helios4.dts b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
index 0545452a983fc..1ed6ddf1719a7 100644
--- a/arch/arm/boot/dts/marvell/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/marvell/armada-388-helios4.dts
@@ -140,7 +140,7 @@ fan2: j17-pwm {
 
 	usb2_phy: usb2-phy {
 		compatible = "usb-nop-xceiv";
-		vbus-regulator = <&reg_5p0v_usb>;
+		vbus-supply = <&reg_5p0v_usb>;
 	};
 
 	usb3_phy: usb3-phy {
-- 
2.53.0



