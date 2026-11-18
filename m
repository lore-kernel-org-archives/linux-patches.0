Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029069;
	b=SJqu2Py05vv954vfDp4N9BgOQCzgXRd95afOXw5Q7jZCXDZaeApVokzFo1u203D1lfy0
	 5c44cowAE2zWcrhehsqo0TLOjRs2Kg3M2gzCMQCSqpEDzaSnSs9BABeSEFZtqzWzm7uqi
	 HeJZHfIc67v+5rrtfPwq2vCoXUozqicRsxMUQp+JdAynzxtWmVNdPR5TmRb78zSrNN2ch
	 UPmPgzTxC7fcWNsmrGiFlC51xLOfltPqJrTqipPB241xAMvA6auUQyStUU+pvQ8TVqPMA
	 b5oCkO6r+FGaeIvAC18JdTMG827znGaQkCvNXz9j819vb7IeFTz7TVlutywwvhv3BJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ka9VfYGI6lBhZ7L9QmsoIPz4cfNjzExruQ4v8f0i+ws=;
	b=HpXPP93w0FscjWIH6D5FckxlvU/0dEr7hlbHJO12eip2wG1nTapYqszNGW0S21bHBcb3
	 X17Z9yLYOyx6o71abliXQaVxsbdH4BshE+97cIdH080Kkh4vF+nXYKohDc130Ad8j/fLQ
	 5ZD/wWxeVYB7/v765SiCysV9yNe2IczR1dt7BgUTiMD5kZu/XSRQ5Mn2vK/X0R26GY81H
	 OXK9isVpej2oZd8HNx0okV8sf+1P5IBYuMTOQv2OhBpA3GI+uhh15q9uOck8j3H5bU6J1
	 5oufrn4dpBM2kHQ2dBV3REe+xIcypnKzONcSGZtJZ7wCTLNNQHXon9R+BZRxZAgOvzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jg1r+gET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FEB606A31C;
	Wed, 18 Nov 2026 19:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jg1r+gET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBBE1F000C4;
	Wed, 18 Nov 2026 19:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029068;
	bh=Ka9VfYGI6lBhZ7L9QmsoIPz4cfNjzExruQ4v8f0i+ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jg1r+gETdNBQIvehJvNqOGaAGjQobzgdDXm7H+7ye3kWPB/8QZ+JLZYXSpZfTPK3w
	 ymbWPkpdBsmykUCmJCWtWtUOARXX+VZmW7AoVdO/P1c96xHNwtRF+gdptoawm2+95G
	 BFOoLJV6yBj+XQA7IWnJoesdWTLp7yXQNdrO5Mgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0159/1756] ARM: dts: helios4: fix vbus-supply for USB2 PHY
Date: Wed, 18 Nov 2026 15:38:06 +0100
Message-ID: <20261118150014.454543340@linuxfoundation.org>
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



