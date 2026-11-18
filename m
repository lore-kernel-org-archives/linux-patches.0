Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039147;
	b=FDjPsOMPD6XXzzNB3Ga7kjG4d6cCoAscjTgSVsV5OFrvK0rMDBr90VlBPTxMYDjBNlV+
	 SLKcGoHgiuik5aQ1rJixgSAeb0C7lnVUXg7NOA/S2SsbC9FgK6n/5tSFbv9UxREiYruY9
	 mG2xOSkizD+t1ulsR6tuS+EkM73VELEh4M2yqVQ22/AWX3ten8NOEAdOGrR4kTezWu1pC
	 Vv4juwPlTC01NAyfMlNikVaBthPGlmS+m4WGLTA8YoEjbTEyDf0iQ4OnaIIFnpKl9Afbf
	 Z7fqzASznCHNNCZJzBJSe5SolWTTaC6nGD7wGttCYgrcIUZQXM2OCwT1gy2oMXoF3Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MJd/1PnX5eVVjJWrM9bxr9K47+F9b6AC6lAENFw6xHU=;
	b=I+A/pQesozpbVclnsxn2s3/NbDge9hxmimrjllIqK5KSykAUNtCMkc+K2p8uNdq6JAs5
	 K2LdlPUC7FSyG7l8NRAUpl+w6tvhlWDq7MTCPL1YiltMEzjiP8hF6CkYYIxBovUX6Pwfh
	 XKo4l4mWlQd9x+7Ed9CV5b0sg2ZXzThuTgVD+ys7PHCB1A2f9RjzIzIexkghQ4Ex+10AL
	 Izer5/W8m/Nv+JORwVC0X2e3LEVrj2GqViE+z78o4MiEBBdCvAd7P357wOxZeAWD3asZ5
	 Ih3VPQhucEpcJmOg9VweOpzu3F4oyUmWFGN7DjuMs3vjVEva00+stPCczYYrxLUUF0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMq1biM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA98606A31C;
	Wed, 18 Nov 2026 21:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jMq1biM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA84F1F000C4;
	Wed, 18 Nov 2026 21:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039147;
	bh=MJd/1PnX5eVVjJWrM9bxr9K47+F9b6AC6lAENFw6xHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jMq1biM09U4AQIrZTmw8ydzAHsUKcvIklyNJHZUuB2vxYfQaG8GP5fdMhZDDiuTLF
	 wxJ1DIN5V8ED3oEYwIxP5Vqm2Ry1Qprs9eMyQfWLNKyKtt0xNMQJSn9gq4w2d28rSF
	 m7WoAPq7asaEmUcsiGXGUVutTXPn+GhSMPi8rv8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1995/3318] ARM: dts: helios4: fix lm75 supply name
Date: Wed, 18 Nov 2026 15:43:37 +0100
Message-ID: <20261118150421.903269040@linuxfoundation.org>
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



