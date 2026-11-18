Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047713;
	b=FkeDI/+kwCPqt4imFLTt83sepM15gdcnbqUgidMj5j2RNuWmgO4aBE3Xo+JKCfcurX/S
	 tKabH2MA9HSQdm2xFud1wDB4n9svLYBlSWRVEgEfSvN93jx9PuLs0uEYCI4iQOcU/hJ4B
	 OkyNzs7lvch6yXO1VXTL/rQlfbDvS9aPVGSHOKk9MzyDEISr/RY7UwnrGgD53EGJrNvt+
	 2Oehko+ZtjQz9+NuBV365zgZj/HKsLleEtPwls0/tgaGZwa4yW5FyHQHuUUVxxbnqtLv9
	 dkafNSbMGOY+dg8AqlNTmgoVXecDTbR0Jvu1TZNIJxsVJeP9Bh1HO8SF0VZVip7h0rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8w+Z6i1uZikB/gmr32tQkYeUHzBaKW2IqS/seexlN/Y=;
	b=pCM8zuV8fGUe1cjU6+g3HV7b1dWdYy061J/om4JA5SuM94VICC6KpzT2rFzL4DRPnJlX
	 vcFlB3PL8vIvT3pDQ6RbK6c5AvDBv3X6592g2LzNhubH6Y1VxJn1MoLeVBrLj72z1frjT
	 LDZK4lHVjHDJhigKnmvGTbl+LAHTwVut6ioA0wZEMODJApO/uv+H7Uimp0+ClLfgGZDfY
	 5YJTUBwENEnnzRpu3es8MHWyRzVEoBVoUh3YqYVErTqvKR3Lmm9+mc5i1Z4PMhFLebzcz
	 CYSumjnDVQYMsJwM9I7o4ZjMrEuqo55a1pHut+qN+XhPQy++tQ5REaC9o927rwTx3fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDfT9ENX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49956606A31C;
	Thu, 19 Nov 2026 00:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LDfT9ENX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F7D1F000CC;
	Thu, 19 Nov 2026 00:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047713;
	bh=8w+Z6i1uZikB/gmr32tQkYeUHzBaKW2IqS/seexlN/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDfT9ENXM4sy52L8qT5XiZAflD4eKiXTaikzGoQsLgEVMVDHt99K5SUmOGz8VPLYL
	 s1wYNaogeASEQB6ZS3VlxP9YgxkIECW3n07uv6h2EGcP7/eWhl+wEKwCPso5zuNtjr
	 HsGuRjdH1W4X9r7UWskJhsamj7AKXnUVnvzj5FSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1738/2857] ARM: dts: helios4: fix lm75 supply name
Date: Wed, 18 Nov 2026 15:46:12 +0100
Message-ID: <20261118150303.883596666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/armada-388-helios4.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-388-helios4.dts b/arch/arm/boot/dts/armada-388-helios4.dts
index 003b0708e9656..f5ae4bea1211f 100644
--- a/arch/arm/boot/dts/armada-388-helios4.dts
+++ b/arch/arm/boot/dts/armada-388-helios4.dts
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



